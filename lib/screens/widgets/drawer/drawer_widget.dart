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
    getLongTermGpDropDownList();
    getShortTermGpList();
  }



  getLongTermGpDropDownList()async{
    longTermGpDropDownList = await _sessionApi.getLongTermGpDropDownList();
  }
  
  getShortTermGpList()async{
    shortTermGpList = await _sessionApi.getShortTermGpList();
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
                      color: Colors.blueGrey,
                  ),
                  accountName: Container(
                  height: 20,
                  child:Text("Bryndle B. Selmar",
                  
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
                      

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context)=> MainTopTabBar(
                        longTermGpDropDownList: longTermGpDropDownList,
                        shortTermGpList: shortTermGpList,

                      ))


                  );
                  }   
                 
                ),
               
                new ListTile(
                  title: Text("My Progress"),
                  onTap: () {

                   


                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context)=>MainTopTabBar(
                        longTermGpDropDownList: longTermGpDropDownList,
                        shortTermGpList: shortTermGpList,
                      ))
                    );
                  },   
                ),
               
        
                new ListTile(
                  title: Text("Enter Session Notes"),
                  onTap: () {
                  
                    Navigator.of(context).push(MaterialPageRoute(builder: 
                    (context)=>EnterSession(
                      longTermGpDropDownList: longTermGpDropDownList,
                      shortTermGpList: shortTermGpList,
                    )));
                  }
                ),
               
                new ListTile(
                  title: new Text("Notifications"),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context)=> NotificationScreen())
                    );
                  },
                  trailing:Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width/30,
                    height: MediaQuery.of(context).size.height/35,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
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
                      color: Colors.blueGrey,
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
                      child:Text("Sign Out",
                      style: TextStyle(color: Colors.white))
                    ),
                  ),
                ),
              )
            )
          )
        ],
      ),
    );
  }
}