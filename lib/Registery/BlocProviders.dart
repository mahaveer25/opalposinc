import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/CloverDesign/Bloc/inventory_bloc.dart';
import 'package:opalsystem/connection.dart';
import 'package:opalsystem/localDatabase/Invoices/bloc/local_invoice_bloc.dart';
import 'package:opalsystem/localDatabase/PathBuilders%20+%20blocs/databaseTypeSelected.dart';
import 'package:opalsystem/localDatabase/Transaction/Bloc/bloc/local_transaction_bloc_bloc.dart';
import 'package:opalsystem/localDatabase/Transaction/Bloc/darftBloc/local_draft_bloc.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/ProductBloc.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/showPriceTextField.dart';

import '../widgets/common/Top Section/Bloc/CartBloc.dart';
import '../widgets/common/Top Section/Bloc/CustomBloc.dart';
import 'BlocRepository.dart';

class BlocProviders {
  static final List<BlocProvider> providers = [
    BlocProvider<IsMobile>.value(value: BlocRepository.isMobile),
    BlocProvider<ListLocationBloc>.value(
        value: BlocRepository.listLocationBloc),
    BlocProvider<ListCategoryBloc>.value(
        value: BlocRepository.listCategoryBloc),
    BlocProvider<TotalDiscountBloc>.value(
        value: BlocRepository.totalDiscountBloc),
    BlocProvider<SelectedExpenseBloc>.value(
        value: BlocRepository.selectedExpenseBloc),
    BlocProvider<ExpenseDropdBloc>.value(
        value: BlocRepository.expenseDropdBloc),
    BlocProvider<CartListBloc>.value(value: BlocRepository.listCartBloc),
    BlocProvider<CartBloc>.value(value: BlocRepository.cartBloc),
    BlocProvider<ListBrandBloc>.value(value: BlocRepository.listBrandBloc),
    BlocProvider<LocationBloc>.value(value: BlocRepository.locationBloc),
    BlocProvider<PaxDeviceBloc>.value(value: BlocRepository.paxDeviceBloc),
    BlocProvider<ListPaxDevicesBloc>.value(
        value: BlocRepository.listPaxDeviceBloc),
    BlocProvider<RegisterStatusBloc>.value(
        value: BlocRepository.registerStatusBloc),
    BlocProvider<CategoryBloc>.value(value: BlocRepository.categoryBloc),
    BlocProvider<BrandBloc>.value(value: BlocRepository.brandBloc),
    BlocProvider<TaxBloc>.value(value: BlocRepository.taxBloc),
    BlocProvider<LoggedInUserBloc>.value(
        value: BlocRepository.loggedInUserBloc),
    BlocProvider<ListCustomerBloc>.value(
        value: BlocRepository.listCustomerBloc),
    BlocProvider<CustomerBloc>.value(value: BlocRepository.customerBloc),
    BlocProvider<CustomerBalanceBloc>.value(
        value: BlocRepository.cutomerBalanceBLoc),
    BlocProvider<ProductBloc>.value(value: BlocRepository.productBloc),
    BlocProvider<PricingBloc>.value(value: BlocRepository.pricingBloc),
    BlocProvider<ListPricingBloc>.value(value: BlocRepository.listPricingBloc),
    BlocProvider<PaymentListBloc>.value(value: BlocRepository.paymentListBloc),
    BlocProvider<PaymentOptionsBloc>.value(value: BlocRepository.paymentBloc),
    BlocProvider<FeatureBooleanBloc>.value(value: BlocRepository.featurebloc),
    BlocProvider<PriceTextFieldBloc>.value(
        value: BlocRepository.priceTextFieldBloc),
    BlocProvider<ChangeCategoryBloc>.value(
        value: BlocRepository.changeCategoryBloc),
    BlocProvider<GetDatePickerBloc>.value(value: BlocRepository.datepickerBloc),
    BlocProvider<GetCustomDateBloc>.value(value: BlocRepository.customDateBloc),
    BlocProvider<GetSuspenddetailsBloc>.value(
        value: BlocRepository.suspendedTransactionId),
    BlocProvider<SettingsBloc>.value(value: BlocRepository.settingsBloc),
    BlocProvider<CheckConnection>.value(value: BlocRepository.connectionBloc),
    BlocProvider<DatabaseTypeBloc>.value(
        value: BlocRepository.localDbtypeSelected),
    BlocProvider<LocalTransactionBlocBloc>.value(
        value: BlocRepository.localTransactionBloc),
    BlocProvider<LocalInvoiceBloc>.value(
        value: BlocRepository.localInvoiceBloc),
    BlocProvider<LocalDraftBloc>.value(value: BlocRepository.localDraftBloc),
    BlocProvider<CheckLocalTransactinBloc>.value(
        value: BlocRepository.checkLocalTransaction),
    BlocProvider<InventoryBloc>.value(
        value: BlocRepository.inventory)
  ];
}
