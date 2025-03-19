import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:opalposinc/Functions/FunctionsProduct.dart';
import 'package:opalposinc/invoices/InvoiceModel.dart';
import 'package:opalposinc/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SellReturnInvoice with PrintPDF {
  static final heading = pw.TextStyle(
    fontSize: 7,
    fontWeight: pw.FontWeight.bold,
  );
  static final body = pw.TextStyle(
    fontSize: 12,
    fontWeight: pw.FontWeight.normal,
  );

  static Future<Uint8List> generateInvoice(
      {required InvoiceModel invoiceModel}) async {
    final pdf = pw.Document();

    // Calculate the total height needed for the invoice content
    final double totalContentHeight =
        await calculateTotalContentHeight(invoiceModel);

    // Create a PdfPageFormat with dynamic height
    PdfPageFormat customPageFormat = PdfPageFormat(
        42 * PdfPageFormat.mm, totalContentHeight,
        marginAll: 2 * PdfPageFormat.mm);

    // Add a page to the PDF document
    pdf.addPage(pw.MultiPage(
        pageFormat: customPageFormat,
        build: (context) => [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  buildPDFHeader(invoiceModel: invoiceModel),
                  pw.SizedBox(height: 15),
                  buildPDFSectionInvoice(invoiceModel: invoiceModel),
                  pw.SizedBox(height: 15),
                  productTableView(invoiceModel: invoiceModel),
                  pw.SizedBox(height: 15),
                  productTableFooter(invoiceModel: invoiceModel),
                  pw.SizedBox(height: 15),
                  thankYouNote(invoiceModel: invoiceModel),
                ],
              ),
            ]));

    return pdf.save();
    // Save the PDF as Uint5List and return
  }

  static Future<String> printInvoice(
      {required InvoiceModel invoiceModel,
      String? cardTotal,
      String? cashTotal}) async {
    final pdf = pw.Document();

    // Calculate the total height needed for the invoice content
    final double totalContentHeight =
        await calculateTotalContentHeight(invoiceModel);

    // Create a PdfPageFormat with dynamic height
    PdfPageFormat customPageFormat = PdfPageFormat(
        58 * PdfPageFormat.mm, totalContentHeight,
        marginAll: 2 * PdfPageFormat.mm);

    // Add a page to the PDF document
    pdf.addPage(pw.MultiPage(
        // mainAxisAlignment: pw.MainAxisAlignment.center,
        // crossAxisAlignment: pw.CrossAxisAlignment.center,
        pageFormat: customPageFormat,
        build: (context) => [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  buildPDFHeader(invoiceModel: invoiceModel),
                  pw.SizedBox(height: 15),
                  buildPDFSectionInvoice(invoiceModel: invoiceModel),
                  pw.SizedBox(height: 15),
                  productTableView(invoiceModel: invoiceModel),
                  pw.SizedBox(height: 15),
                  productTableFooter(
                      invoiceModel: invoiceModel,
                      cardTotal: cardTotal,
                      cashTotal: cashTotal),
                  pw.SizedBox(height: 15),
                  thankYouNote(invoiceModel: invoiceModel),
                ],
              ),
            ]));

    final path = await PrintPDF.getTemporaryPdfFilePath(
        fileName: invoiceModel.invoiceNumber.toString());

    final File file = File(path);
    await file.writeAsBytes(await pdf.save());

    return file.path;
    // Save the PDF as Uint5List and return
  }

  static Future<double> calculateTotalContentHeight(
      InvoiceModel invoiceModel) async {
    double totalHeight = 0;

    totalHeight += 70; // Header height
    totalHeight += 70; // Invoice section height
    totalHeight +=
        await calculateProductTableHeight(invoiceModel); // Product table height
    totalHeight += 70; // Footer height
    totalHeight += 70; // Thank you note height

    return totalHeight;
  }

  static Future<double> calculateProductTableHeight(
      InvoiceModel invoiceModel) async {
    // Calculate and return the height needed for the product table based on the number of products
    double tableHeight = 0;

    // Example calculation for demonstration, replace with actual calculations
    if (invoiceModel.product != null) {
      tableHeight =
          (invoiceModel.product!.length * 25).toDouble(); // Each row height 30
    }

    return tableHeight;
  }

  static pw.Widget thankYouNote({required InvoiceModel invoiceModel}) {
    final data = [
      pw.TableRow(children: [
        pw.Container(
          alignment: pw.Alignment.center,
          child: pw.Text(
            invoiceModel.invoiceFooterText.toString(),
            style: const pw.TextStyle(fontSize: 5.2),
          ),
        ),
      ]),
    ];

    return pw.Table(
      tableWidth: pw.TableWidth.min,
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      columnWidths: {
        0: const pw.FixedColumnWidth(100.0),
      },
      children: data,
    );
  }

  static pw.Widget buildPDFHeader({required InvoiceModel invoiceModel}) {
    final headerData = [
      pw.TableRow(
        children: [
          pw.Text(
            invoiceModel.invoiceTitle.toString(),
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
      pw.TableRow(
        children: [
          pw.Text(
            invoiceModel.address.toString(),
            style: const pw.TextStyle(fontSize: 7),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
      if (invoiceModel.mobile != null)
        pw.TableRow(
          children: [
            pw.Text(
              invoiceModel.mobile != null
                  ? 'Mobile: ${invoiceModel.mobile ?? ""}'
                  : "",
              style: const pw.TextStyle(fontSize: 7),
              textAlign: pw.TextAlign.center,
            ),
          ],
        ),
      pw.TableRow(
        children: [
          pw.Text(
            'Invoice',
            style: const pw.TextStyle(fontSize: 7),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    ];

    return pw.Table(
      tableWidth: pw.TableWidth.min,
      children: headerData,
      columnWidths: {
        0: const pw.FixedColumnWidth(100.0),
        // 1: const pw.FixedColumnWidth(100.0),
        // 2: const pw.FixedColumnWidth(100.0),
        // 3: const pw.FixedColumnWidth(100.0),
      },
    );
  }

  static pw.Widget buildPDFSectionInvoice(
      {required InvoiceModel invoiceModel}) {
    final data = [
      pw.TableRow(children: [
        pw.Text('Return Invoice No:', style: const pw.TextStyle(fontSize: 7)),
        pw.Spacer(),
        pw.Text(invoiceModel.invoiceNumber.toString(),
            style: const pw.TextStyle(fontSize: 7))
      ]),
      pw.TableRow(children: [
        pw.Text('Invoice No:', style: const pw.TextStyle(fontSize: 7)),
        pw.Spacer(),
        pw.Text(invoiceModel.invoiceNumber.toString(),
            style: const pw.TextStyle(fontSize: 7))
      ]),
      pw.TableRow(children: [
        pw.Text('Date:', style: const pw.TextStyle(fontSize: 7)),
        pw.Spacer(),
        pw.Text(invoiceModel.date.toString(),
            style: const pw.TextStyle(fontSize: 7)),
      ]),
      pw.TableRow(children: [
        pw.Text('Customer:', style: const pw.TextStyle(fontSize: 7)),
        pw.Spacer(),
        pw.Text(invoiceModel.customer.toString(),
            style: const pw.TextStyle(fontSize: 7)),
      ]),
      pw.TableRow(children: [
        pw.Text('Mobile:', style: const pw.TextStyle(fontSize: 7)),
        pw.Spacer(),
        pw.Text(invoiceModel.customerMobile.toString(),
            style: const pw.TextStyle(fontSize: 7)),
      ]),
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          height: 15.0,
          child: pw.Divider(),
        ),
        pw.Table(
          tableWidth: pw.TableWidth.min,
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
          columnWidths: {
            0: const pw.FixedColumnWidth(40.0),
            1: const pw.FixedColumnWidth(10.0),
            // 2: const pw.FixedColumnWidth(200.0),
            // 3: const pw.FixedColumnWidth(200.0),
          },
          children: data,
        ),
      ],
    );
  }

  static pw.Widget productTableFooter(
      {required InvoiceModel invoiceModel,
      String? cardTotal,
      String? cashTotal}) {
    final double discountAmount = double.parse(
      double.parse(invoiceModel.invoiceDiscount ?? '0.0').toStringAsFixed(2),
    );

    final sign = invoiceModel.discountType == null
        ? ''
        : invoiceModel.discountType == 'Fixed'
            ? double.parse(invoiceModel.discountAmount.toString())
                .toStringAsFixed(2)
            : '(${double.parse(invoiceModel.discountAmount.toString()).toStringAsFixed(2)}%)';

    final discountResult = discountAmount == 0.0 ? '' : sign;
    final double total = double.parse(
        (((double.parse(invoiceModel.subTotal.toString())) -
                    (double.parse(invoiceModel.invoiceDiscount.toString()))) +
                double.parse(invoiceModel.taxAmount.toString()))
            .toStringAsFixed(2));
    final data = List.generate(invoiceModel.paymentMethod!.length, (index) {
      final payment = invoiceModel.paymentMethod![index];

      DateTime dateTime = DateTime.parse(invoiceModel.date.toString());
      String formattedDate = DateFormat('(dd/MM/yyyy)').format(dateTime);

      return pw.TableRow(
        verticalAlignment: pw.TableCellVerticalAlignment.middle,
        children: [
          pw.Text(
            '${(payment.method).toString()} $formattedDate',
            style: const pw.TextStyle(fontSize: 7),
          ),
          pw.Text(
            '\$ ${_formatNumber(double.parse(payment.amount.toString()).toStringAsFixed(2))}',
            style: const pw.TextStyle(fontSize: 7),
          ),
        ],
      );
    }).toList();

    return pw.Table(
      columnWidths: {
        0: const pw.FlexColumnWidth(0.5),
        1: const pw.FlexColumnWidth(0.5),
      },
      children: [
        pw.TableRow(children: [
          pw.Text(
            'Discount ',
            style: const pw.TextStyle(fontSize: 7),
          ),
          pw.Text(
            '(-) ${_formatNumber(double.parse(invoiceModel.discountAmount!).toStringAsFixed(2))}',
            style: const pw.TextStyle(fontSize: 7),
          )
        ]),
        pw.TableRow(children: [
          pw.Text(
            'Tax (${invoiceModel.taxPercentage})',
            style: const pw.TextStyle(fontSize: 7),
          ),
          pw.Text(
            '(+) \$ ${_formatNumber(double.parse(invoiceModel.taxAmount!).toStringAsFixed(2))}',
            style: const pw.TextStyle(fontSize: 7),
          )
        ]),
        pw.TableRow(children: [
          pw.Text(
            'Cash Total',
            style: const pw.TextStyle(fontSize: 7),
          ),
          pw.Text(
            '\$ ${cashTotal}',
            style: const pw.TextStyle(fontSize: 7),
          )
        ]),
        pw.TableRow(children: [
          pw.Text(
            'Card Total',
            style: const pw.TextStyle(fontSize: 7),
          ),
          pw.Text(
            '\$ ${cardTotal}',
            style: const pw.TextStyle(fontSize: 7),
          )
        ]),
        pw.TableRow(children: [
          pw.Text(
            'Total',
            style: const pw.TextStyle(fontSize: 7),
          ),
          pw.Text(
            '\$ ${_formatNumber(double.parse(invoiceModel.total.toString()).toStringAsFixed(2))}',
            style: const pw.TextStyle(fontSize: 7),
          )
        ]),
      ],
    );
  }

  static pw.Widget productTableView({required InvoiceModel invoiceModel}) {
    final data = List.generate(invoiceModel.product!.length, (index) {
      final product = invoiceModel.product![index];
      if (product.unit_price != null && product.quantity != null) {
        print(
          'pdf pprint${double.parse(product.unit_price.toString()) * int.parse(product.quantity.toString())}',
        );
      } else {
        print('Product unit price or quantity is null.');
      }

      double unitPriceDiscount = FunctionProduct.applyDiscount(
        selectedValue: product.lineDiscountType.toString(),
        discount: double.parse(product.lineDiscountAmount.toString()),
        amount: double.parse(product.unit_price.toString()),
      );

      return pw.TableRow(
        verticalAlignment: pw.TableCellVerticalAlignment.top,
        children: [
          pw.Text(
            '${index + 1}',
            style: const pw.TextStyle(fontSize: 7),
          ),
          pw.Text(product.name.toString(),
              style: const pw.TextStyle(fontSize: 7), maxLines: 3),
          pw.Text(
            product.returnQuantity.toString(),
            style: const pw.TextStyle(fontSize: 7),
            textAlign: pw.TextAlign.center,
          ),
          pw.Text(
            '${_formatNumber(double.parse(product.unit_price.toString()).toStringAsFixed(2))}',
            style: const pw.TextStyle(fontSize: 7),
          ),
          pw.Text(
            '${_formatNumber((unitPriceDiscount * int.parse(product.quantity.toString())).toStringAsFixed(2))}',
            style: const pw.TextStyle(fontSize: 7),
          ),
        ],
      );
    }).toList();

    final header = pw.TableRow(children: [
      pw.Text('#',
          style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
      pw.Text('Product',
          style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
      pw.Text('Qty',
          style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
      pw.Text('Price',
          style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
      pw.Text('Total',
          style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
    ]);

    return pw.Table(
      tableWidth: pw.TableWidth.min,
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.top,
      columnWidths: {
        0: const pw.FixedColumnWidth(10.0), // Adjusted
        1: const pw.FixedColumnWidth(40.0), // Adjusted
        2: const pw.FixedColumnWidth(16.0), // Adjusted
        3: const pw.FixedColumnWidth(20.0), // Adjusted
        4: const pw.FixedColumnWidth(20.0),
      },
      children: [header, ...data.map((e) => e)],
    );
  }

  static String? _formatNumber(String? numberString) {
    if (numberString == null || numberString.isEmpty) return null;
    final number = double.tryParse(numberString);
    if (number == null) return null;
    return NumberFormat("#,##0.00", "en_US").format(number);
  }
}
