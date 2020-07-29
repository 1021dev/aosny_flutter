import 'package:aosny_services/api/login_token_api.dart';
import 'package:aosny_services/api/preload_api.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/screens/login_screen.dart';
import 'package:aosny_services/screens/menu_screen.dart';
import 'package:flutter/material.dart';
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
    PreLoadApi().getPreLoadData('SocialPragmatics');
    PreLoadApi().getPreLoadData('Outcomes');
    PreLoadApi().getPreLoadData('SEITIntervention');
    PreLoadApi().getPreLoadData('CompletedActivity');
    PreLoadApi().getPreLoadData('JointAttention');
    PreLoadApi().getPreLoadData('Activities');
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


