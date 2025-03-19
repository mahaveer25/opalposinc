import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opalposinc/utils/constants.dart';

class DateWidget extends StatefulWidget {
  const DateWidget({super.key});

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) return;
      setState(() {
        selectedTime = TimeOfDay.now();
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MM/dd/yyyy').format(selectedDate);
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 3),
      height: 50.0,
      decoration: BoxDecoration(
        border: Border.all(color: Constant.colorGrey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$formattedDate:${selectedTime.hour}:${selectedTime.minute}',
              style: const TextStyle(fontSize: 18),
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Icon(
                Icons.calendar_month_rounded,
                size: 32,
                color: Constant.colorPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
