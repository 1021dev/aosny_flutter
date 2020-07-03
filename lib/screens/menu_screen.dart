
import 'dart:async';

import 'package:aosny_services/api/preload_api.dart';
import 'package:aosny_services/api/student_api.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:aosny_services/screens/widgets/drawer/drawer_widget.dart';
import 'package:aosny_services/screens/widgets/history_screen.dart';
import 'package:aosny_services/screens/widgets/progress_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert' show json, base64, ascii;

import 'package:shared_preferences/shared_preferences.dart';


class MenuScreen extends StatefulWidget {
  static const String routeName = '/main';
  final int selectedIndex;
  MenuScreen({this.selectedIndex = 0});
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<StudentsDetailsModel> studentList = new List();
  StudentApi studentapiCall = new StudentApi();
  StreamController<bool> eventCategoryList = StreamController<bool>.broadcast();
  StreamController<bool> eventStudents = StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: MainTopTabBar(
        loadCategories: eventCategoryList,
        loadStudents: eventStudents,
        selectedIndex: widget.selectedIndex,
      ),
    );
  }
  @override
  void dispose() {
    eventStudents.close();
    eventCategoryList.close();
    super.dispose();
  }

  @override
  void initState() {
    getDatafromToken();
    callStudentApi();
    callCategory();
    super.initState();
  }

  void callCategory() async {
    if (GlobalCall.socialPragmatics.categoryData.length == 0) {
      bool isLoad = await PreLoadApi().fetchPreLoad();
      if (isLoad) {
        eventCategoryList.sink.add(true);
      }
    } else {
      eventCategoryList.sink.add(true);
    }
  }

  void callStudentApi() async {
    studentList = await studentapiCall.getAllStudentsList();
    GlobalCall.globaleStudentList = studentList;
    eventStudents.sink.add(true);
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

  final StreamController<bool> loadStudents;
  final StreamController<bool> loadCategories;

  final int selectedIndex;
  const MainTopTabBar({
    Key key,
    this.loadStudents,
    this.loadCategories,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  _MainTopTabBarState createState() => _MainTopTabBarState();
}

class _MainTopTabBarState extends State<MainTopTabBar> with SingleTickerProviderStateMixin{
  bool isBackArrow = false;
  bool isStudents = false;
  bool isCategories = false;
  StreamController<int> tabIndnex = StreamController<int>.broadcast();
  int selectedIndex = 0;
  TabController tabController;
  int tabIndex = 0;

  _handleTabSelection() {
    setState(() {
      tabIndex = tabController.index;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
    tabController = TabController(vsync: this, length: 2, initialIndex: selectedIndex);
    tabIndnex.stream.listen((event) {
      setState(() {
        print(event);
        selectedIndex = event;
        tabController.animateTo(selectedIndex);
      });
    });

    print('GlobalCall().isHistoryOrProgress');
    print(GlobalCall.isHistoryOrProgress);
    tabController.addListener(_handleTabSelection);

  }

  @override
  void dispose() {
    tabIndnex.close();
    tabController.dispose();
    super.dispose();
    // _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        title: Text("My Sessions",style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),),
        centerTitle: true,
      ),
      drawer: DrawerWidget(
        currentIndex: selectedIndex,
        loadStudents: widget.loadStudents,
        loadCategories: widget.loadCategories,
        currentRoute: 'session',
        tabIndex: tabIndnex,
      ),
      body: DefaultTabController(
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
              child: new TabBar(
                indicatorColor: Colors.lightBlue,
                unselectedLabelColor: Colors.black,
                labelColor: Colors.black,
                controller: tabController,
                onTap: (index) {
                  setState(() {
                    tabIndex = index;
                  });
                },
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
            controller: tabController,
            children: [
              HistoryScreen(
                loadStudents: widget.loadStudents,
                loadCategoires: widget.loadCategories,
              ),
              ProgressScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
