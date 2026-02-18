import 'package:flutter/material.dart';
import 'ui/screens/ride_pref/ride_pref_screen.dart';
// import 'ui/screens/ride_pref/bla_button_test_screen.dart';
import 'ui/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: Scaffold(
        body: RidePrefScreen(),
        // body: BlaButtonTestScreen(),
        ),
    );
  }
}
