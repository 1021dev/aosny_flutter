import 'package:aosny_services/bloc/session_note/session_note.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/add_session_response.dart';
import 'package:aosny_services/models/complete_session.dart';
import 'package:aosny_services/models/gp_dropdown_model.dart';
import 'package:aosny_services/models/history_model.dart';
import 'package:aosny_services/models/missed_session_model.dart';
import 'package:aosny_services/models/selected_longTerm_model.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

List<String> sessionTypeStrings = [
  'Service Provided',
  'Service provided - Make-up',
  'Student Absent',
  'Provider Absent',
  'Student Unavailable',
  'Non-Direct Care',
];

List<Color> sessionColors = [
  Colors.red,
  Colors.purple,
  Colors.green,
  Colors.blue,
];

Color getSessionColor(int group, String sessionType) {
  if (group == 1 && (sessionType == sessionTypeStrings[0] || sessionType == sessionTypeStrings[1])) {
    return Colors.green;
  } else if (group == 2 && (sessionType == sessionTypeStrings[0] || sessionType == sessionTypeStrings[1])) {
    return Colors.blue;
  } else if (sessionType == sessionTypeStrings[2] || sessionType == sessionTypeStrings[3] || sessionType == sessionTypeStrings[4]) {
    return Colors.red;
  } else if (sessionType == sessionTypeStrings[5]) {
    return Colors.purple;
  // } else if (sessionType == sessionTypeStrings[6]) {
  //   return Colors.red;
  }
  return Colors.white;
}

class AddEditSessionNote extends StatefulWidget {
  final StudentsDetailsModel student;
  final String selectedStudentName;
  final String eventType ;
  final String noteText;
  final CompleteSessionNotes sessionNotes;
  final int sessionId;
  final bool isEditable;

  AddEditSessionNote({
    this.student,
    this.selectedStudentName,
    this.eventType,
    this.noteText,
    this.sessionId,
    this.sessionNotes,
    this.isEditable = true,
  });
  @override
  _AddEditSessionNoteState createState() => _AddEditSessionNoteState();
}

class _AddEditSessionNoteState extends State<AddEditSessionNote> {

  SessionNoteScreenBloc screenBloc;
  bool showSessionsOnDay = false;
  TextEditingController startTimeController = new TextEditingController(text: '9:00 AM');
  TextEditingController showTimeController = new TextEditingController(text: '30');
  TextEditingController noteTextController = new TextEditingController();
  TextEditingController activityChildPerformanceController = new TextEditingController();
  TextEditingController followUpController = new TextEditingController();
  FocusNode noteFocus = FocusNode();
  FocusNode activityFocus = FocusNode();
  FocusNode followUpFocus = FocusNode();
  ScrollController scrollController = ScrollController();
  List<String> listValue =[
    'Select Long Term Goal',
    'Given the aid of verbal and visual cues',
    'Given the aid of modeling verbal and visual cues',
    'Given the aid of modeling verbal and visual cues',
  ];

  List<IconData> iconsList = [
    Icons.check_circle,
    Icons.star_half,
    Icons.not_interested,
  ];

  List<IconData> completeIconsList = [
    Icons.not_interested,
    Icons.star_half,
    Icons.check_circle,
  ];

  @override
  void initState() {

    super.initState();

    screenBloc = SessionNoteScreenBloc(SessionNoteScreenState(isLoading: true));
    screenBloc.add(
        SessionNoteScreenInitEvent(
          studentId: widget.student.studentID.toInt(),
          eventType: widget.eventType,
          noteText: widget.noteText,
          selectedStudentName: widget.selectedStudentName,
          sessionId: widget.sessionId,
          sessionNotes: widget.sessionNotes,
          student: widget.student,
        )
    );
    noteFocus.addListener(_handleNoteChanges);
    activityFocus.addListener(_handleActivityChanges);
    followUpFocus.addListener(_handleFollowUpChanges);
  }

  void _handleNoteChanges() {
    if (!noteFocus.hasFocus) {
      if (screenBloc != null) {
        screenBloc.add(UpdateSessionNoteEvent(note: noteTextController.text));
      }
    }
  }

  void _handleActivityChanges() {
    if (!activityFocus.hasFocus) {
      if (screenBloc != null) {
        screenBloc.add(UpdateActivityChildPerformanceEvent(note: activityChildPerformanceController.text));
      }
    }
  }

  void _handleFollowUpChanges() {
    if (!followUpFocus.hasFocus) {
      if (screenBloc != null) {
        screenBloc.add(UpdateFollowUpEvent(note: followUpController.text));
      }
    }
  }

  Future<Null> _selectDate(BuildContext context, SessionNoteScreenState state) async {
    print('show DatePicker');
    if (!isAvailable(state.selectedDate)) {
      var datePick= await showDatePicker(
        context: context,
        initialDate: getAvailableDate(state.selectedDate),
        selectableDayPredicate: (day) {
          return isAvailable(day);
        },
        firstDate: DateTime(state.selectedDate.year - 1),
        lastDate: DateTime.now(),
      );
      if (datePick != null && datePick != state.selectedDate ?? DateTime.now()) {
        screenBloc.add(UpdateSelectedDate(selectedDate: datePick));
      }
    } else {
      var datePick= await showDatePicker(
        context: context,
        initialDate: state.selectedDate,
        selectableDayPredicate: (day) {
          return isAvailable(day);
        },
        // selectableDayPredicate: (DateTime val) => isAvailable(val),
        // selectableDayPredicate: (DateTime val) => val.weekday == 5 || val.weekday == 6 ? false : true,
        firstDate: DateTime(state.selectedDate.year - 1),
        lastDate: DateTime.now(),
      );
      if (datePick != null && datePick != state.selectedDate ?? DateTime.now()) {
        screenBloc.add(UpdateSelectedDate(selectedDate: datePick));
      }
    }
  }

  Future<Null> _selectTime(BuildContext context, SessionNoteScreenState state) async {
    final TimeOfDay response = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(state.selectedDate) ?? TimeOfDay.now(),
    );
    if (response != null && response != TimeOfDay.fromDateTime(state.selectedDate) ?? TimeOfDay.now()) {
      screenBloc.add(UpdateSelectedTime(selectedTime: response));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    screenBloc.close();
    startTimeController.dispose();
    showTimeController.dispose();
    noteTextController.dispose();
    activityChildPerformanceController.dispose();
    followUpController.dispose();
    noteFocus.dispose();
    activityFocus.dispose();
    followUpFocus.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: screenBloc,
      listener: (BuildContext context, SessionNoteScreenState state) async {
        if (state is SessionNoteScreenStateSuccess) {
          if (widget.eventType != 'Enter') {
            Navigator.pop(context, 'success');
          } else {
            showDialog(context: context, builder: (context) {
              return CupertinoAlertDialog(
                title: Text(
                  'Success',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                content: Text(
                  'Do you want to add another?',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                actions: [
                  CupertinoActionSheetAction(
                    child: Text(
                      'No',
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: Text(
                      'Yes',
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      noteTextController.text = '';
                      screenBloc.add(
                          SessionNoteScreenInitEvent(
                            studentId: widget.student.studentID.toInt(),
                            eventType: widget.eventType,
                            noteText: widget.noteText,
                            selectedStudentName: widget.selectedStudentName,
                            sessionId: widget.sessionId,
                            sessionNotes: widget.sessionNotes,
                            student: widget.student,
                          )
                      );
                    },
                  ),
                ],
              );
            });
          }
        } else if (state is SessionNoteScreenStateFailure) {
          screenBloc.add(SessionNoteScreenInitEvent(
            studentId: widget.student.studentID.toInt(),
            eventType: widget.eventType,
            noteText: widget.noteText,
            selectedStudentName: widget.selectedStudentName,
            sessionId: widget.sessionId,
            sessionNotes: widget.sessionNotes,
            student: widget.student,
          ));
        }
        setState(() {
          noteTextController.text = state.noteText;
          activityChildPerformanceController.text = state.activityChildPerformance ?? '';
          followUpController.text = state.followUp ?? '';
        });
      },
      child: BlocBuilder<SessionNoteScreenBloc, SessionNoteScreenState>(
        cubit: screenBloc,
        builder: (BuildContext context, SessionNoteScreenState state) {
          return Scaffold(
            backgroundColor: Colors.white,
            // drawer: DrawerWidget(),
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Colors.lightBlue,
              title: Text(
                widget.sessionId != null ? 'Session Note Detail': 'Add Session Note',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            body: ModalProgressHUD(
              inAsyncCall: state.isLoading || state.isSaving,
              child: new GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SafeArea(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 5, right: 5, top: 16),
                        child: _getBody(state),
                      ),
                      // state.conflictTime ? GestureDetector(
                      //   child: Container(
                      //     margin: EdgeInsets.only(top: 250),
                      //     height: double.infinity,
                      //     width: double.infinity,
                      //     color: Colors.grey.withAlpha(1),
                      //   ),
                      //   onTap: () {
                      //
                      //   },
                      // ): Container(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getBody(SessionNoteScreenState state) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: state.showAlert && state.conflictTime ? NeverScrollableScrollPhysics(): AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 24),
      child: Column(
        children: <Widget>[
          showBlockDates(state),
          showConflicts(state),
          Container(
            padding: const EdgeInsets.only(left:5,right:5,),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Student',
                              style: TextStyle(color:Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height:2),
                            Flexible(
                              child: Text(
                                widget.selectedStudentName,
                                style: TextStyle(
                                  color:Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            DateFormat('EEEE').format(state.selectedDate ?? DateTime.now()).toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height:2),
                          InkWell(
                            onTap: () {
                              _selectDate(context, state);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 64,
                              width: MediaQuery.of(context).size.width/7,
                              decoration: BoxDecoration(
                                  border: Border.all(color:Colors.blue)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    DateFormat('d').format(state.selectedDate ?? DateTime.now()).toString(),
                                    style: TextStyle(
                                        color:Colors.blue,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  //sessionDateTime== '' ? Text(''):
                                  Text(
                                    DateFormat('MMM').format(state.selectedDate ?? DateTime.now()).toString().toUpperCase(),
                                    style: TextStyle(
                                        color:Colors.blue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                (state.selectedDate != null) ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        showSessionsOnDay = !showSessionsOnDay;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.grey,
                      )
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Sessions on ${state.selectedDate.month}/${state.selectedDate.day}/${state.selectedDate.year.toString().length == 2 ? '20${state.selectedDate.year}': state.selectedDate.year}',
                          ),
                        ),
                        Icon(
                          showSessionsOnDay ? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                        ),
                      ],
                    ),
                  ),
                ): Container(),
                showSessionsOnDay ? Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Start',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'End',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Name',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ): Container(),
                showSessionsOnDay ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(color:Colors.grey),
                  ),
                  margin: EdgeInsets.only(bottom: 8),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.sessionOnDay.length,
                    separatorBuilder: (context, index) {
                      return Divider(color: Colors.black38,
                        height: 0,
                        thickness: 0.5,);
                    },
                    itemBuilder: (context, index) {
                      HistoryModel model = state.sessionOnDay[index];
                      String stime = model.stime;
                      String etime = model.etime;

                      return Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                stime,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                etime,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${model.fname} ${model.lname}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ): Container(),
                isAvailable(state.selectedDate) ? Container(
                  margin: const EdgeInsets.only(left: 8 ,right: 8),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Start Time',
                                  style: TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  child: Container(
                                    height: 44,
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width/4,
                                    decoration: BoxDecoration(
                                      border: Border.all(color:Colors.grey),
                                    ),
                                    child:  Text(
                                      DateFormat.jm().format(state.selectedDate ?? DateTime.now()),
                                      style: TextStyle(
                                        color:Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    await _selectTime(context, state);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                Text('Minutes',
                                  style: TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      child: Container(
                                        height: 44,
                                        width: 44,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(color:Colors.grey,width: 0.5),
                                          color: state.finalNumber == 30 ? Colors.blue: Colors.white,
                                        ),
                                        child: Text(
                                          '30',
                                          style: TextStyle(
                                            color: state.finalNumber == 30 ? Colors.white: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      onTap: (){
                                        screenBloc.add(UpdateFinalNumber(finalNumber: 30));
                                      },
                                    ),
                                    InkWell(
                                      child: Container(
                                        height: 44,
                                        width: 44,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(color:Colors.grey,width: 0.5),
                                          color: state.finalNumber == 60 ? Colors.blue: Colors.white,
                                        ),
                                        child:  Text(
                                          '60',
                                          style: TextStyle(
                                            color: state.finalNumber == 60 ? Colors.white: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      onTap: (){
                                        screenBloc.add(UpdateFinalNumber(finalNumber: 60));
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                Text('End Time',
                                  style: TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  height: 44,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(color:Colors.grey)
                                  ),
                                  child: Text(
                                    DateFormat.jm().format((state.selectedDate ?? DateTime.now()).add(new Duration(minutes: state.finalNumber ?? 30))).toString(),//'10:21 PM',
                                    style: TextStyle(
                                      color:Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ) ,
                      SizedBox(height: 8,),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Location',
                              style: TextStyle(fontWeight:FontWeight.bold,fontSize:15),
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: DropdownButton(
                                      underline: Container(),
                                      hint: state.location == null
                                          ? Text('Select')
                                          : Text(
                                        state.location,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      isExpanded: true,
                                      elevation: 5,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      iconSize: 30.0,
                                      style: TextStyle(color: Colors.black),
                                      items: locationText.map(
                                            (val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: Text(
                                              val,
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (val) {
                                        screenBloc.add(UpdateLocation(location: val));
                                      },
                                    ),
                                  ),
                                ),
                                Container(width: 16,),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: DropdownButton(
                                      underline: Container(),
                                      hint: state.location1 == null
                                          ? Text('Select')
                                          : Text(
                                        state.location1,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      isExpanded: true,
                                      elevation: 5,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      iconSize: 30.0,
                                      style: TextStyle(color: Colors.black),
                                      items: location1Text.map(
                                            (val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: Text(
                                              val,
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (val) {
                                        screenBloc.add(UpdateLocation1(location1: val));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 8,),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Setting',
                              style: TextStyle(fontWeight:FontWeight.bold, fontSize:15),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  children:<Widget>[
                                    Container(
                                      height: 44,
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width/6.5,
                                      decoration: BoxDecoration(
                                          color: state.groupType == 1
                                              ? Color(0xff4A4A4A): Colors.white,
                                          border: Border.all(color:Colors.grey,width: 0.5)
                                      ),
                                      child: Icon(Icons.person,
                                        color: state.groupType == 1
                                            ? Colors.white: Color(0xff4A4A4A),
                                      ),
                                    ),
                                    Text('Individual',style: TextStyle(fontSize: 11),),
                                  ],
                                ),
                                Column(
                                  children:<Widget>[
                                    Container(
                                      height: 44,
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width/6.5,
                                      decoration: BoxDecoration(
                                          color: state.groupType == 2
                                              ?Color(0xff4A4A4A):Colors.white,
                                          border: Border.all(color:Colors.grey,width: 0.5)
                                      ),
                                      child: Icon(Icons.group,
                                        color: state.groupType == 2
                                            ?Colors.white:Color(0xff4A4A4A),
                                      ),
                                    ),
                                    Text(
                                      'Group',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ): Container(),
              ],
            ),
          ),
          isAvailable(state.selectedDate) ? Column(
            children: [
              _sessionTypeWidget(state),
              state.sessionType == sessionTypeStrings[0] || state.sessionType == sessionTypeStrings[1] ? _dropDowns(state): (state.sessionType == sessionTypeStrings[5] ?  _nonDirectCare(state): Container()),
              state.sessionType == sessionTypeStrings[5] ? Container() : Container(
                alignment: Alignment.bottomLeft,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left:20,right:20,top:5),
                child: Text(
                  'Notes: (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              state.isLoading
                  ? Container()
                  : (
                  state.sessionType == sessionTypeStrings[5] ? Container() : Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(left: 16,right: 16,top:2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ) ,
                    child: TextField(
                      focusNode: noteFocus,
                      onChanged: (val) {
                        setState(() {
                        });
                      },
                      controller: noteTextController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      scrollPhysics: NeverScrollableScrollPhysics(),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        hintText: '',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  )
              ),
              SizedBox(height:16),
              widget.isEditable && !state.isLock? Row(
                children: [
                  Flexible(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                      ),
                      child: InkWell(
                        onTap: (){
                          if (state.sessionType == sessionTypeStrings[1]) {
                            if (state.mCalId == 0 || state.mCalId == null) {
                              Fluttertoast.showToast(msg: 'Makeup date selection is required');
                              return;
                            }
                          }
                          if (state.sessionType == sessionTypeStrings[0]) {
                            if (widget.isEditable && widget.eventType == 'Edit') {

                            } else {
                              if (state.showAlert && state.exceedMandate) {
                                TimeList timeList = state.timeList;
                                ProgressedTime progressedTime = timeList.progressedList.firstWhere((element) {
                                  return element.studentId == state.student.studentID.toInt();
                                });
                                Fluttertoast.showToast(msg: 'This mandate has the maximum of ${progressedTime.mandateMins / 60} hours for the week. Only Makeups and Non-Direct Care can be added');
                                return;
                              }
                            }
                          }
                          if (state.showAlert && state.conflictTime) {
                            Fluttertoast.showToast(msg: 'There is already a session entered during this time frame');
                            return;
                          }
                          screenBloc.add(SaveSessionNoteEvent(noteText: noteTextController.text, activityText: activityChildPerformanceController.text, followText: followUpController.text));
                        },
                        child: Container(
                          color: Colors.blue,
                          alignment: Alignment.center,
                          child: Text(
                            'Save',style: TextStyle(color:Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  widget.eventType == 'Enter' ? Container() : SizedBox(width: 8,),
                  widget.eventType == 'Enter' ? Container() : Flexible(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                      ),
                      child: InkWell(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return CupertinoAlertDialog(
                                  title: Text(
                                    'Delete Session Note',
                                  ),
                                  content: Text(
                                      'Are you sure you want to delete this session note?'
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text(
                                        'Cancel',
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: Text(
                                        'Sure',
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        screenBloc.add(DeleteSessionEvent(id: state.sessionId));
                                      },
                                    ),
                                  ],
                                );
                              }
                          );
                        },
                        child: Container(
                          color: Colors.redAccent,
                          alignment: Alignment.center,
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color:Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ): Container(),
              SizedBox(height:16),
            ]
          ) : Container()
        ],
      ),
    );
  }

  Widget _dropDowns(SessionNoteScreenState state) {
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            bool isSelect = state.goalsAndProgress;
            print(state.longTermGpDropDownList.length);
            screenBloc.add(SelectGoalSection(isSelect: !isSelect));
          },
          child: Container(
            height: 44,
            width: MediaQuery.of(context).size.width,
            color: Color(0xff4A4A4A),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child: Text('Goals & Progress',
                        style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)
                    ),
                    padding: const EdgeInsets.all(0)),
                Container(
                  alignment: Alignment.centerRight,
                  child: state.goalsAndProgress ? Icon(Icons.arrow_drop_down,
                    color:Colors.white,
                    size: 35,
                  ) : Icon(Icons.arrow_right,
                    color:Colors.white,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
        ),
        state.goalsAndProgress ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8, top: 8),
              child: Text(
                'Goal Group 1:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, top: 8),
              child: Text(
                'Long Term Goals: ',
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              padding:  const EdgeInsets.all(5.0),
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
              ),
              child: DropdownButton(
                underline: Container(),
                hint: state.dropDownValue == null ? Text(
                  'Select your choice' ,
                  maxLines: 1,
                )
                    : Text(
                  state.dropDownValue,
                  maxLines: 1,
                  style: TextStyle(color: Colors.blue),
                ),
                isExpanded: true,
                // elevation: 10,
                iconSize: 30.0,
                style: TextStyle(color: Colors.black),
                items: state.longTermGpDropDownList.map(
                      (val) {
                    int isContain = 0;
                    if (state.selectedLtGoalId == val.longGoalID) {
                      isContain = 1;
                    } else if (state.selectedLtGoalId2 == val.longGoalID) {
                      isContain = 2;
                    }
                    return DropdownMenuItem<LongTermGpDropDownModel>(
                      value: val,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(height: 5,),
                            Text(
                              val.longGoalText,
                              style: TextStyle(
                                color: isContain == 1 ? Colors.red : ( isContain == 2 ? Colors.blue : Colors.black),
                                fontWeight: isContain == 1 || isContain == 2 ? FontWeight.bold: FontWeight.normal,
                              ),
                            ),
                            Container(height: 5,),
                            Divider(height: 10,color: Colors.black,),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
                onChanged: (val) {
                  if (val.longGoalID == state.selectedLtGoalId2) {
                    return;
                  }
                  int selectedLtGoalId = val.longGoalID;
                  screenBloc.add(SelectLongTermID(id: selectedLtGoalId));
                  // screenBloc.add(UpdateSelectedShortTerms(selectedShortTermResultListModel: selectedShortTermResultListModel));
                  screenBloc.add(UpdateDropdownValue(longGoalText: val.longGoalText));
                },
              ),
            ),
          ],
        ) : Container(),
        state.goalsAndProgress && state.selectedLtGoalId > -1 ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8, top: 8),
              child: Text(
                'Short Term Goals: ',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left:5,right:5),
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                children: state.selectedShortTermResultListModel.map( (item) {
                  return CheckboxListTile(
                    title: Text(
                      item.selectedShortgoaltext,
                      style: TextStyle(fontSize: 15),
                    ),
                    value: item.checkVal,
                    onChanged: (newValue) {
                      List<SelectedShortTermResultListModel> selectedShortTermResultListModel = [];
                      print(state.selectedShortTermResultListModel.length);
                      for(int i = 0; i < state.selectedShortTermResultListModel.length; i++){
                        bool isContain = false;
                        selectedShortTermResultListModel.forEach((element) {
                          if (element.id == state.selectedShortTermResultListModel[i].id) {
                            isContain = true;
                          }
                        });
                        if (!isContain) {
                          if (item.id == state.selectedShortTermResultListModel[i].id){
                            selectedShortTermResultListModel.add(
                                SelectedShortTermResultListModel(
                                  id: state.selectedShortTermResultListModel[i].id,
                                  selectedId: state.selectedShortTermResultListModel[i].selectedId,
                                  selectedShortgoaltext: state.selectedShortTermResultListModel[i].selectedShortgoaltext,
                                  checkVal: newValue,
                                )
                            );
                          } else {
                            selectedShortTermResultListModel.add(
                                state.selectedShortTermResultListModel[i]
                            );
                          }
                        }
                      }
                      screenBloc.add(UpdateSelectedShortTerms(selectedShortTermResultListModel: selectedShortTermResultListModel));
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
                ).toList(),
              ),
            ),
          ],
        ): Container(),
        state.goalsAndProgress && state.selectedLtGoalId > -1 ? goalProgressReview(state) : Container(),
        state.goalsAndProgress ? Divider(height: 8, thickness: 1,) : Container(),
        state.goalsAndProgress ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8, top: 8),
              child:  Text.rich(
                TextSpan(
                  text: 'Goal Group 2:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' (Optional)',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.normal
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Long Term Goals: ',
                  ),
                  MaterialButton(
                    onPressed: () {
                      int selectedLtGoalId = -1;
                      screenBloc.add(SelectLongTermID2(id: selectedLtGoalId));
                      screenBloc.add(UpdateDropdownValue2(longGoalText: ''));
                    },
                    padding: EdgeInsets.zero,
                    child: Text(
                      'Clear',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              padding:  const EdgeInsets.all(5.0),
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
              ),
              child: DropdownButton(
                underline: Container(),
                hint:  state.dropDownValue2 == null || state.dropDownValue2 == '' ? Text(
                  'Select your choice' ,
                  maxLines: 1,
                )
                    : Text(
                  state.dropDownValue2,
                  maxLines: 1,
                  style: TextStyle(color: Colors.blue),
                ),
                isExpanded: true,
                // elevation: 10,
                iconSize: 30.0,
                style: TextStyle(color: Colors.black),
                items: state.longTermGpDropDownList.map(
                      (val) {
                    int isContain = 0;
                    if (state.selectedLtGoalId == val.longGoalID) {
                      isContain = 1;
                    } else if (state.selectedLtGoalId2 == val.longGoalID) {
                      isContain = 2;
                    }
                    return DropdownMenuItem<LongTermGpDropDownModel>(
                      value: val,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(height: 5,),
                            Text(
                              val.longGoalText,
                              style: TextStyle(
                                color: isContain == 1 ? Colors.red : ( isContain == 2 ? Colors.blue : Colors.black),
                                fontWeight: isContain == 1 || isContain == 2 ? FontWeight.bold: FontWeight.normal,
                              ),
                            ),
                            Container(height: 5,),
                            Divider(height: 10,color: Colors.black,),
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
                onChanged: (val) {
                  if (val.longGoalID == state.selectedLtGoalId) {
                    return;
                  }
                  int selectedLtGoalId = val.longGoalID;
                  screenBloc.add(SelectLongTermID2(id: selectedLtGoalId));
                  // screenBloc.add(UpdateSelectedShortTerms2(selectedShortTermResultListModel: selectedShortTerm2));
                  screenBloc.add(UpdateDropdownValue2(longGoalText: val.longGoalText));
                },
              ),
            ),
          ],
        ) : Container(),
        state.goalsAndProgress && state.selectedLtGoalId2 > -1 ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8, top: 8),
              child: Text(
                'Short Term Goals: ',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left:5,right:5),
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                children: state.selectedShortTermResultListModel2.map( (item) {
                  return CheckboxListTile(
                    title: Text(
                      item.selectedShortgoaltext,
                      style: TextStyle(fontSize: 15),
                    ),
                    value: item.checkVal,
                    onChanged: (newValue) {
                      List<SelectedShortTermResultListModel> selectedShortTermResultListModel = [];

                      for(int i = 0; i < state.selectedShortTermResultListModel2.length; i++){
                        if (item.id == state.selectedShortTermResultListModel2[i].id){
                          selectedShortTermResultListModel.add(
                              SelectedShortTermResultListModel(
                                id: state.selectedShortTermResultListModel2[i].id,
                                selectedId: state.selectedShortTermResultListModel2[i].selectedId,
                                selectedShortgoaltext: state.selectedShortTermResultListModel2[i].selectedShortgoaltext,
                                checkVal: newValue,
                              )
                          );
                        } else {
                          selectedShortTermResultListModel.add(
                              state.selectedShortTermResultListModel2[i]
                          );
                        }
                      }
                      screenBloc.add(UpdateSelectedShortTerms2(selectedShortTermResultListModel: selectedShortTermResultListModel));
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
                ).toList(),
              ),
            ),
          ],
        ): Container(),
        state.goalsAndProgress && state.selectedLtGoalId2 > -1 ? goalProgressReview2(state) : Container(),
        SizedBox(height:2),
        GestureDetector(
          onTap: (){
            print(state.activitiesListItems);
            bool isSelect = state.isActivities;
            screenBloc.add(SelectActivitySection(isSelect: !isSelect));
          },
          child:Container(
            alignment: Alignment.center,
            height: 44,
            width: MediaQuery.of(context).size.width,
            color: Color(0xff4A4A4A),
            child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text('Activities',
                        style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,

                    child: state.isActivities ? Icon(Icons.arrow_drop_down,
                      color:Colors.white,
                      size: 35,
                    ) :Icon(Icons.arrow_right,
                      color:Colors.white,
                      size: 35,
                    ),
                  ),
                ]
            ), ///Text('Activities',
          ),
        ),
        SizedBox(height:2),
        state.isActivities ? activitiesDropdownWidget(state) : Container(),
        GestureDetector(
          onTap: (){
            bool isSelect = state.socialPragmaics;
            screenBloc.add(SelectSPSection(isSelect: !isSelect));
          },
          child: Container(
            alignment: Alignment.center,
            height: 44,
            width: MediaQuery.of(context).size.width,
            color: Color(0xff4A4A4A),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text('Social Pragmatics',
                      style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: state.socialPragmaics?Icon(Icons.arrow_drop_down,
                    color:Colors.white,
                    size: 35,
                  ) :Icon(Icons.arrow_right,
                    color:Colors.white,
                    size: 35,
                  ),
                ),
              ] ,
            ),
          ),
        ),
        state.socialPragmaics ? Container(
          margin: const EdgeInsets.only(left:5,right:5),
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            children: List.generate(state.sPcheckListItems.length, (index) {
              return CheckboxListTile(
                title: Text(
                  state.sPcheckListItems[index].title,
                  style: TextStyle(fontSize: 15),
                ),
                dense: true,
                value: state.sPcheckListItems[index].checkVal,
                onChanged: (newValue) {
                  List<CheckList> checklist = [];
                  for (int i = 0; i < state.sPcheckListItems.length; i++) {
                    if (i == index) {
                      CheckList check = state.sPcheckListItems[i];
                      check.checkVal = newValue;
                      checklist.add(check);
                    } else {
                      checklist.add(state.sPcheckListItems[i]);
                    }
                  }
                  screenBloc.add(UpdateSpCheckValue(list: checklist));
                  setState(() {

                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
            },
            ).toList(),
          ),
        ): Container(),
        SizedBox(height:2),
        GestureDetector(
          onTap: (){
            bool isSelect = state.seitIntervention;
            screenBloc.add(SelectSISection(isSelect: !isSelect));
          },
          child: Container(
            alignment: Alignment.center,
            height: 44,
            width: MediaQuery.of(context).size.width,
            color: Color(0xff4A4A4A),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'SEIT Intervention',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: state.seitIntervention ? Icon(Icons.arrow_drop_down,
                    color:Colors.white,
                    size: 35,
                  ) :Icon(Icons.arrow_right,
                    color:Colors.white,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
        ),
        state.seitIntervention ? Container(
          margin: EdgeInsets.only(left:5,right:5),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: List.generate(state.sIcheckListItems.length, (index) {
              CheckList check = state.sIcheckListItems[index];
              return CheckboxListTile(
                title: Text(
                  check.title,
                  style: TextStyle(fontSize: 15),
                ),
                dense: true,
                value: check.checkVal,
                onChanged: (newValue) async {
                  List<CheckList> checklist = [];
                  for (int i = 0; i < state.sIcheckListItems.length; i++) {
                    if (i == index) {
                      CheckList check = state.sIcheckListItems[i];
                      check.checkVal = newValue;
                      checklist.add(check);
                    } else {
                      checklist.add(state.sIcheckListItems[i]);
                    }
                  }
                  screenBloc.add(UpdateSiCheckValue(list: checklist));
                  setState(() {

                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
            },
            ).toList(),
          ),
        ): Container(),
        SizedBox(height:2),
        GestureDetector(
          onTap: (){
            bool isSelect = state.competedActivites;
            screenBloc.add(SelectCASection(isSelect: !isSelect));
          },
          child: Container(
            alignment: Alignment.center,
            height: 44,
            width: MediaQuery.of(context).size.width,
            color: Color(0xff4A4A4A),
            child: Stack(
                alignment: Alignment.center,
                children: <Widget>[

                  Container(

                    alignment: Alignment.center,
                    child: Text('Completed activity',
                      style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal),

                    ),
                  ),


                  Container(
                    alignment: Alignment.centerRight,

                    child: state.competedActivites?Icon(Icons.arrow_drop_down,
                      color:Colors.white,
                      size: 35,
                    ) :Icon(Icons.arrow_right,
                      color:Colors.white,
                      size: 35,
                    ),),
                ]
            ), ///Text('Activities',


          ),),
        state.competedActivites ? completedActivityReview(state) : Container(),
        SizedBox(height:2),
        GestureDetector(
          onTap: (){
            bool isSelect = state.jointAttentionEyeContact;
            screenBloc.add(SelectJASection(isSelect: !isSelect));
          },
          child: Container(
            alignment: Alignment.center,
            height: 44,
            width: MediaQuery.of(context).size.width,
            color: Color(0xff4A4A4A),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text('Joint Attention / Eye Contact',
                      style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,

                  child: state.jointAttentionEyeContact ? Icon(
                    Icons.arrow_drop_down,
                    color:Colors.white,
                    size: 35,
                  ) :
                  Icon(
                    Icons.arrow_right,
                    color:Colors.white,
                    size: 35,
                  ),
                ),
              ],
            ), ///Text('Activities',
          ),
        ),
        state.jointAttentionEyeContact? jointAttentionOrEyeContactReview(state): Container(),
        SizedBox(height:2),
      ],
    );
  }

  Widget _nonDirectCare(SessionNoteScreenState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8, top: 8, bottom: 4),
          child: Text(
            'Activity:',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
        _nonActivity(state),
        state.selectedProgText == nonDirectActivities[0] ? Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Activity and Child Performance:',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      activityChildPerformanceController.text = 'Updated parents on how child is doing in class and on progress toward attaining goals.';
                      screenBloc.add(UpdateActivityChildPerformanceEvent(note: activityChildPerformanceController.text));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Updated Parent',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 8,right: 8,),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ) ,
                child: TextField(
                  focusNode: activityFocus,
                  onChanged: (val) {
                  },
                  onSubmitted: (val) {
                    screenBloc.add(UpdateActivityChildPerformanceEvent(note: val));
                  },
                  controller: activityChildPerformanceController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: null,
                  scrollPhysics: NeverScrollableScrollPhysics(),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    hintText: '',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8, top: 8, bottom: 4),
                          child: Text(
                            'Method of Contact:',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Divider(height: 0, thickness: 0.5,),
                        _coordinationMethods(state),
                        Divider(height: 0, thickness: 0.5,),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8, top: 8, bottom: 4),
                          child: Text(
                            'Party Contacted:',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Divider(height: 0, thickness: 0.5,),
                        _coordinationParty(state),
                        Divider(height: 0, thickness: 0.5,),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ): Container(),
        state.selectedProgText == nonDirectActivities[1] ? Container(): Container(),
        state.selectedProgText == nonDirectActivities[2] ? Padding(
          padding: EdgeInsets.only(left: 8, top: 8, bottom: 4),
          child: Text(
            'Prep type:',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ): Container(),
        state.selectedProgText == nonDirectActivities[2] ? _nonPrepType(state): Container(),
        Padding(padding: EdgeInsets.only(top: 16),),
        state.selectedProgText != nonDirectActivities[0] ? Container()
            : Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Follow Up:',
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        state.selectedProgText != nonDirectActivities[0] ? Container() :
        Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(left: 8,right: 8,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ) ,
          child: TextField(
            focusNode: followUpFocus,
            onChanged: (val) {
            },
            onEditingComplete: () {
              screenBloc.add(UpdateFollowUpEvent(note: followUpController.text));
            },
            onSubmitted: (val) {
              screenBloc.add(UpdateFollowUpEvent(note: val));
            },

            controller: followUpController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: null,
            scrollPhysics: NeverScrollableScrollPhysics(),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              hintText: '',
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  bool getSelected(String text, SessionNoteScreenState state) {
    int index = cptCodeId.indexOf(text);
    bool isSelected = false;
    state.cptCodeList.forEach((element) {
      if (element.cptid <= cptCodeId.length) {
        if (element.cptid > 0) {
          if (cptCodeId[element.cptid - 1] == text) {
            isSelected = true;
          }
        }
      }
    });
    return isSelected;
  }
  Widget _coordinationMethods(SessionNoteScreenState state) {
    return Container(
      margin: EdgeInsets.only(left:5,right:5),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: List.generate(methodOfContact.length, (index) {
          return CheckboxListTile(
            title: Text(
              methodOfContact[index],
              style: TextStyle(fontSize: 15),
            ),
            contentPadding: EdgeInsets.zero,
            dense: true,
            value: getSelected(methodOfContact[index], state),
            onChanged: (newValue) async {
              if (getSelected(methodOfContact[index], state)) {
                List<CptCode> list = state.cptCodeList;
                list.removeWhere((element) {
                  if (element.cptid > 0) {
                    return (methodOfContact[index] == cptCodeId[element.cptid - 1]);
                  } else {
                    return false;
                  }
                });
                screenBloc.add(UpdateCptText1(cptCodeList: list));
              } else {
                List<CptCode> list = state.cptCodeList;
                int id = cptCodeId.indexOf(methodOfContact[index]);
                list.add(CptCode(cptid: id + 1));
                screenBloc.add(UpdateCptText1(cptCodeList: list));
              }
              setState(() {

              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          );
        },
        ).toList(),
      ),
    );
  }

  Widget _coordinationParty(SessionNoteScreenState state) {
    return Container(
      margin: EdgeInsets.only(left:5,right:5),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: List.generate(partyContacted.length, (index) {
          return CheckboxListTile(
            title: Text(
              partyContacted[index],
              style: TextStyle(fontSize: 15),
            ),
            contentPadding: EdgeInsets.zero,
            dense: true,
            value: getSelected(partyContacted[index], state),
            onChanged: (newValue) async {
              if (getSelected(partyContacted[index], state)) {
                List<CptCode> list = state.cptCodeList;
                list.removeWhere((element) {
                  if (element.cptid > 0) {
                    return (partyContacted[index] == cptCodeId[element.cptid - 1]);
                  } else {
                    return false;
                  }
                });
                screenBloc.add(UpdateCptText1(cptCodeList: list));
              } else {
                List<CptCode> list = state.cptCodeList;
                int id = cptCodeId.indexOf(partyContacted[index]);
                list.add(CptCode(cptid: id + 1));
                screenBloc.add(UpdateCptText1(cptCodeList: list));
              }
              setState(() {

              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          );
        },
        ).toList(),
      ),
    );
  }

  Widget _nonActivity(SessionNoteScreenState state) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 12),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                child: SafeArea(
                  child: ListView.separated(
                    itemCount: nonDirectActivities.length,
                    separatorBuilder: (context, index) {
                      return Divider(color: Colors.black38,
                        height: 0,
                        thickness: 0.5,);
                    },
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        dense: true,
                        title: Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                nonDirectActivities[index],
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        value: nonDirectActivities[index] == state.selectedProgText,
                        selected: nonDirectActivities[index] == state.selectedProgText,
                        onChanged: (newValue) {
                          screenBloc.add(UpdateProgText(progText: nonDirectActivities[index]));
                          Navigator.pop(context);
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        dense: true,
        title: Row(
          children: <Widget>[
            Flexible(
              child: Text(
                (state.selectedProgText != null && state.selectedProgText != '') ? state.selectedProgText :
                'Select Your Choice',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.keyboard_arrow_down),
      ),
    );
  }

  Widget _nonPrepType(SessionNoteScreenState state) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 12),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 350,
                child: SafeArea(
                  child: ListView.separated(
                    itemCount: prepTypes.length,
                    separatorBuilder: (context, index) {
                      return Divider(color: Colors.black38,
                        height: 0,
                        thickness: 0.5,);
                    },
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        dense: true,
                        title: Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                prepTypes[index],
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        value: prepTypes[index] == state.noteText,
                        selected: prepTypes[index] == state.noteText,
                        onChanged: (newValue) {
                          screenBloc.add(UpdateSessionNoteEvent(note: prepTypes[index]));
                          Navigator.pop(context);
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        dense: true,
        title: Row(
          children: <Widget>[
            Flexible(
              child: Text(
                state.noteText != null && state.noteText != '' ? state.noteText :
                'Select Your Choice',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.keyboard_arrow_down),
      ),
    );
  }

  Widget activitiesDropdownWidget(SessionNoteScreenState state) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          int key = state.activitiesListItems.keys.toList()[index];
          List<CheckList> list = state.activitiesListItems[key];
          return Container(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index1) {
                CheckList item = list[index1];
                return InkWell(
                  onTap: () {
                    Map<int, List<CheckList>> map = {};
                    for (int i = 0; i < state.activitiesListItems.keys.toList().length; i++) {
                      int key = state.activitiesListItems.keys.toList()[i];
                      List<CheckList> list = [];
                      for (int j = 0; j < state.activitiesListItems[key].length; j ++) {
                        if (i == index && j == index1) {
                          list.add(CheckList(
                            id: state.activitiesListItems[key][j].id,
                            title: state.activitiesListItems[key][j].title,
                            checkVal: !state.activitiesListItems[key][j].checkVal,
                          ));
                        } else {
                          list.add(state.activitiesListItems[key][j]);
                        }
                      }
                      map[key] = list;
                    }
                    screenBloc.add(UpdateActivityListItem(activitiesListItems: map));
                  },
                  splashColor: Color(0xFFEFEFEF),
                  highlightColor: Color(0xFFEFEFEF),
                  hoverColor: Color(0xFFEFEFEF),
                  focusColor: Color(0xFFEFEFEF),
                  child: Container(
                    padding: index1 == 0
                        ? EdgeInsets.only(left: 16, right: 16)
                        : EdgeInsets.only(left: 24, right: 16),
                    height: index1 == 0 ? 44 : 36,
                    color: index1 == 0
                        ? Color(0xFFc6e2ff)
                        : Colors.transparent,
                    child: Row(
                      children: <Widget>[
                        index1 == 0
                            ? (item.checkVal ? Icon(Icons.remove) : Icon(Icons.add))
                            : (item.checkVal ? Icon(Icons.check_box, color: Colors.blue,) : Icon(Icons.check_box_outline_blank, )),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        Text(
                          item.title,
                          style: TextStyle(
                            color: index1 == 0 ? Colors.black: Colors.black87,
                            fontSize: index1 == 0 ? 16: 14,
                            fontWeight: index1 == 0 ? FontWeight.w400: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index1) {
                return Divider(height: 0, thickness: 1,);
              },
              itemCount: list[0].checkVal ? list.length: 1,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height: 0, thickness: 1,);
        },
        itemCount: state.activitiesListItems.keys.length,
      ),
    );
  }

  Widget goalProgressReview(SessionNoteScreenState state){
    // print(state.selectedOutComesIndex);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 8, top: 8),
          child: Text(
            'Outcomes: ',
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: ListTile(
            onTap: () {
              print(state.selectedLtGoalId);
              if (state.selectedLtGoalId == -1) {
                return;
              }
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SafeArea(
                    maintainBottomViewPadding: true,
                    child: ListView.separated(
                      padding: EdgeInsets.only(top: 16),
                      itemCount: state.outComesListItems.length,
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.black38,
                          height: 0,
                          thickness: 0.5,
                        );
                      },
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          dense: true,
                          title: Text(
                            state.outComesListItems[index].categoryTextDetail,
                            style: TextStyle(fontSize: 14),
                          ),
                          value: state.selectedOutComesIndex == index,
                          onChanged: (newValue) {
                            screenBloc.add(UpdateOutComeIndex(selectedOutComesIndex: index));
                            Navigator.pop(context);
                          },
                          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                        );
                      },
                    ),
                  );
                },
              );
            },
            dense: true,
            title: Text(
              state.selectedOutComesIndex > -1 ? state.outComesListItems[state.selectedOutComesIndex].categoryTextDetail: 'Select Your Choice',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            trailing: Icon(Icons.keyboard_arrow_down),
          ),
        ),
      ],
    );
  }

  Widget goalProgressReview2(SessionNoteScreenState state){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 8, top: 8),
          child: Text(
            'Outcomes: ',
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: ListTile(
            onTap: () {
              if (state.selectedLtGoalId2 == -1) {
                return;
              }
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SafeArea(
                    maintainBottomViewPadding: true,
                    child: ListView.separated(
                      padding: EdgeInsets.only(top: 16),
                      itemCount: state.outComesListItems.length,
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.black38,
                          height: 0,
                          thickness: 0.5,
                        );
                      },
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          dense: true,
                          title: Text(
                            state.outComesListItems[index].categoryTextDetail,
                            style: TextStyle(fontSize: 14),
                          ),
                          value: state.selectedOutComesIndex2 == index,
                          onChanged: (newValue) {
                            screenBloc.add(UpdateOutComeIndex2(selectedOutComesIndex: index));
                            Navigator.pop(context);
                          },
                          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                        );
                      },
                    ),
                  );
                },
              );
            },
            dense: true,
            title: Text(
              state.selectedOutComesIndex2 > -1 ? state.outComesListItems[state.selectedOutComesIndex2].categoryTextDetail: 'Select Your Choice',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            trailing: Icon(Icons.keyboard_arrow_down),
          ),
        ),
      ],
    );
  }

  Widget _sessionTypeWidget(SessionNoteScreenState state){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16, top: 8,),
          child: Text(
            'Session Type: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: getSessionColor(state.groupType, state.sessionType),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: ListTile(
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SafeArea(
                    maintainBottomViewPadding: true,
                    child: Container(
                      height: 300,
                      child: ListView.separated(
                        padding: EdgeInsets.only(top: 16),
                        itemCount: sessionTypesForState(state).length,
                        separatorBuilder: (context, index) {
                          return Divider(color: Colors.black38, height: 0, thickness: 0.5,);
                        },
                        itemBuilder: (context, index){
                          return CheckboxListTile(
                            dense: true,
                            title: Text(
                              sessionTypesForState(state)[index],
                              style: TextStyle(fontSize: 16),
                            ),
                            value: state.sessionType == sessionTypesForState(state)[index],
                            onChanged: (newValue) {
                              screenBloc.add(UpdateSessionType(sessionType: sessionTypesForState(state)[index]));
                              Navigator.pop(context);
                            },
                            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
            dense: true,
            title: Text(
              (state.exceedMandate) ? state.sessionType ?? sessionTypeStrings[1]: state.sessionType ?? sessionTypeStrings[0],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(Icons.keyboard_arrow_down),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16),
        ),
        state.sessionType == sessionTypeStrings[1] ? Container(
          padding: EdgeInsets.only(left: 8, top: 4, bottom: 4),
          child: Text(
            'Make Up:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ) : Container(),
        state.sessionType == sessionTypeStrings[1] ?
        Container(
          margin: const EdgeInsets.all(5),
          padding:  const EdgeInsets.all(5.0),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: state.missedSession.length == 0 ? Center(
              child: Text(
                'No Makeup dates available for this Mandate' ,
                maxLines: 1,
              )
          ): DropdownButton(
            underline: Container(),
            hint: state.mCalId == 0 ? Text(
              'Select your choice' ,
              maxLines: 1,
            )
                : Text(
              getSelectedMissedSession(state),
              maxLines: 2,
              style: TextStyle(color: Colors.redAccent),
            ),
            isExpanded: true,
            iconSize: 30.0,
            style: TextStyle(color: Colors.black),
            items: state.missedSession.map(
                  (val) {
                return DropdownMenuItem<MissedSessionModel>(
                  value: val,
                  child: Column(
                    children: <Widget>[
                      Text(
                        '${val.sessionType} - ${val.sessionDateTime} - ${val.duration} minutes',
                      ),
                      Container(height: 5,),
                      Divider(height: 10,color: Colors.black,),
                      Container(height: 5,),
                    ],
                  ),
                );
              },
            ).toList(),
            onChanged: (val) {
              screenBloc.add(UpdateMakeUpSessionId(id: val.id));
            },
          ),
        ):
        Container()
      ],
    );
  }

  String getSelectedMissedSession(SessionNoteScreenState state) {
    if (state.mCalId == 0) {
      return '';
    } else {
      List<MissedSessionModel> list = state.missedSession.where((element) => element.id == state.mCalId).toList();
      if (list.length > 0) {
        return '${list.first.sessionType} - ${list.first.sessionDateTime} - ${list.first.duration} minutes';
      } else {
        return '';
      }
    }
  }

  Widget completedActivityReview(SessionNoteScreenState state){
    return Container(
      margin: EdgeInsets.only(left:5,right:5, top: 12),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                child: SafeArea(
                  child: ListView.separated(
                    itemCount: state.cAcheckListItems.length,
                    separatorBuilder: (context, index) {
                      return Divider(color: Colors.black38, height: 0, thickness: 0.5,);
                    },
                    itemBuilder: (context, index){
                      return CheckboxListTile(
                        dense: true,
                        title: Row(
                          children: <Widget>[
                            Icon(
                              completeIconsList[index],
                              size: 24,
                              color: state.selectedCAIconIndex == index ? Colors.blue: Colors.grey,
                            ),
                            SizedBox(width: 8,),
                            Flexible(
                              child: Text(
                                state.cAcheckListItems[index].categoryTextDetail,
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                          ],
                        ),
                        value: state.selectedCAIconIndex == index,
                        selected: state.selectedCAIconIndex == index,
                        onChanged: (newValue) {
                          screenBloc.add(UpdateCAIndex(selectedCAIconIndex: index));
                          Navigator.pop(context);
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        dense: true,
        title: Row(
          children: <Widget>[
            state.selectedCAIconIndex > -1 ? Icon(
              completeIconsList[state.selectedCAIconIndex],
              size: 24,
              color: Colors.blue,
            ) : Container(),
            SizedBox(width: 8,),
            Flexible(
              child: Text(
                state.selectedCAIconIndex > -1 ? state.cAcheckListItems[state.selectedCAIconIndex].categoryTextDetail: 'Select Your Choice',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.keyboard_arrow_down),
      ),
    );
  }


  Widget jointAttentionOrEyeContactReview(SessionNoteScreenState state){
    return Container(
      margin: EdgeInsets.only(left:5,right:5, top: 12),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                child: SafeArea(
                  child: ListView.separated(
                    itemCount: state.jAcheckListItems.length,
                    separatorBuilder: (context, index) {
                      return Divider(color: Colors.black38, height: 0, thickness: 0.5,);
                    },
                    itemBuilder: (context, index){
                      return CheckboxListTile(
                        dense: true,
                        title: Row(
                          children: <Widget>[
                            Icon(
                              iconsList[index],
                              size: 24,
                              color: state.selectedJAIconIndex == index ? Colors.blue: Colors.grey,
                            ),
                            SizedBox(width: 8,),
                            Flexible(
                              child: Text(
                                state.jAcheckListItems[index].categoryTextDetail,
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                          ],
                        ),
                        value: state.selectedJAIconIndex == index,
                        selected: state.selectedJAIconIndex == index,
                        onChanged: (newValue) {
                          screenBloc.add(UpdateJAIndex(selectedJAIconIndex: index));
                          Navigator.pop(context);
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        dense: true,
        title: Row(
          children: <Widget>[
            state.selectedJAIconIndex > -1 ? Icon(
              iconsList[state.selectedJAIconIndex],
              size: 24,
              color: Colors.blue,
            ) : Container(),
            SizedBox(width: 8,),
            Flexible(
              child: Text(
                state.selectedJAIconIndex > -1 ? state.jAcheckListItems[state.selectedJAIconIndex].categoryTextDetail: 'Select Your Choice',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.keyboard_arrow_down),
      ),
    );

  }

  Widget editWidget(){
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color:Colors.grey),
            color: Colors.amber
        ),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.not_interested,
              color:Colors.grey,
              size: 40,
            ) ,
            Text('No'),
            Text('Progress')
          ],
        )
    );
  }


  Widget firstRowEditWidget(SessionNoteScreenState state){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
            height: 64,
            width: MediaQuery.of(context).size.width/4,
            decoration: BoxDecoration(
                border: Border.all(color:Colors.grey),
                color: Colors.amber
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.not_interested,
                  color:Colors.grey,
                  size: 40,
                ) ,
                Text('Painting'),

              ],
            )
        ),
        Container(
            height: 64,
            width: MediaQuery.of(context).size.width/4,
            decoration: BoxDecoration(
                border: Border.all(color:Colors.grey),
                color: Colors.amber
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.not_interested,
                  color:Colors.grey,
                  size: 40,
                ) ,
                Text('Baking'),

              ],
            )
        ),
        Container(
            height: 64,
            width: MediaQuery.of(context).size.width/4,
            decoration: BoxDecoration(
                border: Border.all(color:Colors.grey),
                color: Colors.amber
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.not_interested,
                  color:Colors.grey,
                  size: 40,
                ) ,
                Text('Vehicles'),

              ],
            )
        ),
      ],
    );
  }

  Widget secondRowEditWidget(SessionNoteScreenState state){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
            height: 64,
            width: MediaQuery.of(context).size.width/4,
            decoration: BoxDecoration(
                border: Border.all(color:Colors.grey),
                color: Colors.amber
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.not_interested,
                  color:Colors.grey,
                  size: 40,
                ) ,
                Text('Excercise'),

              ],
            )
        ),
        Container(
            height: 64,
            width: MediaQuery.of(context).size.width/4,
            decoration: BoxDecoration(
                border: Border.all(color:Colors.grey),
                color: Colors.amber
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.not_interested,
                  color:Colors.grey,
                  size: 40,
                ) ,
                Text('Glue'),

              ],
            )
        ),
        Container(
            height: 64,
            width: MediaQuery.of(context).size.width/4,
            decoration: BoxDecoration(
                border: Border.all(color:Colors.grey),
                color: Colors.amber
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.not_interested,
                  color:Colors.grey,
                  size: 40,
                ) ,
                Text('Calender'),
              ],
            )
        ),
      ],
    );
  }

  Widget showConflicts(SessionNoteScreenState state) {
    if (!state.showAlert) {
      return Container();
    }
    if (state.conflictTime) {
      return Container(
        padding: EdgeInsets.all(8),
        height: 64,
        color: Colors.red,
        child: Center(
          child: Text(
            'There is already a session entered during this time frame',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (state.exceedMandate) {
      TimeList timeList = state.timeList;
      ProgressedTime progressedTime = timeList.progressedList.firstWhere((element) {
        return element.studentId == state.student.studentID.toInt();
      });
      if (state.sessionType == sessionTypeStrings[5]) {
        return Container();
      }
      print('exceed mandate');
      return Container(
        padding: EdgeInsets.all(8),
        height: 64,
        color: Colors.red,
        child: Center(
          child: Text(
            'This mandate has the maximum of ${progressedTime.mandateMins / 60} hours for the week. Only Makeups and Non-Direct Care can be added',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Container();
  }

  Widget showBlockDates(SessionNoteScreenState state) {
    if (!state.showAlert) {
      return Container();
    }
    if (!isAvailable(state.selectedDate)) {
      return Container(
        padding: EdgeInsets.all(8),
        height: 36,
        color: Colors.red,
        child: Center(
          child: Text(
            'No sessions may be entered on this date.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Container();
  }

  List<String> sessionTypesForState(SessionNoteScreenState state) {
    if (state.exceedMandate) {
      if (state.sessionType == null || state.sessionType == sessionTypeStrings[0]) {
        screenBloc.add(UpdateSessionType(sessionType: sessionTypeStrings[1]));
      }
      return [
        'Service provided - Make-up',
        'Student Absent',
        'Provider Absent',
        'Student Unavailable',
        'Non-Direct Care',
      ];
    } else {
      return sessionTypeStrings;
    }
  }
}

class CheckList{
  String title;
  bool checkVal;
  int id;
  CheckList({this.title, this.checkVal, @required this.id});
}
