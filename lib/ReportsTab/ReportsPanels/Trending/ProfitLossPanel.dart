import 'package:flutter/material.dart';

import '../../../utils/decorations.dart';
import '../../Widgets/dropDowns.dart';

class ProfitLossPanel extends StatefulWidget {
  const ProfitLossPanel({super.key});

  @override
  State<StatefulWidget> createState() => _ProfitLossPanel();
}

class _ProfitLossPanel extends State<ProfitLossPanel> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 400,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0.0,
                ),
                child: firstColumn())),
        Decorations.width15,
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0, right: 15.0),
          child: Material(
            borderRadius: BorderRadius.circular(15.0),
            elevation: 10.0,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: secondColumn()),
          ),
        ))
      ],
    );
  }

  Widget firstColumn() {
    final profits = [
      {'name': 'Gross Profit', 'amount': 71.022553},
      {'name': 'Net Profit', 'amount': 125.2553},
    ];

    final openingStock = [
      {'name': 'Opening Stock', 'amount': 0.02},
      {'name': 'Total Purchase', 'amount': 0.12},
      {'name': 'Total Stock Adjustment', 'amount': 0.52},
      {'name': 'Total Purchase Shipping Charge', 'amount': 1.02},
    ];

    final closingStock = [
      {'name': 'Closing Stock', 'amount': 0.02},
      {'name': 'Total Sales', 'amount': 0.12},
      {'name': 'Total Sale Shipping Charges', 'amount': 0.52},
      // {'name': 'Total Purchase Shipping Charge', 'amount': 1.02},
    ];

    final profitsList = List.generate(profits.length, (index) {
      return TableRow(children: [
        Container(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            profits[index]['name'].toString(),
            style: Decorations.heading,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '\$ ${profits[index]['amount'].toString()}',
            textAlign: TextAlign.end,
          ),
        )
      ]);
    }).toList();

    final openingStockList = List.generate(openingStock.length, (index) {
      return TableRow(children: [
        Container(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(openingStock[index]['name'].toString()),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '\$ ${openingStock[index]['amount'].toString()}',
            textAlign: TextAlign.end,
          ),
        )
      ]);
    }).toList();

    final closingStockList = List.generate(closingStock.length, (index) {
      return TableRow(children: [
        Container(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(closingStock[index]['name'].toString()),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '\$ ${closingStock[index]['amount'].toString()}',
            textAlign: TextAlign.end,
          ),
        )
      ]);
    }).toList();

    return ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        children: [
          Material(
            borderRadius: BorderRadius.circular(10.0),
            elevation: 10.0,
            child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(1.2),
                          1: FlexColumnWidth(0.5),
                        },
                        children: profitsList.map((e) => e).toList())
                  ],
                )),
          ),
          Decorations.height10,
          Material(
            borderRadius: BorderRadius.circular(10.0),
            elevation: 10.0,
            child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Open Stock', style: Decorations.heading),
                    Decorations.height10,
                    Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(1.2),
                          1: FlexColumnWidth(0.5),
                        },
                        children: openingStockList.map((e) => e).toList())
                  ],
                )),
          ),
          Decorations.height10,
          Material(
              borderRadius: BorderRadius.circular(10.0),
              elevation: 10.0,
              child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Closing Stock',
                        style: Decorations.heading,
                      ),
                      Decorations.height10,
                      Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(1.2),
                            1: FlexColumnWidth(0.5),
                          },
                          children: closingStockList.map((e) => e).toList())
                    ],
                  )))
        ]);
  }

  Widget secondColumn() {
    List<Text> items = [
      const Text('Profit By Product'),
      const Text('Profit By Categories'),
      const Text('Profit By Brand'),
      const Text('Profit By Locations'),
      const Text('Profit By Invoice'),
      const Text('Profit By Date'),
      const Text('Profit By Customer'),
      const Text('Profit By Day'),
    ];
    final listDropDowns = [
      // OpalDropDown(
      //   items: items,
      //   selectedWidget: items[0].data.toString(),
      //   headingText: 'Business Location',
      // ),
    ];

    List<Widget> cat = [
      Text('Product', style: Decorations.heading),
      Text(
        'Gross Profit',
        style: Decorations.heading,
        textAlign: TextAlign.end,
      )
    ];

    final names = [
      {'product': 'Product 1', 'price': 0.02},
      {'product': 'Product 2', 'price': 0.12},
      {'product': 'Product 3', 'price': 0.52},
      {'product': 'Product 4', 'price': 1.02},
    ];

    final data = List.generate(names.length, (index) {
      return TableRow(children: [
        Container(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(names[index]['product'].toString()),
        ),
        Container(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '\$ ${names[index]['price'].toString()}',
            textAlign: TextAlign.end,
          ),
        )
      ]);
    }).toList();

    List<TableRow> list = [
      TableRow(
          children: cat
              .map((e) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: e))
              .toList()),
      ...data.map((e) => e),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
      child: Column(children: [
        // Row(children: listDropDowns.map((e) => e).toList()),
        Decorations.height10,
        Row(
          children: [
            SizedBox(
              width: 100,
              child: DropdownButton<int>(
                  items: List.generate(
                      100,
                      (index) => DropdownMenuItem<int>(
                          value: index,
                          child: Text(
                            index.toString(),
                          ))),
                  value: selectedIndex,
                  onChanged: (value) {
                    setState(() {
                      selectedIndex = value ?? 0;
                    });
                  }),
            ),
            const Spacer(),
            const RawChip(label: Text('Export PDF')),
            Decorations.width10,
            const RawChip(label: Text('Export CSV')),
          ],
        ),
        Decorations.height10,
        Expanded(
            child: Table(columnWidths: const {
          0: FlexColumnWidth(1.2),
          1: FlexColumnWidth(0.5),
        }, children: list))
      ]),
    );
  }
}
