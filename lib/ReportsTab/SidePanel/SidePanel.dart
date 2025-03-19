import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:opalsystem/widgets/common/Top%20Section/location.dart';
import 'package:opalsystem/widgets/common/left%20Section/left_dropdown.dart';
import '../../utils/decorations.dart';
import '../../widgets/common/Top Section/Bloc/CustomBloc.dart';
import 'Widgets/ListTileSidePanel.dart';

class SidePanel extends StatelessWidget {
  const SidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final listCategories = [
      const Text('Profit / Loss Reports'),
      const Text('Tax Report'),
    ];

    return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: SizedBox(
          height: double.infinity,
          width: MediaQuery.of(context).size.width * 0.25,
          child: BlocBuilder<ChangeCategoryBloc, String?>(
              builder: (context, selectedCategory) {
            return Wrap(
              children: [
                Material(
                  color: Colors.grey.withOpacity(0.1),
                  shape: Decorations.boxShape,
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (BuildContext context, int index) {
                      final title = listCategories[index].data;

                      return ListTileSidePanel(
                          title: title.toString(),
                          selected: title == selectedCategory);
                    },
                    itemCount: listCategories.length,
                  ),
                ),
                Decorations.height10,
                const ListTile(
                  title: Text('Filters'),
                  leading: Icon(FontAwesomeIcons.filter),
                ),
                Decorations.height10,
                Material(
                    color: Colors.grey.withOpacity(0.1),
                    shape: Decorations.boxShape,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      shrinkWrap: true,
                      children: [
                        const LocationDropdown(),
                        Builder(builder: (context) {
                          if (selectedCategory == 'Tax Report') {
                            return Column(
                              children: [
                                Decorations.height10,
                                const Row(
                                  children: [
                                    Expanded(child: DropDownCustomer()),
                                  ],
                                ),
                              ],
                            );
                          }

                          return Container();
                        }),
                        Decorations.height10,
                        const FilterByDate(),
                      ],
                    ))
              ],
            );
          }),
        ));
  }
}

class FilterByDate extends StatefulWidget {
  const FilterByDate({super.key});

  @override
  State<StatefulWidget> createState() => _FilterByDate();
}

class _FilterByDate extends State<FilterByDate> {
  bool showDetails = false;

  @override
  Widget build(BuildContext context) {
    final dateList = [
      'Today',
      'Yesterday',
      'Last 7 Days',
      'Last 30 Days',
      'This Month',
      'Last Month',
      'This Month Last Year',
      'This Year',
      'Last Year',
      'Current Financial Year',
      'Last Financial Year',
      'Custom Range',
    ];

    return Column(
      children: [
        ListTileSidePanel(
          selected: showDetails,
          title: dateList[0],
          onTap: onTap,
          leading: showDetails
              ? const Icon(Icons.arrow_drop_up)
              : const Icon(Icons.arrow_drop_down),
        ),
        if (showDetails)
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 3.0,
                      runSpacing: -2.0,
                      children: dateList
                          .map((e) => BlocBuilder<GetDatePickerBloc, String?>(
                                builder: (context, date) {
                                  return RawChip(
                                      selected: date == e,
                                      onPressed: () => onDateChanged(e),
                                      side: const BorderSide(
                                          color: Colors.black12, width: 0.5),
                                      padding: const EdgeInsets.all(2.0),
                                      labelPadding: const EdgeInsets.symmetric(
                                          horizontal: 7.0),
                                      label: Text(e.toString()));
                                },
                              ))
                          .toList())))
      ],
    );
  }

  onTap() {
    setState(() {
      showDetails = !showDetails;
    });
  }

  void onDateChanged(value) {
    GetDatePickerBloc dateBloc = BlocProvider.of<GetDatePickerBloc>(context);
    dateBloc.add(value);

    switch (value) {
      case 'Today':
        addTodayDate();
        break;

      case 'Yesterday':
        addYesterday();
        break;

      case 'Last 7 Days':
        past7days();
        break;

      case 'Last 30 Days':
        past30days();
        break;

      case 'This Month':
        month();
        break;

      case 'Last Month':
        lastMonth();
        break;

      case 'Last Year':
        lastYear();
        break;

      case 'Current Financial Year':
        currentFinancialYear();
        break;

      case 'Last Financial Year':
        lastFinancialYear();
        break;
    }
  }

  addTodayDate() {
    final now = DateTime.now();
    log('$now');
  }

  addYesterday() {
    final now = DateTime.now();
    final diff = now.subtract(const Duration(days: 1));
    log('$diff - $now');
  }

  past7days() {
    final now = DateTime.now();
    final diff = now.subtract(const Duration(days: 7));
    log('$diff - $now');
  }

  past30days() {
    final now = DateTime.now();
    final diff = now.subtract(const Duration(days: 30));
    log('$diff = $now');
  }

  month() {
    final now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime today = DateTime(now.year, now.month, now.day);

    log('$firstDayOfMonth - $today');
  }

  lastMonth() {
    final now = DateTime.now();

    DateTime firstDayOfMonth = DateTime(now.year, now.month - 1, 1);
    DateTime today = DateTime(now.year, now.month, 0);
    log('$firstDayOfMonth - $today');
  }

  lastYear() {
    final now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year - 1, now.month - 1, 1);
    DateTime today = DateTime(now.year, 1, 0);
    log('$firstDayOfMonth - $today');
  }

  currentFinancialYear() {
    final now = DateTime.now();

    if (now.month >= DateTime.july) {
      DateTime firstDayOfMonth = DateTime(now.year, 7, 1);
      DateTime today = DateTime.now();
      log('$firstDayOfMonth - $today');
    } else {
      DateTime firstDayOfMonth = DateTime(now.year - 1, 7, 1);
      DateTime today = DateTime.now();
      log('$firstDayOfMonth - $today');
    }
  }

  lastFinancialYear() {
    final now = DateTime.now();

    if (now.month >= DateTime.july) {
      DateTime firstDayOfMonth = DateTime(now.year - 1, 7, 1);
      DateTime today = DateTime(now.year, 7, 0);
      log('$firstDayOfMonth - $today');
    } else {
      DateTime firstDayOfMonth = DateTime(now.year - 2, 7, 1);
      DateTime today = DateTime(now.year - 1, 7, 0);
      log('$firstDayOfMonth - $today');
    }
  }
}
