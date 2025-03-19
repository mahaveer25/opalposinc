// ignore_for_file: unused_local_variable

import 'dart:typed_data';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class GenerateQuotation {
  static final heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
  static final body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static final middle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static Future<Uint8List> generateInvoice(
      {required InvoiceModel invoiceModel}) {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
        build: (context) => [
              buildPDFHeader(invoiceModel: invoiceModel),
              SizedBox(height: 25),
              buildPDFSectionInvoice(invoiceModel: invoiceModel),
              SizedBox(height: 25),
              productTableView(invoiceModel: invoiceModel),
              SizedBox(
                height: 25.0,
                child: Divider(),
              ),
              productTableFooter(invoiceModel: invoiceModel),
              SizedBox(
                height: 25.0,
                child: Divider(),
              ),
              thankYouNote(invoiceModel: invoiceModel),
            ]));

    return pdf.save();
  }

  static Widget thankYouNote({required InvoiceModel invoiceModel}) => pw.Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            pw.Text(invoiceModel.invoiceFooterText.toString(), style: middle)
          ]);

  static Widget buildPDFHeader({required InvoiceModel invoiceModel}) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(invoiceModel.invoiceTitle.toString(), style: heading),
              // Text(invoiceModel.address.toString()),
              Text('Mobile: ${invoiceModel.mobile.toString()}'),
              // Text('Quotation', style: heading),
            ],
          ))
        ]);
  }

  static Widget buildPDFSectionInvoice({required InvoiceModel invoiceModel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15.0,
          child: Divider(),
        ),
        // Row(
        //   children: [
        //     Text('Quotation No.'),
        //     Spacer(),
        //     Text(invoiceModel.invoiceNumber.toString())
        //   ],
        // ),
        Row(
          children: [
            Text('Date:'),
            Spacer(),
            Text(invoiceModel.date.toString())
          ],
        ),
        Row(
          children: [
            Text('Customer:'),
            Spacer(),
            Text(invoiceModel.customer.toString())
          ],
        ),
        Row(
          children: [
            Text('Mobile:'),
            Spacer(),
            Text(invoiceModel.customerMobile.toString())
          ],
        )
      ],
    );
  }

  static Widget productTableFooter({required InvoiceModel invoiceModel}) {
    return pw.Table(
      columnWidths: {
        0: const FlexColumnWidth(1.0),
        1: const FlexColumnWidth(0.2),
      },
      children: [
        pw.TableRow(children: [
          pw.Text('SubTotal'),
          pw.Text(
              '\$ ${double.parse(invoiceModel.subTotal.toString()).toStringAsFixed(2)}')
        ]),
        pw.TableRow(children: [
          pw.Text('Tax (${invoiceModel.taxType})'),
          pw.Text(
              '(+) \$ ${double.parse(invoiceModel.taxAmount.toString()).toStringAsFixed(2)}')
        ]),
        pw.TableRow(children: [
          pw.Text('Total'),
          pw.Text(
              '\$ ${double.parse(invoiceModel.total.toString()).toStringAsFixed(2)}')
        ]),
      ],
    );
  }

  static Widget productTableView({required InvoiceModel invoiceModel}) {
    final data = List.generate(invoiceModel.product!.length, (index) {
      final product = invoiceModel.product![index];

      final unitPrice = double.tryParse(product.unit_price.toString()) ?? 0.0;
      final quantity = int.tryParse(product.quantity.toString()) ?? 0;

      final total = unitPrice * quantity;

      return pw.TableRow(
        verticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          pw.Text('${index + 1}'),
          pw.Text('${product.name}'),
          pw.Text(product.quantity.toString()),
          pw.Text(product.unit_price.toString()),
          pw.Text(total.toStringAsFixed(2)),
        ],
      );
    }).toList();

    final header = TableRow(children: [
      pw.Text('#', style: middle),
      pw.Text('Product', style: middle),
      pw.Text('Qty', style: middle),
      pw.Text('Price', style: middle),
      pw.Text('Total', style: middle)
    ]);

    return Table(
      tableWidth: TableWidth.max,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: const FlexColumnWidth(0.3),
        1: const FlexColumnWidth(1.0),
        2: const FlexColumnWidth(0.3),
        3: const FlexColumnWidth(0.3),
        4: const FlexColumnWidth(0.3), // Added for total
      },
      children: [header, ...data.map((e) => e)],
    );
  }
}
