import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/localDatabase/Transaction/Pages/TransactionsPage.dart';

class DatabaseTypeBloc extends Bloc<String?, String?> {
  DatabaseTypeBloc() : super(null) {
    on<String>((event, emit) => emit(event));
  }
}

class DatabaseTypeSelected extends StatelessWidget {
  const DatabaseTypeSelected({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseTypeBloc, String?>(builder: ((context, state) {
      if (state == 'Transactions') return const TransactionsPage();

      // if (state == 'Invoices') return const LocalInvoicesPage();

      return const Center(
        child: Text('Please Select A Type'),
      );
    }));
  }
}
