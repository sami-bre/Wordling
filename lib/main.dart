import 'package:flutter/material.dart';
import 'util/dbhelper.dart';
import 'ui/front.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
    ),
    routes: {'/': (context) => const Front()},
  ));
}
