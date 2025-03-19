import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/NewUi/BlocPages/SettingsBlocPage.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/utils/constants.dart';

import '../../FetchingApis/FetchApis.dart';
import '../../model/location.dart';
import '../../widgets/common/Top Section/Bloc/CustomBloc.dart';

import 'EmptyPage.dart';

class LocationBlocPage extends StatefulWidget {
  final LoggedInUser loggedInUser;
  const LocationBlocPage({super.key, required this.loggedInUser});

  @override
  State<StatefulWidget> createState() => _LocationBlocPage();
}

class _LocationBlocPage extends State<LocationBlocPage> {
  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    await FetchApis(context).fetchLocations();
    await FetchApis(context).fetchCustomers();

    setState(() {
      Constant.colorPurple = widget.loggedInUser.color == ''
          ? const Color(0xff4f55a5)
          : Color(int.parse(widget.loggedInUser.color.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, Location?>(builder: (context, location) {
      if (location == null) {
        return const EmptyPage(message: 'Getting Locations');
      }

      return SettingsBlocPage(location: location);
    });
  }
}
