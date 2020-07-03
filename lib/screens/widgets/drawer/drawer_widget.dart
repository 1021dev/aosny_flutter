import 'dart:async';

import 'package:aosny_services/api/session_api.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/gp_Listview_model.dart';
import 'package:aosny_services/models/gp_dropdown_model.dart';
import 'package:aosny_services/screens/login_screen.dart';
import 'package:aosny_services/screens/menu_screen.dart';
import 'package:aosny_services/screens/widgets/drawer/enter_session.dart';
import 'package:aosny_services/screens/widgets/drawer/notification_screen.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  final StreamController<bool> loadStudents;
  final StreamController<bool> loadCategories;
  final StreamController<int> tabIndex;
  final String currentRoute;
  final int currentIndex;
  DrawerWidget({
    this.loadCategories,
    this.loadStudents,
    this.currentRoute = '',
    this.currentIndex = 0,
    this.tabIndex,
  });
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  SessionApi _sessionApi = new SessionApi();
  GlobalCall globalCall =  new GlobalCall();

  List<LongTermGpDropDownModel> longTermGpDropDownList = new List();
  List<ShortTermGpModel> shortTermGpList = new List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[400],
                  ),
                  accountName: Container(
                    height: 20,
                    child:Text("Test User",

                      style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.normal),
                      //style: Theme.of(context).textTheme.headline
                    ), ),
                  accountEmail: Text(GlobalCall.email,
                      style: TextStyle(fontSize: 13,color: Colors.white)
                    // Theme.of(context).textTheme.subhead Tex
                  ),
                  currentAccountPicture: Icon(Icons.person,
                    size: 90.0,
                    color: Colors.white,

                  ),
                ),

                new ListTile(
                    title: Text("My Sessions"),
                    onTap:  () {
                      print(GlobalCall.isHistoryOrProgress);
                      if (widget.currentRoute == 'session') {
                        widget.tabIndex.sink.add(0);
                        Navigator.pop(context);
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context)=> MenuScreen(
                              selectedIndex: 0,
                            ),
                          ),
                        );
                      }
                    }

                ),

                new ListTile(
                  title: Text("My Progress"),
                  onTap: () {
                    if (widget.currentRoute == 'session') {
                      widget.tabIndex.sink.add(1);
                      Navigator.pop(context);
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context)=> MenuScreen(
                            selectedIndex: 1,
                          ),
                        ),
                      );
                    }
                  },
                ),


                new ListTile(
                    title: Text("Enter Session Notes"),
                    onTap: () {
                      if (widget.currentRoute == 'enterSession') {
                        Navigator.pop(context);
                      } else {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder:
                                (context)=> EnterSession(
                              loadCategories: widget.loadCategories,
                              loadStudents: widget.loadStudents,
                            )));
                      }

                    }
                ),

                new ListTile(
                    title: new Text("Notifications"),
                    onTap: (){
                      if (widget.currentRoute == 'notification') {
                        Navigator.pop(context);
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context)=> NotificationScreen(
                              loadCategories: widget.loadCategories,
                              loadStudents: widget.loadStudents,
                            ),
                          ),
                        );
                      }
                    },
                    trailing:Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width/30,
                      height: MediaQuery.of(context).size.height/35,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child:  Text("1",style: TextStyle(color:Colors.white),),
                    )

                ),
                new ListTile(
                  title: new Text("Settings"),
                  onTap: (){

                  },
                ),
                new ListTile(
                  title: new Text("Help"),
                  onTap: (){
                  },


                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height/7,
            width:  MediaQuery.of(context).size.width/2.5,
            decoration:BoxDecoration(
              // color: Colors.red,
                image: DecorationImage(
                    image: AssetImage("assets/logo/auditory_logo.png"),
                    fit: BoxFit.contain
                )
            ),
          ),
          Container(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    height: 100,
                    child: Center(
                      child:Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.indigo[800],
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child:GestureDetector(
                            onTap: (){

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    LoginScreen()),
                              );
                            },
                            child:Text(
                                "Sign Out",
                                style: TextStyle(color: Colors.white),
                            ),
                        ),
                      ),
                    ),
                  ),
              ),
          ),
        ],
      ),
    );
  }
}