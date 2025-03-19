import 'package:flutter/material.dart';

class CloverMenuItem {
  const CloverMenuItem({
    required this.title,
    this.icon,
    this.children = const [],
  });

  final String title;
  final IconData? icon;
  final List<CloverMenuItem> children;
}