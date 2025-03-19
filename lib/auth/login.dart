// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/NewUi/BlocPages/LoggedUserBloc.dart';
import 'package:opalposinc/NewUi/Widgets/CustomButton.dart';
import 'package:opalposinc/auth/remember_login.dart';
import 'package:opalposinc/auth/resetScreen.dart';
import 'package:opalposinc/connection.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/services/user_authenticate.dart';
import 'package:opalposinc/utils/commonFunction.dart';
import 'package:opalposinc/utils/constant_dialog.dart';
import 'package:opalposinc/utils/global_variables.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/ProductBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/nav_button.dart';

import '../widgets/CustomWidgets/CustomIniputField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loggingIn = false;
  bool _isObscure = true;
  TextEditingController emailaddress = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController url = TextEditingController();
  final AuthService _authService = AuthService();
  late StreamSubscription<bool> streamSubscription;

  Future<void> loginUser(bool isConnected) async {
    if (!isConnected) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                SizedBox(width: 8),
                Text("Alert")
              ],
            ),
            content: const Text("Check Your Internet Connection"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Ok',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    } else {
      if (mounted) {
        setState(() {
          GlobalData.storeUrl = url.text.trim();
          loggingIn = true;
        });
      }

      await RememberLogin.toHiveStorage(storeUrl: url.text);

      if (emailaddress.text.isEmpty || password.text.isEmpty) {
        ConstDialog(context)
            .showErrorDialog(error: 'Please enter both username and password.');
      }

      try {
        final result = await _authService.loginUser(context,
            emailaddress.text.trim(), password.text.trim(), url.text.trim());
        final success = LoggedInUser.fromJson(result);
        ProductBloc productBloc = BlocProvider.of<ProductBloc>(context);
        if (success.businessId != null) {
          productBloc.add(ProductResetEvent());
          LoggedInUserBloc loggedInUserBloc =
              BlocProvider.of<LoggedInUserBloc>(context);
          loggedInUserBloc.add(success);
          RegisterStatusBloc registerStatusBloc =
              BlocProvider.of<RegisterStatusBloc>(context);
          registerStatusBloc.add(success.registerStatus ?? "");

          String? paxIdFromLocal = await RememberLogin.getPaxId();
          String? locationIdFromLocal = await RememberLogin.getLocationId();
          debugPrint("paxId getting from sharedPreferences ${paxIdFromLocal}");
          debugPrint(
              "locationId getting from sharedPreferences ${locationIdFromLocal}");

          PaxDeviceBloc bloc = BlocProvider.of<PaxDeviceBloc>(context);
          ListPaxDevicesBloc listPaxDevicesBloc =
              BlocProvider.of<ListPaxDevicesBloc>(context);
          LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);

          if (locationIdFromLocal != null || locationIdFromLocal != "") {
            if (paxIdFromLocal != null || paxIdFromLocal != "") {
              if (locationIdFromLocal == locationBloc.state?.id) {
                List<PaxDevice>? list = success.paxDevices
                    ?.where(
                      (element) =>
                          element.businessLocationId.toString() ==
                          locationIdFromLocal.toString(),
                    )
                    .toList();
                if (list?.isNotEmpty ?? false) {
                  listPaxDevicesBloc.add(list ?? []);
                  PaxDevice? localDevice = list?.firstWhere(
                    (device) => device.id.toString() == paxIdFromLocal,
                    orElse: () => PaxDevice(),
                  );
                  if (localDevice != null) {
                    bloc.add(PaxDeviceEvent(device: localDevice));
                  } else {
                    debugPrint(
                        "No matching device found locally for paxId: $paxIdFromLocal");
                  }
                }
              } else {
                debugPrint("PaxIdFromLocal is not same coming from api ");
                CommonFunctions.addPaxAndLocationIndexZero(
                    locationBloc, success, listPaxDevicesBloc, bloc);
              }
            } else {
              debugPrint(
                  "PaxIdFromLocal is not available in sharedPreferences ");
              CommonFunctions.addPaxAndLocationIndexZero(
                  locationBloc, success, listPaxDevicesBloc, bloc);
            }
          } else {
            debugPrint("locationId is not available in sharedPreferences ");

            CommonFunctions.addPaxAndLocationIndexZero(
                locationBloc, success, listPaxDevicesBloc, bloc);
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoggedInUserBlocBuilder(),
            ),
          );
        } else {
          log('print something');
        }
      } catch (e) {
        log('Exception during login: $e');
      }
      if (mounted) {
        setState(() {
          loggingIn = false;
        });
      }
    }
  }

  @override
  void initState() {
    streamSubscription = ConnectionFuncs.checkInternetConnectivityStream()
        .asBroadcastStream()
        .listen((isConnected) {
      CheckConnection connection = BlocProvider.of<CheckConnection>(context);
      connection.add(isConnected);
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.bottom]);
    // emailaddress.text="Rakesh";
    // password.text="Laptop123";

    saveUrl();
    super.initState();
  }

  saveUrl() async {
    await RememberLogin().init();

    final storeUrl = await RememberLogin.getUrlFromHive();
    if (storeUrl != null) {
      if (mounted) {
        setState(() {
          url.text = storeUrl.trim();
        });
      }
    }

    // await LocalTransaction().deleteDatabase();
    // await LocalTransaction().close();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 600) {
            // log("Screen constraints are  < 600 ");
            return _buildMobileLayout(constraints);
          } else if (constraints.maxWidth < 900) {
            // log("Screen constraints are  < 900 ");
            return _buildTabletPortraitLayout(constraints);
          } else {
            // log("Screen constraints are  > 900 ");

            return _buildTabletLandscapeLayout(constraints);
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(BoxConstraints constraints) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset(
                'assets/images/opalpay.png',
                width: constraints.maxWidth < 600 ? 200 : 100,
                height: constraints.maxWidth < 600 ? 200 : 100,
                fit: BoxFit.contain,
              ),
            ),
            _buildMobileForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletPortraitLayout(BoxConstraints constraints) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset(
                'assets/images/opalpay.png',
                width: constraints.maxWidth < 600 ? 300 : 300,
                fit: BoxFit.contain,
              ),
            ),
            _buildTabletForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLandscapeLayout(BoxConstraints constraints) {
    return Center(
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Image.asset(
                'assets/images/opalpay.png',
                fit: BoxFit.contain,
                width: 400,
                height: 400,
              ),
            ),
            Expanded(
              child: _buildForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileForm() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Login Form',
            style: TextStyle(
              fontSize: 25,
              color: Color(0XFF4f55a5),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          CustomInputField(
            controller: url,
            labelText: '.opalpay.us',
            hintText: 'Enter Your Store URL',
            toHide: false,
          ),
          const SizedBox(height: 10),
          CustomInputField(
            controller: emailaddress,
            labelText: '',
            hintText: 'Enter Email or Username',
            toHide: false,
          ),
          const SizedBox(height: 10),
          CustomInputField(
            controller: password,
            labelText: '',
            hintText: 'Enter Your Password',
            toHide: _isObscure,
            icon: InkWell(
              onTap: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
              child: Icon(
                _isObscure ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ResetPasswordScreen())),
              child: const Text('Forget Password?'),
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<CheckConnection, bool>(
            builder: (context, isConnected) {
              if (loggingIn) {
                return const SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Center(child: CircularProgressIndicator())],
                    ));
              }

              return CustomButton(
                text: 'Login Here ',
                backgroundColor: const Color(0XFF4f55a5),
                textColor: Colors.white,
                onTap: () async => await loginUser(isConnected = isConnected),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabletForm() {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Login Form',
            style: TextStyle(
              fontSize: 40,
              color: Color(0XFF4f55a5),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 100),
          CustomInputField(
            controller: url,
            labelText: '.opalpay.us',
            hintText: 'Enter Your Store URL',
            toHide: false,
          ),
          const SizedBox(height: 20),
          CustomInputField(
            controller: emailaddress,
            labelText: 'Username',
            hintText: 'Enter Email or Username',
            toHide: false,
          ),
          const SizedBox(height: 20),
          CustomInputField(
            controller: password,
            labelText: '',
            hintText: 'Enter Your Password',
            toHide: _isObscure,
            icon: InkWell(
              onTap: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
              child: Icon(
                _isObscure ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ResetPasswordScreen())),
              child: const Text('Forget Password?'),
            ),
          ),
          const SizedBox(height: 40),
          BlocBuilder<CheckConnection, bool>(
            builder: (context, isConnected) {
              if (loggingIn) {
                return const SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Center(child: CircularProgressIndicator())],
                    ));
              }

              return Button(
                title: 'Login Here ',
                color: const Color(0XFF4f55a5),
                onTap: () async => await loginUser(isConnected = isConnected),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Card(
        surfaceTintColor: Colors.transparent,
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login Form',
                style: TextStyle(
                  fontSize: 40,
                  color: Color(0XFF4f55a5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 100),
              CustomInputField(
                controller: url,
                labelText: '.opalpay.us',
                hintText: 'Enter Your Store URL',
                toHide: false,
              ),
              const SizedBox(height: 20),
              CustomInputField(
                controller: emailaddress,
                labelText: 'Username',
                hintText: 'Enter Email or Username',
                toHide: false,
              ),
              const SizedBox(height: 20),
              CustomInputField(
                controller: password,
                labelText: '',
                hintText: 'Enter Your Password',
                toHide: _isObscure,
                icon: InkWell(
                  onTap: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  child: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ResetPasswordScreen())),
                  child: const Text('Forget Password?'),
                ),
              ),
              const SizedBox(height: 40),
              BlocBuilder<CheckConnection, bool>(
                builder: (context, isConnected) {
                  if (loggingIn) {
                    return const SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(child: CircularProgressIndicator())
                          ],
                        ));
                  }

                  return Button(
                    title: 'Login Here ',
                    color: const Color(0XFF4f55a5),
                    onTap: () async =>
                        await loginUser(isConnected = isConnected),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
