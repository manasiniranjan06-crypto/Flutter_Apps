// lib/features/fields/presentation/bloc/fields_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─── EVENTS ──────────────────────────────────────────────────────────────────
abstract class FieldsEvent extends Equatable {
  const FieldsEvent();
  @override
  List<Object?> get props => [];
}

class FieldsLevelChanged extends FieldsEvent {
  final String level;
  const FieldsLevelChanged(this.level);
  @override
  List<Object?> get props => [level];
}

class FieldsRoundChanged extends FieldsEvent {
  final String round;
  const FieldsRoundChanged(this.round);
  @override
  List<Object?> get props => [round];
}

class FieldsQuestionCountChanged extends FieldsEvent {
  final int count;
  const FieldsQuestionCountChanged(this.count);
  @override
  List<Object?> get props => [count];
}

class FieldsReset extends FieldsEvent {
  const FieldsReset();
}

// ─── STATE ────────────────────────────────────────────────────────────────────
class FieldsState extends Equatable {
  final String level;
  final String round;
  final int questionCount;

  static const int minQuestions = 1;
  static const int maxQuestions = 20;

  const FieldsState({
    this.level = 'Beginner',
    this.round = 'Entry Level',
    this.questionCount = 5,
  });

  int get durationSeconds => questionCount * 60;

  FieldsState copyWith({
    String? level,
    String? round,
    int? questionCount,
  }) {
    return FieldsState(
      level: level ?? this.level,
      round: round ?? this.round,
      questionCount: questionCount ?? this.questionCount,
    );
  }

  @override
  List<Object?> get props => [level, round, questionCount];
}

// ─── BLOC ─────────────────────────────────────────────────────────────────────
class FieldsBloc extends Bloc<FieldsEvent, FieldsState> {
  FieldsBloc() : super(const FieldsState()) {
    on<FieldsLevelChanged>(
        (e, emit) => emit(state.copyWith(level: e.level)));
    on<FieldsRoundChanged>(
        (e, emit) => emit(state.copyWith(round: e.round)));
    on<FieldsQuestionCountChanged>((e, emit) {
      final clamped = e.count.clamp(
          FieldsState.minQuestions, FieldsState.maxQuestions);
      emit(state.copyWith(questionCount: clamped));
    });
    on<FieldsReset>((_,emit) => emit(const FieldsState()));
  }
}