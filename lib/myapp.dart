import 'package:flutter/material.dart';

import 'HomeScreen.dart';
import 'firebase_student.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Firebase_StudentApp(),
    );
  }
}
