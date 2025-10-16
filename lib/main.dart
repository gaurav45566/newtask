import 'package:flutter/material.dart';
import 'package:newsd/homscreen/mainscreenview.dart';

void main() {
  runApp(const VisitingCardApp());
}

class VisitingCardApp extends StatelessWidget {
  const VisitingCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Visiting Card Scanner',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
