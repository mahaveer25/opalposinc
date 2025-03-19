import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/NewUi/BlocPages/CategoryBlocPage.dart';
import 'package:opalsystem/model/location.dart';
import 'package:opalsystem/model/setttings.dart';
import 'package:opalsystem/services/settings_api.dart';
import '../../widgets/common/Top Section/Bloc/CustomBloc.dart';

import 'EmptyPage.dart';

class SettingsBlocPage extends StatefulWidget {
  final Location location;
  const SettingsBlocPage({super.key, required this.location});

  @override
  State<StatefulWidget> createState() => _SettingsBlocPage();
}

class _SettingsBlocPage extends State<SettingsBlocPage> {
  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    LoggedInUserBloc bloc = BlocProvider.of<LoggedInUserBloc>(context);
    log(bloc.state!.businessId.toString());

    await SettingsApi.getAppSetting(
        context: context, businessid: bloc.state!.businessId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsModel?>(
        builder: (context, settings) {
      if (settings == null) {
        return const EmptyPage(message: 'Getting App Settings');
      }

      return CategoryBlocPage(
        location: widget.location,
      );
    });
  }
}
