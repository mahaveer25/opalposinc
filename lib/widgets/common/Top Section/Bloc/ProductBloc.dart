// ignore_for_file: file_names

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/model/brand.dart';
import 'package:opalposinc/model/category.dart';
import 'package:opalposinc/model/location.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/services/product.dart';

import '../../../../model/product.dart';

class ProductBloc extends Bloc<ProductEvents?, ProductState> {
  // final box = Hive.box<String>('cart');

  ProductBloc() : super(ProductInitialState()) {
    on<ProductAddProductEvent>(onProductAdd);
    on<ProductRemoveProductEvent>(onProductRemove);
    on<ProductClearProductEvent>(onProductClear);
    on<ProductFilterEvent>(onfilter);
    on<GetProductEvent>(getProducts);
    on<ProductResetEvent>((event, emit) {
      productList.clear(); // Clear the product list
      emit(ProductInitialState()); // Emit the initial state
    });
  }

  final List<Product> productList = [];

  onProductAdd(
      ProductAddProductEvent event, Emitter<ProductState> emitter) async {
    if (!productList.contains(event.product)) {
      productList.add(event.product);
    }
    emitter(ProductLoadedState(productList));
  }

  onProductRemove(
      ProductRemoveProductEvent event, Emitter<ProductState> emitter) async {
    productList.remove(event.product);
    emitter(ProductLoadedState(productList));
  }

  onProductClear(
      ProductClearProductEvent event, Emitter<ProductState> emitter) async {
    productList.clear();
    emitter(ProductLoadedState(productList));
    log('Product List: $productList ');
  }

  Future<FutureOr<void>> getProducts(
      GetProductEvent event, Emitter<ProductState> emitter) async {
    emitter(ProductLoadingState());

    // Log and clear the product list before fetching new products
    log("Clearing product list before fetching new products.");
    productList.clear();
    log("Product list after clearing: $productList");

    final data = await ProductService().fetchProducts(
      categoryId: event.category.id.toString(),
      brandId: event.brands.id.toString(),
      locationId: event.location.id.toString(),
      loggedInUser: event.loggedInUser,
    );

    for (var element in data) {
      productList.add(element);
    }

    log("Product list after fetching: ${productList.length}");

    if (data.isNotEmpty) {
      emitter(ProductLoadedState(productList));
    } else {
      emitter(ProductLoadedState([])); // Emit empty list if no products found
    }
  }

  FutureOr<void> onfilter(
      ProductFilterEvent event, Emitter<ProductState> emit) {
    if (event.isSearching) {
      final data = productList
          .where((element) =>
              element.subSku!.contains(event.filter) ||
              element.name!.contains(event.filter))
          .toList();

      emit(ProductLoadedState(data));
    } else {
      emit(ProductLoadedState(productList));
    }
  }
}

abstract class ProductState {
  final List<Product> listProduct;

  ProductState(this.listProduct);
}

class ProductInitialState extends ProductState {
  ProductInitialState() : super([]);
}

class ProductLoadingState extends ProductState {
  ProductLoadingState() : super([]);
}

class ProductLoadedState extends ProductState {
  @override
  final List<Product> listProduct;

  ProductLoadedState(this.listProduct) : super(listProduct);
}

abstract class ProductEvents {}

class ProductInitialEvent extends ProductEvents {}

class ProductAddProductEvent extends ProductEvents {
  final Product product;

  ProductAddProductEvent(this.product);
}

class ProductResetEvent extends ProductEvents {}

class ProductRemoveProductEvent extends ProductEvents {
  final Product product;

  ProductRemoveProductEvent(this.product);
}

class ProductClearProductEvent extends ProductEvents {
  ProductClearProductEvent();
}

class ProductFilterEvent extends ProductEvents {
  final String filter;
  final bool isSearching;
  ProductFilterEvent(this.filter, this.isSearching);
}

class GetProductEvent extends ProductEvents {
  final BuildContext context;
  final LoggedInUser loggedInUser;
  final Brand brands;
  final Category category;
  final Location location;

  GetProductEvent(this.context, this.loggedInUser, this.brands, this.category,
      this.location);
}
