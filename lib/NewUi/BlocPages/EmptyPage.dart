import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  final String message;
  const EmptyPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 10.0,
            ),
            Text(message)
          ],
        ),
      ),
    );
  }
}
