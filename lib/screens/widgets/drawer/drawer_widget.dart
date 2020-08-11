
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/gp_Listview_model.dart';
import 'package:aosny_services/models/gp_dropdown_model.dart';
import 'package:flutter/material.dart';

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
                    child: Text("Test User",

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
                    onTap: () {
                      Navigator.pop(context);
                      widget.openHistory();
                    }
                ),
                new ListTile(
                  title: Text("My Progress"),
                  onTap: () {
                    Navigator.pop(context);
                    widget.openProgress();
                  },
                ),
                new ListTile(
                    title: Text("Enter Session Notes"),
                    onTap: () {
                      Navigator.pop(context);
                      widget.openEnterSession();
                    },
                ),
                new ListTile(
                    title: new Text("Notifications"),
                    onTap: () {
                      Navigator.pop(context);
                      widget.openNotification();
                    },
                    trailing:Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width/30,
                      height: MediaQuery.of(context).size.height/35,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                      ),
                      child:  Text("1",style: TextStyle(color:Colors.white),),
                    ),
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
                    image: AssetImage("assets/logo/ic_logo.png"),
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
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: GestureDetector(
                            onTap: widget.signOut,
                            child: Text(
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