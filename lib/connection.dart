import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'localDatabase/Transaction/localTransaction.dart';

class CheckConnection extends Bloc<bool, bool> {
  CheckConnection() : super(true) {
    on<bool>((event, emit) => emit(event));
  }
}

class ConnectionFuncs {
  static Stream<bool> checkInternetConnectivityStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 5)); // Check every 5 seconds
      yield await _checkInternet();
    }
  }

  static Future<bool> _checkInternet() async {
    try {
      final lookup = await InternetAddress.lookup('www.google.com');
      return lookup.isNotEmpty;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}

class BackUpLoader extends StatefulWidget {
  const BackUpLoader({super.key});

  @override
  State<BackUpLoader> createState() => _BackUpLoaderState();
}

class _BackUpLoaderState extends State<BackUpLoader> {
  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    await LocalTransaction()
        .syncTransactions(context: context)
        .whenComplete(() => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 400.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LinearProgressIndicator(),
              SizedBox(
                height: 10.0,
              ),
              Text('Uploading Your Transaction')
            ],
          ),
        ),
      ),
    );
  }
}

class CheckLocalTransactinBloc extends Bloc<bool, bool> {
  CheckLocalTransactinBloc() : super(false) {
    on<bool>((event, emit) => emit(event));
  }
}
