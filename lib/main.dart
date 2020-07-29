
import 'package:aosny_services/bloc/AosnyBlocDelegate.dart';
import 'package:aosny_services/screens/widgets/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  Bloc.observer = AosnyBlocObserver();
  runApp(MyApp());
}


//final storage = FlutterSecureStorage();

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AOSNY Services',
      theme: ThemeData(
        primarySwatch: Colors.blue//,
        //primaryColor: Colors.indigo[200]
      ),
      home:  SplashScreenPage(),
    );
  }
}
