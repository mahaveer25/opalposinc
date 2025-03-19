part of 'local_invoice_bloc.dart';

@immutable
sealed class LocalInvoiceEvent {}

class InvoiceModelInitialEvent extends LocalInvoiceEvent {}

class AddInvoiceModelEvent extends LocalInvoiceEvent {
  final InvoiceModel? invoice;
  final BuildContext? context;

  AddInvoiceModelEvent({this.invoice, this.context});
}

class GetInvoiceModelEvent extends LocalInvoiceEvent {
  final List<InvoiceModel>? invoice;

  GetInvoiceModelEvent({this.invoice});
}

class RemoveInvoiceModelEvent extends LocalInvoiceEvent {
  final String? offlineInvoiceModelId;

  RemoveInvoiceModelEvent({this.offlineInvoiceModelId});
}

class UploadInvoiceModelEvent extends LocalInvoiceEvent {
  final InvoiceModel? invoice;
  final BuildContext? context;

  UploadInvoiceModelEvent({this.invoice, this.context});
}

class ClearInvoiceModelEvent extends LocalInvoiceEvent {
  ClearInvoiceModelEvent();
}
