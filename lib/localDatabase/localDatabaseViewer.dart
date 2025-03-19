import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/localDatabase/PathBuilders%20+%20blocs/databaseTypeSelected.dart';
import 'package:opalsystem/localDatabase/Transaction/Pages/TransactionsPage.dart';

import 'Transaction/Pages/DraftPage.dart';

class LocalDatabaseViewer extends StatefulWidget {
  const LocalDatabaseViewer({super.key});

  @override
  State<LocalDatabaseViewer> createState() => _LocalDatabaseViewerState();
}

class _LocalDatabaseViewerState extends State<LocalDatabaseViewer>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    tabController = TabController(length: 2, vsync: this);
    // await LocalInvoices().deleteDatabase();
    // await LocalTransaction().deleteDatabase();
    // await LocalTransaction().close();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: body(context: context),
    );
  }

  Widget body({required BuildContext context}) {
    final tabChilds = [const TransactionsPage(), const DraftPage()];

    void onUpdateValue(String value) {
      DatabaseTypeBloc bloc = BlocProvider.of(context);
      bloc.add(value);
    }

    return Row(
      children: [
        Expanded(
            child: TabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: tabChilds,
        ))
      ],
    );
  }

  AppBar appBar() {
    final tabs = [const Text('Transactions'), const Text('Drafts')];

    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      toolbarHeight: 100,
      title: const Text('Offline Mode'),
      actions: [
        SizedBox(
            width: 250, child: TabBar(controller: tabController, tabs: tabs))
      ],
    );
  }
}
