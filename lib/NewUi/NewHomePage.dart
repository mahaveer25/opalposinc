import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opalposinc/Functions/FunctionsProduct.dart';
import 'package:opalposinc/NewUi/Pages/CartViewWidget.dart';
import 'package:opalposinc/NewUi/SideBar.dart';
import 'package:opalposinc/NewUi/Widgets/CustomContainer.dart';
import 'package:opalposinc/NewUi/Widgets/CustomPayBar.dart';
import 'package:opalposinc/NewUi/Widgets/CustomSearchBar.dart';
import 'package:opalposinc/connection.dart';
import 'package:opalposinc/invoices/transaction.dart';
import 'package:opalposinc/model/CustomerModel.dart';
import 'package:opalposinc/model/TaxModel.dart';
import 'package:opalposinc/model/TotalDiscountModel.dart';
import 'package:opalposinc/model/brand.dart';
import 'package:opalposinc/model/category.dart';
import 'package:opalposinc/model/location.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/model/pricinggroup.dart';
import 'package:opalposinc/utils/decorations.dart';
import 'package:opalposinc/widgets/common/Right%20Section/brand_dropdown.dart';
import 'package:opalposinc/widgets/common/Right%20Section/category.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CartBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/ProductBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/location.dart';
import 'package:opalposinc/widgets/common/left%20Section/left_dropdown.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  FocusNode focusNode = FocusNode();
  final searchController = TextEditingController();
  bool isFocused = false;

  late StreamSubscription<bool> streamSubscription;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.bottom]);

    focusNode.addListener(_onFocusChange);

    streamSubscription = ConnectionFuncs.checkInternetConnectivityStream()
        .asBroadcastStream()
        .listen((isConnected) {
      log('$isConnected');
      CheckConnection connection = BlocProvider.of<CheckConnection>(context);
      connection.add(isConnected);
    });

    onInit();
    super.initState();
  }

  onInit() async {
    LoggedInUserBloc userBloc = BlocProvider.of<LoggedInUserBloc>(context);
    LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
    CategoryBloc categoryBloc = BlocProvider.of<CategoryBloc>(context);
    BrandBloc brandBloc = BlocProvider.of<BrandBloc>(context);
    ProductBloc bloc = BlocProvider.of<ProductBloc>(context);

    bloc.add(GetProductEvent(
        context,
        userBloc.state ?? LoggedInUser(),
        brandBloc.state ?? Brand(),
        categoryBloc.state ?? Category(),
        locationBloc.state ?? const Location()));
  }

  void _onFocusChange() {
    setState(() {
      isFocused = focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    focusNode.removeListener(_onFocusChange);
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: BlocBuilder<CheckConnection, bool>(
          builder: (context, isConnected) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: body()),
                if (isConnected) const NewSideBar()
              ],
            );
          },
        ));
  }

  Widget body() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomSearchBar(
                  focusNode: focusNode,
                  searchController: searchController,
                  onSearch: onSearch,
                ),
                Decorations.width15,
                if (searchController.text.isEmpty)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: LocationDropdown(),
                            ),
                          ),
                        ),
                        // Decorations.width5,
                        // Expanded(
                        //   child: Material(
                        //     borderRadius: BorderRadius.circular(10.0),
                        //     child: const Padding(
                        //       padding: EdgeInsets.all(8.0),
                        //       child: PricingGroupDropdown(),
                        //     ),
                        //   ),
                        // ),
                        Decorations.width5,
                        Expanded(
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: DropDownCustomer(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (searchController.text.isNotEmpty)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: CategoriesDropdown(),
                            ),
                          ),
                        ),
                        Decorations.width5,
                        Expanded(
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: BrandsDropdown(
                                onBrandChange: (brand) {
                                  BrandBloc brandBloc =
                                      BlocProvider.of<BrandBloc>(context);
                                  brandBloc.add(brand);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Decorations.height10,
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowProducts(searchController: searchController),
                  Decorations.width15,
                  BlocBuilder<LocationBloc, Location?>(
                      builder: (context, location) {
                    return BlocBuilder<CustomerBloc, CustomerModel?>(
                        builder: (context, customer) {
                      return BlocBuilder<LoggedInUserBloc, LoggedInUser?>(
                          builder: (context, loggedInUser) {
                        return BlocBuilder<PricingBloc, PricingGroup?>(
                            builder: (context, pricing) {
                          return BlocBuilder<TotalDiscountBloc,
                                  TotalDiscountModel?>(
                              builder: (context, invoiceDiscount) {
                            return BlocBuilder<TaxBloc, TaxModel?>(
                                builder: (context, taxModel) {
                              return BlocBuilder<CartBloc, CartState>(
                                  builder: (context, cartState) {
                                int quantities =
                                    FunctionProduct.getProductLength(
                                        productList: cartState.listProduct);

                                double calculateItemTotal() {
                                  double itemTotal = 0.0;

                                  itemTotal = FunctionProduct.productstotal(
                                      productList: cartState.listProduct);

                                  return FunctionProduct.applyDiscount(
                                      selectedValue:
                                          invoiceDiscount?.type ?? 'fixed',
                                      discount: (invoiceDiscount?.amount
                                                  ?.toDouble() ??
                                              0.0)
                                          .toDouble(),
                                      amount: itemTotal);
                                }

                                final totalAmountbeforetax =
                                    FunctionProduct.productstotal(
                                        productList: cartState.listProduct);

                                Transaction transaction = Transaction(
                                  product: cartState.listProduct,
                                  userId: loggedInUser?.id,
                                  businessId: loggedInUser?.businessId,
                                  locationId: location?.id,
                                  contactId: customer?.id,
                                  transactionDate:
                                      DateFormat('yyyy-MM-dd hh:mm')
                                          .format(DateTime.now()),
                                  priceGroup: pricing?.id == null
                                      ? 0
                                      : int.parse(pricing?.id ?? ''),
                                  discountType: invoiceDiscount?.type,
                                  discountAmount: invoiceDiscount?.amount ==
                                          null
                                      ? 0.0
                                      : double.parse(
                                          invoiceDiscount?.amount.toString() ??
                                              0.0.toString()),
                                  totalAmountBeforeTax: totalAmountbeforetax,
                                  taxRateId: taxModel?.taxId,
                                  taxCalculationPercentage:
                                      taxModel?.amount == null
                                          ? 0.0
                                          : double.parse(
                                              taxModel!.amount.toString()),
                                  taxCalculationAmount:
                                      FunctionProduct.applyTax(
                                              total: calculateItemTotal(),
                                              taxModel:
                                                  taxModel ?? TaxModel()) -
                                          calculateItemTotal().toDouble(),
                                  orderTaxModal: taxModel?.taxId == null
                                      ? 0
                                      : int.parse(taxModel?.taxId ?? ''),
                                  discountTypeModal: invoiceDiscount?.type,
                                  discountAmountModal:
                                      invoiceDiscount?.amount == null
                                          ? 0.0
                                          : double.parse(invoiceDiscount?.amount
                                                  .toString() ??
                                              0.0.toString()),
                                  userLocation: loggedInUser?.locations,
                                );

                                return Expanded(
                                    child: Column(
                                  // runSpacing: 5.0,
                                  // spacing: 5.0,
                                  children: [
                                    Expanded(
                                      child: CartViewWidget(
                                        taxModel: taxModel ?? TaxModel(),
                                        discountModel: invoiceDiscount ??
                                            TotalDiscountModel(),
                                        listProducts: cartState.listProduct,
                                        itemTotal: calculateItemTotal(),
                                        totalAmountBeforeDisc:
                                            totalAmountbeforetax,
                                        quantities: quantities,
                                      ),
                                    ),
                                    Decorations.height10,
                                    CustomPaymentBar(
                                      itemTotal: calculateItemTotal(),
                                      quantities: quantities,
                                      taxModel: taxModel ?? TaxModel(),
                                      transaction: transaction,
                                    )
                                  ],
                                ));
                              });
                            });
                          });
                        });
                      });
                    });
                  }),
                ],
              ),
            ),
          ],
        ),
      );

  void onSearch(String value) => setState(() {});
}
