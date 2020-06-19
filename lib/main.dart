
import 'package:aosny_services/screens/widgets/splash_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());


//final storage = FlutterSecureStorage();

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AOSNY Services',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  SplashScreenPage(),
    );
  }
}
