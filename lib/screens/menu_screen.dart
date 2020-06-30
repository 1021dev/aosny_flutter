
import 'package:aosny_services/api/student_api.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/gp_Listview_model.dart';
import 'package:aosny_services/models/gp_dropdown_model.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:aosny_services/screens/widgets/drawer/drawer_widget.dart';
import 'package:aosny_services/screens/widgets/history_screen.dart';
import 'package:aosny_services/screens/widgets/progress_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert' show json, base64, ascii;

import 'package:shared_preferences/shared_preferences.dart';


class MenuScreen extends StatefulWidget {

  
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {


  List<StudentsDetailsModel> studentList = new List();
  StudentApi studentapiCall = new StudentApi();

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body:DrawerWidget() ,
      
    );
  }

  @override
  void initState() {


            getDatafromToken();
            callStudentApi();
          super.initState();
        }

      
      
        void callStudentApi() async {
  
       studentList = await studentapiCall.getAllStudentsList();
  
      GlobalCall.globaleStudentList = studentList;
  
        }
  
    void getDatafromToken() async {

       SharedPreferences prefs = await SharedPreferences.getInstance();
  
            String token = prefs.getString('token');
  
    
  
             var jwt = token.split(".");
  
  
  
                var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
  
                
  
                 GlobalCall.email =  payload['Email'];
  
                 if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                  //return HomePage(str, payload);
                } else {
                  //return LoginPage();
                }






    }




}



class MainTopTabBar extends StatefulWidget {

  

  final List<LongTermGpDropDownModel> longTermGpDropDownList ;
  final  List<ShortTermGpModel> shortTermGpList;

  

  const MainTopTabBar({Key key, this.longTermGpDropDownList, this.shortTermGpList}) : super(key: key);
  @override
  _MainTopTabBarState createState() => _MainTopTabBarState();
}

class _MainTopTabBarState extends State<MainTopTabBar> with SingleTickerProviderStateMixin{

    
  AnimationController _animationController;
  bool isBackArrow = false;
  

  @override
  void initState() {
    super.initState();

   
        _animationController = AnimationController(vsync: this, 
          duration: Duration(milliseconds: 300)
        );
      }
    
      @override
      void dispose() {
        super.dispose();
       // _animationController.dispose();
      }
      @override
      Widget build(BuildContext context) {
       return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue[200],
            title: Text("My Sessions",style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal),),
            leading: IconButton(
              iconSize: 30,
              icon: AnimatedIcon(
                icon: AnimatedIcons.arrow_menu,
                progress: _animationController,
              ),
              onPressed: () => _handleOnPressed(),
            ),
            centerTitle: true,
          ),
          // drawer: DrawerWidget(),
          body: TopNavigationScrollBar(
                  longTermGpDropDownList: widget.longTermGpDropDownList,
                  shortTermGpList: widget.shortTermGpList,
                ) ,
               
                
              );
            }
            void _handleOnPressed() {
              setState(() {
               // isBackArrow = !isBackArrow;
               // isBackArrow
                  //  ? _animationController.forward()
                   // :
                      Navigator.of(context).pop();
                    //  Navigator.of(context).pop(_createRoute());
                    
              });
            }
    
     

 
 
      
      
    /*    _onHorizontalDrag(DragEndDetails details) {
            if(details.primaryVelocity == 0) return; // user have just tapped on screen (no dragging)

          if (details.primaryVelocity.compareTo(0) == -1)
            print('dragged from left');
          else 
            print('dragged from right');


        }*/
}






class TopNavigationScrollBar extends StatefulWidget {
  final List<LongTermGpDropDownModel> longTermGpDropDownList ;
  final  List<ShortTermGpModel> shortTermGpList;

  const TopNavigationScrollBar({Key key, this.longTermGpDropDownList, this.shortTermGpList}) : super(key: key);

  @override
  _TopNavigationScrollBarState createState() => _TopNavigationScrollBarState();
}

class _TopNavigationScrollBarState extends State<TopNavigationScrollBar> with SingleTickerProviderStateMixin  {
  int tabIndex = 0;
 

  
  @override
  void initState() {
    super.initState();
print('GlobalCall().isHistoryOrProgress');
    print(GlobalCall.isHistoryOrProgress);
    
  }

  @override
  void dispose() {
   
    super.dispose();
     

  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar:
        PreferredSize(
          
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: 
          Container(
            decoration: BoxDecoration(
              //border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            height: 50.0,
            child:  new TabBar(
              
             
                            indicatorColor: Colors.lightBlue,
                            unselectedLabelColor: Colors.black,
                            labelColor: Colors.black,
                            tabs: [
                              
                              Tab(
                                text: "History",
                                
              
                                
                              
                              ),
              
              
                            
              
                              Tab(
                                text: "Progress",
                               
                              ),
                             
                            ],
                          ),
                        ),
                      ),
                      body: TabBarView(
              
                        
              
              
                        children: [
              
                          
              
                           HistoryScreen(
                           longTermGpDropDownList: widget.longTermGpDropDownList,
                            shortTermGpList: widget.shortTermGpList,
                          ),
              
                          ProgressScreen(),
              
              
                         
                            
              
                          
              
              
              
              
                          
                         
                        ],
                           
              
                        
                      ),
                    ),
                  );
                }
              
          


}

