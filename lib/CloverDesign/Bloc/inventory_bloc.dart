import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc() : super(InventoryInitial()) {
    on<MenuSelectionEvent>((event, emit) {
      emit(MenuSelectionState(event.selectedMenu));

    });
  }
}
