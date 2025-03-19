import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/CloverDesign/Dashboard.dart';
import 'package:opalsystem/FetchingApis/FetchApis.dart';
import 'package:opalsystem/model/category.dart';
import 'package:opalsystem/model/loggedInUser.dart';
import 'package:opalsystem/model/location.dart';
import 'package:opalsystem/pages/home_page.dart';
import 'package:opalsystem/views/Register_Screen.dart';

import '../../model/brand.dart';
import '../../widgets/common/Top Section/Bloc/CustomBloc.dart';
import 'EmptyPage.dart';

class BrandBlocPage extends StatefulWidget {
  final Location location;
  final Category category;
  const BrandBlocPage(
      {super.key, required this.location, required this.category});

  @override
  State<StatefulWidget> createState() => _BrandBlocPage();
}

class _BrandBlocPage extends State<BrandBlocPage> {
  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    await FetchApis(context).fetchBrands();
    await FetchApis(context).fetchPrice();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoggedInUserBloc, LoggedInUser?>(
        builder: (context, loggedInUser) {
      return BlocBuilder<BrandBloc, Brand?>(builder: (context, location) {
        if (location == null) {
          return const EmptyPage(message: 'Getting Brands');
        }

        if (loggedInUser?.registerStatus == 'close') {
          return const RegisterScreen();
        }

        return const HomePage();
      });
    });
  }
}
