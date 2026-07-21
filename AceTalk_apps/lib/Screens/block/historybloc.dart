// // lib/features/history/presentation/bloc/history_bloc.dart
// import 'package:ai_interview_app/Screens/history/historyResp.dart';
// import 'package:ai_interview_app/Screens/history/historymodel.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// // ─── EVENTS ──────────────────────────────────────────────────────────────────
// abstract class HistoryEvent  {
//   const HistoryEvent();
//   // @override
//   // List<Object?> get props => [];
// }

// class HistoryLoadRequested extends HistoryEvent {
//   const HistoryLoadRequested();
// }

// class HistoryDeleteRequested extends HistoryEvent {
//   final int sessionId;
//   const HistoryDeleteRequested(this.sessionId);
//   @override
//   List<Object?> get props => [sessionId];
// }

// class HistoryClearAllRequested extends HistoryEvent {
//   const HistoryClearAllRequested();
// }

// // ─── STATES ───────────────────────────────────────────────────────────────────
// abstract class HistoryState extends Equatable {
//   const HistoryState();
//   @override
//   List<Object?> get props => [];
// }

// class HistoryInitial extends HistoryState {
//   const HistoryInitial();
// }

// class HistoryLoading extends HistoryState {
//   const HistoryLoading();
// }

// class HistoryLoaded extends HistoryState {
//   final List<SessionEntity> sessions;
//   const HistoryLoaded(this.sessions);
//   @override
//   List<Object?> get props => [sessions];
// }

// class HistoryEmpty extends HistoryState {
//   const HistoryEmpty();
// }

// class HistoryError extends HistoryState {
//   final String message;
//   const HistoryError(this.message);
//   @override
//   List<Object?> get props => [message];
// }

// // ─── BLOC ─────────────────────────────────────────────────────────────────────
// class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
//   final SessionRepository _repo;

//   HistoryBloc({SessionRepository? repo})
//       : _repo = repo ?? SessionRepositoryImpl(),
//         super(const HistoryInitial()) {
//     on<HistoryLoadRequested>(_onLoad);
//     on<HistoryDeleteRequested>(_onDelete);
//     on<HistoryClearAllRequested>(_onClearAll);
//   }

//   Future<void> _onLoad(
//       HistoryLoadRequested event, Emitter<HistoryState> emit) async {
//     emit(const HistoryLoading());
//     try {
//       final sessions = await _repo.getAllSessions();
//       if (sessions.isEmpty) {
//         emit(const HistoryEmpty());
//       } else {
//         emit(HistoryLoaded(sessions));
//       }
//     } catch (e) {
//       emit(HistoryError(e.toString()));
//     }
//   }

//   Future<void> _onDelete(
//       HistoryDeleteRequested event, Emitter<HistoryState> emit) async {
//     try {
//       await _repo.deleteSession(event.sessionId);
//       add(const HistoryLoadRequested());
//     } catch (e) {
//       emit(HistoryError(e.toString()));
//     }
//   }

//   Future<void> _onClearAll(
//       HistoryClearAllRequested event, Emitter<HistoryState> emit) async {
//     try {
//       await _repo.clearAll();
//       emit(const HistoryEmpty());
//     } catch (e) {
//       emit(HistoryError(e.toString()));
//     }
//   }
// }

// lib/features/history/presentation/bloc/history_bloc.dart

import 'package:ai_interview_app/Screens/history/historyResp.dart';
import 'package:ai_interview_app/Screens/history/historymodel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ───────────────── EVENTS ─────────────────

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class HistoryLoadRequested extends HistoryEvent {
  const HistoryLoadRequested();
}

class HistoryDeleteRequested extends HistoryEvent {
  final int sessionId;

  const HistoryDeleteRequested(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class HistoryClearAllRequested extends HistoryEvent {
  const HistoryClearAllRequested();
}

/// ───────────────── STATES ─────────────────

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final List<SessionEntity> sessions;

  const HistoryLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

class HistoryEmpty extends HistoryState {
  const HistoryEmpty();
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

/// ───────────────── BLOC ─────────────────

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final SessionRepository _repo;

  HistoryBloc({SessionRepository? repo})
      : _repo = repo ?? SessionRepositoryImpl(),
        super(const HistoryInitial()) {
    on<HistoryLoadRequested>(_onLoad);
    on<HistoryDeleteRequested>(_onDelete);
    on<HistoryClearAllRequested>(_onClearAll);
  }

  /// LOAD HISTORY
  Future<void> _onLoad(
    HistoryLoadRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());

    try {
      final sessions = await _repo.getAllSessions();

      if (sessions.isEmpty) {
        emit(const HistoryEmpty());
      } else {
        emit(HistoryLoaded(sessions));
      }
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  /// DELETE SINGLE SESSION
  Future<void> _onDelete(
    HistoryDeleteRequested event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      await _repo.deleteSession(event.sessionId);

      final sessions = await _repo.getAllSessions();

      if (sessions.isEmpty) {
        emit(const HistoryEmpty());
      } else {
        emit(HistoryLoaded(sessions));
      }
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  /// CLEAR ALL HISTORY
  Future<void> _onClearAll(
    HistoryClearAllRequested event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      await _repo.clearAll();
      emit(const HistoryEmpty());
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}