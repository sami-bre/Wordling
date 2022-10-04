import 'package:flutter/material.dart';
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
      routes: {'/': (context) => const Front(),
      '/saved':(context) => SavedDefinitions(),
      },
    ),
  );
}
