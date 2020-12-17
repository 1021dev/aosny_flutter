
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'drawer/drawer_widget.dart';

class PlannedScheduleScreen extends StatefulWidget {
  @override
  _PlannedScheduleScreenState createState() => new _PlannedScheduleScreenState();
}

class _PlannedScheduleScreenState extends State<PlannedScheduleScreen> {

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Planned Schedule'),
      ),
      drawer: DrawerWidget(),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(24),
          ),
        ),
      ),
    );
  }
}