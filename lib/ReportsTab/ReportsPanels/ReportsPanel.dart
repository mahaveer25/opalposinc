import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/ReportsTab/ReportsPanels/Trending/TaxReportsPanel.dart';

import '../../widgets/common/Top Section/Bloc/CustomBloc.dart';
import 'Trending/ProfitLossPanel.dart';

class ReportsPanel extends StatelessWidget {
  const ReportsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeCategoryBloc, String?>(
        builder: (context, selectedCategory) {
      if (selectedCategory == 'Profit / Loss Reports') {
        return const ProfitLossPanel();
        // Expanded(child: DetailPanelTrending())
      } else if (selectedCategory == 'Tax Report') {
        return const TaxReportPanel();
      }
      return Container();
    });
  }
}
