import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/Animations/Slide.dart';
import 'package:opalposinc/utils/decorations.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CartBloc.dart';
import 'package:opalposinc/widgets/common/left%20Section/product_disctcard.dart';

import '../../model/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    log(widget.product.lineDiscountAmount.toString());

    final isDiscounted = widget.product.lineDiscountAmount != null &&
        widget.product.lineDiscountAmount != '0.0';

    return SlideUp(
      type: 'up',
      child: Material(
        elevation: 5.0,
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10.0),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return ProductDiscCard(
                  product: widget.product,
                  updateProductPriceCallback: onApplyDiscount);
            },
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 60,
                              height: 60,
                              child: Image(
                                image: NetworkImage(
                                    widget.product.image.toString()),
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                      'assets/images/ErrorImage.png');
                                },
                              )),
                          Decorations.width5,
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.name.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Decorations.height10,
                                Row(
                                  children: [
                                    Text(
                                      '\$ ${(double.parse(widget.product.unit_price ?? 0.0.toString()) * double.parse(widget.product.quantity.toString())).toStringAsFixed(2)}',
                                      style: TextStyle(
                                          color: isDiscounted
                                              ? Colors.black38
                                              : Colors.green.shade700,
                                          decoration: isDiscounted
                                              ? TextDecoration.lineThrough
                                              : null),
                                    ),
                                    if (isDiscounted)
                                      const SizedBox(
                                        width: 5.0,
                                        child: Divider(),
                                      ),
                                    if (isDiscounted)
                                      Text(
                                        '\$ ${(double.parse(widget.product.calculate.toString()) * double.parse(widget.product.quantity.toString())).toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: onIncrement,
                                    icon: const Icon(Icons.add)),
                                Text(widget.product.quantity.toString()),
                                IconButton(
                                    onPressed: ondecrement,
                                    icon: const Icon(Icons.remove)),
                              ],
                            ),
                          ),
                          if (widget.product.lineDiscountAmount != null &&
                              widget.product.lineDiscountAmount != "0.0")
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Disc: \$${(double.parse(widget.product.lineDiscountAmount.toString()) * double.parse(widget.product.quantity.toString())).toStringAsFixed(2)}',
                                style:
                                    const TextStyle(color: Colors.deepOrange),
                              ),
                            )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    CartBloc bloc = BlocProvider.of<CartBloc>(context);
                    bloc.add(CartRemoveProductEvent(widget.product));
                  },
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove,
                        color: Colors.deepOrange,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  onIncrement() async {
    CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
    cartBloc.add(CartOnincrementEvent(widget.product));
  }

  ondecrement() async {
    CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
    cartBloc.add(CartOndecrementEvent(widget.product));
  }

  void onApplyDiscount(double p1) {
    setState(() {
      widget.product.calculate = p1.toString();
    });
  }
}
