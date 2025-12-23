import 'package:chatapp/features/contacts/domain/entities/contact_entity.dart';

abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<ContactEntity> contacts;
  ContactsLoaded(this.contacts);
}

class ContactsError extends ContactsState {
  final String message;
  ContactsError(this.message);
}

class ContactsAdded extends ContactsState {}
