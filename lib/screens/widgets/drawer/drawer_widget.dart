
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/gp_Listview_model.dart';
import 'package:aosny_services/models/gp_dropdown_model.dart';
import 'package:aosny_services/screens/change_password_screen.dart';
import 'package:aosny_services/screens/widgets/drawer/enter_session.dart';
import 'package:aosny_services/screens/widgets/drawer/notification_screen.dart';
import 'package:aosny_services/screens/widgets/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../menu_screen.dart';
import '../planned_schedule_screen.dart';

class DrawerWidget extends StatefulWidget {
  final Function openHistory;
  final Function openProgress;
  final Function openEnterSession;
  final Function openNotification;
  final Function openSettings;
  final Function openHelp;
  final Function signOut;

  DrawerWidget({
    this.openHistory,
    this.openProgress,
    this.openEnterSession,
    this.openNotification,
    this.openSettings,
    this.openHelp,
    this.signOut,
  });
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  GlobalCall globalCall =  new GlobalCall();

  List<LongTermGpDropDownModel> longTermGpDropDownList = new List();
  List<ShortTermGpModel> shortTermGpList = new List();
  SharedPreferences preferences;
  String buildNumber = '';
  String versionNumber = '';
  @override

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        preferences = value;
      });
    });

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      setState(() {
        versionNumber = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
      print(versionNumber);
    });


  }

  @override
  Widget build(BuildContext context) {
    if (preferences != null) {
      String userName = preferences.getString('userName') ?? '';
      String firstName = preferences.getString('firstName') ?? '';
      String lastName = preferences.getString('lastName') ?? '';
      String email = preferences.getString('email') ?? '';
      GlobalCall.fullName = '$firstName $lastName';
      GlobalCall.name = userName;
      GlobalCall.email = email;
    }
    return Drawer(
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: SafeArea(
          bottom: true,
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                        ),
                        accountName: Container(
                          child: Text(
                            GlobalCall.fullName != '' ? GlobalCall.fullName ?? '' : '',
                            style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.normal),
                          ),
                        ),
                        accountEmail: Text(
                            GlobalCall.singUpEmil != '' ? GlobalCall.singUpEmil: GlobalCall.email ?? '',
                            style: TextStyle(fontSize: 13,color: Colors.white)
                          // Theme.of(context).textTheme.subhead Tex
                        ),
                        currentAccountPicture: Icon(Icons.person,
                          size: 90.0,
                          color: Colors.white,
                        ),
                      ),
                      new ListTile(
                          title: Text('My Sessions'),
                          dense: true,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder:
                                  (context)=> MenuScreen(
                                selectedIndex: 0,
                              ),
                              ),
                            );
                          }
                      ),
                      new ListTile(
                        title: Text('My Progress'),
                        dense: true,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder:
                                (context)=> MenuScreen(
                              selectedIndex: 1,
                            ),
                            ),
                          );
                        },
                      ),
                      new ListTile(
                        title: Text('Enter Session Notes'),
                        dense: true,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context)=> EnterSession(),
                            ),
                          );
                        },
                      ),
                      new ListTile(
                        title: new Text('Change Password'),
                        dense: true,
                        onTap: (){
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context)=> ChangePasswordScreen(),
                            ),
                          );
                        },
                      ),
                      new ListTile(
                        title: new Text('Planned Schedule'),
                        dense: true,
                        onTap: (){
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context)=> PlannedScheduleScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height/7,
                  width:  MediaQuery.of(context).size.width/2.5,
                  decoration:BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo/ic_logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'App version: $versionNumber($buildNumber)',
                  ),
                ),
                Container(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: GestureDetector(
                        onTap: () async {
                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          preferences.setString('token', '');
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context)=> SplashScreenPage(),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Sign Out',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}