import 'package:flutter/material.dart';

class RUCheckAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String title;
  final List<Widget>? actions;

  const RUCheckAppBar({
    Key? key,
    this.leading,
    required this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: AppBar(
        toolbarHeight: 100,
        leading: leading,
        foregroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(fontSize: 36),
        ),
        actions: actions,
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
