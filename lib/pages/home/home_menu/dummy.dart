import 'package:flutter/material.dart';

class Dummy extends StatelessWidget {
  const Dummy({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: Text("the dummy"))),
    );
  }
}
