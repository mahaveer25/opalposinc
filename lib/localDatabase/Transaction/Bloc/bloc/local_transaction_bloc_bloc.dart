import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:opalposinc/invoices/transaction.dart';
import 'package:opalposinc/localDatabase/Transaction/Pages/LocalDraftdb.dart';
import 'package:opalposinc/localDatabase/Transaction/localTransaction.dart';
import 'package:opalposinc/services/placeorder.dart';

part 'local_transaction_bloc_event.dart';
part 'local_transaction_bloc_state.dart';

class LocalTransactionBlocBloc
    extends Bloc<LocalTransactionBlocEvent, LocalTransactionBlocState> {
  LocalTransaction localTransaction = LocalTransaction();
  LocalDraft draft = LocalDraft();

  // List<Transaction> list = [];

  LocalTransactionBlocBloc() : super(TransactionInitialState()) {
    on<AddTransactionEvent>(addTransaction);
    on<GetTransactionEvent>(getTransaction);
    on<UploadTransactionEvent>(uploadTransaction);
    on<RemoveTransactionEvent>(removeTransaction);
    on<ClearTransactionEvent>(clearTransaction);
    on<CheckTransactionEvent>(checkTransaction);
  }

  addTransaction(AddTransactionEvent event,
      Emitter<LocalTransactionBlocState> emitter) async {
    await localTransaction.addToLocal(
        transaction: event.transaction!, context: event.context!);
  }

  getTransaction(GetTransactionEvent event,
      Emitter<LocalTransactionBlocState> emitter) async {
    final list = await localTransaction.getLocalTransactions();

    // .then((value) {
    //   for (var element in value) {
    //     final ids = list.map((e) => e.offlineInvoiceNo).toList();
    //     if (!ids.contains(element.offlineInvoiceNo)) {
    //       list.add(element);
    //     }
    //   }
    // });

    emitter(TransactionLoadedState(list));
  }

  removeTransaction(RemoveTransactionEvent event,
      Emitter<LocalTransactionBlocState> emitter) async {
    // final list = await localTransaction.getLocalTransactions();
    // final transaction = list.firstWhere(
    //     (element) => element.offlineInvoiceNo == event.offlineTransactionId);

    await localTransaction.removeFromLocal(
        id: event.offlineTransactionId.toString());
    // .whenComplete(() => list.remove(transaction));

    add(GetTransactionEvent());
  }

  clearTransaction(ClearTransactionEvent event,
      Emitter<LocalTransactionBlocState> emitter) {}

  uploadTransaction(UploadTransactionEvent event,
      Emitter<LocalTransactionBlocState> emit) async {
    for (var transaction in event.transaction) {
      emit(const TransactionUploadingState([]));

      // Attempt to place the order
      final data = await PlaceOrder().placeOrder(event.context, transaction);
// if (data['success'] == true){}
      await data.fold((invoiceModel) async {
        // If successful, remove the transaction from local storage
        // await localTransaction.removeFromLocal(
        //     id: transaction.offlineInvoiceNo.toString());
      }, (error) async {
        // If failed, add the transaction to the draft
        log(error);
        await draft.addToLocal(
            context: event.context, transaction: transaction);
      });

      // Add a delay before processing the next transaction
      await Future.delayed(const Duration(seconds: 3));
    }

    emit(const TransactionUploadedState([]));
  }

  Future<FutureOr<void>> checkTransaction(CheckTransactionEvent event,
      Emitter<LocalTransactionBlocState> emit) async {
    final list = await localTransaction.getLocalTransactions();
    log("list: $list");
    if (list.isNotEmpty) {
      add(UploadTransactionEvent(transaction: list, context: event.context));
    }

    emit(TransactionUploadedState(list));
  }
}
