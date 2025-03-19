import 'package:flutter/material.dart';
import 'package:opalsystem/utils/constants.dart';

import '../widgets/common/Top Section/paxDropdown.dart';

class PaxDeviceRailWidget extends StatelessWidget {
  const PaxDeviceRailWidget({
    super.key,
  });

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
              'PAX Device',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
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
        Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black)),
            child: const PaxDeviceDropdown()),
        const SizedBox(
          height: 10.0,
        ),
        ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Submit')),
      ],
    );
  }
}
