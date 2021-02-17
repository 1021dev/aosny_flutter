import 'dart:async';

import 'package:aosny_services/screens/menu_screen.dart';
import 'package:aosny_services/screens/widgets/drawer/drawer_widget.dart';
import 'package:flutter/material.dart';

import '../../login_screen.dart';
import 'enter_session.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = '/notificaiton';

  final StreamController<bool> loadStudents;
  final StreamController<bool> loadCategories;
  NotificationScreen({this.loadStudents, this.loadCategories,});
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          "Notifications",
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      drawer: DrawerWidget(
        openEnterSession: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder:
                  (context)=> EnterSession(
                loadCategories: widget.loadCategories,
                loadStudents: widget.loadStudents,
              )
              )
          );
        },
        openNotification: () {
        },
        openHelp: () {

        },
        openHistory: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder:
                (context)=> MenuScreen(
              selectedIndex: 0,
            ),
            ),
          );
        },
        openProgress: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder:
                (context)=> MenuScreen(
              selectedIndex: 1,
            ),
            ),
          );
        },
        openSettings: () {

        },
        signOut: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                LoginScreen()),
          );
        },
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            ListTile(
//              leading: CircleAvatar(
//                radius: 30,
//                backgroundColor: Colors.yellow,
//              ),
              title: Text(
                "Please ensure progress reports are complete by Feb 15th 2020",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Today at 12:00 PM",
                style: TextStyle(fontSize: 11),
              ),
            ),
            Divider(
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
