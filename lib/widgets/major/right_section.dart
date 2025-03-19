import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/model/brand.dart';
import 'package:opalposinc/model/category.dart';
import 'package:opalposinc/model/location.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/model/setttings.dart';
import 'package:opalposinc/services/product.dart';
import 'package:opalposinc/utils/constant_dialog.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/styles.dart';
import 'package:opalposinc/widgets/common/Right%20Section/brand_dropdown.dart';
import 'package:opalposinc/widgets/common/Right%20Section/category.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/ProductBloc.dart';

import '../../model/product.dart';
import '../../model/pricinggroup.dart';
import '../../pages/productFilteration.dart';
import '../common/Top Section/Bloc/CartBloc.dart';
import '../common/Top Section/Bloc/CustomBloc.dart';

class RightWidget extends StatefulWidget {
  const RightWidget({
    super.key,
  });

  @override
  _RightWidgetState createState() => _RightWidgetState();
}

class _RightWidgetState extends State<RightWidget> {
  bool productLoading = false;
  final TextEditingController searchController = TextEditingController();
  final ProductService productService = ProductService();
  final FocusNode _focusNode = FocusNode();
  TextInputType textInputType = TextInputType.none;
  bool _showKeyboard = false;

  List<Product> list = [];
  @override
  void initState() {
    super.initState();
    // Hide keyboard initially
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    onInit();

    // Ensure keyboard stays hidden after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });

    // Listener to control keyboard visibility
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !_showKeyboard) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure keyboard is hidden when returning to this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _hideKeyboard();
        // Keep the field focusable but don't show keyboard
        _focusNode.requestFocus();
      }
    });
  }

  void _hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  void _toggleKeyboard() {
    if (searchController.text.isNotEmpty) {
      searchController.clear();
      _showKeyboard = false; // Reset to hidden when clearing
      setState(() {
        _showKeyboard = !_showKeyboard;
      });
    } else {
      setState(() {
        _showKeyboard = !_showKeyboard;
      });
    }

    if (_showKeyboard) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _focusNode.requestFocus();
        SystemChannels.textInput.invokeMethod('TextInput.show');
      });
    } else {
      _focusNode.unfocus(); // Unfocus to avoid keyboard reappearing
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _focusNode.requestFocus();
    }
  }

  onInit() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    LoggedInUserBloc userBloc = BlocProvider.of<LoggedInUserBloc>(context);
    LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
    CategoryBloc categoryBloc = BlocProvider.of<CategoryBloc>(context);
    BrandBloc brandBloc = BlocProvider.of<BrandBloc>(context);
    if (mounted) {
      ProductBloc bloc = BlocProvider.of<ProductBloc>(context);

      bloc.add(ProductClearProductEvent());
      Future.delayed(const Duration(seconds: 1), () {
        bloc.add(GetProductEvent(
            context,
            userBloc.state ?? LoggedInUser(),
            brandBloc.state ?? Brand(),
            categoryBloc.state ?? Category(),
            locationBloc.state ?? const Location()));
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget valueChangeBuilders() {
    return BlocBuilder<LocationBloc, Location?>(builder: (context, location) {
      return BlocBuilder<CategoryBloc, Category?>(builder: (context, category) {
        return BlocBuilder<BrandBloc, Brand?>(builder: (context, brand) {
          return BlocBuilder<LoggedInUserBloc, LoggedInUser?>(
              builder: (context, loggedInUser) {
            return productDataBuilder(
                category: category ?? Category(),
                location: location ?? const Location(),
                brand: brand ?? Brand(),
                loggedInUser: loggedInUser ?? LoggedInUser());
          });
        });
      });
    });
  }

  void _onSearchTextChanged(String value) => setState(() {
        CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
        ProductBloc productBloc = BlocProvider.of<ProductBloc>(context);

        if (searchController.text.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 500)).whenComplete(() {
            final searchText = searchController.text.toLowerCase();

            // Filter the products by subSku first
            List<Product> subSkuMatches =
                productBloc.productList.where((element) {
              return element.subSku.toString().contains(searchText);
            }).toList();

            if (subSkuMatches.isNotEmpty) {
              // If there are matches by subSku, display only those
              list = subSkuMatches;
            } else {
              // If there are no matches by subSku, filter by name
              list = productBloc.productList.where((element) {
                return element.name
                    .toString()
                    .toLowerCase()
                    .contains(searchText);
              }).toList();
            }
            if (list.isEmpty) {
              searchController.clear();
              ConstDialog(context).showErrorDialog(error: "No Matches Found");
            }
            _focusNode.requestFocus();
            log('Product list length: ${productBloc.productList.length}');
            log('Filtered list length: ${list.length}');

            if (list.isNotEmpty && list.length == 1) {
              log('Selected product: ${list.single.name}, Price: ${list.single.defaultSellPrice}');

              final product = list.single;

              final getSelectedPrice =
                  product.pricingGroups?.firstWhere((element) {
                log("pricing group id ${BlocProvider.of<PricingBloc>(context).state?.id}");
                log("element id ${element.id}");
                return BlocProvider.of<PricingBloc>(context).state?.id ==
                    element.id;
              }, orElse: () => product.pricingGroups![0]);

              int quant = int.parse(product.quantity.toString());

              int newQ = cartBloc.productList.contains(product) ? quant : 1;
              setState(() {
                list = productBloc.productList;
              });
              cartBloc.add(CartAddProductEvent(product
                ..calculate = getSelectedPrice?.price
                ..unit_price = getSelectedPrice?.price
                ..lineDiscountAmount = 0.0.toString()
                ..quantity = newQ.toString()));
              setState(() {
                list = productBloc.productList;
                searchController.clear();
                _focusNode.requestFocus();
              });
              // _focusNode.unfocus();

              _focusNode.requestFocus();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              });
            } else {
              setState(() {
                list = subSkuMatches.isNotEmpty ? subSkuMatches : list;
              });
            }
          });
        } else {
          log("empty list");
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          list = productBloc.productList;
        }
      });

  Widget productDataBuilder(
          {required Category category,
          required Location location,
          required LoggedInUser loggedInUser,
          required Brand brand}) =>
      BlocBuilder<FeatureBooleanBloc, bool>(builder: (context, featureState) {
        return BlocBuilder<ProductBloc, ProductState>(
            builder: (context, blocState) {
          if (blocState is ProductLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (blocState is ProductLoadedState) {
            final data = blocState.listProduct;
            // if (data.isEmpty) {
            //   return const Text('Error Fetching Product');
            // }
            if (featureState) {
              list =
                  data.where((element) => element.isFeatured == true).toList();
            } else {
              if (searchController.text.isNotEmpty) {
                list = ProductFilteration(context).filteredProductList(
                    location: location,
                    category: category,
                    brand: brand,
                    list: list);
              } else {
                list = ProductFilteration(context).filteredProductList(
                    location: location,
                    category: category,
                    brand: brand,
                    list: data);
              }
            }

            if (list.isEmpty) {
              return const Center(
                child: Text('No Product Found'),
              );
            }

            // log('in grid ${list.length}');
            return ProductGridView(
                productList: list); // Make sure `list` here is the right one.
          }

          return Container();
          // Other states reremain unchanged
        });
      });

  void onCategory(String category) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: FocusScope(
                  onFocusChange: (hasFocus) {
                    if (hasFocus && !_showKeyboard) {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      focusNode: _focusNode,
                      controller: searchController,
                      onChanged: _onSearchTextChanged,
                      onTap: () {
                        if (!_showKeyboard) {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Product name / SKU',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: _toggleKeyboard,
                          icon: searchController.text.isNotEmpty
                              ? const Icon(Icons.cancel_rounded)
                              : const Icon(Icons.keyboard_alt_outlined),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5.0),
              SizedBox(
                width: 200,
                child: BlocBuilder<FeatureBooleanBloc, bool>(
                  builder: (context, featureState) {
                    if (featureState) {
                      return ElevatedButton(
                        onPressed: () {
                          FeatureBooleanBloc bloc =
                              BlocProvider.of<FeatureBooleanBloc>(context);
                          bloc.add(false);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          backgroundColor: Constant.colorPurple,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'All Product',
                            style: TextStyles.body(
                                context: context, color: Colors.white),
                          ),
                        ),
                      );
                    }
                    return ElevatedButton(
                      onPressed: () {
                        FeatureBooleanBloc bloc =
                            BlocProvider.of<FeatureBooleanBloc>(context);
                        bloc.add(true);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        backgroundColor: Constant.colorOrange,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Featured Product',
                          style: TextStyles.body(
                              context: context, color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 5.0),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              categoryDrop(),
              const SizedBox(width: 8),
              brandsDrop(),
              const SizedBox(width: 5.0),
              Container(
                decoration: BoxDecoration(
                  color: Constant.colorPurple,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      productLoading = true;
                    });
                    onInit(); // Refresh the products
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(child: valueChangeBuilders()),
        ],
      ),
    );
  }

  Widget categoryDrop() {
    return BlocBuilder<SettingsBloc, SettingsModel?>(
        builder: ((context, state) {
      if (int.parse(state!.enableCategory.toString()) == 0) {
        return Container();
      }

      return Expanded(
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Constant.colorGrey, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const CategoriesDropdown()),
      );
    }));
  }

  Widget brandsDrop() {
    return BlocBuilder<SettingsBloc, SettingsModel?>(
        builder: ((context, state) {
      if (int.parse(state!.enableBrand.toString()) == 0) {
        return Container();
      }

      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Constant.colorGrey, width: 1.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: BrandsDropdown(
            onBrandChange: (brand) {
              BrandBloc brandBloc = BlocProvider.of<BrandBloc>(context);
              brandBloc.add(brand);
            },
          ),
        ),
      );
    }));
  }

  void onSubmit(String value) {
    setState(() {
      ProductBloc productBloc = BlocProvider.of(context);
      list = productBloc.productList;
    });
  }
}

class ProductGridView extends StatefulWidget {
  final List<Product> productList;

  const ProductGridView({super.key, required this.productList});

  @override
  State<StatefulWidget> createState() => _ProductGridView();
}

class _ProductGridView extends State<ProductGridView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IsMobile, bool>(builder: (context, isMob) {
      return BlocBuilder<PricingBloc, PricingGroup?>(
          builder: (context, prices) {
        return GridView.count(
          padding: const EdgeInsets.all(10.0),
          crossAxisCount: isMob ? 2 : 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: List.generate(widget.productList.length, (index) {
            final product = widget.productList[index];

            final getSelectedPrice =
                product.pricingGroups?.firstWhere((element) {
              //log('Checking pricing group id2: ${element.id}');
              return prices?.id == element.id;
            }, orElse: () => product.pricingGroups![0]);

            return Material(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(10.0),
              elevation: 4,
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () {
                  CartBloc cartBloc = BlocProvider.of<CartBloc>(context);

                  int quant =
                      int.parse(widget.productList[index].quantity.toString());

                  int newQ =
                      cartBloc.productList.contains(widget.productList[index])
                          ? quant
                          : 1;
                  log('Selected pricing group ${prices?.id}');
                  log('Selected pricing group222 ${getSelectedPrice?.id}');

                  cartBloc.add(CartAddProductEvent(widget.productList[index]
                    ..calculate = getSelectedPrice?.price
                    ..unit_price = getSelectedPrice?.price
                    ..lineDiscountAmount = 0.0.toString()
                    ..quantity = newQ.toString()));
                  log('Current Cart List: ${cartBloc.productList}');
                },
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.network(
                      widget.productList[index].image.toString(),
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        return Image.asset('assets/images/ErrorImage.png');
                      },
                    ),
                    Positioned(
                      top: 8.0,
                      left: 8.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.0,
                          horizontal: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 112, 112, 112),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          '\$${double.parse(getSelectedPrice?.price.toString() ?? '0.00').toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 52.0,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Center(
                              child: Text(
                                widget.productList[index].name.toString(),
                                style: const TextStyle(fontSize: 14.0),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Center(
                              child: Text(
                                '(${widget.productList[index].subSku.toString()})',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        );
      });
    });
  }
}
