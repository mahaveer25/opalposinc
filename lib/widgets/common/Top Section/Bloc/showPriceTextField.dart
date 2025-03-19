import 'package:flutter_bloc/flutter_bloc.dart';

class PriceTextFieldBloc
    extends Bloc<PriceTextFieldEvent, PriceTextFieldState> {
  PriceTextFieldBloc() : super(PriceTextFieldChangedState('')) {
    on<PriceTextFieldChangedEvent>(textFieldChanged);
  }

  textFieldChanged(
      PriceTextFieldChangedEvent event, Emitter<PriceTextFieldState> emitter) {
    emitter(PriceTextFieldChangedState(event.text));
  }
}

abstract class PriceTextFieldEvent {
  final String text;

  PriceTextFieldEvent(this.text);
}

class PriceTextFieldChangedEvent extends PriceTextFieldEvent {
  @override
  final String text;

  PriceTextFieldChangedEvent(this.text) : super(text);
}

abstract class PriceTextFieldState {
  final String text;

  PriceTextFieldState(this.text);
}

class PriceTextFieldChangedState extends PriceTextFieldState {
  @override
  final String text;

  PriceTextFieldChangedState(this.text) : super(text);
}
