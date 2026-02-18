import 'package:flutter/material.dart';
import 'services/vote_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const UrnaApp());
}

class UrnaApp extends StatelessWidget {
  const UrnaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final voteService = VoteService();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(voteService: voteService),
    );
  }
}
