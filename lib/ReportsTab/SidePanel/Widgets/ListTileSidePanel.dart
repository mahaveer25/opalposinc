import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/decorations.dart';
import '../../../widgets/common/Top Section/Bloc/CustomBloc.dart';

class ListTileSidePanel extends StatelessWidget {
  final String title;
  final bool? selected;
  final Function()? onTap;
  final Widget? leading;
  const ListTileSidePanel({
    super.key,
    required this.title,
    this.selected,
    this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceInOut,
        decoration: selected ?? false
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: const LinearGradient(
                    colors: [Colors.blueAccent, Colors.deepPurpleAccent]))
            : const BoxDecoration(color: Colors.transparent),
        child: ListTile(
          shape: Decorations.boxShape,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          dense: true,
          onTap: onTap ??
              () {
                ChangeCategoryBloc categoryBloc =
                    BlocProvider.of<ChangeCategoryBloc>(context);
                categoryBloc.add(title);
              },
          leading: leading ??
              Icon(
                Icons.arrow_right_alt,
                color: selected ?? false ? Colors.white : Colors.black,
              ),
          title: Text(
            title,
            style: selected ?? false
                ? Decorations.body.copyWith(color: Colors.white)
                : Decorations.body,
          ),
        ));
  }
}
