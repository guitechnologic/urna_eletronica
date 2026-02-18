import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(UrnaApp());
}

class UrnaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Urna Eletrônica',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
