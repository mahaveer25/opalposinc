import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:opalposinc/invoices/transaction.dart';
import 'package:opalposinc/localDatabase/Transaction/Pages/LocalDraftdb.dart';
import 'package:opalposinc/services/placeorder.dart';

part 'local_draft_event.dart';
part 'local_draft_state.dart';

class LocalDraftBloc extends Bloc<LocalDraftEvent, LocalDraftState> {
  LocalDraft localDraft = LocalDraft();

  List<Transaction> list = [];

  LocalDraftBloc() : super(DraftInitialState()) {
    on<AddDraftEvent>(addDraft);
    on<GetDraftEvent>(getDraft);
    on<UploadDraftEvent>(uploadDraft);
    on<RemoveDraftEvent>(removeDraft);
    on<ClearDraftEvent>(clearDraft);
  }

  addDraft(AddDraftEvent event, Emitter<LocalDraftState> emitter) async {
    await localDraft.addToLocal(
        transaction: event.transaction!, context: event.context!);
  }

  getDraft(GetDraftEvent event, Emitter<LocalDraftState> emitter) async {
    await localDraft.getLocalTransactions().then((value) {
      for (var element in value) {
        final ids = list.map((e) => e.offlineInvoiceNo).toList();
        if (!ids.contains(element.offlineInvoiceNo)) {
          list.add(element);
        }
      }
    });

    emitter(DraftLoadedState(list));
  }

  removeDraft(RemoveDraftEvent event, Emitter<LocalDraftState> emitter) async {
    emitter(DraftLoadingState());
    final transaction = list.firstWhere(
        (element) => element.offlineInvoiceNo == event.offlineDraftId);

    await localDraft
        .removeFromLocal(id: event.offlineDraftId.toString())
        .whenComplete(() => list.remove(transaction));

    add(GetDraftEvent());
  }

  clearDraft(ClearDraftEvent event, Emitter<LocalDraftState> emitter) {}

  uploadDraft(UploadDraftEvent event, Emitter<LocalDraftState> emit) async {
    emit(DraftLoadingState());
    // await Future.delayed(const Duration(seconds: 10));

    final data =
        await PlaceOrder().placeOrder(event.context!, event.transaction!);

    await data.fold((invoiceModel) async {
      add(RemoveDraftEvent(
          offlineDraftId: invoiceModel.offlineInvoiceNo.toString()));
    }, (error) async {
      log(error);
      add(GetDraftEvent());
    });
  }
}
