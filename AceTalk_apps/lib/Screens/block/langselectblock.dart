// lib/features/language_select/presentation/bloc/language_bloc.dart

// ─── EVENTS ──────────────────────────────────────────────────────────────────
import 'package:ai_interview_app/Screens/langugae/langdatasource.dart';
import 'package:ai_interview_app/Screens/langugae/lqngugaecard.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();
  @override
  List<Object?> get props => [];
}

class LanguageLoadRequested extends LanguageEvent {
  const LanguageLoadRequested();
}

class LanguageSearchChanged extends LanguageEvent {
  final String query;
  const LanguageSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class LanguageFilterChanged extends LanguageEvent {
  final String filter;
  const LanguageFilterChanged(this.filter);
  @override
  List<Object?> get props => [filter];
}

// ─── STATES ───────────────────────────────────────────────────────────────────
abstract class LanguageState  extends Equatable {
  const LanguageState();
  @override
  List<Object?> get props => [];
}

class LanguageInitial extends LanguageState {
  const LanguageInitial();
}

class LanguageLoaded extends LanguageState {
  final List<LanguageEntity> all;
  final List<LanguageEntity> filtered;
  final String searchQuery;
  final String selectedFilter;

  const LanguageLoaded({
    required this.all,
    required this.filtered,
    required this.searchQuery,
    required this.selectedFilter,
  });

  LanguageLoaded copyWith({
    List<LanguageEntity>? filtered,
    String? searchQuery,
    String? selectedFilter,
  }) {
    return LanguageLoaded(
      all: all,
      filtered: filtered ?? this.filtered,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [all, filtered, searchQuery, selectedFilter];
}

// ─── BLOC ─────────────────────────────────────────────────────────────────────
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final LanguageLocalDatasource _datasource;

  LanguageBloc({LanguageLocalDatasource? datasource})
      : _datasource = datasource ?? LanguageLocalDatasource(),
        super(const LanguageInitial()) {
    on<LanguageLoadRequested>(_onLoad);
    on<LanguageSearchChanged>(_onSearch);
    on<LanguageFilterChanged>(_onFilter);
  }

  void _onLoad(LanguageLoadRequested event, Emitter<LanguageState> emit) {
    final all = _datasource.getAll();
    emit(LanguageLoaded(
      all: all,
      filtered: all,
      searchQuery: '',
      selectedFilter: 'All',
    ));
  }

  void _onSearch(LanguageSearchChanged event, Emitter<LanguageState> emit) {
    if (state is LanguageLoaded) {
      final cur = state as LanguageLoaded;
      final filtered = _applyFilters(
        cur.all,
        event.query,
        cur.selectedFilter,
      );
      emit(cur.copyWith(filtered: filtered, searchQuery: event.query));
    }
  }

  void _onFilter(LanguageFilterChanged event, Emitter<LanguageState> emit) {
    if (state is LanguageLoaded) {
      final cur = state as LanguageLoaded;
      final filtered = _applyFilters(
        cur.all,
        cur.searchQuery,
        event.filter,
      );
      emit(cur.copyWith(filtered: filtered, selectedFilter: event.filter));
    }
  }

  List<LanguageEntity> _applyFilters(
    List<LanguageEntity> all,
    String query,
    String filter,
  ) {
    return all.where((l) {
      final matchSearch = query.isEmpty ||
          l.name.toLowerCase().contains(query.toLowerCase()) ||
          l.detail.toLowerCase().contains(query.toLowerCase());
      final matchFilter = filter == 'All' || l.tag == filter;
      return matchSearch && matchFilter;
    }).toList();
  }
}