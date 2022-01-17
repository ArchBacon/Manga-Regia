import 'package:flutter/material.dart';

class FadingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FadingAppBar({Key? key,
    required this.child,
    required this.controller,
    required this.visible,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final bool visible;

  @override
  Size get preferredSize => const Size(double.maxFinite, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    visible ? controller.forward() : controller.reverse();
    return IgnorePointer(
      ignoring: !visible,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ),
        child: child,
      ),
    );
  }
}
