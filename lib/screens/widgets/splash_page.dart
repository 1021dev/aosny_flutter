import 'package:aosny_services/api/login_token_api.dart';
import 'package:aosny_services/api/preload_api.dart';
import 'package:aosny_services/screens/login_screen.dart';
import 'package:aosny_services/screens/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';


class SplashScreenPage extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<SplashScreenPage> {
  LoginApi loginapiCall = new LoginApi();
  String token = '';

  @override
  void initState() {
    PreLoadApi().fetchPreLoad();
    SharedPreferences.getInstance().then((pref) {
      String token = pref.getString('token') ?? '';
      setState(() {
        this.token = token;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(750, 1334), allowFontScaling: false);
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: token != '' ? new MenuScreen(): new LoginScreen(),
      //title: new Text('Welcome In SplashScreen'),
      image: new Image.asset('assets/logo/ic_logo.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: MediaQuery.of(context).size.width * 0.5,
      loaderColor: Colors.blue,
    );
  }
}