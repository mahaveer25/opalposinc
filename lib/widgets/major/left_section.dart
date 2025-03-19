import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/FetchingApis/FetchApis.dart';
import 'package:opalposinc/Functions/FunctionsProduct.dart';
import 'package:opalposinc/connection.dart';
import 'package:opalposinc/model/TaxModel.dart';
import 'package:opalposinc/model/TotalDiscountModel.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/model/setttings.dart';
import 'package:opalposinc/services/removeIteminCartNotification.dart';
import 'package:opalposinc/utils/constants_number.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalposinc/widgets/common/left%20Section/left_bottom_bar.dart';
import 'package:opalposinc/widgets/common/left%20Section/left_dropdown.dart';
import 'package:presentation_displays/displays_manager.dart';

import '../../model/product.dart';
import '../../model/pricinggroup.dart';
import '../common/Top Section/Bloc/CartBloc.dart';
import '../common/left Section/product_disctcard.dart';

DisplayManager displayManager = DisplayManager();

class LeftSection extends StatefulWidget {
  const LeftSection({
    super.key,
  });

  @override
  State<LeftSection> createState() => _LeftSectionState();
}

class _LeftSectionState extends State<LeftSection> {
  double? totalAmountBeforeDisc;
  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    TotalDiscountBloc totalDiscountBloc =
        BlocProvider.of<TotalDiscountBloc>(context);
    totalDiscountBloc.add(TotalDiscountModel());

    await FetchApis(context).fetchTaxes();
  }

  @override
  Widget build(BuildContext context) {
    return cartBloc();
  }

  Widget left_home({required List<Product> cartList, TaxModel? taxModel}) {
    int quantities = FunctionProduct.getProductLength(productList: cartList);

    return BlocBuilder<IsMobile, bool>(
      builder: (context, isMobile) {
        return BlocBuilder<PricingBloc, PricingGroup?>(
            builder: (context, prices) {
          double calculateItemTotal(
              {required TotalDiscountModel? discountprice}) {
            double itemTotal = 0.0;

            // Calculate item total
            itemTotal = double.parse(
                FunctionProduct.productstotal(productList: cartList)
                    .toStringAsFixed(2));
            totalAmountBeforeDisc = itemTotal;

            // Log the calculated itemTotal before applying the discount
            log('Item Total before discount: $itemTotal');

            // Log the discount details
            log('Discount Type: ${discountprice!.type}');
            log('Discount Amount: ${discountprice.amount?.toDouble() ?? 0.0}');

            // Apply the discount and return the final amount
            double finalAmount = FunctionProduct.applyDiscount(
                selectedValue: discountprice.type.toString(),
                discount: (discountprice.amount?.toDouble() ?? 0.0),
                amount: itemTotal);

            // Log the final amount after discount
            log('Final Amount after discount: $finalAmount');

            return finalAmount;
          }

// (discountprice.amount?.toDouble() ?? 0.0).toDouble(),
          return Scaffold(
            appBar: !isMobile
                ? null
                : AppBar(
                    title: const Text('Cart'),
                  ),
            backgroundColor: Colors.white,
            body: Column(children: [
              const SizedBox(
                height: 5,
              ),
              const LeftSecDropdown(),
              const SizedBox(
                height: NumberConstants.size_02,
              ),
              Expanded(
                  child: cartListView(
                      cartList: cartList, prices: prices ?? PricingGroup())),
              SizedBox(
                  height: 170,
                  child: BlocBuilder<TotalDiscountBloc, TotalDiscountModel?>(
                      builder: (context, discount) {
                    log('total discount amount${discount?.toJson()}');

                    return LeftBottomBar(
                      itemTotal: calculateItemTotal(
                        discountprice: (discount) ?? TotalDiscountModel(),
                      ),
                      quantities: quantities,
                      product: cartList,
                      totalAmountBeforeDisc: double.parse(
                          totalAmountBeforeDisc!.toStringAsFixed(2)),
                    );
                  })),
            ]),
          );
        });
      },
    );
  }

  Widget cartListView(
      {required List<Product> cartList, required PricingGroup prices}) {
    if (cartList.isEmpty) {
      TotalDiscountBloc discountBloc =
          BlocProvider.of<TotalDiscountBloc>(context);
      discountBloc.add(TotalDiscountModel());
    }

    return ListView.separated(
      itemCount: cartList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (context, index) {
        Product product = cartList[index];

        PricingGroups? getSelectedPrice;

        if (product.suspendId == null && prices.id != null) {
          getSelectedPrice = product.pricingGroups?.firstWhere((element) {
            // log('left sec product price ${prices.id.toString()} ${element.id.toString()}');
            return element.id == prices.id;
          },
              orElse: () => product.pricingGroups!.isEmpty
                  ? const PricingGroups()
                  : product.pricingGroups![0]);
        }

        return CartListTile(
          product: product,
          onIncrement: () => incrementQty(product: product),
          onDecrement: () => decreaseQty(product: product),
          onApplyDiscount: (updatedSellingPrice) async {
            setState(() {
              product.calculate = updatedSellingPrice.toString();
            });

            log("product price after disc${product.unit_price.toString()}");
          },
          pricingGroup: getSelectedPrice ?? const PricingGroups(),
          productPrice: product.unit_price ?? "",
        );
      },
    );
  }

  Widget cartBloc() =>
      BlocBuilder<CartBloc, CartState>(builder: (context, cartState) {
        return BlocBuilder<TaxBloc, TaxModel?>(builder: (context, taxModel) {
          if (cartState is CartLoadedState) {
            return left_home(
                cartList: cartState.listProduct.reversed.toList(),
                taxModel: taxModel ?? TaxModel());
          }

          return left_home(cartList: []);
        });
      });

  incrementQty({required Product product}) async {
    setState(() {
      product.quantity =
          (int.parse(product.quantity.toString()) + 1).toString();
    });

    log('quantity increase${product.toJson()}');

    await displayManager.transferDataToPresentation(
        {'type': 'update', 'product': product.toJson()});
  }

  decreaseQty({required Product product}) async {
    log('quantity decrease: ${product.quantity}');

    setState(() {
      if (int.parse(product.quantity ?? '1') > 1) {
        // Decrement the quantity
        product.quantity = (int.parse(product.quantity!) - 1).toString();
      }
    });

    // Log the current state of the product to check if the quantity was actually decremented
    log('quantity decrease: ${product.toJson()}');

    // Send the updated product data to the display manager
    await displayManager.transferDataToPresentation({
      'type': 'update',
      'product': product.toJson(),
    });
  }
}

class CartListTile extends StatefulWidget {
  final Product product;
  final PricingGroups pricingGroup;
  final Function()? onIncrement, onDecrement;
  final Function(double) onApplyDiscount;
  final String productPrice;

  const CartListTile({
    super.key,
    required this.product,
    this.onIncrement,
    this.onDecrement,
    required this.onApplyDiscount,
    required this.pricingGroup,
    required this.productPrice,
  });

  @override
  State<StatefulWidget> createState() => _CartListTile();
}

class _CartListTile extends State<CartListTile> {
  final TextEditingController totalViewController = TextEditingController();
  bool isTextField = false;

  @override
  void initState() {
    // log('Product Pricing group${widget.pricingGroup.toJson()}');
    setState(() {
      log("Product Discount: ${widget.productPrice}");
      widget.product.unit_price =
          widget.productPrice == null || widget.productPrice.isEmpty
              ? widget.pricingGroup.price
              : widget.productPrice;
    });
    super.initState();
  }

  @override
  void dispose() {
    totalViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsModel?>(
      builder: (context, state) {
        return pricingGroupWidget(state!);
      },
    );
  }

  Future<void> deleteProduct(
      Product product, LoggedInUser loggedInuser, bool isConnected) async {
    CartBloc cartBloc = BlocProvider.of<CartBloc>(context);

    if (!isConnected) {
      cartBloc.add(CartRemoveProductEvent(product));
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: const Row(
      //         children: [
      //           Icon(
      //             Icons.error,
      //             color: Colors.red,
      //           ),
      //           SizedBox(width: 8),
      //           Text("No Internet")
      //         ],
      //       ),
      //       content: const Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           Text('Kindly clear the cart on pressing the Cancel button.'),
      //         ],
      //       ),
      //       actions: <Widget>[
      //         TextButton(
      //           onPressed: () {
      //             // Close the dialog
      //             Navigator.of(context).pop();
      //           },
      //           child: const Text('OK'),
      //         ),
      //       ],
      //     );
      //   },
      // );
    } else {
      final response =
          await RemoveItemCartNotification.sendRemoveProductNotification(
              context: context, product: product, loggedInUser: loggedInuser);

      if (!mounted) return;

      log("Body response of api: $response");

      try {
        if (response['status'] == true) {
          cartBloc.add(CartRemoveProductEvent(product));
        } else {
          log("$response");
        }
      } catch (e) {
        log('Error: $e');
      }
    }
  }

  Widget pricingGroupWidget(SettingsModel setting) {
    return BlocBuilder<CheckConnection, bool>(
      builder: (context, isConnected) {
        return BlocBuilder<LoggedInUserBloc, LoggedInUser?>(
          builder: (context, loggedInUser) {
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              onTap: () => setting.posSettings?.disableDiscount == "0"
                  ? showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ProductDiscCard(
                            product: widget.product,
                            updateProductPriceCallback: widget.onApplyDiscount);
                      },
                    )
                  : null,
              leading: SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                  widget.product.image.toString(),
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Image.asset('assets/images/ErrorImage.png');
                  },
                  fit: BoxFit.contain,
                  width: 100,
                  height: 100,
                ),
              ),
              title: Text(
                widget.product.name.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              subtitle: Row(
                children: <Widget>[
                  IconButton(
                    iconSize: 20.0,
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (widget.onDecrement != null) {
                        widget.onDecrement!();
                      }
                    },
                  ),
                  Text(
                    '${widget.product.quantity}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  IconButton(
                      iconSize: 20.0,
                      icon: const Icon(Icons.add),
                      onPressed: widget.onIncrement),
                  const SizedBox(width: 50),
                  Text((double.parse(widget.product.calculate ??
                              0.0.toStringAsFixed(2)) *
                          double.parse(widget.product.quantity.toString()))
                      .toStringAsFixed(2)),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red,
                // size: 30.0,
                onPressed: () =>
                    deleteProduct(widget.product, loggedInUser!, isConnected),
              ),
            );
          },
        );
      },
    );
  }
}
