import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final Widget child;

  const CommonScaffold({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: child,
    ));
  }
}
