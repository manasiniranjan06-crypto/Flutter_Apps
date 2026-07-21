
// lib/features/interview/presentation/pages/question_screen.dart

import 'package:ai_interview_app/Screens/block/interve.dart';
import 'package:ai_interview_app/Screens/fieldscreen/scorescreen.dart';
import 'package:ai_interview_app/Screens/langugae/lqngugaecard.dart';
import 'package:ai_interview_app/shared/animatedbackground.dart';
import 'package:ai_interview_app/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionScreen extends StatelessWidget {
  final LanguageEntity language;
  final int totalQuestions;
  final String level;
  final String round;

  const QuestionScreen({
    super.key,
    required this.language,
    required this.totalQuestions,
    required this.level,
    required this.round,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InterviewBloc()
        ..add(
          InterviewStarted(
            languageId: language.id,
            level: level,
            round: round,
            totalQuestions: totalQuestions,
          ),
        ),
      child: _QuestionView(language: language),
    );
  }
}

class _QuestionView extends StatefulWidget {
  final LanguageEntity language;

  const _QuestionView({required this.language});

  @override
  State<_QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<_QuestionView>
    with SingleTickerProviderStateMixin {

  final TextEditingController _answerCtrl = TextEditingController();

  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;

  int charCount = 0;
  final int maxChars = 400;

  @override
  void initState() {
    super.initState();

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0.08, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic),
    );

    _slideCtrl.forward();

    _answerCtrl.addListener(() {
      setState(() {
        charCount = _answerCtrl.text.length;
      });
    });
  }

  @override
  void dispose() {
    _answerCtrl.dispose();
    _slideCtrl.dispose();
    super.dispose();
  }

  void _animateNextQuestion() {
    _slideCtrl.reset();
    _answerCtrl.clear();
    _slideCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InterviewBloc, InterviewState>(
      listener: (context, state) {
        if (state is InterviewCompleted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ScoreScreen(session: state.session),
            ),
          );
        }
      },
      builder: (context, state) {

        if (state is InterviewInProgress) {
          return _buildInterviewUI(context, state);
        }

        if (state is InterviewError) {
          return Scaffold(
            backgroundColor: AppColors.bgDark,
            body: Center(
              child: Text(
                state.message,
                style: GoogleFonts.dmSans(color: Colors.white),
              ),
            ),
          );
        }

        return const Scaffold(
          backgroundColor: AppColors.bgDark,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildInterviewUI(BuildContext context, InterviewInProgress state) {

    final progress = (state.currentIndex + 1) / state.questions.length;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [

          const AnimatedBackground(),

          SafeArea(
            child: Column(
              children: [

                _buildTopBar(state, progress),

                Expanded(
                  child: SlideTransition(
                    position: _slideAnim,
                    child: ListView(
                      padding: const EdgeInsets.all(18),
                      children: [

                        _buildQuestionCard(state),

                        const SizedBox(height: 20),

                        if (!state.isAnswered)
                          _buildAnswerInput(context, state),

                        if (state.isAnswered)
                          _buildFeedbackCard(state),

                        const SizedBox(height: 20),

                        _buildBottomActions(context, state),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
Widget _buildTopBar(InterviewInProgress state, double progress) {

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [

        Row(
          children: [

            /// Exit button
            GestureDetector(
              onTap: () => _showExitDialog(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(.08),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Text(
              "Question ${state.currentIndex + 1}/${state.questions.length}",
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const Spacer(),

            /// Timer
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white10,
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, size: 16),
                  const SizedBox(width: 6),
                  Text("${state.timerSeconds}s"),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation(
              widget.language.accentColor,
            ),
          ),
        ),
      ],
    ),
  );
}

void _showExitDialog() {

  if (!mounted) return;

  HapticFeedback.mediumImpact();

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Exit",
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 250),

    pageBuilder: (dialogContext, _, __) {

      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.surface1,
            border: Border.all(color: Colors.white10),
          ),

          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// Icon
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(.1),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                    size: 36,
                  ),
                ),

                const SizedBox(height: 16),

                /// Title
                Text(
                  "Exit Interview?",
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                /// Description
                Text(
                  "Your progress will be lost if you exit the test now.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [

                    /// Continue Test
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.white24),
                        ),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        child: Text(
                          "Continue Test",
                          style: GoogleFonts.dmSans(color: Colors.white70),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// Exit Test
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {

                          Navigator.of(dialogContext).pop();

                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          "Exit Test",
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },

    transitionBuilder: (_, anim, __, child) {

      return Transform.scale(
        scale: Curves.easeOutBack.transform(anim.value),
        child: Opacity(
          opacity: anim.value,
          child: child,
        ),
      );
    },
  );
}
  Widget _buildQuestionCard(InterviewInProgress state) {

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: widget.language.accentColor.withOpacity(.3),
        ),
        color: Colors.white.withOpacity(.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: widget.language.accentColor.withOpacity(.15),
                ),
                child: Text(
                  state.currentQuestion.level,
                  style: GoogleFonts.dmSans(
                    color: widget.language.accentColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            state.currentQuestion.question,
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontSize: 18,
              height: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Hint: ${state.currentQuestion.keywords.take(3).join(", ")}",
            style: GoogleFonts.dmSans(
              color: Colors.white54,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerInput(BuildContext context, InterviewInProgress state) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white12),
            color: Colors.white.withOpacity(.04),
          ),
          child: TextField(
            controller: _answerCtrl,
            maxLines: 5,
            maxLength: maxChars,
            style: GoogleFonts.dmSans(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Type your answer...",
              counterText: "",
              hintStyle: GoogleFonts.dmSans(color: Colors.white30),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
            ),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          "$charCount / $maxChars characters",
          style: GoogleFonts.dmSans(
            color: charCount > maxChars * 0.9
                ? Colors.orange
                : Colors.white54,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackCard(InterviewInProgress state) {

    final correct = state.isCorrect;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: correct
            ? Colors.green.withOpacity(.1)
            : Colors.red.withOpacity(.1),
      ),
      child: Row(
        children: [

          Icon(
            correct ? Icons.check_circle : Icons.cancel,
            color: correct ? Colors.green : Colors.red,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              correct
                  ? "Good answer!"
                  : "Try mentioning: ${state.currentQuestion.keywords.join(", ")}",
              style: GoogleFonts.dmSans(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildBottomActions(
  BuildContext context,
  InterviewInProgress state,
) {

  final accent = widget.language.accentColor;

  return Row(
    children: [

      /// Skip Button
      Expanded(
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white70,
            side: BorderSide(color: accent.withOpacity(.4)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: const Icon(Icons.skip_next_rounded),
          label: const Text("Skip"),
          onPressed: () {

            HapticFeedback.lightImpact();

            _animateNextQuestion();

            context.read<InterviewBloc>().add(
              const InterviewNextQuestion(),
            );
          },
        ),
      ),

      const SizedBox(width: 12),

      /// Submit / Next Button
      Expanded(
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [
                accent,
                accent.withOpacity(.75),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(.4),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),

            icon: Icon(
              state.isAnswered
                  ? Icons.arrow_forward_rounded
                  : Icons.send_rounded,
              color: Colors.white,
            ),

            label: Text(
              state.isAnswered ? "Next Question" : "Submit Answer",
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

            onPressed: () {

              HapticFeedback.mediumImpact();

              if (!state.isAnswered) {

                context.read<InterviewBloc>().add(
                  InterviewAnswerSubmitted(
                    _answerCtrl.text.trim(),
                  ),
                );

              } else {

                _animateNextQuestion();

                if (state.isLastQuestion) {

                  context.read<InterviewBloc>().add(
                    const InterviewFinished(),
                  );

                } else {

                  context.read<InterviewBloc>().add(
                    const InterviewNextQuestion(),
                  );
                }
              }
            },
          ),
        ),
      ),
    ],
  );
}
}