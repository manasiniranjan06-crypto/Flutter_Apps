

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ai_interview_app/Screens/history/historyResp.dart';
import 'package:ai_interview_app/Screens/history/historymodel.dart';
import 'package:ai_interview_app/Screens/mainScreen/model/question_model.dart';
import 'package:ai_interview_app/Screens/mainScreen/widget/question_data.dart';

/// ───────────────────────────────── EVENTS ─────────────────────────────────

abstract class InterviewEvent extends Equatable {
  const InterviewEvent();

  @override
  List<Object?> get props => [];
}

class InterviewStarted extends InterviewEvent {
  final String languageId;
  final String level;
  final String round;
  final int totalQuestions;

  const InterviewStarted({
    required this.languageId,
    required this.level,
    required this.round,
    required this.totalQuestions,
  });

  @override
  List<Object?> get props => [languageId, level, round, totalQuestions];
}

class InterviewAnswerSubmitted extends InterviewEvent {
  final String answer;

  const InterviewAnswerSubmitted(this.answer);

  @override
  List<Object?> get props => [answer];
}

class InterviewNextQuestion extends InterviewEvent {
  const InterviewNextQuestion();
}

class InterviewTimerTick extends InterviewEvent {
  final int remaining;

  const InterviewTimerTick(this.remaining);

  @override
  List<Object?> get props => [remaining];
}

class InterviewTimedOut extends InterviewEvent {
  const InterviewTimedOut();
}

class InterviewFinished extends InterviewEvent {
  const InterviewFinished();
}

/// ───────────────────────────────── STATES ─────────────────────────────────

abstract class InterviewState extends Equatable {
  const InterviewState();

  @override
  List<Object?> get props => [];
}

class InterviewInitial extends InterviewState {
  const InterviewInitial();
}

class InterviewInProgress extends InterviewState {
  final List<QuestionEntity> questions;
  final int currentIndex;
  final int timerSeconds;
  final bool isAnswered;
  final String currentAnswer;
  final bool isCorrect;
  final List<QuestionResultEntity> results;

  const InterviewInProgress({
    required this.questions,
    required this.currentIndex,
    required this.timerSeconds,
    required this.isAnswered,
    required this.currentAnswer,
    required this.isCorrect,
    required this.results,
  });

  QuestionEntity get currentQuestion => questions[currentIndex];

  bool get isLastQuestion => currentIndex >= questions.length - 1;

  int get correctCount => results.where((e) => e.isCorrect).length;

  InterviewInProgress copyWith({
    int? currentIndex,
    int? timerSeconds,
    bool? isAnswered,
    String? currentAnswer,
    bool? isCorrect,
    List<QuestionResultEntity>? results,
  }) {
    return InterviewInProgress(
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      isAnswered: isAnswered ?? this.isAnswered,
      currentAnswer: currentAnswer ?? this.currentAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      results: results ?? this.results,
    );
  }

  @override
  List<Object?> get props => [
        questions,
        currentIndex,
        timerSeconds,
        isAnswered,
        currentAnswer,
        isCorrect,
        results,
      ];
}

class InterviewCompleted extends InterviewState {
  final SessionEntity session;

  const InterviewCompleted({required this.session});

  @override
  List<Object?> get props => [session];
}

class InterviewError extends InterviewState {
  final String message;

  const InterviewError(this.message);

  @override
  List<Object?> get props => [message];
}

/// ───────────────────────────────── BLOC ─────────────────────────────────

class InterviewBloc extends Bloc<InterviewEvent, InterviewState> {
  final SessionRepository _sessionRepo;

  Timer? _timer;

  static const int questionDuration = 60;

  late String _languageId;
  late String _level;
  late String _round;

  int _questionStartTime = 0;

  InterviewBloc({SessionRepository? sessionRepo})
      : _sessionRepo = sessionRepo ?? SessionRepositoryImpl(),
        super(const InterviewInitial()) {
    on<InterviewStarted>(_onStarted);
    on<InterviewAnswerSubmitted>(_onAnswerSubmitted);
    on<InterviewNextQuestion>(_onNextQuestion);
    on<InterviewTimerTick>(_onTimerTick);
    on<InterviewTimedOut>(_onTimedOut);
    on<InterviewFinished>(_onFinished);
  }

  /// ───────────────────────── START INTERVIEW ─────────────────────────

  void _onStarted(
    InterviewStarted event,
    Emitter<InterviewState> emit,
  ) {
    _languageId = event.languageId;
    _level = event.level;
    _round = event.round;

    final questions = QuestionBank.getQuestions(
      languageId: event.languageId,
      level: event.level,
      count: event.totalQuestions,
    );

    if (questions.isEmpty) {
      emit(const InterviewError("No questions available"));
      return;
    }

    emit(
      InterviewInProgress(
        questions: questions,
        currentIndex: 0,
        timerSeconds: questionDuration,
        isAnswered: false,
        currentAnswer: "",
        isCorrect: false,
        results: const [],
      ),
    );

    _startTimer();
    _questionStartTime = DateTime.now().millisecondsSinceEpoch;
  }

  /// ───────────────────────── ANSWER SUBMITTED ─────────────────────────

  void _onAnswerSubmitted(
    InterviewAnswerSubmitted event,
    Emitter<InterviewState> emit,
  ) {
    if (state is! InterviewInProgress || isClosed) return;

    final cur = state as InterviewInProgress;

    if (cur.isAnswered) return;

    _timer?.cancel();

    final timeTaken = _calcTimeTaken();
    final isCorrect = _evaluateAnswer(cur.currentQuestion, event.answer);

    final result = QuestionResultEntity(
      question: cur.currentQuestion.question,
      userAnswer: event.answer,
      isCorrect: isCorrect,
      timeTaken: timeTaken,
    );

    emit(
      cur.copyWith(
        isAnswered: true,
        currentAnswer: event.answer,
        isCorrect: isCorrect,
        results: [...cur.results, result],
      ),
    );
  }

  /// ───────────────────────── NEXT QUESTION ─────────────────────────

  void _onNextQuestion(
    InterviewNextQuestion event,
    Emitter<InterviewState> emit,
  ) {
    if (state is! InterviewInProgress) return;

    final cur = state as InterviewInProgress;

    _timer?.cancel();

    if (cur.isLastQuestion) {
      add(const InterviewFinished());
      return;
    }

    emit(
      cur.copyWith(
        currentIndex: cur.currentIndex + 1,
        timerSeconds: questionDuration,
        isAnswered: false,
        currentAnswer: "",
        isCorrect: false,
      ),
    );

    _startTimer();
    _questionStartTime = DateTime.now().millisecondsSinceEpoch;
  }

  /// ───────────────────────── TIMER TICK ─────────────────────────

  void _onTimerTick(
    InterviewTimerTick event,
    Emitter<InterviewState> emit,
  ) {
    if (state is! InterviewInProgress) return;

    final cur = state as InterviewInProgress;

    if (!cur.isAnswered) {
      emit(cur.copyWith(timerSeconds: event.remaining));
    }
  }

  /// ───────────────────────── TIMEOUT ─────────────────────────

  void _onTimedOut(
    InterviewTimedOut event,
    Emitter<InterviewState> emit,
  ) {
    if (state is! InterviewInProgress) return;

    final cur = state as InterviewInProgress;

    if (cur.isAnswered) return;

    _timer?.cancel();

    final result = QuestionResultEntity(
      question: cur.currentQuestion.question,
      userAnswer: "(Timed out)",
      isCorrect: false,
      timeTaken: questionDuration,
    );

    emit(
      cur.copyWith(
        isAnswered: true,
        timerSeconds: 0,
        results: [...cur.results, result],
      ),
    );
  }

  /// ───────────────────────── FINISH INTERVIEW ─────────────────────────

  Future<void> _onFinished(
    InterviewFinished event,
    Emitter<InterviewState> emit,
  ) async {
    if (state is! InterviewInProgress) return;

    final cur = state as InterviewInProgress;

    _timer?.cancel();

      final correctCount = cur.results.where((r) => r.isCorrect).length;
     final scorePercent =
        cur.results.isEmpty ? 0.0 : correctCount / cur.results.length * 100;

    final session = SessionEntity(
      language: _languageId,
      level: _level,
      round: _round,
      totalQuestions: cur.questions.length,
      correctAnswers: correctCount,
      scorePercent: scorePercent,
      completedAt: DateTime.now(),
      results: cur.results,
    );

    try {
      await _sessionRepo.saveSession(session);
    } catch (_) {}

    emit(InterviewCompleted(session: session));
  }

  /// ───────────────────────── TIMER ─────────────────────────

  void _startTimer() {
    _timer?.cancel();

    int remaining = questionDuration;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }

      remaining--;

      if (remaining <= 0) {
        timer.cancel();
        add(const InterviewTimedOut());
      } else {
        add(InterviewTimerTick(remaining));
      }
    });
  }

  /// ───────────────────────── UTILITIES ─────────────────────────

  int _calcTimeTaken() {
    final elapsed =
        (DateTime.now().millisecondsSinceEpoch - _questionStartTime) ~/ 1000;

    return elapsed.clamp(0, questionDuration);
  }

  bool _evaluateAnswer(QuestionEntity q, String answer) {
    if (answer.trim().isEmpty) return false;

    final lower = answer.toLowerCase();

    final matched =
        q.keywords.where((k) => lower.contains(k.toLowerCase())).length;

    return matched >= (q.keywords.length * 0.3).ceil();
  }

  /// ───────────────────────── CLOSE ─────────────────────────

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}