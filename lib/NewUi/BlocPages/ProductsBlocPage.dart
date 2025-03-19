import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalsystem/NewUi/BlocPages/EmptyPage.dart';
import 'package:opalsystem/pages/home_page.dart';
import 'package:opalsystem/widgets/common/Top%20Section/Bloc/ProductBloc.dart';

class ProductsBlocPage extends StatefulWidget {
  const ProductsBlocPage({super.key});

  @override
  State<ProductsBlocPage> createState() => _ProductsBlocPageState();
}

class _ProductsBlocPageState extends State<ProductsBlocPage> {
  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
      if (state is ProductLoadingState) {
        return const EmptyPage(message: 'Getting Products');
      }

      if (state is ProductLoadedState) {
        return const HomePage();
      }

      return Container();
    });
  }
}
