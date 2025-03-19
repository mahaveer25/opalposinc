import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/NewUi/BlocPages/LoggedUserBloc.dart';
import 'package:opalsystem/NewUi/Widgets/CustomButton.dart';
import 'package:opalsystem/auth/remember_login.dart';
import 'package:opalsystem/connection.dart';
import 'package:opalsystem/model/loggedInUser.dart';
import 'package:opalsystem/my_flutter_app_icons.dart';
import 'package:opalsystem/services/user_authenticate.dart';
import 'package:opalsystem/utils/constant_dialog.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/utils/decorations.dart';
import 'package:opalsystem/utils/global_variables.dart';
import 'package:opalsystem/widgets/CustomWidgets/CustomIniputField.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/CustomBloc.dart';

class NewLoginPage extends StatefulWidget {
  const NewLoginPage({super.key});

  @override
  State<NewLoginPage> createState() => _NewLoginPageState();
}

class _NewLoginPageState extends State<NewLoginPage> {
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
          GlobalData.storeUrl = url.text;
          loggingIn = true;
        });
      }

      await RememberLogin.toHiveStorage(storeUrl: url.text);

      if (emailaddress.text.isEmpty || password.text.isEmpty) {
        ConstDialog(context)
            .showErrorDialog(error: 'Please enter both username and password.');
      }

      try {
        final result = await _authService.loginUser(
            context, emailaddress.text, password.text, url.text);

        final success = LoggedInUser.fromJson(result);
        // final data = result['data'];

        if (success.businessId != null) {
          LoggedInUserBloc loggedInUserBloc =
              BlocProvider.of<LoggedInUserBloc>(context);
          loggedInUserBloc.add(success);

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

    saveUrl();
    super.initState();
  }

  saveUrl() async {
    await RememberLogin().init();

    final storeUrl = await RememberLogin.getUrlFromHive();
    if (storeUrl != null) {
      if (mounted) {
        setState(() {
          url.text = storeUrl;
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
      appBar: AppBar(
        leadingWidth: 150,
        leading: const Icon(
          MyFlutterApp.opalpay_logo,
          size: 50,
        ),
        toolbarHeight: 120,
        title: RichText(
            text: const TextSpan(
                text: 'SIGN',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 28),
                children: [
              WidgetSpan(
                  child: SizedBox(
                width: 10.0,
              )),
              TextSpan(
                text: 'INTO',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 28),
              ),
              WidgetSpan(
                  child: SizedBox(
                width: 10.0,
              )),
              TextSpan(
                text: 'OPAL PAY',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 28),
              )
            ])),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 85.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: CustomInputField(
                  labelText: '.opalpay.us',
                  hintText: 'Store Url',
                  controller: url,
                  toHide: false,
                  onChanged: onUrlChanged,
                )),
                Decorations.width5,
                Expanded(
                  child: CustomInputField(
                    onChanged: onEmailChanged,
                    controller: emailaddress,
                    labelText: 'User Name',
                    hintText: 'Enter User Name',
                    toHide: false,
                  ),
                ),
                Decorations.width5,
                Expanded(
                    child: CustomInputField(
                        onChanged: onPasswordChanged,
                        controller: password,
                        toHide: _isObscure,
                        icon: InkWell(
                          onTap: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          child: Icon(
                            !_isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: !_isObscure ? Colors.grey : Colors.black,
                          ),
                        ),
                        labelText: 'Enter Password',
                        hintText: 'User Password')),
              ],
            ),
            Decorations.height10,
            Row(
              children: [
                Expanded(child: Container()),
                Decorations.width5,
                Expanded(
                  child: Container(),
                ),
                Decorations.width5,
                Expanded(
                    child: SizedBox(
                  height: 50,
                  child: BlocBuilder<CheckConnection, bool>(
                      builder: (context, isConnected) {
                    if (loggingIn) {
                      return const SizedBox(
                          width: 30.0,
                          height: 30.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(child: CircularProgressIndicator())
                            ],
                          ));
                    }

                    return CustomButton(
                      enabled: url.text.isNotEmpty &&
                          emailaddress.text.isNotEmpty &&
                          password.text.isNotEmpty,
                      backgroundColor: Constant.colorPurple,
                      text: 'Login Here ',
                      textColor: Colors.white,
                      onTap: () async =>
                          await loginUser(isConnected = isConnected),
                    );
                  }),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }

  onUrlChanged(String value) => setState(() {});

  onPasswordChanged(String value) => setState(() {});

  onEmailChanged(String value) => setState(() {});
}
