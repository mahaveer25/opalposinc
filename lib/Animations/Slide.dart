import 'package:flutter/material.dart';

class SlideUp extends StatefulWidget {
  final Widget child;
  final String type;
  const SlideUp({super.key, required this.child, required this.type});

  @override
  State<SlideUp> createState() => _SlideUpState();
}

class _SlideUpState extends State<SlideUp> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<Offset> slideAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    final isRight = widget.type == 'right';

    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: isRight ? 300 : 200))
      ..forward();

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);

    slideAnimation = Tween<Offset>(
            begin: isRight ? const Offset(-1.0, 0.0) : const Offset(0, 1.0),
            end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: widget.child,
      ),
    );
  }
}
