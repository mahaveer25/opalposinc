part of 'local_draft_bloc.dart';

@immutable
sealed class LocalDraftEvent {}

class AddDraftEvent extends LocalDraftEvent {
  final Transaction? transaction;
  final BuildContext? context;

  AddDraftEvent({this.transaction, this.context});
}

class GetDraftEvent extends LocalDraftEvent {
  final List<Transaction>? transaction;

  GetDraftEvent({this.transaction});
}

class RemoveDraftEvent extends LocalDraftEvent {
  final String? offlineDraftId;

  RemoveDraftEvent({this.offlineDraftId});
}

class UploadDraftEvent extends LocalDraftEvent {
  final Transaction? transaction;
  final BuildContext? context;

  UploadDraftEvent({this.transaction, this.context});
}

class ClearDraftEvent extends LocalDraftEvent {
  ClearDraftEvent();
}
