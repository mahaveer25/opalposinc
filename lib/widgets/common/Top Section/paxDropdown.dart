import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/FetchingApis/FetchApis.dart';
import 'package:opalposinc/auth/remember_login.dart';
import 'package:opalposinc/model/location.dart';
import 'package:opalposinc/model/loggedInUser.dart';
import 'Bloc/CartBloc.dart';
import 'Bloc/CustomBloc.dart';

class PaxDeviceDropdown extends StatefulWidget {
  const PaxDeviceDropdown({
    super.key,
  });

  @override
  _PaxDeviceDropdownState createState() => _PaxDeviceDropdownState();
}

class _PaxDeviceDropdownState extends State<PaxDeviceDropdown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListPaxDevicesBloc, List<PaxDevice>?>(
      builder: (context, paxDeviceList) {
        debugPrint(paxDeviceList?.toString());
        return BlocBuilder<PaxDeviceBloc, PaxDevice?>(
          builder: (context, paxDevice) {
            return PaxDropDownWidget(
              paxDeviceList: paxDeviceList,
              selectedPaxDevice: paxDevice,
              onChanged: (value) async {
                final bloc = BlocProvider.of<PaxDeviceBloc>(context);
                bloc.add(PaxDeviceEvent(device: value));
                debugPrint("Saving id to SharedPreferences ${value?.id}");
                await RememberLogin.savePaxId(paxId: value?.id ?? "");
                String? id = await RememberLogin.getPaxId();

                debugPrint("getting saved id to pax SharedPreferences ${id}");
              },
            );
          },
        );
      },
    );
  }
}

class PaxDropDownWidget extends StatelessWidget {
  final List<PaxDevice>? paxDeviceList;
  final PaxDevice? selectedPaxDevice;
  final Function(PaxDevice?)? onChanged;

  const PaxDropDownWidget({
    super.key,
    required this.paxDeviceList,
    required this.onChanged,
    required this.selectedPaxDevice,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure the selected device exists in the list
    final items = [
      const DropdownMenuItem<PaxDevice?>(
        value: null,
        child: Text(
          "None",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14),
        ),
      ),
      ...?paxDeviceList?.map(
        (item) => DropdownMenuItem<PaxDevice?>(
          value: item,
          child: Text(
            "${item.deviceName} | (${item.serialNumber})",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    ];

    // Validate selectedPaxDevice
    PaxDevice? validatedSelection =
        paxDeviceList?.contains(selectedPaxDevice) == true
            ? selectedPaxDevice
            : null;

    return DropdownButtonHideUnderline(
      child: DropdownButton2<PaxDevice?>(
        value: validatedSelection,
        isExpanded: true,
        items: items,
        onChanged: onChanged,
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
