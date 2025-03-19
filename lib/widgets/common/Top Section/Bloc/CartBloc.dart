import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/model/TotalDiscountModel.dart';
import 'package:presentation_displays/displays_manager.dart';
import '../../../../model/product.dart';

class CartBloc extends Bloc<CartEvents?, CartState> {
  final displayManager = DisplayManager();

  final List<Product> productList = [];

  CartBloc() : super(CartInitialState()) {
    on<CartAddProductEvent>(onCartAdd);
    on<CartRemoveProductEvent>(onCartRemove);
    on<CartClearProductEvent>(onCartClear);
    on<CartOnincrementEvent>(increment);
    on<CartOndecrementEvent>(decrement);
  }

  onCartAdd(CartAddProductEvent event, Emitter<CartState> emitter) async {
    final skuList = productList.map((e) => e.variationId).toList();
    final isSame = skuList.contains(event.product.variationId);

    if (!isSame) {
      productList.add(event.product);
    } else {
      final prod = productList
          .firstWhere((element) => element.subSku == event.product.subSku);
      prod.quantity = (int.parse(prod.quantity.toString()) + 1).toString();
    }
    await displayManager.transferDataToPresentation(
        {'type': 'add', 'product': event.product.toJson()});

    emitter(CartLoadedState(productList));
  }

  onCartRemove(CartRemoveProductEvent event, Emitter<CartState> emitter) async {
    productList.removeWhere(
        (element) => element.variationId == event.product.variationId);
    if (productList.isEmpty) {
      await displayManager.transferDataToPresentation(
          {'type': 'discount', 'discount': TotalDiscountModel().toJson()});
    }
    await displayManager.transferDataToPresentation(
        {'type': 'remove', 'product': event.product.toJson()});
    emitter(CartLoadedState(productList));
  }

  onCartClear(CartClearProductEvent event, Emitter<CartState> emitter) async {
    productList.clear();
    await displayManager.transferDataToPresentation({'type': 'delete'});
    emitter(CartLoadedState([]));
  }

  Future<FutureOr<void>> increment(
      CartOnincrementEvent event, Emitter<CartState> emitter) async {
    final product = productList.firstWhere(
        (element) => element.variationId == event.product.variationId);

    product.quantity = (int.parse(product.quantity.toString()) + 1).toString();

    await displayManager.transferDataToPresentation(
        {'type': 'update', 'product': product.toJson()});
    emitter(CartLoadedState(productList));
  }

  Future<FutureOr<void>> decrement(
      CartOndecrementEvent event, Emitter<CartState> emitter) async {
    final product = productList.firstWhere(
        (element) => element.variationId == event.product.variationId);

    if (int.parse(product.quantity.toString()) > 1) {
      product.quantity =
          (int.parse(product.quantity.toString()) - 1).toString();
    }

    await displayManager.transferDataToPresentation(
        {'type': 'update', 'product': product.toJson()});
    emitter(CartLoadedState(productList));
  }
}

abstract class CartState {
  final List<Product> listProduct;

  CartState(this.listProduct);
}

class CartInitialState extends CartState {
  CartInitialState() : super([]);
}

class CartLoadedState extends CartState {
  @override
  final List<Product> listProduct;

  CartLoadedState(this.listProduct) : super(listProduct);
}

class CartCustomerLoadedState extends CartState {
  @override
  final List<Product> listProduct;

  CartCustomerLoadedState(this.listProduct) : super(listProduct);
}

abstract class CartEvents {}

class CartInitialEvent extends CartEvents {}

class CartAddProductEvent extends CartEvents {
  final Product product;

  CartAddProductEvent(this.product);
}

class CartRemoveProductEvent extends CartEvents {
  final Product product;

  CartRemoveProductEvent(this.product);
}

class CartClearProductEvent extends CartEvents {
  CartClearProductEvent();
}

class CartOnincrementEvent extends CartEvents {
  final Product product;
  CartOnincrementEvent(this.product);
}

class CartOndecrementEvent extends CartEvents {
  final Product product;
  CartOndecrementEvent(this.product);
}
