import 'package:aosny_services/bloc/session_note/session_note.dart';
import 'package:aosny_services/models/complete_session.dart';
import 'package:aosny_services/models/gp_dropdown_model.dart';
import 'package:aosny_services/models/selected_longTerm_model.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


List<String> sessionTypeStrings = [
  'Service Provided',
  'Service provided - Make-up',
  'Student Absent',
  'Provider Absent',
  'Student Unavailable',
  'Non-Direct Care',
  'Cancelled'
];

List<Color> sessionColors = [
  Colors.red,
  Colors.purple,
  Colors.green,
  Colors.blue,
];

Color getSessionColor(int group, int sessionType) {
  if (group == 1 && (sessionType == 0 || sessionType == 1)) {
    return Colors.green;
  } else if (group == 2 && (sessionType == 0 || sessionType == 1)) {
    return Colors.blue;
  } else if (sessionType == 2 || sessionType == 3 || sessionType == 4) {
    return Colors.red;
  } else if (sessionType == 5) {
    return Colors.purple;
  } else if (sessionType == 6) {
    return Colors.red;
  }
  return Colors.white;
}

class AddEditSessionNote extends StatefulWidget {
  final StudentsDetailsModel student;
  final String selectedStudentName;
  final String eventType ;
  final String noteText;
  final CompleteSessionNotes sessionNotes;
  final String sessionId;

  AddEditSessionNote({
    this.student,
    this.selectedStudentName,
    this.eventType,
    this.noteText,
    this.sessionId,
    this.sessionNotes
  });
  @override
  _AddEditSessionNotetate createState() => _AddEditSessionNotetate();
}

class _AddEditSessionNotetate extends State<AddEditSessionNote> {

  SessionNoteScreenBloc screenBloc;

  TextEditingController startTimeController = new TextEditingController(text: '9:00 AM');
  TextEditingController showTimeController = new TextEditingController(text: '30');
  TextEditingController noteTextController = new TextEditingController();
  FocusNode noteFocus = FocusNode();
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
  }

  Future<Null> _selectDate(BuildContext context, SessionNoteScreenState state) async {
    print('show DatePicker');
    var datePick= await showDatePicker(
      context: context,
      initialDate: state.selectedDate,
      firstDate: DateTime(state.selectedDate.year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (datePick != null && datePick != state.selectedDate ?? DateTime.now()) {
      screenBloc.add(UpdateSelectedDate(selectedDate: datePick));
    }
  }

  Future<Null> _selectTime(BuildContext context, SessionNoteScreenState state) async {
    final TimeOfDay response = await showTimePicker(
      context: context,
      initialTime: state.selectedTime ?? TimeOfDay.now(),
    );
    if (response != null && response != state.selectedTime ?? TimeOfDay.now()) {
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
    noteFocus.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: screenBloc,
      listener: (BuildContext context, SessionNoteScreenState state) async {
        setState(() {
          noteTextController.text = state.noteText;
        });
      },
      child: BlocBuilder<SessionNoteScreenBloc, SessionNoteScreenState>(
        cubit: screenBloc,
        builder: (BuildContext context, SessionNoteScreenState state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Colors.lightBlue[200],
              title: Text(
                widget.sessionId != null ? 'Session Note Detail': 'Add Session Note',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            body: ModalProgressHUD(
              inAsyncCall: state.isLoading,
              child: new GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 16),
                    child: _getBody(state),
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
      padding: EdgeInsets.only(bottom: 24),
      child: Column(
        children: <Widget>[
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //${widget.eventType}
                          Text('Session Note',
                            style: TextStyle(color:Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height:2),
                          Text(
                            widget.selectedStudentName,
                            style: TextStyle(
                              color:Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            DateFormat('EEEE').format(state.selectedDate ?? DateTime.now()).toString(),
                            style: TextStyle(
                              color:Colors.grey,
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
                Container(
                  margin: const EdgeInsets.only(left:11,right:11),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Column(
                              children: <Widget>[
                                Text('Start Time',
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
                          // SizedBox(width:40),
                          Column(
                            children: <Widget>[
                              Text('',
                                  style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold)),
                              Row(
                                children: <Widget>[
                                  InkWell(
                                    child: Container(
                                      height: 44,
                                      width: MediaQuery.of(context).size.width/8.5,
                                      decoration: BoxDecoration(
                                          border: Border.all(color:Colors.grey,width: 0.5),
                                          color: Colors.blue
                                      ),
                                      child: Icon(Icons.remove,color: Colors.white,),
                                    ),
                                    onTap: (){
                                      int finalNumber = state.finalNumber - 1;
                                      screenBloc.add(UpdateFinalNumber(finalNumber: finalNumber));
                                    },
                                  ),
                                  Container(
                                    height: 44,
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width/8.5,
                                    decoration: BoxDecoration(
                                      border: Border.all(color:Colors.grey,width: 0.5),
                                    ),
                                    child:  Text(
                                      state.finalNumber.toString(),
                                      style: TextStyle(
                                        color:Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    child: Container(
                                      height: 44,
                                      width: MediaQuery.of(context).size.width/8.5,
                                      decoration: BoxDecoration(
                                          border: Border.all(color:Colors.grey,width: 0.5),
                                          color: Colors.blue
                                      ),
                                      child: Icon(Icons.add,color: Colors.white,),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        int finalNumber = state.finalNumber + 1;
                                        screenBloc.add(UpdateFinalNumber(finalNumber: finalNumber));
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Flexible(
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
                                    DateFormat.jm().format((state.selectedDate ?? DateTime.now()).add(new Duration(minutes: state.finalNumber))).toString(),//'10:21 PM',
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
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width/2.5,
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Location',
                                  style: TextStyle(fontWeight:FontWeight.bold,fontSize:15),
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        InkWell(
                                          child: Container(
                                            height: 44,
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context).size.width/6.5,
                                            decoration: BoxDecoration(
                                                color: state.isHome ?
                                                  Color(0xff4A4A4A) : Colors.white,
                                                border: Border.all(color:Colors.grey,width: 0.5)
                                            ),
                                            child: Icon(
                                              Icons.home,
                                              color: state.isHome
                                                  ? Colors.white:Color(0xff4A4A4A),
                                            ),
                                          ),
                                          onTap: (){
                                            screenBloc.add(UpdateHomeBuilding(isHome: true));
                                          },
                                        ),
                                        Text(
                                          'Home',
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    Container(width: 2,),
                                    Column(
                                      children: <Widget>[
                                        InkWell(
                                          child: Container(
                                            height: 44,
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context).size.width/6.5,
                                            decoration: BoxDecoration(
                                                color: !state.isHome
                                                    ? Color(0xff4A4A4A): Colors.white,
                                                border: Border.all(color:Colors.grey,width: 0.5)
                                            ),
                                            child: Icon(Icons.school,
                                              color: !state.isHome
                                                  ? Colors.white: Color(0xff4A4A4A),
                                            ),
                                          ),
                                          onTap: (){
                                            screenBloc.add(UpdateHomeBuilding(isHome: false));
                                          },
                                        ),
                                        Text(
                                          'School',
                                          style: TextStyle(
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            width:  MediaQuery.of(context).size.width/2.5,
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Setting',
                                  style: TextStyle(fontWeight:FontWeight.bold, fontSize:15),
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                        children:<Widget>[
                                          InkWell(
                                            child: Container(
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
                                            onTap: (){
                                              screenBloc.add(UpdateSchoolGroup(groupType: 1));
                                            },
                                          ),
                                          Text('Individual',style: TextStyle(fontSize: 11),),
                                        ],
                                    ),
                                    Column(
                                      children:<Widget>[
                                        InkWell(
                                          child: Container(
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
                                          onTap: (){
                                            screenBloc.add(UpdateSchoolGroup(groupType: 2));
                                          },

                                        ),

                                        Text('Group',style: TextStyle(fontSize: 11),),

                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      _sessionTypeWidget(state),
                    ],
                  ),
                )
              ],
            ),

          ),
          //Container(height: 10,),
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

          state.goalsAndProgress ? Container(
            margin: const EdgeInsets.all(5),
            padding:  const EdgeInsets.all(5.0),
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey)
            ),
            child: DropdownButton(
              underline: Container(),
              hint: state.dropDownValue == null
                  ? Text(
                state.longTermGpDropDownList.length > 0  ? state.longTermGpDropDownList[0].longGoalText : '' ,
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
                  return DropdownMenuItem<LongTermGpDropDownModel>(
                    value: val,
                    child: Column(
                      children: <Widget>[
                        Text(val.longGoalText),
                        Container(height: 5,),
                        Divider(height: 10,color: Colors.black,),
                        Container(height: 5,),
                      ],
                    ),
                  );
                },
              ).toList(),
              onChanged: (val) {
                List<SelectedShortTermResultListModel> selectedShortTermResultListModel = [];
                int selectedLtGoalId = val.longGoalID;

                for(int i = 0; i< state.shortTermGpList.length; i++){
                  if(state.shortTermGpList[i].longGoalID == val.longGoalID){
                    selectedShortTermResultListModel.add(
                        SelectedShortTermResultListModel(
                          id: state.shortTermGpList[i].shortgoalid,
                          selectedId: state.shortTermGpList[i].longGoalID,
                          selectedShortgoaltext: state.shortTermGpList[i].shortgoaltext,
                          checkVal: false,
                        )
                    );
                  }
                }
                screenBloc.add(SelectLongTermID(id: selectedLtGoalId));
                screenBloc.add(UpdateSelectedShortTerms(selectedShortTermResultListModel: selectedShortTermResultListModel));
                screenBloc.add(UpdateDropdownValue(longGoalText: val.longGoalText));
              },
            ),
          ) : Container(),
          state.goalsAndProgress ? Container(
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

                    for(int i = 0; i < state.selectedShortTermResultListModel.length; i++){
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
                    screenBloc.add(UpdateSelectedShortTerms(selectedShortTermResultListModel: selectedShortTermResultListModel));
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            ).toList(),
          ),
          ): Container(),
          state.goalsAndProgress ? goalprogressReview(state) : Container(),
          state.goalsAndProgress ? Container(
              margin: const EdgeInsets.all(5),
              child: CheckboxListTile(
                title: Text('Regression Noted?',
                  style: TextStyle(fontSize:18),
                ),
                value: state.checkedValue,
                onChanged: (newValue) {
                  screenBloc.add(UpdateCheckedValue(checkedValue: newValue));
                },
                controlAffinity: ListTileControlAffinity.leading,
              )
          ):Container(),

          SizedBox(height:20),
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
          SizedBox(height:16),
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
                    var height = state.sPcheckListItems.length * 50.0 + MediaQuery.of(context).viewPadding.bottom;
                    if (height > MediaQuery.of(context).size.height / 2.0) {
                      height = MediaQuery.of(context).size.height / 2.0;
                    }
                    return Container(
                      height: height,
                      child: SafeArea(
                        child: ListView.separated(
                          itemCount: state.sPcheckListItems.length,
                          separatorBuilder: (context, index) {
                            return Divider(color: Colors.black38, height: 0, thickness: 0.5,);
                          },
                          itemBuilder: (context, index){
                            return CheckboxListTile(
                              dense: true,
                              title: Text(
                                state.sPcheckListItems[index].categoryTextDetail,
                                style: TextStyle(fontSize: 14),
                              ),
                              value: state.selectedSPIndex == index,
                              onChanged: (newValue) {
                                screenBloc.add(UpdateSPIndex(selectedSPIndex: index));
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
                state.selectedSPIndex > -1 ? state.sPcheckListItems[state.selectedSPIndex].categoryTextDetail: 'Select Your Choice',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_down),
            ),
          ) : Container(),

          SizedBox(height:20),
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
                    return SafeArea(
                      child: ListView.separated(
                        itemCount: state.sIcheckListItems.length,
                        separatorBuilder: (context, index) {
                          return Divider(color: Colors.black38, height: 0, thickness: 0.5,);
                        },
                        itemBuilder: (context, index){
                          return CheckboxListTile(
                            dense: true,
                            title: Text(
                              state.sIcheckListItems[index].categoryTextDetail,
                              style: TextStyle(fontSize: 14),
                            ),
                            value: state.selectedSIIndex == index,
                            onChanged: (newValue) {
                              screenBloc.add(UpdateSIIndex(selectedSIIndex: index));
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
                state.selectedSIIndex > -1 ? state.sIcheckListItems[state.selectedSIIndex].categoryTextDetail: 'Select Your Choice',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_down),
            ),
          ) : Container(),

          SizedBox(height:20),

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
          SizedBox(height:20),
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

          Padding(padding: EdgeInsets.only(top: 16),),
          Container(
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

          state.isLoading ? Container() : Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left:20,right:20,top:2),
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

              },
              controller: noteTextController,
              keyboardType: TextInputType.text,
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
          SizedBox(height:30),
          Container(
            width:  MediaQuery.of(context).size.width/2,
            height: 44,
            decoration: BoxDecoration(
            ),
            child: InkWell(
              onTap: (){
                screenBloc.add(SaveSessionNoteEvent());
              },
              child: Container(
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: Text('Save',style: TextStyle(color:Colors.white),)
              ),
            ),
          ),
          // SizedBox(height:10),
        ],
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

  Widget goalprogressReview(SessionNoteScreenState state){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
          child: Text(
            'Outcomes: ',
          ),
        ),
        Container(
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
          margin: EdgeInsets.only(left:5,right:5, top: 12),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: getSessionColor(state.groupType, state.selectedSessionTypeIndex),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: ListTile(
            onTap: () {
              print(sessionTypeStrings.length);
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SafeArea(
                    maintainBottomViewPadding: true,
                    child: ListView.separated(
                      padding: EdgeInsets.only(top: 16),
                      itemCount: sessionTypeStrings.length,
                      separatorBuilder: (context, index) {
                        return Divider(color: Colors.black38, height: 0, thickness: 0.5,);
                      },
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          dense: true,
                          title: Text(
                            sessionTypeStrings[index],
                            style: TextStyle(fontSize: 16),
                          ),
                          value: state.selectedSessionTypeIndex == index,
                          onChanged: (newValue) {
                            screenBloc.add(UpdateSessionType(selectedSessionTypeIndex: index));
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
              state.selectedSessionTypeIndex > -1 ? sessionTypeStrings[state.selectedSessionTypeIndex]: sessionTypeStrings[0],
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
      ],
    );
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
//    return Container(
//      margin: EdgeInsets.only(left:10 ,right: 10, top: 16),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: state.cAcheckListItems.map((e) {
//          int index = state.cAcheckListItems.indexOf(e);
//          return InkWell(
//            child: Container(
//              height: 110,
//              width: 90,
//              decoration: BoxDecoration(
//                  border: Border.all(color:Colors.grey,width: 0.5)
//              ),
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Icon(
//                    iconsList[index],
//                    color: selectedCAIconIndex == index ? Colors.green:Colors.grey,
//                    size: 40,
//                  ) ,
//                  Text('Made',
//                    style: TextStyle(
//                        color: selectedCAIconIndex == index ? Colors.green:Colors.grey,fontSize: 10
//                    ),
//                  ),
//                  Text('Progress',
//                    style: TextStyle(
//                        color: selectedCAIconIndex == index ? Colors.green:Colors.grey,fontSize: 10
//                    ),
//                  ),
//                ],
//              ) ,
//            ),
//            onTap: (){
//              setState(() {
//                selectedCAIconIndex = index;
//              });
//            },
//          );
//        },
//        ).toList(),
//      ),
//    );
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

//    return Container(
//      margin: EdgeInsets.only(left:10 ,right: 10, top :16),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: state.jAcheckListItems.map((e) {
//          int index = state.jAcheckListItems.indexOf(e);
//          return InkWell(
//            child: Container(
//              height: 110,
//              width: 90,
//              decoration: BoxDecoration(
//                  border: Border.all(color:Colors.grey,width: 0.5)
//              ),
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Icon(
//                    iconsList[index],
//                    color: selectedJAIconIndex == index ? Colors.green:Colors.grey,
//                    size: 40,
//                  ) ,
//                  Text('Made',
//                    style: TextStyle(
//                        color: selectedJAIconIndex == index ? Colors.green:Colors.grey,fontSize: 10
//                    ),
//                  ),
//                  Text('Progress',
//                    style: TextStyle(
//                        color: selectedJAIconIndex == index ? Colors.green:Colors.grey,fontSize: 10
//                    ),
//                  ),
//                ],
//              ) ,
//            ),
//            onTap: (){
//              setState(() {
//                selectedJAIconIndex = index;
//              });
//            },
//          );
//        },
//        ).toList(),
//      ),
//    );
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

  void addSaveNotesApiCall()  {
      screenBloc.add(SaveSessionNoteEvent());
  }

}

class CheckList{
  String title;
  bool checkVal;
  int id;
  CheckList({this.title, this.checkVal, @required this.id});
}
