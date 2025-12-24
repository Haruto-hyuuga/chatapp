import 'package:chatapp/features/recents/domain/usecases/recent_contacts_use_case.dart';
import 'package:chatapp/features/recents/presentaion/bloc/recents_event.dart';
import 'package:chatapp/features/recents/presentaion/bloc/recents_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentsBloc extends Bloc<RecentsEvent, RecentsState> {
  final RecentContactsUseCase recentContactsUseCase;

  Future<void> _onRecentContactsEvent(
    LoadRecentContacts event,
    Emitter<RecentsState> emit,
  ) async {
    emit(RecentsLoading());
    try {
      final recentcontacts = await recentContactsUseCase();
      emit(RecentsLoaded(recentcontacts));
    } catch (error) {
      emit(RecentsError('Failed to load recent contacts'));
    }
  }

  RecentsBloc({required this.recentContactsUseCase}) : super(RecentsInitial()) {
    on<LoadRecentContacts>(_onRecentContactsEvent);
  }
}
