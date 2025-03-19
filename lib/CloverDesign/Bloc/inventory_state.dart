part of 'inventory_bloc.dart';

@immutable
sealed class InventoryState {}

final class InventoryInitial extends InventoryState {}


class MenuSelectionState extends InventoryState {
  final String selectedMenu;

  MenuSelectionState(this.selectedMenu);


}