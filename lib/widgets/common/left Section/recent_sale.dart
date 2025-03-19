import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/model/recent_sales_model.dart';
import 'package:opalsystem/services/recent_sale_service.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/widgets/common/Recent%20Sales/Pages/CustomRecentSaleTab.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class RecentSales extends StatefulWidget {
  const RecentSales({
    super.key,
  });

  @override
  State<RecentSales> createState() => _RecentSalesState();
}

class _RecentSalesState extends State<RecentSales>
    with TickerProviderStateMixin {
  List<RecentSalesModel>? recentModel;
  final RecenetSalesService recentSale = RecenetSalesService();
  late TabController tabContoller;
  bool isLoading = true;
  late String type;

  @override
  void initState() {
    tabContoller = TabController(vsync: this, length: 3);
    onInit();
    super.initState();
  }

  onInit() async {
    try {
      final List<RecentSalesModel> data =
          await recentSale.getRecentSales(context, type);
      setState(() {
        recentModel = data;
        isLoading = false;
      });
    } catch (e) {
      log('Error fetching suspended orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void tabChange(index) {}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IsMobile, bool>(
      builder: (context, isMobile) {
        return Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: isMobile ? 10 : 0,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text
                      (
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.cancel_rounded,
                        size: 30,
                        color: Constant.colorPurple,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: CustomRecentSaleTab(),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Constant.colorPurple,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
