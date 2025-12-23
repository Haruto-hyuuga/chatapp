import 'package:chatapp/features/contacts/domain/usecases/add_contact_use_case.dart';
import 'package:chatapp/features/contacts/domain/usecases/fetch_contacts_use_case.dart';
import 'package:chatapp/features/contacts/presentaion/bloc/contacts_event.dart';
import 'package:chatapp/features/contacts/presentaion/bloc/contacts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final FetchContactsUseCase fetchContactsUseCase;
  final AddContactUseCase addContactUseCase;

  Future<void> _onFetchContacts(
    FetchContacts event,
    Emitter<ContactsState> emit,
  ) async {
    emit(ContactsLoading());
    try {
      final contacts = await fetchContactsUseCase();
      emit(ContactsLoaded(contacts));
    } catch (error) {
      emit(ContactsError('Failed to fetch contacts $error'));
    }
  }

  Future<void> _onAddContact(
    AddContact event,
    Emitter<ContactsState> emit,
  ) async {
    emit(ContactsLoading());
    try {
      await addContactUseCase(email: event.email);
      emit(ContactsAdded());
      add(FetchContacts());
    } catch (error) {
      emit(ContactsError('Failed to add contacts $error'));
    }
  }

  ContactsBloc({
    required this.fetchContactsUseCase,
    required this.addContactUseCase,
  }) : super(ContactsInitial()) {
    on<FetchContacts>(_onFetchContacts);
    on<AddContact>(_onAddContact);
  }
}
