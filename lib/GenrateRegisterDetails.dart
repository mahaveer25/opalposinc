import 'dart:io';
import 'dart:typed_data';
import 'package:opalposinc/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'model/register_details_model.dart';

class GenerateRegisterPdf with PrintPDF {
  static Future<Uint8List> generateInvoice(
      {required RegisterDetails registerDetails}) async {
    final pdf = pw.Document();

    // Create a PdfPageFormat with dynamic height
    PdfPageFormat customPageFormat = const PdfPageFormat(
        52 * PdfPageFormat.mm, 80 * PdfPageFormat.mm,
        marginAll: 2 * PdfPageFormat.mm);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: customPageFormat,
        build: (context) => [
          buildPDFHeader(registerDetails: registerDetails),
          pw.Divider(height: 1),
          pw.Container(
            // width: double.infinity,
            child: buildPDFSectionRegister(registerDetails: registerDetails),
          ),
          pw.Divider(height: 1),
          pw.Container(
            // width: double.infinity,
            child: buildPDFRegister(registerDetails: registerDetails),
          ),
          pw.Divider(height: 1),
          footerRegisterDetails(registerDetails: registerDetails),
        ],
      ),
    );

    return pdf.save();
  }

  static Future<String> printInvoice(
      {required RegisterDetails registerDetails}) async {
    final pdf = pw.Document();

    // Define the custom page format
    const PdfPageFormat customPageFormat = PdfPageFormat(
        52 * PdfPageFormat.mm, 100 * PdfPageFormat.mm,
        marginAll: 2 * PdfPageFormat.mm);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: customPageFormat,
        build: (context) => [
          buildPDFHeader(registerDetails: registerDetails),
          pw.Divider(height: 3),
          pw.SizedBox(height: 10),
          buildPDFSectionRegister(registerDetails: registerDetails),
          pw.Divider(height: 3),
          buildPDFRegister(registerDetails: registerDetails),
          pw.Divider(height: 3),
          footerRegisterDetails(registerDetails: registerDetails),
        ],
      ),
    );

    final path = await PrintPDF.getTemporaryPdfFilePath(
        fileName:
            "Register_${registerDetails.openTime?.replaceAll(' ', '_') ?? 'Register'}.pdf");

    final File file = File(path);
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  static pw.Widget buildPDFHeader({required RegisterDetails registerDetails}) {
    return pw.Container(
        alignment: pw.Alignment.centerLeft,
        margin: const pw.EdgeInsets.only(bottom: 10),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'Register Details',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                registerDetails.openTime ?? '',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ]));
  }

  static pw.Widget buildPDFSectionRegister(
      {required RegisterDetails registerDetails}) {
    return pw.Table(
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(1.5),
        2: const pw.FlexColumnWidth(2.7),
      },
      children: [
        _buildTableRow(['Payment Method', 'Sell', 'Expense'], isHeader: true),
        _buildTableRow([
          'Cash in Hand:',
          registerDetails.cashInHand ?? '',
          registerDetails.totalCashExpense ?? ''
        ]),
        _buildTableRow([
          'Cash Payment',
          registerDetails.totalCash ?? '',
          registerDetails.totalCardExpense ?? ''
        ]),
        _buildTableRow([
          'Card Payment',
          registerDetails.totalCard ?? '',
          registerDetails.totalCardExpense ?? ''
        ]),
        _buildTableRow([
          'Other Payments:',
          registerDetails.totalOther ?? '',
          registerDetails.totalOtherExpense ?? ''
        ]),
      ],
    );
  }

  static pw.Widget buildPDFRegister(
      {required RegisterDetails registerDetails}) {
    return pw.Table(
      columnWidths: {
        0: const pw.FlexColumnWidth(15),
        1: const pw.FlexColumnWidth(20),
        // 2: const pw.FlexColumnWidth(10),
      },
      children: [
        _buildTableRow(['', ''], isHeader: true),
        _buildTableRow(['Total Sales:', registerDetails.totalSale ?? '']),
        _buildTableRow(['Total Refund', registerDetails.totalRefund ?? '']),
        _buildTableRow(['Total Cash Payment', registerDetails.totalCash ?? '']),
        _buildTableRow(['Total Payment', registerDetails.totalPayment ?? '']),
      ],
    );
  }

  static pw.Widget footerRegisterDetails(
      {required RegisterDetails registerDetails}) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildTextRow('User:', registerDetails.userName ?? ''),
          _buildTextRow('Email:', registerDetails.email ?? ''),
          _buildTextRow(
              'Business Location:', registerDetails.locationName ?? ''),
        ],
      ),
    );
  }

  static pw.TableRow _buildTableRow(List<String> data,
      {bool isHeader = false}) {
    return pw.TableRow(
      children: data.map((item) {
        return pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 3.0),
          child: pw.Text(
            item,
            style: isHeader
                ? pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 5)
                : const pw.TextStyle(fontSize: 6.0),
          ),
        );
      }).toList(),
    );
  }

  static pw.Widget _buildTextRow(String label, String value) {
    return pw.Row(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 5.0),
        ),
        pw.Text(value, style: const pw.TextStyle(fontSize: 6.0)),
      ],
    );
  }
}
