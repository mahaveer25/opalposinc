// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opalposinc/CustomFuncs.dart';
import 'package:opalposinc/FetchingApis/FetchApis.dart';
import 'package:opalposinc/Functions/FunctionsProduct.dart';
import 'package:opalposinc/NewUi/Widgets/CustomMaterialWidget.dart';
import 'package:opalposinc/invoices/transaction.dart';
import 'package:opalposinc/localDatabase/Transaction/Bloc/bloc/local_transaction_bloc_bloc.dart';
import 'package:opalposinc/model/TaxModel.dart';
import 'package:opalposinc/model/TotalDiscountModel.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/model/pricinggroup.dart';
import 'package:opalposinc/model/product.dart';
import 'package:opalposinc/model/setttings.dart';
import 'package:opalposinc/services/draft_post.dart';
import 'package:opalposinc/services/quatation-Post.dart';
import 'package:opalposinc/utils/constant_dialog.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CartBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalposinc/widgets/common/left%20Section/left_sec_nav.dart';
import 'package:opalposinc/widgets/common/left%20Section/ordertaxdialog.dart';
import 'package:opalposinc/widgets/common/left%20Section/suspended_note.dart';

import '../../../model/CustomerModel.dart';
import '../../../model/location.dart';
import '../../../multiplePay/MultiplePay.dart';
import '../../major/left_section.dart';
import 'discount_card.dart';

class LeftBottomBar extends StatefulWidget {
  final double itemTotal;
  final double totalAmountBeforeDisc;
  final int quantities;
  List<Product> product = [];

  LeftBottomBar(
      {super.key,
      required this.itemTotal,
      required this.quantities,
      required this.product,
      required this.totalAmountBeforeDisc});

  @override
  State<LeftBottomBar> createState() => _LeftBottomBarState();
}

class _LeftBottomBarState extends State<LeftBottomBar> {
  double taxPlusAmount = 0.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // log('itemtotal result ${widget.itemTotal.toString()}');
    return builderTax();
  }

  Widget bottomBar(
      {required bool mobile,
      required List<Product> listProduct,
      required TaxModel taxModel,
      required TotalDiscountModel discountModel,
      required PricingGroup pricingGroup,
      required LoggedInUser loggedInUser,
      required CustomerModel customer,
      required SettingsModel setting,
      required Location location}) {
    int totalQuantity = widget.quantities;
    double itemTotalBeforeDiscountAndTax = double.parse(
        FunctionProduct.productstotal(productList: listProduct)
            .toStringAsFixed(2));
    double discountTotal = FunctionProduct.getPercentageDiscountAmount(
        amount: discountModel.amount ?? 0.0,
        discountType: discountModel.type ?? "Fixed",
        total: itemTotalBeforeDiscountAndTax);

    taxPlusAmount = FunctionProduct.getCalculatedTaxAmount(
        amountTotal: itemTotalBeforeDiscountAndTax,
        tax: taxModel.amount ?? "0.0",
        discount: discountTotal);
    log('itemTotalBeforeDiscountAndTax $itemTotalBeforeDiscountAndTax');
    log('discountTotal $discountTotal');
    log('taxPlusAmount $taxPlusAmount');

    Transaction transaction = Transaction(
      product: listProduct,
      userId: loggedInUser.id,
      businessId: loggedInUser.businessId,
      locationId: location.id,
      contactId: customer.id,
      transactionDate: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),
      priceGroup: int.parse(pricingGroup.id.toString()),
      discountType: discountModel.type,
      discountAmount: discountModel.amount == null
          ? 0.0
          : double.parse(discountModel.amount.toString()),
      totalAmountBeforeTax: widget.totalAmountBeforeDisc,
      taxRateId: taxModel.taxId,
      taxCalculationPercentage: taxModel.amount == null
          ? 0.0
          : double.parse(taxModel.amount.toString()),
      taxCalculationAmount: FunctionProduct.applyTax(
              total: widget.itemTotal, taxModel: taxModel) -
          widget.itemTotal.toDouble(),
      orderTaxModal:
          taxModel.taxId == null ? 0 : int.parse(taxModel.taxId.toString()),
      discountTypeModal: discountModel.type,
      discountAmountModal: discountModel.amount == null
          ? 0.0
          : double.parse(discountModel.amount.toString()),
      userLocation: loggedInUser.locations,
    );
    return BlocBuilder<IsMobile, bool>(
      builder: (context, isMobile) {
        return Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text('Items: $totalQuantity'),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Text(
                  'Total: \$${itemTotalBeforeDiscountAndTax.toStringAsFixed(2)}',
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: setting.posSettings?.disableDiscount == "0",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const Text('Discount Opal Points ')),
                    InkWell(
                      onTap: () {
                        if (listProduct.isEmpty) {
                          ConstDialog(context)
                              .showErrorDialog(error: 'Cart is empty');
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DiscountCard(
                                total: widget.itemTotal,
                              );
                            },
                          );
                        }
                      },
                      child: Icon(
                        Icons.add_circle,
                        color: Constant.colorPurple,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                // if( discountModel.amount!=0.00 && discountModel.amount!=null)
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(discountModel.type == "Percentage"
                          ? "Discount (${discountModel.amount}%) : "
                          : "Discount: "),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Text(" (-) \$${discountTotal.toStringAsFixed(2)}"),
                    )
                  ],
                )
              ],
            ),
          ),

          const SizedBox(
            height: 5,
          ),
          // Padding(
          //     padding:
          //         const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          // Text(
          //     'Tax Applied (${double.parse(taxModel.amount.toString()).toStringAsFixed(2)}%): \$${taxPlusAmount.toStringAsFixed(2)}  '),
          //      IconButton(onPressed: null, icon: Icons.add_circle),
          //         const Spacer(),
          //         Text.rich(
          //           TextSpan(
          //             text: 'Total Payable:  ',
          //             children: [
          //               TextSpan(
          //                 text:
          //                     '\$${FunctionProduct.applyTax(total: widget.itemTotal, taxModel: taxModel).toStringAsFixed(2)}',
          //                 style: const TextStyle(
          //                     color: Constant.colorRed,
          //                     fontSize: 18,
          //                     fontWeight: FontWeight.w900),
          //               )
          //             ],
          //             style: const TextStyle(
          //                 color: Constant.colorGrey,
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.w900),
          //           ),
          //         ),
          //       ],
          //     )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!mobile)
                  Text(
                      'Tax Applied (${double.parse(taxModel.amount.toString()).toStringAsFixed(2)}%): \$${taxPlusAmount.toStringAsFixed(2)}  '),
                if (mobile)
                  Text(
                      'Tax(${double.parse(taxModel.amount.toString()).toStringAsFixed(2)}%): \$${taxPlusAmount.toStringAsFixed(2)}  '),
                // IconButton(
                //     onPressed: () {
                //       showDialog(
                //         context: context,
                //         builder: (BuildContext context) {
                //           return Ordertaxdialog();
                //         },
                //       );
                //     },
                //     icon: Icon(Icons.add_circle)),
                // IconButton(
                //   onPressed: () {
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) => const OrderTaxDropdown(),
                //     );
                //   },
                //   icon: const Icon(Icons.add_circle),
                // ),
                if (setting.posSettings?.disableOrderTax == "0")
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              const OrderTaxDropdown(), // Wrap OrderTaxDropdown inside Dialog
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.add_circle,
                      color: Constant.colorPurple,
                      size: 28,
                    ),
                  ),

                const Spacer(),
                Text.rich(
                  TextSpan(
                    text: 'Total Payable:  ',
                    children: [
                      TextSpan(
                        text:
                            '\$${FunctionProduct.applyTax(total: widget.itemTotal, taxModel: taxModel).toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Constant.colorRed,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      )
                    ],
                    style: const TextStyle(
                      color: Constant.colorGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // const SizedBox(
          //   height: 8,
          // ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 57,
                  width: 50,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  margin: const EdgeInsets.only(left: 3, right: 3),
                  decoration: BoxDecoration(
                    color: Constant.colorPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        await FetchApis(context).fetchAll();

                        if (isMobile) {
                          await displayManager.transferDataToPresentation({
                            'type': 'discount',
                            'discount': TotalDiscountModel().toJson()
                          });

                          Navigator.of(context).pop();

                          CartBloc cartBloc =
                              BlocProvider.of<CartBloc>(context);
                          cartBloc.add(CartClearProductEvent());
                        } else {
                          // await FetchApis(context).fetchTaxes();

                          await displayManager.transferDataToPresentation({
                            'type': 'discount',
                            'discount': TotalDiscountModel().toJson()
                          });

                          CartBloc cartBloc =
                              BlocProvider.of<CartBloc>(context);
                          cartBloc.add(CartClearProductEvent());
                        }

                        await displayManager.transferDataToPresentation({
                          'type': 'discount',
                          'discount': TotalDiscountModel().toJson()
                        });

                        CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
                        cartBloc.add(CartClearProductEvent());
                      },
                      icon: const Icon(
                        Icons.remove_shopping_cart,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                suspendDrop(
                    listProduct: listProduct,
                    totalWithTax: FunctionProduct.applyTax(
                        total: widget.itemTotal, taxModel: taxModel),
                    transaction: transaction),
                draftDrop(
                    listProduct: listProduct,
                    totalWithTax: FunctionProduct.applyTax(
                        total: widget.itemTotal, taxModel: taxModel),
                    transaction: transaction),
                quotationDrop(
                    listProduct: listProduct,
                    totalWithTax: FunctionProduct.applyTax(
                        total: widget.itemTotal, taxModel: taxModel),
                    transaction: transaction),
                // LeftSecNav(
                //   title: 'Suspended',
                //   onTap: () {
                //     if (listProduct.isEmpty) {
                //       ConstDialog(context).showErrorDialog(error: 'Cart is Empty');
                //     } else {
                //       showDialog(
                //         barrierColor: Colors.black87,
                //         context: context,
                //         builder: (BuildContext context) {
                //           return const SuspendedNoteDailog();
                //         },
                //       );
                //     }
                //   },
                // ),
                // LeftSecNav(
                //   title: 'Draft',
                //   onTap: () => onPostDraft(
                //     toatlAmount: FunctionProduct.applyTax(
                // total: widget.itemTotal, taxModel: taxModel),
                //     transactionModel: transaction,
                //     listProduct: listProduct,
                //   ),
                // ),
                // LeftSecNav(
                //     title: 'Quotation',
                //     onTap: () async => onPostQuotation(
                //           toatlAmount: FunctionProduct.applyTax(
                // total: widget.itemTotal, taxModel: taxModel),
                //           transactionModel: transaction,
                //           listProduct: listProduct,
                //         )),
                BlocBuilder<IsMobile, bool>(
                  builder: (context, isMobile) {
                    return BlocBuilder<LocalTransactionBlocBloc,
                        LocalTransactionBlocState>(
                      builder: (context, state) {
                        if (state is TransactionUploadingState) {
                          return const CustomMaterialWidget(
                            onPressed: null,
                            child: SizedBox(
                                width: 20.0,
                                height: 20.0,
                                child: CircularProgressIndicator()),
                          );
                        }

                        return Expanded(
                          flex: 2,
                          child: LeftSecNav(
                              title: 'PAY',
                              color: const Color(0xff59BA47),
                              onTap: () {
                                onMultiPayment(
                                    totalAmount: FunctionProduct.applyTax(
                                        total: widget.itemTotal,
                                        taxModel: taxModel),
                                    isMobile: isMobile);
                              }),
                        );
                      },
                    );
                  },
                ),

                // LeftSecNav(
                //   title: 'Card',
                //   onTap: () => onCardTap(totalAmount: FunctionProduct.applyTax(
                // total: widget.itemTotal, taxModel: taxModel)),
                // ),
                // LeftSecNav(
                //   title: 'CANCEL',
                //   onTap: () async {
                //     if (isMobile) {
                //       await displayManager.transferDataToPresentation({
                //         'type': 'discount',
                //         'discount': TotalDiscountModel().toJson()
                //       });

                //       Navigator.of(context).pop();

                //       CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
                //       cartBloc.add(CartClearProductEvent());
                //     } else {
                //       await displayManager.transferDataToPresentation({
                //         'type': 'discount',
                //         'discount': TotalDiscountModel().toJson()
                //       });

                //       CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
                //       cartBloc.add(CartClearProductEvent());
                //     }

                //     await displayManager.transferDataToPresentation({
                //       'type': 'discount',
                //       'discount': TotalDiscountModel().toJson()
                //     });

                //     CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
                //     cartBloc.add(CartClearProductEvent());
                //   },
                // ),
              ],
            ),
          )
        ]);
      },
    );
  }

  Widget draftDrop(
      {required List<Product> listProduct,
      required double totalWithTax,
      required Transaction transaction}) {
    return BlocBuilder<SettingsBloc, SettingsModel?>(builder: (context, state) {
      if (int.parse(state!.posSettings!.disableDraft.toString()) == 1) {
        return Container();
      }

      return Expanded(
        flex: 1,
        child: LeftSecNav(
          title: 'DRAFT',
          onTap: () => onPostDraft(
            toatlAmount: totalWithTax,
            transactionModel: transaction,
            listProduct: listProduct,
          ),
        ),
      );
    });
  }

  Widget suspendDrop(
      {required List<Product> listProduct,
      required double totalWithTax,
      required Transaction transaction}) {
    return BlocBuilder<SettingsBloc, SettingsModel?>(
        builder: ((context, state) {
      if (state?.posSettings?.disableSuspend != null) {
        return Container();
      }

      return Expanded(
        flex: 1,
        child: LeftSecNav(
          title: 'SUSPEND',
          onTap: () {
            if (listProduct.isEmpty) {
              ConstDialog(context).showErrorDialog(error: 'Cart is Empty');
            } else {
              showDialog(
                barrierColor: Colors.black87,
                context: context,
                builder: (BuildContext context) {
                  return const SuspendedNoteDailog();
                },
              );
            }
          },
        ),
      );
    }));
  }

  Widget quotationDrop(
      {required List<Product> listProduct,
      required double totalWithTax,
      required Transaction transaction}) {
    return BlocBuilder<SettingsBloc, SettingsModel?>(
        builder: ((context, state) {
      if (int.parse(state!.posSettings!.disableDraft.toString()) == 1) {
        return Container();
      }

      return Expanded(
        flex: 1,
        child: LeftSecNav(
            title: 'QUOTATION',
            onTap: () async => onPostQuotation(
                  toatlAmount: totalWithTax,
                  transactionModel: transaction,
                  listProduct: listProduct,
                )),
      );
    }));
  }

  onCardTap({required double totalAmount}) {
    if (widget.quantities <= 0) {
      ConstDialog(context).showErrorDialog(error: 'Cart is empty');
    } else {
      showDialog(
          context: context,
          builder: (context) => SimpleDialog(
                clipBehavior: Clip.hardEdge,
                children: [
                  SizedBox(
                    // width: MediaQuery.of(context).size.width * 0.8,
                    // height: MediaQuery.of(context).size.height * 0.8,
                    child: MultiplePayUi(
                      amountWithOutTax: widget.itemTotal,
                      totalAmount: totalAmount,
                      totalItems: widget.quantities,
                      selectedPay: 'Card',
                      taxAmount: taxPlusAmount,
                      totalAmountBeforeDisc: widget.totalAmountBeforeDisc,
                    ),
                  )
                ],
              ));
    }
  }

  onMultiPayment({required double totalAmount, required bool isMobile}) {
    if (widget.quantities <= 0) {
      ConstDialog(context).showErrorDialog(error: 'Cart is an empty');
    } else {
      if (isMobile) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MultiplePayUi(
                  amountWithOutTax: widget.itemTotal,
                  totalAmount: totalAmount,
                  totalItems: widget.quantities,
                  selectedPay: 'Cash',
                  taxAmount: taxPlusAmount,
                  totalAmountBeforeDisc: widget.totalAmountBeforeDisc,
                )));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiplePayUi(
                amountWithOutTax: widget.itemTotal,
                totalAmount: totalAmount,
                totalItems: widget.quantities,
                selectedPay: 'Cash',
                taxAmount: taxPlusAmount,
                totalAmountBeforeDisc: widget.totalAmountBeforeDisc,
              ),
            ));
      }
    }
  }

  Widget builderTax() =>
      BlocBuilder<IsMobile, bool>(builder: (context, isMobile) {
        return BlocBuilder<LocationBloc, Location?>(
            builder: (context, location) {
          return BlocBuilder<SettingsBloc, SettingsModel?>(
              builder: (context, settings) {
            return BlocBuilder<CustomerBloc, CustomerModel?>(
                builder: (context, customer) {
              return BlocBuilder<LoggedInUserBloc, LoggedInUser?>(
                  builder: (context, loggedInUser) {
                return BlocBuilder<PricingBloc, PricingGroup?>(
                    builder: (context, pricing) {
                  return BlocBuilder<TotalDiscountBloc, TotalDiscountModel?>(
                      builder: (context, discount) {
                    return BlocBuilder<TaxBloc, TaxModel?>(
                        builder: (context, taxModel) {
                      return BlocBuilder<CartBloc, CartState>(
                          builder: (context, cartState) {
                        return bottomBar(
                          listProduct: cartState.listProduct,
                          taxModel:
                              taxModel ?? TaxModel(amount: 0.0.toString()),
                          discountModel: discount ?? TotalDiscountModel(),
                          pricingGroup:
                              pricing ?? PricingGroup(id: 0.toString()),
                          loggedInUser: loggedInUser!,
                          customer: customer ?? CustomerModel(),
                          location: location ?? const Location(),
                          setting: settings ?? const SettingsModel(),
                          mobile: isMobile,
                        );
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });

  onPostDraft(
      {required double toatlAmount,
      required Transaction transactionModel,
      required List<Product> listProduct}) async {
    if (listProduct.isEmpty) {
      ConstDialog(context).showErrorDialog(error: 'Cart is Empty');
    } else {
      await PostDraftService.postDraft(transactionModel)
          .then((result) => result.fold((left) {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => PdfPreviewPage(
                              invoice: left,
                              openFrom: 'quotation',
                            )))
                    .whenComplete(() {
                  CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
                  cartBloc.add(CartClearProductEvent());
                });
              }, (error) {
                ErrorFuncs(context)
                    .errRegisterClose(errorInfo: {'info': error});
              }));
    }
  }

  onPostQuotation(
      {required double toatlAmount,
      required Transaction transactionModel,
      required List<Product> listProduct}) async {
    if (listProduct.isEmpty) {
      ConstDialog(context).showErrorDialog(error: 'Cart is Empty');
    } else {
      await PostQuatationService.placeOrder(transactionModel)
          .then((result) => result.fold((left) {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => PdfPreviewPage(
                              invoice: left,
                              openFrom: 'quotation',
                            )))
                    .whenComplete(() {
                  CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
                  cartBloc.add(CartClearProductEvent());
                });
              }, (error) {
                ErrorFuncs(context)
                    .errRegisterClose(errorInfo: {'info': error});
              }));
    }
  }
}
