import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:opalposinc/FetchingApis/FetchApis.dart';
import 'package:opalposinc/Functions/FunctionsProduct.dart';
import 'package:opalposinc/auth/login.dart';
import 'package:opalposinc/connection.dart';
import 'package:opalposinc/expense/Expense_card.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/localDatabase/Transaction/Bloc/bloc/local_transaction_bloc_bloc.dart';
import 'package:opalposinc/localDatabase/localDatabaseViewer.dart';
import 'package:opalposinc/model/brand.dart';
import 'package:opalposinc/model/category.dart';
import 'package:opalposinc/model/location.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/model/product.dart';
import 'package:opalposinc/model/setttings.dart';
import 'package:opalposinc/pages/productFilteration.dart';
import 'package:opalposinc/pages/sell_retun.dart';
import 'package:opalposinc/services/product.dart';
import 'package:opalposinc/services/sell_return.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/decorations.dart';
import 'package:opalposinc/widgets/CustomWidgets/CustomIniputField.dart';
import 'package:opalposinc/widgets/common/Right%20Section/brand_dropdown.dart';
import 'package:opalposinc/widgets/common/Right%20Section/category.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CartBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/ProductBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/calculator.dart';
import 'package:opalposinc/widgets/common/Top%20Section/register_details.dart';
import 'package:opalposinc/widgets/common/left%20Section/left_dropdown.dart';
import 'package:opalposinc/widgets/common/left%20Section/recent_sale.dart';
import 'package:opalposinc/widgets/common/left%20Section/suspended_sales.dart';
import 'package:opalposinc/widgets/major/left_section.dart';
import 'package:opalposinc/widgets/major/right_section.dart';

import '../utils/global_variables.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final returnInvoiceController = TextEditingController();
  late StreamSubscription<bool> streamSubscription;
  // late StreamSubscription subscription;
  bool productLoading = false;
  final TextEditingController searchController = TextEditingController();
  final ProductService productService = ProductService();
  FocusNode focusNode = FocusNode();
  List<Product> list = [];

  @override
  void initState() {
    onInit();

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
    //     overlays: [SystemUiOverlay.bottom]);

    streamSubscription = ConnectionFuncs.checkInternetConnectivityStream()
        .asBroadcastStream()
        .listen((isConnected) {
      log('$isConnected');
      CheckConnection connection = BlocProvider.of<CheckConnection>(context);
      connection.add(isConnected);
    });

    super.initState();
  }

  onInit() async {
    LoggedInUserBloc userBloc = BlocProvider.of<LoggedInUserBloc>(context);
    LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
    CategoryBloc categoryBloc = BlocProvider.of<CategoryBloc>(context);
    BrandBloc brandBloc = BlocProvider.of<BrandBloc>(context);
    if (mounted) {
      // setState(() {
      //   productLoading = true;
      // });
      ProductBloc bloc = BlocProvider.of<ProductBloc>(context);
      bloc.add(GetProductEvent(
          context,
          userBloc.state ?? LoggedInUser(),
          brandBloc.state ?? Brand(),
          categoryBloc.state ?? Category(),
          locationBloc.state ?? const Location()));
      // setState(() {
      //   productLoading = false;
      // });
    }
    await FetchApis(context).fetchPaymentMethods();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
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
        ProductBloc productBloc = BlocProvider.of(context);

        if (searchController.text.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 500)).whenComplete(() {
            list = productBloc.productList.where((element) {
              return element.name
                      .toString()
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase()) ||
                  element.subSku.toString().contains(value.toString());
            }).toList();

            log('data ${productBloc.productList.length}');
            log('list ${list.length}');

            if (list.isNotEmpty && list.length == 1) {
              // log('${list.length}');
              cartBloc.add(CartAddProductEvent(list.single));

              searchController.clear();
              focusNode.requestFocus();
            }
          });
        } else {
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

            if (data.isEmpty) {
              return const Text('Error Fetching Product');
            }

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

            return ProductGridView(productList: list);
          }
          if (productLoading == true) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Loading Product....'),
              ],
            );
          }

          return Container();
        });
      });
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

      return Container(
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
      );
    }));
  }

  void onSubmit(String value) {
    setState(() {
      ProductBloc productBloc = BlocProvider.of(context);
      list = productBloc.productList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IsMobile, bool>(builder: (context, isMobile) {
      return BlocBuilder<SettingsBloc, SettingsModel?>(
          builder: (context, settings) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Opal POS Inc'),
            toolbarHeight: 60.0,
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarBrightness: Brightness.light),
          ),
          drawer: Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 2,
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.attach_money_outlined,
                            color: Constant.colorPurple),
                        title: const Text('Add Expense'),
                        onTap: () {
                          if (isMobile) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ExpenseCard()));
                          } else {
                            Navigator.pop(context);
                            showDialog(
                              barrierColor: Colors.black87,
                              context: context,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                    insetPadding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    alignment: Alignment.center,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    children: [
                                      Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.9,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          padding: const EdgeInsets.all(15),
                                          child: const ExpenseCard())
                                    ]);
                              },
                            );
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.undo_rounded,
                            color: Constant.colorPurple),
                        title: const Text('Sell Return'),
                        onTap: () {
                          Navigator.pop(context);
                          sellReturn();
                        },
                      ),
                      if (settings?.posSettings?.disableSuspend == null)
                        ListTile(
                          leading: Icon(FontAwesomeIcons.pause,
                              color: Constant.colorPurple),
                          title: const Text('Suspended Sales'),
                          onTap: () {
                            Navigator.pop(context);
                            if (isMobile) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const SuspandedSales()));
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                      insetPadding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      alignment: Alignment.center,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      children: [
                                        Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: const SuspandedSales())
                                      ]);
                                },
                              );
                            }
                          },
                        ),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.calculator,
                            color: Constant.colorPurple),
                        title: const Text('Calculator'),
                        onTap: () {
                          if (isMobile) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Calculator()));
                          } else {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Dialog(
                                        backgroundColor: Colors.black54,
                                        shadowColor: Colors.black,
                                        alignment: Alignment.centerLeft,
                                        insetPadding: const EdgeInsets.only(
                                            right: 850, left: 100),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Calculator()));
                              },
                            );
                          }
                          // Update the state of the app
                          // ...
                          // Then close the drawer
                        },
                      ),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.briefcase,
                            color: Constant.colorPurple),
                        title: const Text('Register Details'),
                        onTap: () {
                          if (isMobile) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const RegisterDetils(
                                      forShow: true,
                                    )));
                          } else {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.9,
                                    child: Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const RegisterDetils(
                                        forShow: true,
                                      ),
                                    ));
                              },
                            );
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.tags,
                            color: Constant.colorPurple),
                        title: const Text('Recent Transactions'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RecentSales()));
                          // if (isMobile) {

                          // } else {
                          //   showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return SimpleDialog(
                          //           insetPadding: const EdgeInsets.only(
                          //               left: 20, right: 20),
                          //           alignment: Alignment.center,
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(20),
                          //           ),
                          //           children: [
                          //             Container(
                          //                 height: MediaQuery.of(context)
                          //                         .size
                          //                         .height *
                          //                     0.8,
                          //                 width: MediaQuery.of(context)
                          //                         .size
                          //                         .width *
                          //                     0.6,
                          //                 padding: const EdgeInsets.symmetric(
                          //                     horizontal: 10.0),
                          //                 child: const RecentSales())
                          //           ]);
                          //     },
                          //   );
                          // }
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                    leading: Icon(
                        Icons.signal_wifi_connected_no_internet_4_sharp,
                        size: 26.0,
                        color: Constant.colorPurple),
                    title: const Text('Offline Transactions'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LocalDatabaseViewer()));
                    }),
                ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout'),
                    onTap: () {
                      onLogout();
                    }),
              ],
            ),
          ),
          body: RefreshIndicator(
            // key: refreshIndicatorKey,
            onRefresh: FetchApis(context).fetchAll,
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                BlocBuilder<CheckConnection, bool>(
                  builder: (context, state) {
                    if (state) {
                      LocalTransactionBlocBloc bloc =
                          BlocProvider.of<LocalTransactionBlocBloc>(context);
                      bloc.add(CheckTransactionEvent(context: context));

                      return Container();
                    }

                    return Material(
                      color: Colors.deepOrange.shade600,
                      child: SizedBox(
                        height: 40.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          child: Row(
                            children: [
                              const Text(
                                'No Internet Connection',
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              if (!isMobile)
                                const Text(
                                  'All Transactions will Now be saved locally ',
                                  style: TextStyle(color: Colors.white70),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            focusNode: focusNode,
                            controller: searchController,
                            onChanged: _onSearchTextChanged,
                            onSubmitted: onSubmit,
                            decoration: const InputDecoration(
                              hintText: 'Enter Product name / SKU ',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      BlocBuilder<FeatureBooleanBloc, bool>(
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
                              backgroundColor: Constant.colorOrange,
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  Icons.app_shortcut_sharp,
                                  color: Constant.colorPurple,
                                )),
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
                            backgroundColor: Constant.colorPurple,
                          ),
                          child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                Icons.app_shortcut_sharp,
                                color: Colors.white,
                              )),
                        );
                      }),
                      // const SizedBox(
                      //   width: 5.0,
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(children: [
                    Expanded(
                      child:
                          Decorations.contain(child: const DropDownCustomer()),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                        // width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Constant.colorPurple,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              productLoading = true;
                            });

                            onInit(); // Refresh the product
                          },
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Refresh Product',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ))
                  ]),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      categoryDrop(),
                      const SizedBox(
                        width: 5,
                      ),
                      brandsDrop(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Expanded(child: valueChangeBuilders()),
              ],
            ),
          ),
          floatingActionButton: BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              final length = FunctionProduct.getProductLength(
                  productList: cartState.listProduct);

              return Badge(
                label: Text(length.toString()),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LeftSection()));
                  },
                  backgroundColor: Constant.colorPurple,
                  child: const Icon(
                    Icons.shopping_cart_checkout_rounded,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        );
      });
    });
  }

  void sellReturn() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            contentPadding: const EdgeInsets.all(10.0),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Invoice Return',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.cancel_rounded,
                      size: 20,
                      color: Constant.colorPurple,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomInputField(
                labelText: 'Invoice No.',
                hintText: 'Invoice No.',
                controller: returnInvoiceController,
                onChanged: onReturnInvoiceChanged,
              ),
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton(onPressed: _onSend, child: const Text('Send')),
            ],
          );
        });
  }

  void onReturnInvoiceChanged(String? value) {}

  void _onSend() async {
    String storeUrl = GlobalData.storeUrl;

    try {
      InvoiceModel? sellReturn = await SellReturnService.getSellRetrunDetails(
          context, returnInvoiceController.text, storeUrl);

      if (sellReturn != null) {
        showDialog(
            context: context,
            builder: (context) {
              return SellReturn(returnsale: sellReturn);
            });
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      log('Error fetching suspended order details: $e');
    }
  }

  onLogout() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
    CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
    cartBloc.add(CartClearProductEvent());
  }
}
