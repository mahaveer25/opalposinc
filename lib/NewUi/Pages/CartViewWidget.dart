import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/Functions/FunctionsProduct.dart';
import 'package:opalposinc/NewUi/Widgets/CustomButton.dart';
import 'package:opalposinc/NewUi/Widgets/ProductCardWidget.dart';
import 'package:opalposinc/model/product.dart';
import 'package:opalposinc/model/TaxModel.dart';
import 'package:opalposinc/model/TotalDiscountModel.dart';
import 'package:opalposinc/utils/constant_dialog.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CartBloc.dart';
import 'package:opalposinc/widgets/common/left%20Section/discount_card.dart';

class CartViewWidget extends StatelessWidget {
  final double itemTotal, totalAmountBeforeDisc;
  final int quantities;
  final List<Product> listProducts;
  final TaxModel taxModel;
  final TotalDiscountModel discountModel;
  const CartViewWidget({
    super.key,
    required this.itemTotal,
    required this.totalAmountBeforeDisc,
    required this.quantities,
    required this.listProducts,
    required this.taxModel,
    required this.discountModel,
  });

  @override
  Widget build(BuildContext context) {
    int quantities =
        FunctionProduct.getProductLength(productList: listProducts);

    double calculateItemTotal() {
      double itemTotal = 0.0;

      itemTotal = FunctionProduct.productstotal(productList: listProducts);
      return FunctionProduct.applyDiscount(
          selectedValue: discountModel.type.toString(),
          discount: (discountModel.amount?.toDouble() ?? 0.0).toDouble(),
          amount: itemTotal);
    }

    final totalWithTax =
        '\$${FunctionProduct.applyTax(total: calculateItemTotal(), taxModel: taxModel).toStringAsFixed(2)}';

    return Material(
      // elevation: 5.0,
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              children: [
                Text('Total Items: $quantities'),
                const Spacer(),
                CustomButton(
                  text: 'Clear Cart',
                  onTap: () => onClearCart(context),
                  textColor: Colors.deepOrange,
                )
              ],
            ),
          ),
          Material(
            color: Colors.deepOrange.shade50,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                children: [
                  Text('Total: ${calculateItemTotal().toStringAsFixed(2)}'),
                  const SizedBox(
                      width: 20.0,
                      child: Icon(
                        Icons.circle,
                        size: 4.0,
                      )),
                  Text(
                    'Tax: ${double.parse(taxModel.amount == null ? 0.0.toString() : taxModel.amount.toString()).toStringAsFixed(2)}%',
                    style: TextStyle(color: Colors.deepOrange.shade700),
                  ),
                  const SizedBox(
                      width: 20.0,
                      child: Icon(
                        Icons.circle,
                        size: 4.0,
                      )),
                  if (discountModel.amount != null)
                    Text('Discount Invoice: ${discountModel.amount}',
                        style: TextStyle(color: Colors.green.shade700)),
                  if (discountModel.amount != null)
                    const SizedBox(
                        width: 20.0,
                        child: Icon(
                          Icons.circle,
                          size: 4.0,
                        )),
                  Text('Sub Total: $totalWithTax'),
                  const Spacer(),
                  CustomButton(
                      onTap: () {
                        if (listProducts.isEmpty) {
                          ConstDialog(context)
                              .showErrorDialog(error: 'Cart is empty');
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DiscountCard(
                                total: FunctionProduct().calculateItemTotal(
                                    discountprice: discountModel,
                                    listProduct: listProducts),
                              );
                            },
                          );
                        }
                      },
                      text: 'Apply Discount')
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(25.0),
              // scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) {
                final product = listProducts.reversed.toList()[index];
                return ProductCard(product: product);
              }),
              itemCount: listProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 193,
                  crossAxisCount: 3,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 15.0),
            ),
          ),
        ],
      ),
    );
  }

  onClearCart(BuildContext context) {
    CartBloc cartBloc = BlocProvider.of(context);
    cartBloc.add(CartClearProductEvent());
  }
}
