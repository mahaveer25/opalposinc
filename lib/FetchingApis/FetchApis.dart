import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/auth/remember_login.dart';
import 'package:opalposinc/model/customer_balance.dart';
import 'package:opalposinc/model/expense_drop_model.dart';
import 'package:opalposinc/model/location.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/model/payment_model.dart';
import 'package:opalposinc/services/expense_category.dart';
import 'package:opalposinc/services/getTaxApi.dart';
import 'package:opalposinc/services/getordertax.dart';
import 'package:opalposinc/services/payment_method.dart';
import '../model/product.dart';
import '../model/pricinggroup.dart';
import '../services/product.dart';
import '../services/brands.dart';
import '../services/categories.dart';
import '../services/customer.dart';
import '../services/location.dart';
import '../services/pricing_group.dart';
import '../widgets/common/Top Section/Bloc/CustomBloc.dart';
import '../widgets/major/left_section.dart';

class FetchApis {
  final BuildContext context;
  FetchApis(this.context);

  Future<void> fetchAll() async => await fetchAllApis();

  Future<void> fetchAllApis() async {
    fetchPaymentMethods();
    fetchTaxes();
    fetchPrice();
    fetchBrands();
    fetchCategories();
    fetchCustomers();
    fetchLocations();
    getProducts();
    getExpense();
  }

  // Future<void> fetchLocations() async {
  //   LoggedInUserBloc loggedInUser = BlocProvider.of<LoggedInUserBloc>(context);

  //   try {
  //     LocationService()
  //         .getlocations(context, loggedInUser.state!)
  //         .then((value) async {
  //       ListLocationBloc listLocationBloc =
  //           BlocProvider.of<ListLocationBloc>(context);
  //       listLocationBloc.add(value);
  //       LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
  //       locationBloc.add(value[0]);
  //       await displayManager.transferDataToPresentation(
  //           {'type': 'location', 'location': value[0].toJson()});
  //     });
  //   } catch (e) {
  //     log('Error fetching data: $e');
  //   }
  // }
  Future<void> fetchLocations() async {
    LoggedInUserBloc loggedInUser = BlocProvider.of<LoggedInUserBloc>(context);

    try {
      LocationService()
          .getlocations(context, loggedInUser.state!)
          .then((value) async {
        final listLocationBloc = BlocProvider.of<ListLocationBloc>(context);
        final locationBloc = BlocProvider.of<LocationBloc>(context);
        final loggedInUserBloc = BlocProvider.of<LoggedInUserBloc>(context);
        final listPaxDevicesBloc = BlocProvider.of<ListPaxDevicesBloc>(context);
        final paxDeviceBloc = BlocProvider.of<PaxDeviceBloc>(context);

        listLocationBloc.add(value);
        await displayManager.transferDataToPresentation(
            {'type': 'location', 'location': value[0].toJson()});

        final locationIdFromLocal = await RememberLogin.getLocationId();
        final location = locationIdFromLocal?.isNotEmpty == true
            ? listLocationBloc.state.firstWhere(
                (loc) => loc.id.toString() == locationIdFromLocal,
                orElse: () => const Location(),
              )
            : value[0];

        if (locationIdFromLocal == null || locationIdFromLocal.isEmpty) {
          debugPrint("Saving location id ${location.id} in local");
          await RememberLogin.saveLocationId(
              savedLocationID: location.id ?? "");
        }

        locationBloc.add(
            location.id != null && (location.id?.isNotEmpty ?? false)
                ? location
                : value[0]);
        debugPrint("LocationBloc in Location ${value[0].toJson()}");

        final paxIdFromLocal = await RememberLogin.getPaxId();
        debugPrint("paxId: $paxIdFromLocal, locationId: $locationIdFromLocal");

        final currentLocationId =
            locationBloc.state?.id ?? value[0].id.toString();
        final paxDevices = loggedInUserBloc.state?.paxDevices
            ?.where((device) =>
                device.businessLocationId.toString() == currentLocationId)
            .toList();

        if (paxDevices?.isNotEmpty ?? false) {
          listPaxDevicesBloc.add(paxDevices ?? []);
          final device = paxIdFromLocal?.isNotEmpty == true
              ? paxDevices?.firstWhere((d) => d.id.toString() == paxIdFromLocal,
                  orElse: () => PaxDevice())
              : null;
          paxDeviceBloc.add(PaxDeviceEvent(device: device));
          if (device == null)
            debugPrint("No matching device for paxId: $paxIdFromLocal");
        } else {
          debugPrint("PaxList in location is empty");
        }
      });

      // LocationService().getlocations(context, loggedInUser.state!).then((value) async {
      //   ListLocationBloc listLocationBloc = BlocProvider.of<ListLocationBloc>(context);
      //   listLocationBloc.add(value);
      //
      //   String? locationIdFromLocal = await RememberLogin.getLocationId();
      //   LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
      //   await displayManager.transferDataToPresentation({'type': 'location', 'location': value[0].toJson()});
      //   if (locationIdFromLocal != null|| (locationIdFromLocal!="")) {
      //     if (listLocationBloc.state.isNotEmpty) {
      //       Location? locationFromLocal = listLocationBloc.state.firstWhere(
      //         (element) => element.id.toString() == locationIdFromLocal.toString(),
      //         orElse: () => const Location(),
      //       );
      //
      //       if (locationFromLocal.id != null ||locationFromLocal.id !="") {
      //         locationBloc.add(locationFromLocal);
      //       } else {
      //         debugPrint("LocationFromLocal is null");
      //       }
      //     } else {
      //       debugPrint("listLocationBloc.state is empty");
      //     }
      //   } else {
      //     locationBloc.add(value[0]);
      //     debugPrint("LocationFromLocal is not available");
      //   }
      //
      //   debugPrint("LocationBloc  in Location ${value[0].toJson()}");
      //
      //   LoggedInUserBloc loggedInUserBloc = BlocProvider.of<LoggedInUserBloc>(context);
      //   ListPaxDevicesBloc listPaxDevicesBloc = BlocProvider.of<ListPaxDevicesBloc>(context);
      //   PaxDeviceBloc bloc = BlocProvider.of<PaxDeviceBloc>(context);
      //
      //   String? paxIdFromLocal = await RememberLogin.getPaxId();
      //   debugPrint("paxId getting from sharedPreferences ${paxIdFromLocal}");
      //   debugPrint("locationId getting from sharedPreferences ${locationIdFromLocal}");
      //
      //   if (locationIdFromLocal != null || locationIdFromLocal != "") {
      //     if (paxIdFromLocal != null || paxIdFromLocal != "") {
      //       if (locationIdFromLocal == locationBloc.state?.id) {
      //         List<PaxDevice>? list = loggedInUserBloc.state?.paxDevices
      //             ?.where(
      //               (element) =>
      //                   element.businessLocationId.toString() ==
      //                   locationIdFromLocal.toString(),
      //             )
      //             .toList();
      //         if (list?.isNotEmpty ?? false) {
      //           listPaxDevicesBloc.add(list ?? []);
      //           PaxDevice? localDevice = list?.firstWhere(
      //             (device) => device.id.toString() == paxIdFromLocal,
      //           );
      //           if (localDevice != null) {
      //             bloc.add(PaxDeviceEvent(device: localDevice));
      //           } else {
      //             debugPrint(
      //                 "No matching device found locally for paxId: $paxIdFromLocal");
      //           }
      //         }
      //       } else {
      //         debugPrint("PaxIdFromLocal is not same coming from api ");
      //         List<PaxDevice>? list = loggedInUserBloc.state?.paxDevices
      //             ?.where(
      //               (element) =>
      //                   element.businessLocationId.toString() ==
      //                   value[0].id.toString(),
      //             )
      //             .toList();
      //         if (list?.isNotEmpty ?? false) {
      //           listPaxDevicesBloc.add(list ?? []);
      //           bloc.add(PaxDeviceEvent(device: null));
      //           debugPrint(
      //               "Getting PaxDevice Bloc from login in fetchApis ${list?[0]}");
      //         } else {
      //           debugPrint("PaxList in location is empty");
      //         }
      //       }
      //     } else {
      //       debugPrint("PaxIdFromLocal is not available in sharedPreferences ");
      //       List<PaxDevice>? list = loggedInUserBloc.state?.paxDevices
      //           ?.where(
      //             (element) =>
      //                 element.businessLocationId.toString() ==
      //                 value[0].id.toString(),
      //           )
      //           .toList();
      //       if (list?.isNotEmpty ?? false) {
      //         listPaxDevicesBloc.add(list ?? []);
      //         bloc.add(PaxDeviceEvent(device: null));
      //         debugPrint(
      //             "Getting PaxDevice Bloc from login in fetchApis ${list?[0]}");
      //       } else {
      //         debugPrint("PaxList in location is empty");
      //       }
      //     }
      //   } else {
      //     debugPrint("locationId is not available in sharedPreferences ");
      //
      //     List<PaxDevice>? list = loggedInUserBloc.state?.paxDevices?.where((element) => element.businessLocationId.toString() == value[0].id.toString(),).toList();
      //     if (list?.isNotEmpty ?? false) {
      //       listPaxDevicesBloc.add(list ?? []);
      //       bloc.add(PaxDeviceEvent(device: null));
      //       debugPrint(
      //           "Getting PaxDevice Bloc from login in fetchApis ${list?[0]}");
      //     } else {
      //       debugPrint("PaxList in location is empty");
      //     }
      //   }
      // });
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  Future<void> fetchCustomers() async {
    LoggedInUserBloc loggedInUser = BlocProvider.of<LoggedInUserBloc>(context);
    try {
      CustomerDataService()
          .getCustomerNames(context, loggedInUser.state!)
          .then((customerNames) {
        ListCustomerBloc customerListBloc =
            BlocProvider.of<ListCustomerBloc>(context);
        customerListBloc.add(customerNames);

        CustomerBloc customerBloc = BlocProvider.of<CustomerBloc>(context);
        customerBloc.add(customerNames[0]);
      });
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  Future<void> fetchCategories() async {
    LoggedInUserBloc loggedInUser = BlocProvider.of<LoggedInUserBloc>(context);
    try {
      CategoryService categoryService = CategoryService();

      categoryService
          .getCategories(loggedInUser: loggedInUser.state!)
          .then((fetchedCategories) {
        ListCategoryBloc listCategoryBloc =
            BlocProvider.of<ListCategoryBloc>(context);
        listCategoryBloc.add(fetchedCategories);
        CategoryBloc categoryBloc = BlocProvider.of<CategoryBloc>(context);
        categoryBloc.add(fetchedCategories[0]);
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> fetchBrands() async {
    LoggedInUserBloc loggedInUser = BlocProvider.of<LoggedInUserBloc>(context);
    try {
      BrandsService()
          .getBrands(context: context, loggedInUser: loggedInUser.state!)
          .then((brands) {
        ListBrandBloc listBrandBloc = BlocProvider.of<ListBrandBloc>(context);
        listBrandBloc.add(brands);
        BrandBloc brandBloc = BlocProvider.of<BrandBloc>(context);
        brandBloc.add(brands[0]);
      });
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  Future<void> fetchTaxes() async {
    LoggedInUserBloc loggedInUser = BlocProvider.of<LoggedInUserBloc>(context);
    try {
      GetTaxServices()
          .getTaxModel(context: context, loggedInUser: loggedInUser.state!)
          .then((tax) async {
        await displayManager
            .transferDataToPresentation({'type': 'tax', 'tax': tax.toJson()});

        TaxBloc taxBloc = BlocProvider.of<TaxBloc>(context);
        taxBloc.add(tax);
      });
      // GetOrderTaxServices().getOrderTaxList(context: context);
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  Future<List<PricingGroup>> fetchPrice() async {
    LoggedInUserBloc loggedInUser = BlocProvider.of<LoggedInUserBloc>(context);
    LocationBloc location = BlocProvider.of<LocationBloc>(context);
    try {
      List<PricingGroup> priceGroup = await PricingGroupService()
          .getPricingGroup(
              context: context,
              loggedInUser: loggedInUser.state!,
              location: location.state!);

      return priceGroup;
    } catch (e) {
      log('Error fetching data: $e');
      return [];
    }
  }

  Future<List<ExpenseDrop>> getExpense() async {
    LoggedInUserBloc loggedInUser = BlocProvider.of<LoggedInUserBloc>(context);
    LocationBloc location = BlocProvider.of<LocationBloc>(context);
    try {
      List<ExpenseDrop> expenseDrop = await ExpenseDropdownService()
          .getExpenseDropdown(
              context: context,
              loggedInUser: loggedInUser.state!,
              location: location.state!);

      return expenseDrop;
    } catch (e) {
      log('Error fetching data: $e');
      return [];
    }
  }

  onupdatePrices({required Location location}) async {
    final pricingList = await fetchPrice();

    ListPricingBloc listPricingBloc = BlocProvider.of<ListPricingBloc>(context);
    listPricingBloc.add(pricingList);
    PricingBloc pricingBloc = BlocProvider.of<PricingBloc>(context);

    final selectedPrice = pricingList.firstWhere(
        (element) => element.selected_flag == 'selected',
        orElse: () => PricingGroup());

    if (selectedPrice.id != null) {
      pricingBloc.add(selectedPrice);
    } else {
      if (pricingList.isNotEmpty) {
        pricingBloc.add(pricingList[0]);
      }
    }
  }

  customerBalance({required CustomerBalanceModel customerBalance}) async {
    final pricingList = await fetchPrice();

    ListPricingBloc listPricingBloc = BlocProvider.of<ListPricingBloc>(context);
    listPricingBloc.add(pricingList);
    PricingBloc pricingBloc = BlocProvider.of<PricingBloc>(context);

    final selectedPrice = pricingList.firstWhere(
        (element) => element.selected_flag == 'selected',
        orElse: () => PricingGroup());

    if (selectedPrice.id != null) {
      pricingBloc.add(selectedPrice);
    } else {
      pricingBloc.add(pricingList[0]);
    }
  }

  Future<void> fetchPaymentMethods() async {
    try {
      List<PaymentMethod> priceGroup =
          await PaymentMethodService().getPaymentMethods(context);

      PaymentListBloc listBloc = BlocProvider.of<PaymentListBloc>(context);
      listBloc.add(priceGroup);

      log('from fetchApis ${listBloc.state}');

      PaymentOptionsBloc optionsBloc =
          BlocProvider.of<PaymentOptionsBloc>(context);
      optionsBloc.add(priceGroup[0]);
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  Future<List<Product>> getProducts() async {
    LoggedInUserBloc userBloc = BlocProvider.of<LoggedInUserBloc>(context);
    LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
    CategoryBloc categoryBloc = BlocProvider.of<CategoryBloc>(context);
    BrandBloc brandBloc = BlocProvider.of<BrandBloc>(context);

    List<Product>? allProducts = await ProductService().fetchProducts(
      categoryId: categoryBloc.state?.id.toString(),
      brandId: brandBloc.state?.id.toString(),
      locationId: locationBloc.state?.id.toString(),
      loggedInUser: userBloc.state!,
    );

    log('$allProducts');

    return allProducts;
    // ProductBloc productBloc = BlocProvider.of<ProductBloc>(context);

    // for (Product product in allProducts) {
    //   productBloc.add(ProductAddProductEvent(product));
    // }
  }
}
