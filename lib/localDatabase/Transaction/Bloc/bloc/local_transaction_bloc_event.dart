part of 'local_transaction_bloc_bloc.dart';

@immutable
sealed class LocalTransactionBlocEvent {}

class TransactionInitialEvent extends LocalTransactionBlocEvent {}

class AddTransactionEvent extends LocalTransactionBlocEvent {
  final Transaction? transaction;
  final BuildContext? context;

  AddTransactionEvent({this.transaction, this.context});
}

class GetTransactionEvent extends LocalTransactionBlocEvent {
  GetTransactionEvent();
}

class CheckTransactionEvent extends LocalTransactionBlocEvent {
  final BuildContext context;

  CheckTransactionEvent({required this.context});
}

class RemoveTransactionEvent extends LocalTransactionBlocEvent {
  final String? offlineTransactionId;

  RemoveTransactionEvent({this.offlineTransactionId});
}

class UploadTransactionEvent extends LocalTransactionBlocEvent {
  final List<Transaction> transaction;
  final BuildContext context;

  UploadTransactionEvent({required this.transaction, required this.context});
}

class ClearTransactionEvent extends LocalTransactionBlocEvent {
  ClearTransactionEvent();
}
