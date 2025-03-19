part of 'local_invoice_bloc.dart';

@immutable
sealed class LocalInvoiceState {
  final List<InvoiceModel> listInvoiceModel;

  const LocalInvoiceState(this.listInvoiceModel);
}

class InvoiceModelInitialState extends LocalInvoiceState {
  InvoiceModelInitialState() : super([]);
}

class InvoiceModelLoadingState extends LocalInvoiceState {
  InvoiceModelLoadingState() : super([]);
}

class InvoiceModelLoadedState extends LocalInvoiceState {
  @override
  final List<InvoiceModel> listInvoiceModel;

  const InvoiceModelLoadedState(this.listInvoiceModel)
      : super(listInvoiceModel);
}
