import 'package:flutter/material.dart';

import '../../../utils/decorations.dart';
import '../../Widgets/dropDowns.dart';

class TaxReportPanel extends StatefulWidget {
  const TaxReportPanel({super.key});

  @override
  State<StatefulWidget> createState() => _TaxReportPanel();
}

class _TaxReportPanel extends State<TaxReportPanel> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          firstRow(),
          Decorations.height10,
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
                    child: secondRow()),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget firstRow() {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: 10.0,
      child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Overall Input, Output Expense'.toString(),
                    style: Decorations.heading,
                  ),
                ],
              ),
              Decorations.height10,
              Row(
                children: [
                  Text(
                    'Output Tax, input Tax, Expense Tax: \$ ${1258}',
                    style: Decorations.body,
                  ),
                ],
              )
            ],
          )),
    );
  }

  Widget secondRow() {
    final styleHead = Decorations.body.copyWith(fontWeight: FontWeight.bold);

    List<Text> items = [
      const Text('Input Tax'),
      const Text('Output Tax'),
      const Text('Expense Tax'),
    ];
    final listDropDowns = [
      // OpalDropDown(
      //   items: items,
      //   selectedWidget: items[0].data.toString(),
      //   headingText: 'Business Location',
      // ),
    ];

    List<Widget> cat = [
      Text('Date', style: styleHead),
      Text('Reference No', style: styleHead),
      Text('Supplier', style: styleHead),
      Text('Tax Number', style: styleHead),
      Text('Total Amount', style: styleHead),
      Text('Payment Method', style: styleHead),
      Text('Discount', style: styleHead),
      Text('Tax', style: styleHead),
    ];

    final names = [
      {
        'Date': 'Date',
        'Reference No': 'Reference No',
        'Supplier': 'Supplier',
        'Tax number': 'Tax number',
        'Total Amount': 'Total Amount',
        'Payment Method': 'Payment Method',
        'Discount': 'Discount',
        'Tax': 'Tax',
      },
    ];

    final data = List.generate(names.length, (index) {
      return TableRow(children: [
        Text(names[index]['Date'].toString()),
        Text(
          names[index]['Reference No'].toString(),
          // textAlign: TextAlign.end,
        ),
        Text(names[index]['Supplier'].toString()),
        Text(names[index]['Tax number'].toString()),
        Text(names[index]['Total Amount'].toString()),
        Text(names[index]['Payment Method'].toString()),
        Text(names[index]['Discount'].toString()),
        Text(names[index]['Tax'].toString()),
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
        Expanded(child: Table(children: list))
      ]),
    );
  }
}
