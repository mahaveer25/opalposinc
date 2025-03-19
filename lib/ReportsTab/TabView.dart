import 'dart:developer';

import 'package:flutter/material.dart';

import '../utils/decorations.dart';
import 'ReportsPanels/ReportsPanel.dart';
import 'SidePanel/SidePanel.dart';

class TabView extends StatelessWidget {
  const TabView({super.key});

  @override
  Widget build(BuildContext context) {
    log('tab mode');
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 80,
          // leading: const Icon(Icons.abc),
          title: Text(
            'Reports',
            style: Decorations.headingBig,
          ),
        ),
        body: const SafeArea(
          child: Row(
            children: [SidePanel(), Expanded(child: ReportsPanel())],
          ),
        ));
  }
}
