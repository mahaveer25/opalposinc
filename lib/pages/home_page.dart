import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/MobileView/mobileHome.dart';
import 'package:opalsystem/auth/remember_login.dart';
import 'package:opalsystem/connection.dart';
import 'package:opalsystem/localDatabase/Transaction/Bloc/bloc/local_transaction_bloc_bloc.dart';
import 'package:opalsystem/views/paxDevice.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalsystem/widgets/major/left_section.dart';
import 'package:opalsystem/widgets/major/right_section.dart';

import '../FetchingApis/FetchApis.dart';
import '../NewUi/ButtonRail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  late StreamSubscription<bool> streamSubscription;
  late StreamSubscription subscription;

  Future<void> refresh() async {
    refreshIndicatorKey.currentState?.show();
  }

  @override
  void initState() {
    onInit();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    streamSubscription = ConnectionFuncs.checkInternetConnectivityStream()
        .asBroadcastStream()
        .listen((isConnected) {
      log('$isConnected');
      CheckConnection connection = BlocProvider.of<CheckConnection>(context);
      connection.add(isConnected);
    });

    super.initState();
  }

  onInit() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint("  WidgetsBinding.instance.addPostFrameCallback ");

      LoggedInUserBloc userBloc = BlocProvider.of<LoggedInUserBloc>(context);
      String? paxId = await RememberLogin.getPaxId();

      bool? apiCheckPaxId = userBloc.state?.paxDevices?.any(
        (element) => element.id == paxId,
      );

      debugPrint("paxId getting from sharedPreferences ${paxId}");
      if (paxId == "" || paxId == null) {
        if (apiCheckPaxId != true && userBloc.state?.registerStatus == "open") {
          showDialog(
            context: context,
            builder: (context) {
              debugPrint("showDialog log");
              return const PaxDeviceRailWidget();
            },
          );
        } else {
          debugPrint("paxId is from api is changed ");
        }
      } else {
        debugPrint("paxId is available ${paxId}");
      }
    });
    await FetchApis(context).fetchPaymentMethods();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<IsMobile>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(child: LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth <= 700;
      bloc.add(isMobile);
      if (isMobile) {
        return const MobileHomePage();
      }

      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarBrightness: Brightness.light),
        ),
        body: RefreshIndicator(
            // key: refreshIndicatorKey,
            onRefresh: FetchApis(context).fetchAll,
            child: Column(
              children: [
                BlocBuilder<CheckConnection, bool>(
                  builder: (context, state) {
                    if (state) {
                      LocalTransactionBlocBloc bloc =
                          BlocProvider.of<LocalTransactionBlocBloc>(context);
                      bloc.add(CheckTransactionEvent(context: context));

                      return Container();
                    }

                    return Material(
                      color: Colors.deepOrange.shade600,
                      child: const SizedBox(
                        height: 40.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          child: Row(
                            children: [
                              Text(
                                'No Internet Connection',
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'All Transactions will Now be saved locally ',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ButtonRails(),
                      // SizedBox(width: 250, child: SideBar()),
                      // Expanded(child: ProductScreen()),
                      // Expanded(child: SideBar()),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: height * 0.965,
                            width: width * 0.55,
                            child: const LeftSection(),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            height: height * 0.965,
                            width: width * 0.4,
                            child: const RightWidget(),
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              ],
            )),
      );
    }));
  }
}
