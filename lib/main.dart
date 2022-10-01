import 'package:flutter/material.dart';
import 'ui/front.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      routes: {'/': (context) => const Front()},
    ),
  );
}
