import 'package:flutter/material.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/common_app_barV1.dart';
import 'package:opalposinc/utils/assets.dart';

import '../../../../widgets/common/left Section/recent_sale.dart';

class Transactionv1 extends StatelessWidget {
  const Transactionv1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: CommonAppBarV1(
            imagePath: Myassets.transactions,
            title: "Transactions",
          )),
      body: RecentSales(),
    );
  }
}
