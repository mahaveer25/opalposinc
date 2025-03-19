import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/model/setttings.dart';
import 'package:opalsystem/widgets/common/Recent%20Sales/draft_sale.dart';
import 'package:opalsystem/widgets/common/Recent%20Sales/final_sales.dart';
import 'package:opalsystem/widgets/common/Recent%20Sales/quotation.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class CustomRecentSaleTab extends StatefulWidget {
  const CustomRecentSaleTab({
    super.key,
  });

  @override
  State<CustomRecentSaleTab> createState() => _CustomRecentSaleTabState();
}

class _CustomRecentSaleTabState extends State<CustomRecentSaleTab> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsModel?>(
      builder: (context, state) {
        // if (state != null &&
        //     int.parse(state.posSettings!.disableDraft.toString()) == 1) {
        //   list.removeAt(2);
        //   list.removeAt(1);
        //   listWidget.removeAt(2);
        //   listWidget.removeAt(1);
        // }
        return buildTab();
      },
    );
  }

  int getPage({required int index}) {
    return pageController.positions.isNotEmpty
        ? pageController.page?.toInt() ?? 0.0.toInt()
        : 0;
  }

  List<RawChip> list = [
    const RawChip(label: Text('Final')),
    // const RawChip(label: Text('Quotation')),
    // const RawChip(label: Text('Draft'))
  ];

  List<Widget> listWidget = [
    const FinalSale(),
    const QuotationSale(),
    const DraftSale()
  ];

  Widget buildTab() {
    return Column(
      children: [
        SizedBox(
          height: 50.0,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      list.length,
                      (index) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: RawChip(
                              selected: index == getPage(index: index),
                              label: list[index].label,
                              onPressed: () => onChangedIndex(index),
                            ),
                          ))),
            ),
          ),
        ),
        Expanded(
            child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onChangedIndex,
          children: listWidget,
        ))
      ],
    );
  }

  onChangedIndex(int index) {
    setState(() => pageController.jumpToPage(
          index,
        ));
  }
}
