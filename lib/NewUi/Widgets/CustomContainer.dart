import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/Animations/Slide.dart';
import 'package:opalposinc/model/brand.dart';
import 'package:opalposinc/model/category.dart';
import 'package:opalposinc/model/location.dart';
import 'package:opalposinc/model/pricinggroup.dart';
import 'package:opalposinc/model/product.dart';
import 'package:opalposinc/pages/productFilteration.dart';
import 'package:opalposinc/utils/decorations.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CartBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/ProductBloc.dart';

class ShowProducts extends StatefulWidget {
  final TextEditingController searchController;
  const ShowProducts({super.key, required this.searchController});

  @override
  State<ShowProducts> createState() => _ShowProductsState();
}

class _ShowProductsState extends State<ShowProducts> {
  List<Product> list = [];

  @override
  Widget build(BuildContext context) {
    CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
    return SizedBox(
      width: 410,
      height: double.infinity,
      child: Material(
          // elevation: 10.0,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
          child: BlocBuilder<PricingBloc, PricingGroup?>(
              builder: (context, prices) {
            return BlocBuilder<FeatureBooleanBloc, bool>(
                builder: (context, isfeatured) {
              return BlocBuilder<BrandBloc, Brand?>(builder: (context, brand) {
                return BlocBuilder<CategoryBloc, Category?>(
                    builder: (context, category) {
                  return BlocBuilder<LocationBloc, Location?>(
                      builder: (context, location) {
                    return BlocBuilder<ProductBloc, ProductState>(
                        builder: ((context, state) {
                      if (state is ProductLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is ProductLoadedState) {
                        var data = state.listProduct;

                        if (data.isEmpty) {
                          return const Text('Error Fetching Product');
                        }

                        if (isfeatured) {
                          list = data
                              .where((element) => element.isFeatured == true)
                              .toList();
                        } else {
                          if (widget.searchController.text.isNotEmpty) {
                            list = ProductFilteration(context)
                                .filteredProductList(
                                    location: location ?? const Location(),
                                    category: category ?? Category(),
                                    brand: brand ?? Brand(),
                                    list: list);
                          } else {
                            list = ProductFilteration(context)
                                .filteredProductList(
                                    location: location ?? const Location(),
                                    category: category ?? Category(),
                                    brand: brand ?? Brand(),
                                    list: data);
                          }
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          // padding: const EdgeInsets.all(5.0),
                          itemBuilder: ((context, index) {
                            final product = list[index];

                            return ProductWidget(
                              onProductTap: () {
                                final getSelectedPrice = product.pricingGroups
                                    ?.firstWhere(
                                        (element) => element.id == prices?.id,
                                        orElse: () =>
                                            product.pricingGroups![0]);

                                int quant =
                                    int.parse(product.quantity.toString());

                                int newQ =
                                    cartBloc.productList.contains(product)
                                        ? quant
                                        : 1;

                                cartBloc.add(CartAddProductEvent(product
                                  ..calculate = getSelectedPrice?.price
                                  ..unit_price = getSelectedPrice?.price
                                  ..lineDiscountAmount = 0.0.toString()
                                  ..quantity = newQ.toString()));
                              },
                              product: product,
                            );
                          }),

                          itemCount: list.length,

                          separatorBuilder: (BuildContext context, int index) {
                            return Decorations.height5;
                          },
                        );
                      }

                      return Container();
                    }));
                  });
                });
              });
            });
          })),
    );
  }
}

class ProductWidget extends StatelessWidget {
  final Product product;
  final Function() onProductTap;
  const ProductWidget({
    super.key,
    required this.product,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return SlideUp(
      type: 'up',
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        child: InkWell(
          onTap: onProductTap,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      height: 50,
                      width: 50,
                      image: NetworkImage(product.image.toString()),
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/ErrorImage.png');
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(product.name.toString())),
                        ],
                      ),
                      Row(
                        children: [
                          Text(product.unit_price.toString()),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
