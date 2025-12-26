import 'package:chatapp/features/contacts/domain/usecases/add_contact_use_case.dart';
import 'package:chatapp/features/contacts/domain/usecases/fetch_contacts_use_case.dart';
import 'package:chatapp/features/contacts/presentaion/bloc/contacts_event.dart';
import 'package:chatapp/features/contacts/presentaion/bloc/contacts_state.dart';
import 'package:chatapp/features/conversation/domain/usecases/check_or_create_conversation_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final FetchContactsUseCase fetchContactsUseCase;
  final AddContactUseCase addContactUseCase;
  final CheckOrCreateConversationUseCase checkOrCreateConversationUseCase;

  Future<void> _onFetchContacts(
    FetchContacts event,
    Emitter<ContactsState> emit,
  ) async {
    emit(ContactsLoading());
    try {
      final contacts = await fetchContactsUseCase();
      emit(ContactsLoaded(contacts));
    } catch (err) {
      emit(
        ContactsError(error: 'Failed to fetch contacts\nBackend Says:\n$err'),
      );
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
    } catch (err) {
      emit(ContactsError(error: 'Failed to add contacts\nBackend Says:\n$err'));
    }
  }

  Future<void> _onCheckOrCreateConversation(
    CheckOrCreateConversation event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      emit(ContactsLoading());
      final conversationId = await checkOrCreateConversationUseCase(
        contactId: event.contactId,
      );
      emit(
        ConversationReady(
          conversationId: conversationId,
          contactName: event.contactName,
          contactProfileUrl: event.contactProfileUrl,
        ),
      );
    } catch (err) {
      emit(
        ContactsError(
          error: 'Failed to start conversation.\nBackend Says:\n$err',
        ),
      );
    }
  }

  ContactsBloc({
    required this.fetchContactsUseCase,
    required this.addContactUseCase,
    required this.checkOrCreateConversationUseCase,
  }) : super(ContactsInitial()) {
    on<FetchContacts>(_onFetchContacts);
    on<AddContact>(_onAddContact);
    on<CheckOrCreateConversation>(_onCheckOrCreateConversation);
  }
}
