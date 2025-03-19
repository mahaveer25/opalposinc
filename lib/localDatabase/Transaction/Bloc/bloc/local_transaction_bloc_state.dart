part of 'local_transaction_bloc_bloc.dart';

@immutable
sealed class LocalTransactionBlocState {
  final List<Transaction> listTransaction;

  const LocalTransactionBlocState(this.listTransaction);
}

class TransactionInitialState extends LocalTransactionBlocState {
  TransactionInitialState() : super([]);
}

class TransactionLoadingState extends LocalTransactionBlocState {
  TransactionLoadingState() : super([]);
}

class TransactionLoadedState extends LocalTransactionBlocState {
  @override
  final List<Transaction> listTransaction;

  const TransactionLoadedState(this.listTransaction) : super(listTransaction);
}

class TransactionUploadingState extends LocalTransactionBlocState {
  const TransactionUploadingState(super.listTransaction);
}

class TransactionUploadedState extends LocalTransactionBlocState {
  const TransactionUploadedState(super.listTransaction);
}
