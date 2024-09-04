import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget {
  const AppbarWidget(
      {super.key,
      required this.title,
      this.icon,
      this.iconButton,
      required this.backgroundColor,
      this.fontWeight});

  final String title;
  final Icon? icon;
  final IconButton? iconButton;
  final Color backgroundColor;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        actions: [if (iconButton != null) iconButton!],
        backgroundColor: backgroundColor,
        title: Center(
          child: Text(
            title,
            style: TextStyle(
                fontSize: 28, fontWeight: fontWeight, color: Colors.white),
          ),
        ));
  }
}
