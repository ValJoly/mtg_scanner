import 'package:flutter/material.dart';
import 'package:mtg_scanner/pages/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const Home(),
    ),
  );
}
