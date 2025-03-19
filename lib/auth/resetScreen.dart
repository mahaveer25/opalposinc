import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/NewUi/Widgets/CustomButton.dart';
import 'package:opalposinc/auth/login.dart';
import 'package:opalposinc/auth/remember_login.dart';
import 'package:opalposinc/connection.dart';
import 'package:opalposinc/services/resetPasswordService.dart';
import 'package:opalposinc/widgets/CustomWidgets/CustomIniputField.dart';
import 'package:opalposinc/widgets/common/Top%20Section/nav_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool loggingIn = false;
  TextEditingController emailaddress = TextEditingController();
  TextEditingController url = TextEditingController();
  final ResetPasswordService resetPasswordService = ResetPasswordService();
  @override
  void initState() {
    super.initState();
    saveUrl(); // Make sure this is called in the correct lifecycle method.
  }

  saveUrl() async {
    await RememberLogin().init();

    final storeUrl = await RememberLogin.getUrlFromHive();
    if (storeUrl != null && storeUrl.isNotEmpty) {
      // Check if the URL is not empty
      if (mounted) {
        setState(() {
          url.text = storeUrl; // Set the URL to the TextEditingController
        });
      }
    }
  }

  Future<void> resetUser(bool isConnected) async {
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
          loggingIn = true; // Show loader
        });
      }

      try {
        final Map<String, dynamic> response = await resetPasswordService
            .resetUser(context, emailaddress.text, url.text);
        log('email:${emailaddress.text} response: $response');

        if (response['status'] == true) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              double width = MediaQuery.of(context).size.width;
              return Dialog(
                child: SizedBox(
                  width: width > 800 ? width * 0.3 : width * 0.5,
                  child: Wrap(
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              color: Color.fromARGB(255, 37, 84, 124),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Reset Successfully',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 3,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.email,
                                  color: Color.fromARGB(255, 37, 84, 124),
                                  size: 30,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Please Check your Email",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: width < 700 ? 18 : 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 70,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen())),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  width: 100,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 37, 84, 124),
                                        width: 2.0, // Border width
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: const Center(
                                      child: Text(
                                    'OK',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 37, 84, 124)),
                                  )),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          if (mounted) {
            setState(() {
              loggingIn = false; // Hide loader on failure
            });
          }
        }
      } catch (e) {
        log('Error: $e');
      } finally {
        if (mounted) {
          setState(() {
            loggingIn = false; // Ensure loader is hidden after the try block
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 600) {
            // For Mobile layout
            return _buildMobileLayout(constraints);
          } else if (constraints.maxWidth < 900) {
            return _buildTabletPortraitLayout(constraints);
          } else {
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

  Widget _buildTabletForm() {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Reset Password',
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
            labelText: 'Email Address',
            hintText: 'Enter Email Address',
            toHide: false,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen())),
              child: const Text('back to Login?'),
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
                title: 'Reset Now ',
                color: const Color(0XFF4f55a5),
                onTap: () async => await resetUser(isConnected),
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
                'Reset Password',
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
                labelText: 'Email Address',
                hintText: 'Enter Email Address',
                toHide: false,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen())),
                  child: const Text('back to Login?'),
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
                    title: 'Reset Now ',
                    color: const Color(0XFF4f55a5),
                    onTap: () async =>
                        await resetUser(isConnected = isConnected),
                  );
                },
              ),
            ],
          ),
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
            'Reset Password',
            style: TextStyle(
              fontSize: 25,
              color: Color(0XFF4f55a5),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          CustomInputField(
            controller: url,
            labelText: '.opalpay.us',
            hintText: 'Enter Your Store URL',
            toHide: false,
          ),
          const SizedBox(height: 20),
          CustomInputField(
            controller: emailaddress,
            labelText: 'Email Address',
            hintText: 'Enter Email Address',
            toHide: false,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen())),
              child: const Text('back to Login?'),
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
                text: 'Reset Now ',
                backgroundColor: const Color(0XFF4f55a5),
                textColor: Colors.white,
                onTap: () async => await resetUser(isConnected = isConnected),
              );
            },
          ),
        ],
      ),
    );
  }
}
