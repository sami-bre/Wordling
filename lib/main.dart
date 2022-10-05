import 'package:flutter/material.dart';
import 'package:wordling/ui/study.dart';
import 'ui/front.dart';
import 'ui/saved_definitions.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wordling',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      routes: {
        '/': (context) => const Front(),
        '/saved': (context) => const SavedDefinitions(),
        '/study': (context) => const Study(),
      },
    ),
  );
}
