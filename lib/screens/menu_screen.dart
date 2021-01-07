
import 'dart:async';

import 'package:aosny_services/api/student_api.dart';
import 'package:aosny_services/bloc/bloc.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:aosny_services/screens/widgets/add_edit_session_note.dart';
import 'package:aosny_services/screens/widgets/drawer/drawer_widget.dart';
import 'package:aosny_services/screens/widgets/drawer/notification_screen.dart';
import 'package:aosny_services/screens/widgets/history_screen.dart';
import 'package:aosny_services/screens/widgets/progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_version/new_version.dart';

import 'login_screen.dart';
import 'widgets/drawer/enter_session.dart';



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

  MainScreenBloc mainScreenBloc;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: mainScreenBloc,
      listener: (BuildContext context, MainScreenState state) async {
        if (state is MainScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>
                LoginScreen()),
          );
        }
      },
      child: BlocBuilder<MainScreenBloc, MainScreenState>(
        cubit: mainScreenBloc,
        builder: (BuildContext context, MainScreenState state) {
          return Scaffold(
            backgroundColor: Colors.grey[300],
            body: MainTopTabBar(
              mainScreenBloc: mainScreenBloc,
              loadCategories: eventCategoryList,
              loadStudents: eventStudents,
              selectedIndex: widget.selectedIndex,
            ),
          );
        },
      ),
    );
  }
  @override
  void dispose() {
    eventStudents.close();
    eventCategoryList.close();
    mainScreenBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    mainScreenBloc = MainScreenBloc(MainScreenState(isLoading: true));
    mainScreenBloc.add(MainScreenInitialEvent());
    if (GlobalCall.openUpdate) {
      final newVersion = NewVersion(context: context);
      print(newVersion.iOSId);
      print(newVersion.androidId);
      newVersion.getVersionStatus().then((status) {
        print(status.canUpdate);
        print(status.localVersion);
        print(status.storeVersion);
        print(status.appStoreLink);

        GlobalCall.openUpdate = false;
        newVersion.showAlertIfNecessary();
      });
    }

    super.initState();
  }
}

class MainTopTabBar extends StatefulWidget {

  final StreamController<bool> loadStudents;
  final StreamController<bool> loadCategories;
  final MainScreenBloc mainScreenBloc;

  final int selectedIndex;
  const MainTopTabBar({
    Key key,
    this.loadStudents,
    this.loadCategories,
    this.selectedIndex = 0,
    this.mainScreenBloc,
  }) : super(key: key);

  @override
  _MainTopTabBarState createState() => _MainTopTabBarState();
}

class _MainTopTabBarState extends State<MainTopTabBar> with SingleTickerProviderStateMixin{
  bool isBackArrow = false;
  bool isStudents = false;
  bool isCategories = false;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  StreamController<int> tabIndnex = StreamController<int>.broadcast();
  int selectedIndex = 0;
  TabController tabController;
  int tabIndex = 0;
  List<OverflowMenuItem> appBarPopupActions(
      BuildContext context) {
    return [
      OverflowMenuItem(
        title: 'Dates',
        onTap: () {
          setState(() {
            GlobalCall.filterDates = !GlobalCall.filterDates;
          });
          widget.mainScreenBloc.add(UpdateSortFilterEvent());
          widget.mainScreenBloc.add(UpdateFilterProgressEvent());
        },
      ),
      OverflowMenuItem(
        title: 'Students',
        onTap: () {
          setState(() {
            GlobalCall.filterStudents = !GlobalCall.filterStudents;
            GlobalCall.student = GlobalCall.filterStudents ? '${GlobalCall.globaleStudentList.first.firstName} ${GlobalCall.globaleStudentList.first.lastName}': '';
            print(GlobalCall.student);
          });
          widget.mainScreenBloc.add(UpdateSortFilterEvent());
          widget.mainScreenBloc.add(UpdateFilterProgressEvent());
        },
      ),
      OverflowMenuItem(
        title: 'Session Types',
        onTap: () {
          setState(() {
            GlobalCall.filterSessionTypes = !GlobalCall.filterSessionTypes;
            GlobalCall.sessionType = GlobalCall.filterSessionTypes ? sessionTypeStrings[0]: '';
          });
          widget.mainScreenBloc.add(UpdateSortFilterEvent());
          widget.mainScreenBloc.add(UpdateFilterProgressEvent());
        },
      ),
    ];
  }

  _handleTabSelection() {
    setState(() {
      tabIndex = tabController.index;
    });
    // if (tabIndex == 0) {
    //   String startDate = DateFormat('MM/dd/yyyy').format(GlobalCall.startDate).toString();
    //   String endDate = DateFormat('MM/dd/yyyy').format(GlobalCall.endDate).toString();
    //   widget.mainScreenBloc.add(GetHistoryEvent(startDate: startDate, endDate: endDate));
    // } else {
    //   String startDate = DateFormat('MM/dd/yyyy').format(GlobalCall.proStartDate).toString();
    //   String endDate = DateFormat('MM/dd/yyyy').format(GlobalCall.proEndDate).toString();
    //   widget.mainScreenBloc.add(GetProgressEvent(startDate: startDate, endDate: endDate));
    // }
  }

  _onLayoutDone(_) {
    //your logic here
    if (GlobalCall.openDrawer) {
      GlobalCall.openDrawer = false;
      _drawerKey.currentState.openDrawer();
    }
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
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);

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
    return BlocListener(
      cubit: widget.mainScreenBloc,
      listener: (BuildContext context, MainScreenState state) async {
      },
      child: BlocBuilder<MainScreenBloc, MainScreenState>(
        cubit: widget.mainScreenBloc,
        builder: (BuildContext context, MainScreenState state) {

          return Scaffold(
            key: _drawerKey,
            appBar: AppBar(
              backgroundColor: Colors.lightBlue,
              title: Text("My Sessions",style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),),
              centerTitle: true,
              actions: <Widget>[
                PopupMenuButton<OverflowMenuItem>(
                  icon: Icon(Icons.filter_list),
                  offset: Offset(0, 100),
                  onSelected: (OverflowMenuItem item) => item.onTap(),
                  itemBuilder: (BuildContext context) {
                    return appBarPopupActions(context)
                        .map((OverflowMenuItem item) {
                      bool isChecked = false;
                      if (item.title == 'Dates') {
                        isChecked = GlobalCall.filterDates;
                      } else if (item.title == 'Students') {
                        isChecked = GlobalCall.filterStudents;
                      } else if (item.title == 'Session Types') {
                        isChecked = GlobalCall.filterSessionTypes;
                      }
                      return PopupMenuItem<OverflowMenuItem>(
                        value: item,
                        child: Row(
                          children: <Widget>[
                            isChecked ? Icon(Icons.check, color: Colors.blue,) : Icon(Icons.check, color: Colors.transparent,),
                            Text(
                              item.title,
                              style: TextStyle(color: item.textColor),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                ),
              ],
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context)=> NotificationScreen(
                      loadCategories: widget.loadCategories,
                      loadStudents: widget.loadStudents,
                    ),
                  ),
                );
              },
              openHelp: () {

              },
              openHistory: () {
                tabIndnex.sink.add(0);
              },
              openProgress: () {
                tabIndnex.sink.add(1);
              },
              openSettings: () {

              },
              signOut: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      LoginScreen()),
                );
              },
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
                      mainScreenBloc: widget.mainScreenBloc,
                      loadStudents: widget.loadStudents,
                      loadCategoires: widget.loadCategories,
                    ),
                    ProgressScreen(
                      mainScreenBloc: widget.mainScreenBloc,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

  }
}

class OverflowMenuItem {
  final String title;
  final Color textColor;
  final VoidCallback onTap;

  OverflowMenuItem({
    this.title,
    this.textColor = Colors.black,
    this.onTap,
  });
}
