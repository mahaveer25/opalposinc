import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/model/pricinggroup.dart';

class PricingBloc extends Bloc<PricingEvents?, PricingState> {
  PricingBloc() : super(PricingInitialState()) {
    on<PricingAddPricingEvent>(onPricingAdd);
    on<PricingRemovePricingEvent>(onPricingRemove);
    on<PricingClearPricingEvent>(onPricingClear);
  }

  final List<PricingGroup> pricingList = [];

  onPricingAdd(
      PricingAddPricingEvent event, Emitter<PricingState> emitter) async {
    pricingList.clear();
    if (!pricingList.contains(event.pricing)) {
      pricingList.add(event.pricing);
    }
    emitter(PricingLoadedState(pricingList));
  }

  onPricingRemove(
      PricingRemovePricingEvent event, Emitter<PricingState> emitter) async {
    pricingList.remove(event.pricing);
    emitter(PricingLoadedState(pricingList));
  }

  onPricingClear(
      PricingClearPricingEvent event, Emitter<PricingState> emitter) async {
    pricingList.clear();
    emitter(PricingLoadedState(pricingList));
  }
}

abstract class PricingState {
  final List<PricingGroup> listPricing;

  PricingState(this.listPricing);
}

class PricingInitialState extends PricingState {
  PricingInitialState() : super([]);
}

class PricingLoadingState extends PricingState {
  PricingLoadingState() : super([]);
}

class PricingLoadedState extends PricingState {
  @override
  final List<PricingGroup> listPricing;

  PricingLoadedState(this.listPricing) : super(listPricing);
}

abstract class PricingEvents {}

class PricingInitialEvent extends PricingEvents {}

class PricingAddPricingEvent extends PricingEvents {
  final PricingGroup pricing;

  PricingAddPricingEvent(this.pricing);
}

class PricingRemovePricingEvent extends PricingEvents {
  final PricingGroup pricing;

  PricingRemovePricingEvent(this.pricing);
}

class PricingClearPricingEvent extends PricingEvents {
  PricingClearPricingEvent();
}
