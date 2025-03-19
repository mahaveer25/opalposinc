import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/Add%20Item%20Inventory%20V1/add_inventory.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/Add%20Item%20Inventory%20V1/add_inventry_v1.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/Add%20Item%20Inventory%20V1/transaction/transactionV1.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/Close%20out/close_register_v1.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/Open%20Register/open_registerV1.dart';
import 'package:opalposinc/CloverDesign/Dashboard%20Pages/Refund/refundV1.dart';
import 'package:opalposinc/NewUi/Widgets/CustomButton.dart';
import 'package:opalposinc/auth/login.dart';
import 'package:opalposinc/pages/home_page.dart';
import 'package:opalposinc/utils/constant_dialog.dart';
import 'package:opalposinc/utils/constants.dart';
import 'package:opalposinc/utils/route_utlity.dart';
import 'package:opalposinc/utils/toastification_utility.dart';
import 'package:opalposinc/widgets/common/Top%20Section/Bloc/CustomBloc.dart';
import 'package:opalposinc/widgets/common/Top%20Section/register_details.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoggedInUserBloc loggedInUserBloc =
        BlocProvider.of<LoggedInUserBloc>(context);

    final List<Map<String, dynamic>> dashboardItems = [
      {
        'image': const AssetImage("assets/images/cash.png"),
        'label': "Cash Log",
        "onTap": () {
          // RegisterStatusBloc registerStatus = BlocProvider.of<RegisterStatusBloc>(context);
          if (loggedInUserBloc.state?.registerStatus == "open") {
            return ToastificationUtility.showToast(
              context: context,
              message: "Register is already open",
              type: ToastType.info,
            );
          } else {
            RouteUtility.push(context, OpenRegisterv1());
          }
        }
      },
      {
        'image': const AssetImage("assets/images/cashout.png"),
        'label': "Closeout",
        'onTap': () {
          if (loggedInUserBloc.state?.registerStatus == "close") {
            return ConstDialog(context).showErrorDialog(
              error: "Cash Register is closed \n click ok to open register",
              ontap: () {
                RouteUtility.pop(context);
                RouteUtility.push(context, OpenRegisterv1());
              },
            );
          } else {
            return RouteUtility.push(context, const CloseRegisterV1());
          }
        }
      },
      {
        'image': const AssetImage("assets/images/tips.png"),
        'label': "Tips",
      },
      {
        'image': const AssetImage("assets/images/reward.png"),
        'label': "Rewards"
      },
      {
        'image': const AssetImage("assets/images/reporting.png"),
        'label': "Reporting",
      },
      {
        'image': const AssetImage("assets/images/addinventory.png"),
        'label': "Add Inventory",
        'onTap': () => RouteUtility.push(context, const AddInventoryV1()),
      },
      {
        'image': const AssetImage("assets/images/employees.png"),
        'label': "Employees"
      },
      {
        'image': const AssetImage("assets/images/addcustomer.png"),
        'label': "Add Customers"
      },
      {
        'image': const AssetImage("assets/images/help.png"),
        'label': "Ask Help"
      },
      {'image': const AssetImage("assets/images/setup.png"), 'label': "Setup"},
      {
        'image': const AssetImage("assets/images/printer.png"),
        'label': "Printers"
      },
    ];
    return Scaffold(
      backgroundColor: Colors.white, // Matches the dark theme in the image

      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  // Top Section
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        QuickAction(
                            image: "assets/images/register.png",
                            label: "Register"),
                        QuickAction(
                            image: "assets/images/order.png", label: "Orders"),
                        QuickAction(
                            onTap: () {
                              RouteUtility.push(context, Refundv1());
                            },
                            image: "assets/images/refund.png",
                            label: "Refund"),
                        QuickAction(
                            onTap: () {
                              RouteUtility.push(context, Transactionv1());
                            },
                            image: "assets/images/transactions.png",
                            label: "Transactions"),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.grey, indent: 25, endIndent: 25),
                  Expanded(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          // crossAxisSpacing: ,
                          // mainAxisSpacing: 10,
                          mainAxisExtent: 155,
                        ),
                        itemCount: dashboardItems.length,
                        itemBuilder: (context, index) {
                          final item = dashboardItems[index];
                          return DashboardIcon(
                            onTap: item['onTap'],
                            image: item['image'],
                            label: item['label'],
                          );
                        }),
                  ),
                ],
              ),
            ),
            // Sidebar Section
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20, right: 20),
              child: Container(
                width: 380,
                decoration: BoxDecoration(
                  color: Colors.white, // Background color for outer container
                  borderRadius: BorderRadius.circular(14), // Rounded corners
                  border: Border.all(
                    color: Colors.grey, // Border color
                    width: 2, // Border width
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 170,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff505595),
                                Color.fromARGB(255, 91, 192, 200)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(
                                12), // Match Card's border radius
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "support@opalpay.us",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "817-400-4009",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                              "assets/images/opal pos png.png",
                                            ),
                                            width: 150,
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomButton(
                                text: "HELP",
                                backgroundColor: Colors.white,
                                textColor: Constant.colorPurple,
                              )
                            ],
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 170,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff505595),
                                Color.fromARGB(255, 91, 192, 200)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(
                                12), // Match Card's border radius
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "EULESS SMOKE & VAPOR",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "last Order",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "\$07.00",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomePage())),
                                          child: Text(
                                            "Logged In",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          "Stewie Hawkin",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 220,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xff505595), Color(0xff59B8BE)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(
                                12), // Match Card's border radius
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Demo: NOT FOR ACTUAL USE",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Last Order: \$7.00",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const Text(
                                    "Logged In: Melissa Johnson",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const Text(
                                    "12:03 PM, Tuesday March 23",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 20),
                                  // Test Message
                                  Align(
                                    alignment: Alignment.center,
                                    child: CustomButton(
                                      text: "This is gcp test messages",
                                      backgroundColor: Colors.white,
                                      textColor: Constant.colorPurple,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  final String image;
  final String label;
  final void Function()? onTap;

  const QuickAction(
      {super.key, required this.image, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              // Gradient border
              Container(
                width: 150,
                height: 135,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.circular(12), // Match Card's border radius
                ),
              ),
              // Card inside the gradient border
              Positioned.fill(
                left: 0,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  elevation: 4,
                  margin: const EdgeInsets.all(
                      1.5), // For gradient border thickness
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Image(
                      image: AssetImage(image),
                      height: 135,
                      width: 80,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardIcon extends StatelessWidget {
  final ImageProvider image;
  final String label;
  final void Function()? onTap;

  const DashboardIcon({
    super.key,
    required this.image,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
              color: Colors.white,
              elevation: 4,
              child: SizedBox(
                  width: 150,
                  height: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Image(
                      image: image,
                      height: 135,
                      width: 80,
                    ),
                  ))), // Use ImageProvider
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
