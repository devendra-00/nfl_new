import 'package:flutter/material.dart';
import 'package:nfl_new/functionalities/computercomplaint/computer_complaint.dart';
import 'package:nfl_new/splash_nfl_logo.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Varela',             // <-- 1
        textTheme: Theme.of(context)
            .textTheme
            .apply(fontFamily: 'Varela'),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black,),
        useMaterial3: true,
      ),
      home: SplashNFL(),
    );
  }
}
