import 'package:flutter/material.dart';
import 'MyHomePage.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color.fromRGBO(27, 27, 27, 1.0),
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
            fontFamily: 'Poppins'),
      ),
      home: const MyHomePage(title: 'ShopChain Mobile'),
    );
  }
}

