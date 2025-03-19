import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/model/TaxModel.dart';
import 'package:opalsystem/model/TotalDiscountModel.dart';
import 'package:opalsystem/model/brand.dart';
import 'package:opalsystem/model/category.dart';
import 'package:opalsystem/model/CustomerModel.dart';
import 'package:opalsystem/model/customer_balance.dart';
import 'package:opalsystem/model/expense_drop_model.dart';
import 'package:opalsystem/model/location.dart';
import 'package:opalsystem/model/loggedInUser.dart';
import 'package:opalsystem/model/payment_model.dart';
import 'package:opalsystem/model/pricinggroup.dart';
import 'package:opalsystem/model/setttings.dart';

import '../../../../model/product.dart';

class IsMobile extends Bloc<bool, bool> {
  IsMobile() : super(false) {
    on<bool>((event, emit) => emit(event));
  }
}

class ListLocationBloc extends Bloc<List<Location>, List<Location>> {
  ListLocationBloc() : super([]) {
    on<List<Location>>((event, emit) => emit(event));
  }
}

class UpdateSelectedLocationEvent {
  final LocationList selectedLocation;

  UpdateSelectedLocationEvent(this.selectedLocation);
}

class ListCategoryBloc extends Bloc<List<Category>, List<Category>> {
  ListCategoryBloc() : super([]) {
    on<List<Category>>((event, emit) => emit(event));
  }
}

class ListBrandBloc extends Bloc<List<Brand>, List<Brand>> {
  ListBrandBloc() : super([]) {
    on<List<Brand>>((event, emit) => emit(event));
  }
}

class CartListBloc extends Bloc<List<Product>, List<Product>> {
  CartListBloc() : super([]) {
    on<List<Product>>((event, emit) => emit(event));
  }
}

class ListCustomerBloc extends Bloc<List<CustomerModel>, List<CustomerModel>> {
  ListCustomerBloc() : super([]) {
    on<List<CustomerModel>>((event, emit) => emit(event));
  }
}

class LocationBloc extends Bloc<Location?, Location?> {
  LocationBloc() : super(null) {
    on<Location>((event, emit) => emit(event));
  }
}

class PaxDeviceBloc extends Bloc<PaxDeviceEvent, PaxDevice?> {
  PaxDeviceBloc() : super(null) {
    on<PaxDeviceEvent>((event, emit) => emit(event.device));
  }
}

class ListPaxDevicesBloc extends Bloc<List<PaxDevice>, List<PaxDevice>> {
  ListPaxDevicesBloc() : super([]) {
    on<List<PaxDevice>>((event, emit) => emit(event));
  }
}

class RegisterStatusBloc extends Bloc<String, String> {
  RegisterStatusBloc() : super("") {
    on<String>((event, emit) => emit(event));
  }
}

class CustomerBloc extends Bloc<CustomerModel?, CustomerModel?> {
  CustomerBloc() : super(null) {
    on<CustomerModel>((event, emit) => emit(event));
  }
}

class CustomerBalanceBloc
    extends Bloc<CustomerBalanceModel?, CustomerBalanceModel?> {
  CustomerBalanceBloc() : super(null) {
    on<CustomerBalanceModel>((event, emit) => emit(event));
  }
}

class CategoryBloc extends Bloc<Category?, Category?> {
  CategoryBloc() : super(null) {
    on<Category?>((event, emit) => emit(event));
  }
}

class TotalDiscountBloc extends Bloc<TotalDiscountModel?, TotalDiscountModel?> {
  TotalDiscountBloc() : super(null) {
    on<TotalDiscountModel?>((event, emit) => emit(event));
  }
}

class ExpenseDropdBloc extends Bloc<List<ExpenseDrop>, List<ExpenseDrop>> {
  ExpenseDropdBloc() : super([]) {
    on<List<ExpenseDrop>>((event, emit) => emit(event));
  }
}

class SelectedExpenseBloc extends Bloc<ExpenseDrop?, ExpenseDrop?> {
  SelectedExpenseBloc() : super(null) {
    on<ExpenseDrop>((event, emit) => emit(event));
  }
}

class BrandBloc extends Bloc<Brand?, Brand?> {
  BrandBloc() : super(null) {
    on<Brand>((event, emit) => emit(event));
  }
}

class LoggedInUserBloc extends Bloc<dynamic, LoggedInUser?> {
  LoggedInUserBloc() : super(null) {
    on<LoggedInUser>((event, emit) => emit(event));
  }
}

class TaxBloc extends Bloc<TaxModel?, TaxModel?> {
  TaxBloc() : super(null) {
    on<TaxModel>((event, emit) => emit(event));
  }
}

class ListPricingBloc extends Bloc<List<PricingGroup>, List<PricingGroup>> {
  ListPricingBloc() : super([]) {
    on<List<PricingGroup>>((event, emit) => emit(event));
  }
}

class PricingBloc extends Bloc<PricingGroup?, PricingGroup?> {
  PricingBloc() : super(null) {
    on<PricingGroup>((event, emit) => emit(event));
  }
}

class PaymentListBloc extends Bloc<List<PaymentMethod>, List<PaymentMethod>> {
  PaymentListBloc() : super([]) {
    on<List<PaymentMethod>>((event, emit) => emit(event));
  }
}

class PaymentOptionsBloc extends Bloc<PaymentMethod?, PaymentMethod?> {
  PaymentOptionsBloc() : super(null) {
    on<PaymentMethod>((event, emit) => emit(event));
  }
}

class FeatureBooleanBloc extends Bloc<bool, bool> {
  FeatureBooleanBloc() : super(false) {
    on<bool>((event, emit) => emit(event));
  }
}

class ChangeCategoryBloc extends Bloc<String?, String?> {
  ChangeCategoryBloc() : super('Profit / Loss Reports') {
    on<String?>((event, emit) => emit(event));
  }
}

class GetDatePickerBloc extends Bloc<String?, String?> {
  GetDatePickerBloc() : super(null) {
    on<String?>((event, emit) => emit(event));
  }
}

class GetCustomDateBloc extends Bloc<DateTime?, DateTime?> {
  GetCustomDateBloc() : super(null) {
    on<DateTime?>((event, emit) => emit(event));
  }
}

class GetSuspenddetailsBloc extends Bloc<String?, String?> {
  GetSuspenddetailsBloc() : super(null) {
    on<String?>((event, emit) => emit(event));
  }
}

class SettingsBloc extends Bloc<SettingsModel?, SettingsModel?> {
  SettingsBloc() : super(null) {
    on<SettingsModel>((event, emit) => emit(event));
  }
}

class PaxDeviceEvent {
  final PaxDevice? device;

  PaxDeviceEvent({this.device});
}
