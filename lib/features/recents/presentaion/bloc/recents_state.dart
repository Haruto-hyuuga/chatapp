import 'package:chatapp/features/contacts/domain/entities/contact_entity.dart';

abstract class RecentsState {}

class RecentsInitial extends RecentsState {}

class RecentsLoading extends RecentsState {}

class RecentsLoaded extends RecentsState {
  final List<ContactEntity> recentContacts;
  RecentsLoaded(this.recentContacts);
}

class RecentsError extends RecentsState {
  final String error;
  RecentsError({required this.error});
}
