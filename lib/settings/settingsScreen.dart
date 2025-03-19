import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/connection.dart';
import 'package:opalsystem/utils/decorations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: body(context: context),
    );
  }

  Widget body({required BuildContext context}) {
    BlocProvider.of<CheckConnection>(context);

    List<SettingsWidget> list = [
      SettingsWidget(heading: 'Network', childrens: [
        BlocBuilder<CheckConnection, bool>(
          builder: (context, state) {
            // log('${state}');

            return SwitchListTile(
              contentPadding: const EdgeInsets.all(0.0),
              value: state,
              onChanged: (value) {
                setState(() {});
              },
              title: state
                  ? const Text('Online Mode')
                  : const Text('Offline Mode'),
            );
          },
        )
      ])
    ];

    return GridView.builder(
        padding: const EdgeInsets.all(15.0),
        itemCount: list.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: ((context, index) {
          return list[index];
        }));
  }
}

class SettingsWidget extends StatelessWidget {
  final String heading;
  final List<Widget> childrens;
  const SettingsWidget(
      {super.key, required this.heading, required this.childrens});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  heading.toString(),
                  style: Decorations.heading,
                ),
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: childrens,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
