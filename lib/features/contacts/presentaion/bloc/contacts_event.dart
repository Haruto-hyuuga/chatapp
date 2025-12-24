abstract class ContactsEvent {}

class FetchContacts extends ContactsEvent {}

class CheckOrCreateConversation extends ContactsEvent {
  final String contactId;
  final String contactName;
  final String contactProfileUrl;

  CheckOrCreateConversation(
    this.contactId,
    this.contactName,
    this.contactProfileUrl,
  );
}

class AddContact extends ContactsEvent {
  final String email;

  AddContact(this.email);
}
