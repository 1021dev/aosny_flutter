import 'dart:async';

import 'package:aosny_services/screens/widgets/drawer/drawer_widget.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: Colors.lightBlue[200],
        title: Text(
          "Notifications",
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),
      drawer: DrawerWidget(
        currentRoute: 'notification',
        loadCategories: widget.loadCategories,
        loadStudents: widget.loadStudents,
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