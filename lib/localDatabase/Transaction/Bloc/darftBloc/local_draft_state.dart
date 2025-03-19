part of 'local_draft_bloc.dart';

@immutable
sealed class LocalDraftState {
  final List<Transaction> listTransaction;

  const LocalDraftState(this.listTransaction);
}

class DraftInitialState extends LocalDraftState {
  DraftInitialState() : super([]);
}

class DraftLoadingState extends LocalDraftState {
  DraftLoadingState() : super([]);
}

class DraftLoadedState extends LocalDraftState {
  final List<Transaction> listDraft;

  const DraftLoadedState(this.listDraft) : super(listDraft);
}
