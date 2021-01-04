import 'package:aosny_services/screens/widgets/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:new_version/new_version.dart';

import 'bloc/AosnyBlocDelegate.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AosnyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AOSNY Services',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blue,
      ),
      home: SplashScreenPage(),
    );
  }
}
