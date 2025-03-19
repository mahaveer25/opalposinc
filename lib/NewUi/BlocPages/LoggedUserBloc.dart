import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/loggedInUser.dart';
import '../../widgets/common/Top Section/Bloc/CustomBloc.dart';

import 'EmptyPage.dart';
import 'LocationBlocPage.dart';

class LoggedInUserBlocBuilder extends StatelessWidget {
  const LoggedInUserBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoggedInUserBloc, LoggedInUser?>(
        builder: (context, user) {
      if (user == null) {
        return const EmptyPage(message: 'Getting User Info');
      }

      return LocationBlocPage(
        loggedInUser: user,
      );
    });
  }
}
