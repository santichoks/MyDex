import 'package:flutter/material.dart';
import 'package:my_dex/screens/home_screen.dart';

void main() {
  runApp(MyDex());
}

class MyDex extends StatelessWidget {
  const MyDex({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}
