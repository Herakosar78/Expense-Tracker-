import 'package:flutter/material.dart';
import 'package:expense_tracker/home_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Expense Tracker",
      home: HomeScreen(), // You'll need to define the HomeScreen widget
    );
  }
}