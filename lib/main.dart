import 'package:flutter/material.dart';
import 'package:wordling/ui/study.dart';
import 'ui/front.dart';
import 'ui/saved_definitions.dart';
import 'package:get/get.dart';

var darkTheme = ThemeData.dark();

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wordling',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          // buttonTheme: ButtonThemeData(
          //   textTheme: ButtonTextTheme.primary,
          // ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 33, 98, 141),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                )),
          ),
          snackBarTheme: const SnackBarThemeData(
              contentTextStyle: TextStyle(color: Colors.white),
              backgroundColor: Colors.black54,
              behavior: SnackBarBehavior.fixed),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color.fromARGB(255, 38, 192, 212),
          ),
          sliderTheme: const SliderThemeData(
            thumbColor: Color.fromARGB(255, 38, 192, 212),
            activeTrackColor: Color.fromARGB(255, 38, 192, 212),
          )),
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            )),
          )),
      routes: {
        '/': (context) => const Front(),
        '/saved': (context) => const SavedDefinitions(),
        '/study': (context) => const Study(),
      },
    ),
  );
}
