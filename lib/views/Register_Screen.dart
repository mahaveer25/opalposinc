import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/auth/login.dart';
import 'package:opalsystem/model/loggedInUser.dart';
import 'package:opalsystem/pages/home_page.dart';
import 'package:opalsystem/utils/constants.dart';
import 'package:opalsystem/utils/decorations.dart';
import 'package:opalsystem/widgets/CustomWidgets.dart';
import 'package:opalsystem/widgets/CustomWidgets/CustomIniputField.dart';
import '../services/open_register.dart';
import '../widgets/common/Top Section/Bloc/CustomBloc.dart';
import '../widgets/common/Top Section/location.dart';
import '../widgets/common/Top Section/paxDropdown.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
        backgroundColor: const Color.fromARGB(255, 222, 219, 219),
        body: Center(
          child: Container(
            width: 600,
            height: 520,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(40),
            child: SingleChildScrollView(
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
                        child: CustomTextWidget(text: "Select Location")),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      child:
                      Decorations.contain(child: const LocationDropdown()),
                    ),

                  ],
                  const SizedBox(height: 10),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child:
                      const CustomTextWidget(text: "Select PAX Device")),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child:
                    Decorations.contain(child: const PaxDeviceDropdown()),
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 45,
                        decoration: BoxDecoration(
                            color: Constant.colorPurple,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Constant.colorPurple,
                          ),
                          child: const Text('Back'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 150,
                        height: 45,
                        decoration: BoxDecoration(
                            color: Constant.colorPurple,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _openCashRegister,
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: Constant.colorPurple,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text('Open Register'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
