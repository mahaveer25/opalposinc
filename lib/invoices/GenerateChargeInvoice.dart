// ignore_for_file: unused_local_variable

import 'dart:typed_data';
import 'package:opalsystem/invoices/chargeInvoiceModel.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class GenerateChargeInvoice {
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

  static Future<Uint8List> generateChargeInvoice(
      {required ChargeInvoiceModel invoiceModel}) {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
        build: (context) => [
              buildPDFHeader(invoiceModel: invoiceModel),
              SizedBox(height: 25),
              buildPDFSectionChargeInvoice(invoiceModel: invoiceModel),
              SizedBox(height: 25),
            ]));

    return pdf.save();
  }

  static Widget buildPDFHeader({required ChargeInvoiceModel invoiceModel}) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(invoiceModel.name.toString(), style: heading),
              Text(
                  '${invoiceModel.city.toString()} ${invoiceModel.state}  ${invoiceModel.zipCode}'),
            ],
          ))
        ]);
  }

  static Widget buildPDFSectionChargeInvoice(
      {required ChargeInvoiceModel invoiceModel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Trans:${invoiceModel.response?.tranNo ?? ''} '),
            Spacer(),
            Text('Batch:${invoiceModel.response?.stan ?? ''}')
          ],
        ),
        Row(
          children: [
            Text('Amount'),
            Spacer(),
            Text('\$${invoiceModel.response?.amount ?? ''}')
          ],
        ),
        Row(
          children: [
            Text('Resp'),
            Spacer(),
            Text(invoiceModel.response?.desc ?? '')
          ],
        ),
        Row(
          children: [
            Text('Code'),
            Spacer(),
            Text('\$${invoiceModel.response?.approvalCode ?? ''}')
          ],
        ),
        Row(
          children: [
            Text('Ref#'),
            Spacer(),
            Text(invoiceModel.response?.txnid ?? '')
          ],
        ),
        Row(
          children: [
            Text('App Name'),
            Spacer(),
            Text('\$${invoiceModel.response?.amount ?? ''}')
          ],
        ),
        Row(
          children: [
            Text('AID'),
            Spacer(),
            Text(invoiceModel.response?.amount ?? '')
          ],
        ),
        Row(
          children: [
            Text('TVR'),
            Spacer(),
            Text('\$${invoiceModel.response?.amount ?? ''}')
          ],
        ),
        SizedBox(height: 25.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: SizedBox(
                    width: double.infinity / 2,
                    child: Wrap(children: [
                      Text(invoiceModel.footerText ?? '', style: body),
                    ])))
          ],
        ),
        SizedBox(height: 25.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('X___________________X'),
          ],
        ),
        SizedBox(height: 25.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('MERCHANT COPY'),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Thank You'),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(invoiceModel.poweredBy.toString(), style: body),
          ],
        ),
      ],
    );
  }
}
