import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/common_app_barV1.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/widgets/save_and_cancel_buttons.dart';
import 'package:opalposinc/auth/login.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'package:opalposinc/pages/home_page.dart';
import 'package:opalposinc/services/open_register.dart';
import 'package:opalposinc/utils/assets.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/decorations.dart';
import 'package:opalposinc/views/Register_Screen.dart';
import 'package:opalposinc/widgets/CustomWidgets/CustomIniputField.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/location.dart';
import 'package:opalposinc/widgets/common/Top%20Section/paxDropdown.dart';

import '../../../widgets/CustomWidgets.dart';

class OpenRegisterv1 extends StatefulWidget {
  const OpenRegisterv1({super.key});

  @override
  State<OpenRegisterv1> createState() => _OpenRegisterv1State();
}

class _OpenRegisterv1State extends State<OpenRegisterv1> {
  final TextEditingController cashInHandController = TextEditingController();
  LocationList? _selectedLocation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _openCashRegister() async {
    if (cashInHandController.text.isEmpty) {
      // Show a dialog if the amount is empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Input Error'),
          content: const Text('Please enter the amount.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return; // Exit the function to prevent further execution
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      LoggedInUserBloc loggedInUserBloc =
          BlocProvider.of<LoggedInUserBloc>(context);
      LocationBloc locationBloc = BlocProvider.of<LocationBloc>(context);
      RegisterStatusBloc registerStatusBloc =
          BlocProvider.of<RegisterStatusBloc>(context);
      final response = await CashRegisterService.openCashRegister(
        businessId: loggedInUserBloc.state!.businessId.toString(),
        locationId: locationBloc.state?.id.toString() ?? '',
        userId: loggedInUserBloc.state!.id.toString(),
        amount: cashInHandController.text,
      );

      log('selected location ${loggedInUserBloc.state!.businessId.toString()}');
      log('selected location ${_selectedLocation?.id.toString()}');
      log('selected location ${loggedInUserBloc.state!.id.toString()}');

      if (response['success'] == true) {
        registerStatusBloc.add("open");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content:
                Text(response['error']?['info']?.toString() ?? 'Unknown Error'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      log('Error opening cash register: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('An error occurred. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoggedInUserBloc, LoggedInUser?>(
        builder: (context, loggedInUser) {
      if (loggedInUser == null) {
        return const Scaffold(
          body: Center(child: Text('User not found')),
        );
      }

      final locationList = loggedInUser.locationList;
      final showDropdown = locationList != null && locationList.length > 1;

      if (_selectedLocation == null && locationList!.isNotEmpty) {
        _selectedLocation = locationList.first;
      } else if (_selectedLocation != null &&
          !locationList!.contains(_selectedLocation)) {
        _selectedLocation = locationList.first;
      }

      return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: CommonAppBarV1(
              imagePath: Myassets.cashlog,
              title: "Cashlog",
            )),
        backgroundColor: const Color.fromARGB(255, 222, 219, 219),
        body: Center(
          child: Container(
            width: context.width * 0.7,
            height: context.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Open Register",
                            style: TextStyle(
                              fontSize: 40,
                              color: Constant.colorPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 50),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: CustomTextWidget(text: "Enter Amount")),
                          const SizedBox(height: 5),
                          CustomInputField(
                            labelText: "Cash in hand*",
                            hintText: "Enter Amount",
                            controller: cashInHandController,
                          ),
                          if (showDropdown) ...[
                            const SizedBox(height: 10),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    CustomTextWidget(text: "Select Location")),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: double.infinity,
                              child: Decorations.contain(
                                  child: const LocationDropdown()),
                            ),
                          ],
                          const SizedBox(height: 10),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: const CustomTextWidget(
                                  text: "Select PAX Device")),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            child: Decorations.contain(
                                child: const PaxDeviceDropdown()),
                          ),
                          const SizedBox(height: 35),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Container(
                          //       width: 100,
                          //       height: 45,
                          //       decoration: BoxDecoration(
                          //           color: Constant.colorPurple,
                          //           borderRadius:
                          //           const BorderRadius.all(Radius.circular(10.0))),
                          //       child: ElevatedButton(
                          //         onPressed: () => Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) => const LoginScreen()),
                          //         ),
                          //         style: ElevatedButton.styleFrom(
                          //           elevation: 5,
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(6),
                          //           ),
                          //           foregroundColor: Colors.white,
                          //           backgroundColor: Constant.colorPurple,
                          //         ),
                          //         child: const Text('Back'),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 10),
                          //     Container(
                          //       width: 150,
                          //       height: 45,
                          //       decoration: BoxDecoration(
                          //           color: Constant.colorPurple,
                          //           borderRadius:
                          //           const BorderRadius.all(Radius.circular(10.0))),
                          //       child: ElevatedButton(
                          //         onPressed: _isLoading ? null : _openCashRegister,
                          //         style: ElevatedButton.styleFrom(
                          //           elevation: 5,
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(6),
                          //           ),
                          //           foregroundColor: Colors.white,
                          //           backgroundColor: Constant.colorPurple,
                          //         ),
                          //         child: _isLoading
                          //             ? const SizedBox(
                          //           width: 24,
                          //           height: 24,
                          //           child: CircularProgressIndicator(
                          //             valueColor: AlwaysStoppedAnimation<Color>(
                          //                 Colors.white),
                          //           ),
                          //         )
                          //             : const Text('Open Register'),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                VerticalDivider(
                  endIndent: 30,
                  indent: 30,
                  color: Colors.black,
                  thickness: 0.5,
                ),
                BlueAndWhiteButtons(
                  isLoadingCheckBlue: _isLoading,
                  onPressedWhite: () async {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  whiteButtonTitle: "Back",
                  blueButtonTitle: 'Open Register',
                  onPressedBlue: () async {
                    if (!_isLoading) {
                      await _openCashRegister();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
