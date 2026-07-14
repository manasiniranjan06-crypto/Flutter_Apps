// lib/features/language_select/presentation/pages/language_screen.dart
import 'dart:ui';
import 'package:ai_interview_app/Screens/block/langselectblock.dart';
import 'package:ai_interview_app/Screens/mainScreen/view/lang_card.dart';
import 'package:ai_interview_app/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ai_interview_app/shared/animatedbackground.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = ['All', 'Beginner', 'Popular', 'Advanced'];

  @override
  void initState() {
    super.initState();
    context.read<LanguageBloc>().add(const LanguageLoadRequested());

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _headerFade = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _headerController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  @override
  void dispose() {
    _headerController.dispose();
    _searchController.dispose();
    super.dispose();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: _headerFade,
                  child: SlideTransition(
                    position: _headerSlide,
                    child: _buildHeader(),
                  ),
                ),
                FadeTransition(opacity: _headerFade, child: _buildSearchBar()),
                FadeTransition(
                  opacity: _headerFade,
                  child: _buildFilterChips(),
                ),
                const SizedBox(height: 8),
                FadeTransition(opacity: _headerFade, child: _buildStatsRow()),
                const SizedBox(height: 8),
                Expanded(child: _buildList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Interview Prep',
                style: GoogleFonts.dmSans(
                  color: AppColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Choose your technology',
                style: GoogleFonts.dmSans(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accentBlue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accentCyan.withOpacity(0.25)),
            ),
            child: const Icon(
              Icons.psychology_alt_rounded,
              color: AppColors.accentCyan,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, state) {
              final query = state is LanguageLoaded ? state.searchQuery : '';
              return TextField(
                controller: _searchController,
                style: GoogleFonts.dmSans(
                  color: AppColors.textPrimary,
                  fontSize: 14.5,
                ),
                onChanged: (v) =>
                    context.read<LanguageBloc>().add(LanguageSearchChanged(v)),
                decoration: InputDecoration(
                  hintText: 'Search language or topic…',
                  hintStyle: GoogleFonts.dmSans(
                    color: Colors.white24,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.textSecondary,
                            size: 18,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            context.read<LanguageBloc>().add(
                              const LanguageSearchChanged(''),
                            );
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Colors.white10,
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppColors.accentCyan.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 44,
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          final selected = state is LanguageLoaded
              ? state.selectedFilter
              : 'All';
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final f = _filters[i];
              final active = selected == f;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.read<LanguageBloc>().add(LanguageFilterChanged(f));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.accentBlue
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active
                          ? AppColors.accentBlue
                          : Colors.white.withOpacity(0.1),
                    ),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: AppColors.accentBlue.withOpacity(0.3),
                              blurRadius: 10,
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    f,
                    style: GoogleFonts.dmSans(
                      color: active ? Colors.white : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatsRow() {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        if (state is! LanguageLoaded) return const SizedBox.shrink();
        final count = state.filtered.length;
        final totalQ = state.filtered
            .map((l) => l.totalQuestions)
            .fold(0, (a, b) => a + b);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                '$count ${count == 1 ? 'track' : 'tracks'} available',
                style: GoogleFonts.dmSans(
                  color: AppColors.textSecondary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.accentGold.withOpacity(0.25),
                  ),
                ),
                child: Text(
                  '$totalQ total questions',
                  style: GoogleFonts.spaceMono(
                    color: AppColors.accentGold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildList() {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        if (state is! LanguageLoaded) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accentCyan),
          );
        }
        if (state.filtered.isEmpty) {
          return _buildEmpty();
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          itemCount: state.filtered.length,
          itemBuilder: (_, i) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 300 + i * 100),
              curve: Curves.easeOutCubic,
              builder: (_, val, child) => Opacity(
                opacity: val,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - val)),
                  child: child,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: LanguageCard(language: state.filtered[i]),
              ),
            );
          },
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
            Icons.search_off_rounded,
            color: AppColors.textSecondary.withOpacity(0.4),
            size: 56,
          ),
          const SizedBox(height: 14),
          Text(
            'No results found',
            style: GoogleFonts.dmSans(
              color: AppColors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try a different search or filter',
            style: GoogleFonts.dmSans(
              color: AppColors.textSecondary.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
