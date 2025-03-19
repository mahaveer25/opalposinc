import 'package:opalposinc/CloverDesign/Bloc/inventory_bloc.dart';
import 'package:opalposinc/connection.dart';
import 'package:opalposinc/localDatabase/Invoices/bloc/local_invoice_bloc.dart';
import 'package:opalposinc/localDatabase/PathBuilders%20+%20blocs/databaseTypeSelected.dart';
import 'package:opalposinc/localDatabase/Transaction/Bloc/bloc/local_transaction_bloc_bloc.dart';
import 'package:opalposinc/localDatabase/Transaction/Bloc/darftBloc/local_draft_bloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CartBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/showPriceTextField.dart';

import '../widgets/common/Top Section/Bloc/CustomBloc.dart';
import '../widgets/common/Top Section/Bloc/ProductBloc.dart';

class BlocRepository {
  static final cartBloc = CartBloc();
  static final listLocationBloc = ListLocationBloc();
  static final listCategoryBloc = ListCategoryBloc();
  static final listCartBloc = CartListBloc();
  static final listCustomerBloc = ListCustomerBloc();
  static final listPricingBloc = ListPricingBloc();
  static final pricingBloc = PricingBloc();

  static final customerBloc = CustomerBloc();
  static final cutomerBalanceBLoc = CustomerBalanceBloc();
  static final productBloc = ProductBloc();
  static final listBrandBloc = ListBrandBloc();
  static final locationBloc = LocationBloc();
  static final paxDeviceBloc = PaxDeviceBloc();
  static final listPaxDeviceBloc = ListPaxDevicesBloc();
  static final registerStatusBloc = RegisterStatusBloc();
  static final categoryBloc = CategoryBloc();
  static final brandBloc = BrandBloc();
  static final taxBloc = TaxBloc();

  static final loggedInUserBloc = LoggedInUserBloc();
  static final totalDiscountBloc = TotalDiscountBloc();
  static final selectedExpenseBloc = SelectedExpenseBloc();
  static final expenseDropdBloc = ExpenseDropdBloc();

  static final paymentListBloc = PaymentListBloc();
  static final paymentBloc = PaymentOptionsBloc();

  static final featurebloc = FeatureBooleanBloc();

  static final priceTextFieldBloc = PriceTextFieldBloc();

  static final changeCategoryBloc = ChangeCategoryBloc();

  static final datepickerBloc = GetDatePickerBloc();
  static final suspendedTransactionId = GetSuspenddetailsBloc();

  static final customDateBloc = GetCustomDateBloc();
  static final settingsBloc = SettingsBloc();
  static final connectionBloc = CheckConnection();

  static final localDbtypeSelected = DatabaseTypeBloc();

  static final localTransactionBloc = LocalTransactionBlocBloc();
  static final localInvoiceBloc = LocalInvoiceBloc();

  static final localDraftBloc = LocalDraftBloc();
  static final checkLocalTransaction = CheckLocalTransactinBloc();
  static final inventory = InventoryBloc();
  static final isMobile = IsMobile();
}
