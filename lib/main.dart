import 'package:flutter/material.dart';
import 'HomeScreen.dart';

ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.white,
  primary: Colors.blue,
  minimumSize: const Size(100, 40),
  padding: const EdgeInsets.symmetric(horizontal: 20),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Stock Analysis App',
    home: HomeScreen(),
  ));
}


