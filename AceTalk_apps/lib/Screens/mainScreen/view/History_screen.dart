import 'package:ai_interview_app/Screens/block/historybloc.dart';
import 'package:ai_interview_app/Screens/fieldscreen/scorescreen.dart';
import 'package:ai_interview_app/Screens/history/historymodel.dart';
import 'package:ai_interview_app/shared/animatedbackground.dart';
import 'package:ai_interview_app/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(const HistoryLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: BlocBuilder<HistoryBloc, HistoryState>(
                    builder: (context, state) {
                      if (state is HistoryLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accentCyan,
                          ),
                        );
                      }
                      if (state is HistoryEmpty) {
                        return _buildEmpty();
                      }
                      if (state is HistoryLoaded) {
                        return _buildList(context, state.sessions);
                      }
                      if (state is HistoryError) {
                        return _buildError(state.message);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Interview History',
                style: GoogleFonts.spaceMono(
                  fontSize: 18,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  final count = state is HistoryLoaded
                      ? state.sessions.length
                      : 0;
                  return Text(
                    '$count session${count == 1 ? '' : 's'} recorded',
                    style: GoogleFonts.dmSans(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  );
                },
              ),
            ],
          ),
          const Spacer(),
          BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              if (state is! HistoryLoaded || state.sessions.isEmpty) {
                return const SizedBox.shrink();
              }
              return GestureDetector(
                onTap: () => _confirmClearAll(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.accentRed.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    'Clear All',
                    style: GoogleFonts.dmSans(
                      color: AppColors.accentRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<SessionEntity> sessions) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: sessions.length,
      itemBuilder: (_, i) {
        final session = sessions[i];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + i * 80),
          builder: (_, val, child) => Opacity(
            opacity: val,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - val)),
              child: child,
            ),
          ),
          child: Dismissible(
            key: Key('session_${session.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: AppColors.accentRed.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.delete_rounded,
                color: AppColors.accentRed,
                size: 22,
              ),
            ),
            onDismissed: (_) {
              if (session.id != null) {
                context.read<HistoryBloc>().add(
                  HistoryDeleteRequested(session.id!),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SessionCard(
                session: session,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScoreScreen(session: session),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.history_rounded,
            color: AppColors.textSecondary.withOpacity(0.3),
            size: 72,
          ),
          const SizedBox(height: 16),
          Text(
            'No sessions yet',
            style: GoogleFonts.dmSans(
              color: AppColors.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete an interview to see your history here',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              color: AppColors.textSecondary.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String msg) {
    return Center(
      child: Text(
        msg,
        style: GoogleFonts.dmSans(color: AppColors.accentRed, fontSize: 14),
      ),
    );
  }

  void _confirmClearAll(BuildContext context) {
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Clear All History?',
            style: GoogleFonts.dmSans(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'This cannot be undone.',
            style: GoogleFonts.dmSans(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.dmSans(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<HistoryBloc>().add(
                  const HistoryClearAllRequested(),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("History cleared"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Clear',
                style: GoogleFonts.dmSans(
                  color: AppColors.accentRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── SESSION CARD ─────────────────────────────────────────────────────────────
class _SessionCard extends StatelessWidget {
  final SessionEntity session;
  final VoidCallback onTap;

  const _SessionCard({required this.session, required this.onTap});

  Color get _gradeColor {
    final s = session.scorePercent;
    if (s >= 80) return AppColors.accentGreen;
    if (s >= 60) return AppColors.accentGold;
    return AppColors.accentRed;
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat(
      'MMM d, yyyy • h:mm a',
    ).format(session.completedAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _gradeColor.withOpacity(0.2), width: 1.5),
        ),
        child: Row(
          children: [
            // Grade circle
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _gradeColor.withOpacity(0.1),
                border: Border.all(
                  color: _gradeColor.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  session.grade,
                  style: GoogleFonts.spaceMono(
                    color: _gradeColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.language
                        .replaceAll('-', ' ')
                        .split(' ')
                        .map(
                          (w) => w.isEmpty
                              ? ''
                              : w[0].toUpperCase() + w.substring(1),
                        )
                        .join(' '),
                    style: GoogleFonts.dmSans(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${session.level}  •  ${session.round}',
                    style: GoogleFonts.dmSans(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateStr,
                    style: GoogleFonts.dmSans(
                      color: AppColors.textSecondary.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${session.scorePercent.toInt()}%',
                  style: GoogleFonts.spaceMono(
                    color: _gradeColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '${session.correctAnswers}/${session.totalQuestions}',
                  style: GoogleFonts.dmSans(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
