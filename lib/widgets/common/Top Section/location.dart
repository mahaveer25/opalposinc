import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/FetchingApis/FetchApis.dart';
import 'package:opalsystem/auth/remember_login.dart';
import 'package:opalsystem/main.dart';
import 'package:opalsystem/model/location.dart';
import 'package:opalsystem/model/loggedInUser.dart';
import 'package:opalsystem/views/paxDevice.dart';
import 'Bloc/CartBloc.dart';
import 'Bloc/CustomBloc.dart';

class LocationDropdown extends StatefulWidget {
  const LocationDropdown({
    super.key,
  });

  @override
  _LocationDropdownState createState() => _LocationDropdownState();
}

class _LocationDropdownState extends State<LocationDropdown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return locationListBuilder();
  }

  Widget selectedLocationBloc({required List<Location> locations}) =>
      BlocBuilder<LocationBloc, Location?>(
          builder: (context, selectedLocation) {
        return dropDownLocation(
            locations: locations, selectedLocation: selectedLocation!);
      });

  Widget locationListBuilder() => BlocBuilder<ListLocationBloc, List<Location>>(
          builder: (context, locations) {
        if (locations.isEmpty) {
          return Container();
        }

        return selectedLocationBloc(locations: locations);
      });

  Widget dropDownLocation(
      {required List<Location> locations, required Location selectedLocation}) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<Location>(
        value: selectedLocation,
        isExpanded: true,
        items: locations
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    "${item.name} (${item.locationId})",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (value) async {
          await FetchApis(context).onupdatePrices(location: value!);

          final bloc = BlocProvider.of<LocationBloc>(context);
          bloc.add(value);
          await RememberLogin.saveLocationId(savedLocationID: value.id ?? "");
          // debugPrint("saving location id to shared preferences ${value.id}");
          String? locationBusinessId = await RememberLogin.getLocationId();
          // debugPrint("getting location id from  shared preferences ${locationBusinessId}");

          CartBloc cartBloc = BlocProvider.of<CartBloc>(context);
          cartBloc.add(CartClearProductEvent());
          // debugPrint("value  in Location ${value.toJson()}");

          PaxDeviceBloc paxDeviceBloc = BlocProvider.of<PaxDeviceBloc>(context);
          ListPaxDevicesBloc listPaxDevicesBloc = BlocProvider.of<ListPaxDevicesBloc>(context);
          LoggedInUserBloc loggedInUserBloc = BlocProvider.of<LoggedInUserBloc>(context);
          RegisterStatusBloc registerStatusBloc = BlocProvider.of<RegisterStatusBloc>(context);

          // debugPrint("from registerStatusBloc.state${registerStatusBloc.state}");

          List<PaxDevice>? list = loggedInUserBloc.state?.paxDevices?.where((element) => element.businessLocationId.toString() == value.id.toString(),).toList();
          // debugPrint("coming in this dialog ${loggedInUserBloc.state?.registerStatus}");
          listPaxDevicesBloc.add(list ?? []);
          if ((list?.isNotEmpty ?? false) && locations.length>1 ) {
            paxDeviceBloc.add(PaxDeviceEvent(device: null));

            debugPrint("from registerStatusBloc.state${registerStatusBloc.state}");
            debugPrint("locations length.... ${locations.length}");

            if (registerStatusBloc.state == "open") {
              // debugPrint("coming in this dialog ${loggedInUserBloc.state?.registerStatus}");

              showDialog(
                  context: context,
                  builder: (context) {
                    return const PaxDeviceRailWidget();
                  });
            }
          } else {
            debugPrint("Location dialog is not showing pax list is empty");
          }
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: 40,
          width: 150,
        ),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 200,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
