import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opalsystem/CustomFuncs.dart';
import 'package:opalsystem/model/product.dart';
import 'package:opalsystem/multiplePay/MultiplePay.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/widgets/CustomWidgets/CustomIniputField.dart';

import '../../../invoices/transaction.dart';
import '../../../model/CustomerModel.dart';
import '../../../model/TaxModel.dart';
import '../../../model/TotalDiscountModel.dart';
import '../../../model/location.dart';
import '../../../model/loggedInUser.dart';
import '../../../model/pricinggroup.dart';
import '../../../services/suspended_note.dart';
import '../Top Section/Bloc/CartBloc.dart';
import '../Top Section/Bloc/CustomBloc.dart';

class SuspendedNoteDailog extends StatefulWidget {
  final String? methodTypes;
  final double? totalAmount, amountWithOutTax;
  final int? totalItems;
  const SuspendedNoteDailog(
      {super.key,
      this.methodTypes,
      this.totalAmount,
      this.amountWithOutTax,
      this.totalItems});

  @override
  State<SuspendedNoteDailog> createState() => _SuspendedNoteDailogState();
}

class _SuspendedNoteDailogState extends State<SuspendedNoteDailog> {
  TextEditingController suspendedNote = TextEditingController();

  void onsuspended(
      {required LoggedInUser loggedInUser,
      required Location location,
      required CustomerModel customerModel,
      required PricingGroup pricing,
      required TotalDiscountModel totalDiscountModel,
      required TaxModel taxModel,
      required List<Product> productList}) async {
    Transaction payload = Transaction(
      userId: loggedInUser.id,
      businessId: loggedInUser.businessId,
      locationId: location.id,
      contactId: customerModel.id,
      transactionDate: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),
      priceGroup: int.parse(pricing.id.toString()),
      product: productList,
      discountType: totalDiscountModel.type,
      discountAmount: totalDiscountModel.amount == null
          ? 0.0
          : double.parse(totalDiscountModel.amount.toString()),
      totalAmountBeforeTax: widget.amountWithOutTax ?? 0.0,
      taxRateId: taxModel.taxId,
      taxCalculationPercentage: taxModel.amount == null
          ? 0.0
          : double.parse(taxModel.amount.toString()),
      taxCalculationAmount: (widget.totalAmount ?? 0.0).toDouble() -
          (widget.amountWithOutTax ?? 0.0).toDouble(),
      orderTaxModal: int.parse(taxModel.taxId.toString()),
      discountTypeModal: totalDiscountModel.type,
      discountAmountModal: totalDiscountModel.amount == null
          ? 0.0
          : double.parse(totalDiscountModel.amount.toString()),
      suspendNote: suspendedNote.text,
    );

    await Suspendorder()
        .suspendOrder(context, payload)
        .then((result) => result.fold((left) {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => PdfPreviewPage(
                            invoice: left,
                            openFrom: 'invoice',
                          )))
                  .whenComplete(() {
                CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
                cartBloc.add(CartClearProductEvent());
              });
            }, (error) {
              ErrorFuncs(context).errRegisterClose(errorInfo: {'info': error});
            }));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IsMobile, bool>(builder: (context, isMobile) {
      return SimpleDialog(
        insetPadding: const EdgeInsets.only(left: 20, right: 20),
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.6,
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Suspended Sale',
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.cancel_rounded,
                          size: 30,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: CustomInputField(
                        labelText: 'Suspended Note',
                        hintText: 'Suspended Note',
                        maxLines: 5,
                        controller: suspendedNote,
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      suspendedButton(),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Constant.colorPurple,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget suspendedButton() {
    return BlocBuilder<LoggedInUserBloc, LoggedInUser?>(
      builder: (context, loggedInUser) {
        if (loggedInUser == null) {
          return Container(); // Return an empty container if user is null
        }
        return BlocBuilder<LocationBloc, Location?>(
          builder: (context, location) {
            if (location == null) {
              return Container(); // Return an empty container if location is null
            }
            return BlocBuilder<CustomerBloc, CustomerModel?>(
              builder: (context, customer) {
                if (customer == null) {
                  return Container(); // Return an empty container if customer is null
                }
                return BlocBuilder<PricingBloc, PricingGroup?>(
                  builder: (context, pricing) {
                    if (pricing == null) {
                      return Container(); // Return an empty container if pricing is null
                    }
                    return BlocBuilder<TotalDiscountBloc, TotalDiscountModel?>(
                      builder: (context, discount) {
                        if (discount == null) {
                          return Container(); // Return an empty container if discount is null
                        }
                        return BlocBuilder<CartBloc, CartState?>(
                          builder: (context, cart) {
                            if (cart is! CartLoadedState) {
                              return Container(); // Return an empty container if cart is not loaded
                            }
                            return BlocBuilder<TaxBloc, TaxModel?>(
                              builder: (context, tax) {
                                if (tax == null) {
                                  return Container(); // Return an empty container if tax is null
                                }
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Constant.colorPurple,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  onPressed: () => onsuspended(
                                    loggedInUser: loggedInUser,
                                    location: location,
                                    customerModel: customer,
                                    pricing: pricing,
                                    totalDiscountModel: discount,
                                    taxModel: tax,
                                    productList: (cart).listProduct,
                                  ),
                                  child: const Text(
                                    'Suspend Sale',
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
