import 'package:flutter/material.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/widgets/CustomWidgets/CustomIniputField.dart';

class InvoiceReturnPopup extends StatelessWidget {
  final void Function() onPressed;
  const InvoiceReturnPopup({
    super.key,
    required this.returnInvoiceController,
    required this.onPressed,
  });

  final TextEditingController returnInvoiceController;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      contentPadding: const EdgeInsets.all(10.0),
      clipBehavior: Clip.hardEdge,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Invoice Return',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.cancel_rounded,
                size: 20,
                color: Constant.colorPurple,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        CustomInputField(
          labelText: 'Invoice No.',
          hintText: 'Invoice No.',
          controller: returnInvoiceController,
          // onChanged: onReturnInvoiceChanged,
        ),
        const SizedBox(
          height: 10.0,
        ),
        ElevatedButton(onPressed: onPressed, child: const Text('Send')),
      ],
    );
  }
}
