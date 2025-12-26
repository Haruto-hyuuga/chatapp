import 'package:chatapp/features/contacts/domain/entities/contact_entity.dart';

abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<ContactEntity> contacts;
  ContactsLoaded(this.contacts);
}

class ContactsError extends ContactsState {
  final String error;
  ContactsError({required this.error});
}

class ContactsAdded extends ContactsState {}

class ConversationReady extends ContactsState {
  final String conversationId;
  final String contactName;
  final String contactProfileUrl;

  ConversationReady({
    required this.conversationId,
    required this.contactName,
    required this.contactProfileUrl,
  });
}
