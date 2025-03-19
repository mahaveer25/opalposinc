import 'package:flutter/material.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/menuItem.dart';

class SideBarItemClover extends StatelessWidget {
  const SideBarItemClover({
    required this.items,
    required this.index,
    this.onSelected,
    this.depth = 0,
    this.iconColor,
    this.activeIconColor,
    required this.textStyle,
    this.activeTextStyle,
    this.backgroundColor,
    this.activeBackgroundColor,
    this.borderColor,
  });

  final List<CloverMenuItem> items;
  final int index;
  final void Function(CloverMenuItem item)? onSelected;
  final int depth;
  final Color? iconColor;
  final Color? activeIconColor;
  final TextStyle textStyle;
  final TextStyle? activeTextStyle;
  final Color? backgroundColor;
  final Color? activeBackgroundColor;
  final Color? borderColor;
  bool get isLast => index == items.length - 1;

  @override
  Widget build(BuildContext context) {
    if (depth > 0 && isLast) {
      return _buildTiles(context, items[index]);
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            backgroundColor ?? Colors.grey.shade200,
            (backgroundColor ?? Colors.grey.shade200).withOpacity(0.9),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(8.0),
        // border: Border.all(
        //   color: borderColor ?? Colors.black,
        //   width: 0.0,
        // ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: _buildTiles(context, items[index]),
    );
  }

  Widget _buildTiles(BuildContext context, CloverMenuItem item) {
    bool selected = _isSelected([item]);

    if (item.children.isEmpty) {
      return ListTile(
        contentPadding: _getTilePadding(depth),
        leading: _buildIcon(item.icon, selected),
        title: _buildTitle(item.title, selected),
        selected: selected,
        tileColor: backgroundColor,
        selectedTileColor:
            activeBackgroundColor ?? Colors.blue.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        onTap: () {
          if (onSelected != null) {
            onSelected!(item);
          }
        },
      );
    }

    int index = 0;
    final childrenTiles = item.children.map((child) {
      return SideBarItemClover(
        items: item.children,
        index: index++,
        onSelected: onSelected,
        depth: depth + 1,
        iconColor: iconColor,
        activeIconColor: activeIconColor,
        textStyle: textStyle,
        activeTextStyle: activeTextStyle,
        backgroundColor: backgroundColor,
        activeBackgroundColor: activeBackgroundColor,
        borderColor: borderColor,
      );
    }).toList();

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: _getTilePadding(depth),
        leading: _buildIcon(item.icon),
        title: _buildTitle(item.title),
        initiallyExpanded: selected,
        children: childrenTiles,
        collapsedBackgroundColor: backgroundColor,
        backgroundColor: activeBackgroundColor ?? Colors.blue.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  bool _isSelected(List<CloverMenuItem> items) {
    return false;
  }

  Widget _buildIcon(IconData? icon, [bool selected = false]) {
    return icon != null
        ? Icon(
            icon,
            size: 22,
            color: selected
                ? activeIconColor ?? activeTextStyle?.color
                : iconColor ?? textStyle.color,
          )
        : const SizedBox();
  }

  Widget _buildTitle(String title, [bool selected = false]) {
    return Text(
      title,
      style: selected ? activeTextStyle : textStyle,
    );
  }

  EdgeInsets _getTilePadding(int depth) {
    return EdgeInsets.only(
      left: 10.0 + 10.0 * depth,
      right: 10.0,
    );
  }
}
