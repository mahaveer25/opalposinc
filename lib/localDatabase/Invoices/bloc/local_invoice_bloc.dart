import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/localDatabase/Invoices/LocalInvoices.dart';

part 'local_invoice_event.dart';
part 'local_invoice_state.dart';

class LocalInvoiceBloc extends Bloc<LocalInvoiceEvent, LocalInvoiceState> {
  LocalInvoices localInvoiceModel = LocalInvoices();

  List<InvoiceModel> list = [];

  LocalInvoiceBloc() : super(InvoiceModelInitialState()) {
    on<AddInvoiceModelEvent>(addInvoiceModel);
    on<GetInvoiceModelEvent>(getInvoiceModel);
    // on<UploadInvoiceModelEvent>(uploadInvoiceModel);
    on<RemoveInvoiceModelEvent>(removeInvoiceModel);
    on<ClearInvoiceModelEvent>(clearInvoiceModel);
  }

  addInvoiceModel(
      AddInvoiceModelEvent event, Emitter<LocalInvoiceState> emitter) async {
    await localInvoiceModel.addToLocal(
        context: event.context!, invoice: event.invoice!);
  }

  getInvoiceModel(
      GetInvoiceModelEvent event, Emitter<LocalInvoiceState> emitter) async {
    await localInvoiceModel.getLocalInvoices().then((value) {
      for (var element in value) {
        final ids = list.map((e) => e.offlineInvoiceNo).toList();
        if (!ids.contains(element.offlineInvoiceNo)) {
          list.add(element);
        }
      }
    });

    emitter(InvoiceModelLoadedState(list));
  }

  removeInvoiceModel(
      RemoveInvoiceModelEvent event, Emitter<LocalInvoiceState> emitter) async {
    final transaction = list.firstWhere(
        (element) => element.offlineInvoiceNo == event.offlineInvoiceModelId);

    await localInvoiceModel
        .removeFromLocal(id: event.offlineInvoiceModelId.toString())
        .whenComplete(() => list.remove(transaction));

    add(GetInvoiceModelEvent());
  }

  clearInvoiceModel(
      ClearInvoiceModelEvent event, Emitter<LocalInvoiceState> emitter) {}
}
