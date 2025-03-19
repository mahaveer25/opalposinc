part of 'inventory_bloc.dart';

@immutable
sealed class InventoryEvent {}


final class MenuSelectionEvent extends InventoryEvent{
  final String selectedMenu;
  MenuSelectionEvent({required this.selectedMenu});
}