import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opalposinc/FetchingApis/FetchApis.dart';
import 'package:opalposinc/model/location.dart';
import '../../model/category.dart';
import '../../widgets/common/Top Section/Bloc/CustomBloc.dart';

import 'BrandsBlocPage.dart';
import 'EmptyPage.dart';

class CategoryBlocPage extends StatefulWidget {
  final Location location;
  const CategoryBlocPage({super.key, required this.location});

  @override
  State<StatefulWidget> createState() => _CategoryBlocPage();
}

class _CategoryBlocPage extends State<CategoryBlocPage> {
  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    await FetchApis(context).fetchCategories();
    await FetchApis(context).fetchTaxes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, Category?>(builder: (context, category) {
      if (category == null) {
        return const EmptyPage(message: 'Getting Categories');
      }

      return BrandBlocPage(
        location: widget.location,
        category: category,
      );
    });
  }
}
