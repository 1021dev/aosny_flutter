import 'package:aosny_services/api/complete_session_details_api.dart';
import 'package:aosny_services/models/complete_session.dart';
import 'package:aosny_services/models/gp_Listview_model.dart';
import 'package:aosny_services/models/gp_dropdown_model.dart';
import 'package:aosny_services/models/selected_longTerm_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SessionNote extends StatefulWidget {
  final String selectedStudentName;
  final String eventType ;
  final String noteText;
  
  final List<LongTermGpDropDownModel> longTermGpDropDownList ;
  final  List<ShortTermGpModel> shortTermGpList;
  SessionNote({this.selectedStudentName, this.eventType, this.noteText, this.longTermGpDropDownList, this.shortTermGpList});
  @override
  _SessionNoteState createState() => _SessionNoteState();
}

class _SessionNoteState extends State<SessionNote> {

  String noteText="",sessionDateTime="",sessionTime="",duration="",sessionEndTime="",
  locationHomeOrSchool="",settingsGroupOrNot="",sessionType="";

  CompleteSessionApi completeSessionApi = new CompleteSessionApi();
  CompleteSessionNotes response;
  bool settingPersonSelectedbutton = true;
  bool settingGroupSelectedButton = false;
  bool locHomeSelectedButton= true;
  bool locBuildingSelectedButton = false;
  String _dropDownValue;
  bool sPSelected = true;
  bool sPmSelected = false;
  bool sASelected = false;
  bool pASelected = false;
  bool sUSelected = false;
  bool checkedValue = false;
  TextEditingController startTimeController = new TextEditingController(text: "9:00 AM");
  TextEditingController showTimeController = new TextEditingController(text: "30");
  DateTime selectedDate;
  DateTime toPassDate,endDateTime;
  String showDate;
  bool isSelectecDate = false;

  bool colorGPMadeProgress = true;
  bool colorGPpartialProgress = false;
  bool colorGPNoProgress = false;


  bool goalsAndProgress = false;
  bool activities = false;
  bool socialPragmaics = false;
  bool seitIntervention = false;
  bool competedActivites = false;
  bool jointAttentionEyeContact = false;
  bool _isLoading = false;

  // jointAttentionOrEyeContactReview completedActivityReview

  bool colorCAMadeProgress = true;
  bool colorCApartialProgress = false;
  bool colorCANoProgress = false;

  bool colorJAPMadeProgress = true;
  bool colorJApartialProgress = false;
  bool colorJANoProgress = false;

  TimeOfDay selectedTime ;
   int finalNumber= 30;


  List<String> listValue =[
   "Select Long Term Goal",
   "Given the aid of verbal and visual cues",
   "Given the aid of modeling verbal and visual cues",
   "Given the aid of modeling verbal and visual cues",
  ];
  List<GPCheckList> gPcheckListItems =[
   GPCheckList(
     title: "During playtime, shmuel will initiate and intraction with at least one peer and sustain the intraction with decreasing prompts 4/5 times",
     checkVal: false
    ),
    GPCheckList(
     title: "Shmuel will demonstrate with associative play skills with 2-3 peers without prompts 4/5 trials",
     checkVal: false
    ),
    GPCheckList(
     title: "Shmuel will spontaneously play with other children nad verbally communicate while doing it, 4/5 times",
     checkVal: false
    ),
    GPCheckList(
     title: "Shmuel will join peer activity initiated by other children with decreasing prompts on 4/5 times",
     checkVal: false
    ),
    GPCheckList(
     title: "Shmuel will join teacher initiated activity in an appropiate manner with decreasing prompts on 4/5 times",
     checkVal: false
    ),
    GPCheckList(
     title: "Shmuel will maintain eye contact while conversing with peers with verbal cues, 4/5",
     checkVal: false
    ),
    GPCheckList(
     title: "Shmuel will share and/or take turns with other following modeling, prompts and positive reinforcement with decreasing prompts in 4/5 trials",
     checkVal: false
    ),
  ];

  List<SPCheckList>  sPcheckListItems = [
   SPCheckList(
     title: "Followed Rules & Limitations",
     checkVal: false
   ),
   SPCheckList(
     title: "Needed help following rules & limitations",
     checkVal: false
   ),
   SPCheckList(
     title: "Shared with friends",
     checkVal: false
   ),
   SPCheckList(
     title: "Intiated intraction with peers",
     checkVal: false
   ),
   SPCheckList(
     title: "Sustained a social intraction with peers",
     checkVal: false
   ),
   SPCheckList(
     title: "Engaged in conversation with peers",
     checkVal: false
   ),
   SPCheckList(
     title: "Spontanously played with peers & engaged in conversation",
     checkVal: false
   ),
  ];

  List<SICheckList> sIcheckListItems =[
    SICheckList(
     title: "Modeling appropiated behavior",
     checkVal: false
   ),
    SICheckList(
     title: "Visual and Verbal prompts",
     checkVal: false
   ),
    SICheckList(
     title: "Encouragement",
     checkVal: false
   ),

    SICheckList(
     title: "Positive reinforcement",
     checkVal: false
   ),
    SICheckList(
     title: "Reminder of appropriate problem solving strategies",
     checkVal: false
   ),
    SICheckList(
     title: "Reminder of appropriate copying strategies",
     checkVal: false
   ),
    SICheckList(
     title: "Simplified directions",
     checkVal: false
   ),
    SICheckList(
     title: "Repetitions",
     checkVal: false
   ),
    SICheckList(
     title: "Reocusing",
     checkVal: false
   ),
    SICheckList(
     title: "sensory input",
     checkVal: false
   ),

  ];

  List<SelectedShortTermResultListModel> selectedShortTermResultListModel = List<SelectedShortTermResultListModel>() ;

  @override
  void initState() {

    callCompleteSessionApi();
    
        
    
       showDate =  DateFormat('EEEE, MMMM d').format(DateTime.now()).toString();
       selectedTime = new TimeOfDay.now();
       selectedDate = DateTime.now();
       //print("selectedDate::"+selectedDate.toString());
        super.initState();
    
        for(int i = 0; i< widget.shortTermGpList.length; i++){
    
           if(widget.shortTermGpList[i].longGoalID== widget.longTermGpDropDownList[0].longGoalID){
                            setState(() {
                              selectedShortTermResultListModel.add(SelectedShortTermResultListModel(
                                selectedId: widget.shortTermGpList[i].longGoalID,
                                selectedShortgoaltext: widget.shortTermGpList[i].shortgoaltext,
                                checkVal: false
                              ));
                            });
                          }
                      
        
                   }
    
                 //  print("initState,selectedShortTermResultListModel.length"+selectedShortTermResultListModel.length.toString());
    
       
      }
    
      static var  currentTime = DateTime(  DateTime.now().year, DateTime.now().month, DateTime.now().day,  TimeOfDay.now().hour, TimeOfDay.now().minute);
      
      var pickedTime = DateFormat.jm().format(currentTime);
    
      Future<Null> _selectTime(BuildContext context) async {
        final TimeOfDay response = await showTimePicker(
          context: context,
          initialTime:  TimeOfDay.now(),
        );
        if (response != null && response != pickedTime) {
          final dt = DateTime( DateTime.now().year, DateTime.now().month, DateTime.now().day, response.hour, response.minute);
          final format = DateFormat.jm();
          setState(() {
            pickedTime = format.format(dt);
            print("pickedTime :$pickedTime");
          });
        }
      } 
     
      
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: ModalProgressHUD(
            inAsyncCall: _isLoading,
            child: Container(
            padding: const EdgeInsets.only(left:5,right:5, top:25),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                 Container(
                   padding: const EdgeInsets.only(left:5,right:5,),
                   height: MediaQuery.of(context).size.height/1.2,
                   width: MediaQuery.of(context).size.width,
                   child:Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       InkWell(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height/20,
                            width: MediaQuery.of(context).size.width/5.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text("Back",style:TextStyle(color: Colors.white)),
                          ),
                        ),
                        Container( 
                         height: MediaQuery.of(context).size.height/7,
                         width: MediaQuery.of(context).size.width,
                         child: Row( 
    
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: <Widget>[ 
    
                             Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //${widget.eventType}
                                 Text("Session Note",
                                 style: TextStyle(color:Colors.black,
                                    fontWeight: FontWeight.bold),
                                  ),
                                 SizedBox(height:2),
                                 Text(widget.selectedStudentName,
                                   style: TextStyle(color:Colors.black,
                                   fontSize: 25,fontWeight: FontWeight.bold)
                                  ),
                                 
                                ],
                             ),
                            
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[

                                 sessionDateTime==""?Text(""):Text(
                                   DateFormat('EEEE').format(toPassDate).toString(),
                                 style: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold),
                                 
                                 ),
                                 SizedBox(height:2),
                                 
                                  InkWell(
                                     child: Container(
                                      alignment: Alignment.center,
                                      height:MediaQuery.of(context).size.height/13,
                                      width: MediaQuery.of(context).size.width/7,
                                      decoration: BoxDecoration(
                                       
                                       border: Border.all(color:Colors.blue)
                                      ),
                                      child:Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[


                                        sessionDateTime == "" ? Text(""):Text( DateFormat('d').format(toPassDate).toString(),
                                          style: TextStyle(color:Colors.blue,fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                          
                                          
                                          ),
    
                                          sessionDateTime== "" ? Text(""):Text( DateFormat('MMM').format(toPassDate).toString().toUpperCase(),
                                          style: TextStyle(color:Colors.blue,
                                          fontWeight: FontWeight.normal),),
                                        ],
                                      )
                                    ),
                                    onTap: () async {
                                      /*final datePick= await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2018),
                                        lastDate: DateTime(2030),
                                      );
                                      if(datePick!=null && datePick!=selectedDate){
                                        setState(() {
                                         selectedDate=datePick; 
                                          isSelectecDate= true;
                                        
                                         
                                        });
                                      }*/
                                    },
                                  )
                                 
                                ],
                             ),
                           ],
                         ),
                        ),
                       Container(
                         height: MediaQuery.of(context).size.height/1.6,
                         margin: const EdgeInsets.only(left:11,right:11),
                         child: Column(
                           children: <Widget>[
                             Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text("Start Time",
                                      style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold)),
                                      InkWell(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: MediaQuery.of(context).size.height/20,
                                          width: MediaQuery.of(context).size.width/4,
                                          decoration: BoxDecoration(
                                            border: Border.all(color:Colors.grey)
                                          ),
                                          //pickedTime.toString()
                                          child: sessionTime == "" ? Text(""): Text(sessionTime)
                                          
                                        ),
                                        onTap: (){
                                          _selectTime(context);
                                          
    
                                        },
                                      )
                                      
                                    ],
                                  ),
                                  // SizedBox(width:40),
                                  Column(
                                    children: <Widget>[
                                        Text("",
                                      style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold)),
                                     
                                         Row(
                                          children: <Widget>[
                                            InkWell(
                                              child: Container(
                                                 width: MediaQuery.of(context).size.width/8.5,
                                                  height:  MediaQuery.of(context).size.height/18,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color:Colors.grey,width: 0.5),
                                                  color: Colors.blue
                                                ),
                                                child: Icon(Icons.remove,color: Colors.white,),
                                              ),
                                              onTap: (){
                                                setState(() {
                                                   finalNumber = finalNumber - 1;
                                                });
                                              },
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                               width: MediaQuery.of(context).size.width/8.5,
                                                height:  MediaQuery.of(context).size.height/18,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color:Colors.grey,width: 0.5),
                      
                                                ),
                                              child: duration == "" ? Text("") : Text(duration)
                                              
                                            ),
                                            InkWell(
                                              child: Container(
                                                width: MediaQuery.of(context).size.width/8.5,
                                                  height:  MediaQuery.of(context).size.height/18,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color:Colors.grey,width: 0.5),
                                                  color: Colors.blue
                                                ),
                                                child: Icon(Icons.add,color: Colors.white,),
                                              ),
                                              onTap: (){
                                                setState(() {
                                                  finalNumber = finalNumber +1;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      // )
                                      
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text("End Time",
                                      style: TextStyle(color:Colors.grey,fontSize: 16,fontWeight: FontWeight.bold)),
                                     sessionEndTime ==""?Text(""): Text(sessionEndTime,
                                      style: TextStyle(color:Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                                      
                                    ],
                                  ),
                                ],
                              ) ,
    
                              SizedBox(height: 30,),
    
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                   
                                    width: MediaQuery.of(context).size.width/2.5,
                                    height:  MediaQuery.of(context).size.height/7,
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Location",
                                        style: TextStyle(fontWeight:FontWeight.bold,fontSize:15),
                                        ),
                                        Row(
                                         children: <Widget>[
    
                                           Column(
                                             children: <Widget>[ 
    
    
                                           InkWell(
                                             child: Container(
                                               
                                               alignment: Alignment.center,
                                               width: MediaQuery.of(context).size.width/6.5,
                                               height:  MediaQuery.of(context).size.height/13,
                                               decoration: BoxDecoration(
                                                 color: locHomeSelectedButton ? 
                                                 Color(0xff4A4A4A) :Colors.white,
                                                 border: Border.all(color:Colors.grey,width: 0.5)
                                               ),
                                               child: Icon(Icons.home,
                                               color: locHomeSelectedButton
                                               ? Colors.white:Color(0xff4A4A4A),
                                               ),
                                             ),
                                             onTap: (){
                                               setState(() {
                                                //locHomeSelectedButton = true;
                                                 //locBuildingSelectedButton = false;
                                               });
                                               
                                             },
                                             
                                             
                                            ),
    
                                            Text("Home",style: TextStyle(fontSize: 11),),
                                             ],
                                        ),

                                        Container(width: 2,),
    
                                        Column(
                                          children: <Widget>[
    
                                          InkWell(
                                             child: Container(
                                               alignment: Alignment.center,
                                               width: MediaQuery.of(context).size.width/6.5,
                                               height:  MediaQuery.of(context).size.height/13,
                                               decoration: BoxDecoration(
                                                 color: locBuildingSelectedButton
                                                 ?Color(0xff4A4A4A):Colors.white,
                                                 border: Border.all(color:Colors.grey,width: 0.5)
                                               ),
                                               child: Icon(Icons.school,
                                               color: locBuildingSelectedButton
                                               ?Colors.white:Color(0xff4A4A4A),
                                               ),
                                             ),
                                             onTap: (){
                                                setState(() {
                                                 //locBuildingSelectedButton = true;
                                                 //locHomeSelectedButton= false;
                                               });
                                             },
                                             
                                            ),
                                            
                                            Text("School",style: TextStyle(fontSize: 11),),
    
                                          ],
                                        ),
                                         ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width:  MediaQuery.of(context).size.width/2.5,
                                    height: MediaQuery.of(context).size.height/7,
                                    child:Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Setting",
                                        style: TextStyle(fontWeight:FontWeight.bold, fontSize:15),
                                        ),
                                        Row(
                                         children: <Widget>[
    
                                           Column(
    
                                             children:<Widget>[
    
                                           InkWell(
                                             child: Container(
                                               alignment: Alignment.center,
                                               width: MediaQuery.of(context).size.width/6.5,
                                               height:  MediaQuery.of(context).size.height/13,
                                               decoration: BoxDecoration(
                                                 color: settingPersonSelectedbutton
                                                 ?Color(0xff4A4A4A):Colors.white,
                                                 border: Border.all(color:Colors.grey,width: 0.5)
                                               ),
                                               child: Icon(Icons.person,
                                               color: settingPersonSelectedbutton
                                               ?Colors.white:Color(0xff4A4A4A),
                                               ),
                                             ),
                                             onTap: (){
                                               setState(() {
                                                 //settingPersonSelectedbutton = true;
                                                 //settingGroupSelectedButton = false;
                                               });
                                             },
                                             
                                            ),
                                     Text("Individual",style: TextStyle(fontSize: 11),),
    
                                             ]
                                           ),
    
                                       Column(
                                         children:<Widget>[
    
                                          InkWell(
                                             child: Container(
                                                alignment: Alignment.center,
                                               width: MediaQuery.of(context).size.width/6.5,
                                               height:  MediaQuery.of(context).size.height/13,
                                               decoration: BoxDecoration(
                                                 color: settingGroupSelectedButton
                                                 ?Color(0xff4A4A4A):Colors.white,
                                                 border: Border.all(color:Colors.grey,width: 0.5)
                                               ),
                                               child: Icon(Icons.group,
                                               color: settingGroupSelectedButton
                                               ?Colors.white:Color(0xff4A4A4A),
                                               ),
                                             ),
                                             onTap: (){
                                               setState(() {
                                                 //settingGroupSelectedButton = true;
                                                 //settingPersonSelectedbutton = false;
                                               });
    
                                             },
                                             
                                            ),
    
                                           Text("Group",style: TextStyle(fontSize: 11),),
     
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
                              Container(
                                margin: const EdgeInsets.only(left:5,right:5),
                                height:  MediaQuery.of(context).size.height/3.1,
                                width: MediaQuery.of(context).size.width,
                               
                                child: Column(
                                  children: <Widget>[
                                   InkWell(
                                      child: Container(
                                      
                                       padding: const EdgeInsets.only(left:10),
                                       alignment: Alignment.centerLeft,
                                      
                                        height: MediaQuery.of(context).size.height/20,
                                       child: Text("Service Provided",
                                         style: TextStyle(
                                           color: sPSelected?Colors.white:Colors.black,
                                         ),
                                       ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color:Colors.grey,width: 0.5),
                                         color: sPSelected?Colors.blue:Colors.white,
                                      ),
                                      ),
                                      onTap: (){
                                       /* setState(() {
                                          sPSelected = true;
                                          sPmSelected = false;
                                          sASelected = false;
                                          pASelected = false;
                                          sUSelected = false;
                                        }); */
                                      
                                      },
                                   ),
                                    // Divider(color:Colors.grey),
                                    InkWell(
                                      child: Container(
                                      //  margin: const EdgeInsets.all(5),
                                       padding: const EdgeInsets.only(left:10),
                                       alignment: Alignment.centerLeft,
                                        height: MediaQuery.of(context).size.height/20,
                                       
                                       child: Text("Service Provided, Makeup",
                                          style: TextStyle(
                                           color: sPmSelected?Colors.white:Colors.black,
                                         ),
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(color:Colors.grey,width: 0.5),
                                          color: sPmSelected?Colors.blue:Colors.white,
                                        )
                                      ),
                                      onTap: (){
                                       /* setState(() {
                                          sPSelected = false;
                                          sPmSelected = true;
                                          sASelected = false;
                                          pASelected = false;
                                          sUSelected = false;
                                        });*/
                                      },
                                    ),
                                    // Divider(color:Colors.grey),
                                    InkWell(
                                      child: Container(
                                      //  margin: const EdgeInsets.all(5),
                                       padding: const EdgeInsets.only(left:10),
                                       alignment: Alignment.centerLeft,
                                       height: MediaQuery.of(context).size.height/20,
                                        
                                       child: Text("Student Absent",
                                         style: TextStyle(
                                           color: sASelected?Colors.white:Colors.black,
                                         ),
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(color:Colors.grey,width: 0.5),
                                          color: sASelected?Colors.blue:Colors.white,
                                        ),
                                      ),
                                      onTap: (){
                                       /* setState(() {
                                          sPSelected = false;
                                          sPmSelected = false;
                                          sASelected = true;
                                          pASelected = false;
                                          sUSelected = false;
                                        });*/
                                      },
                                    ),
                                   
                                    InkWell(
                                      child: Container(
                                      //  margin: const EdgeInsets.all(5),
                                       padding: const EdgeInsets.only(left:10),
                                       alignment: Alignment.centerLeft,
                                       height: MediaQuery.of(context).size.height/20,
                                        
                                       child: Text("Provider Absent",
                                         style: TextStyle(
                                           color: pASelected?Colors.white:Colors.black,
                                         ),
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(color:Colors.grey,width: 0.5),
                                          color: pASelected?Colors.blue:Colors.white,
                                        ),
                                      ),
                                      onTap: (){
                                        /* setState(() {
                                          sPSelected = false;
                                          sPmSelected = false;
                                          sASelected = false;
                                          pASelected = true;
                                          sUSelected = false;
                                        });*/
                                      },
                                    ),
                                   
                                    InkWell(
                                      child: Container(
                                      //  margin: const EdgeInsets.all(5),
                                       padding: const EdgeInsets.only(left:10),
                                       alignment: Alignment.centerLeft,
                                        height: MediaQuery.of(context).size.height/20,
                                        
                                        child: Text("Student unavailable",
                                         style: TextStyle(
                                           color: sUSelected?Colors.white:Colors.black,
                                         ),
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(color:Colors.grey,width: 0.5),
                                          color: sUSelected?Colors.blue:Colors.white,
                                        ),
                                      ),
                                      onTap: (){

                                         /*setState(() {
                                          sPSelected = false;
                                          sPmSelected = false;
                                          sASelected = false;
                                          pASelected = false;
                                          sUSelected = true;
                                        });*/
                                        
                                      },
                                    ),
                                    
                                  ],
                                ),
                              )
                           ],
                         ),
                       )
                     ],
                   ),
                   
                 ),
                 //Container(height: 10,),

                 GestureDetector(
                   onTap: (){
    
                    setState(() {
    
                      goalsAndProgress = !goalsAndProgress;
                      
                    });
    
    
    
                   },
                 child:Container(
                    height: MediaQuery.of(context).size.height/20,
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xff4A4A4A),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
    
                        Container(
    
                        alignment: Alignment.center,
                       child: Text("Goals & Progress", 
                       style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)
    
                    ),),
    
    
                      Container(
                       alignment: Alignment.centerRight,
                       
                     child:goalsAndProgress?Icon(Icons.arrow_drop_down,
                        color:Colors.white,
                        size: 35,
                      ) :Icon(Icons.arrow_right,
                        color:Colors.white,
                        size: 35,
                      ),),
                      ]
                    )
                    
                    
                 ),),
                 //SizedBox(height:MediaQuery.of(context).size.height/20),
                 
                goalsAndProgress?Container(
                    margin: const EdgeInsets.all(5),
                    //padding:  const EdgeInsets.all(5.0),
                    height: MediaQuery.of(context).size.height/20,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey)
                    ),
                    child: DropdownButton(
                      
                      underline: Container(
                        //height: 2,
                        //color: Colors.deepPurpleAccent,
                      ),
                      hint: _dropDownValue == null
                      ? Text(widget.longTermGpDropDownList[0].longGoalText,maxLines: 1,)
                      : Text(
                        _dropDownValue,maxLines: 1,
                        style: TextStyle(color: Colors.black),
                      ),
                      isExpanded: true,
                      // elevation: 10,
                      iconSize: 30.0,
    
                      style: TextStyle(color: Colors.black),
                      items: 
                      widget.longTermGpDropDownList.map(
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
                        print("val val val  val val :${val.longGoalID}");
                        selectedShortTermResultListModel.clear();
                        
                        for(int i = 0; i< widget.shortTermGpList.length; i++){
                          
                          if(widget.shortTermGpList[i].longGoalID == val.longGoalID){
                            setState(() {
                              selectedShortTermResultListModel.add(SelectedShortTermResultListModel(
                                selectedId: widget.shortTermGpList[i].longGoalID,
                                selectedShortgoaltext: widget.shortTermGpList[i].shortgoaltext,
                                checkVal: false
                              ));
                            });
                          }
                        }
                       
    
                        setState(
                          () {
                          
                            _dropDownValue = val.longGoalText;
                          },
                        );
                      },
                    //  selectedItemBuilder: (context){
                      
                    //   },
                    ),
                  ):Container(),
    
                goalsAndProgress?Container(
                  margin: const EdgeInsets.only(left:5,right:5),
                height: selectedShortTermResultListModel.length*98.0, //MediaQuery.of(context).size.height/1.6,
               width: MediaQuery.of(context).size.width, 
                 
    
                   child: 
                   
                  ListView.builder(
                   
                    itemCount: selectedShortTermResultListModel.length,
                    physics: const NeverScrollableScrollPhysics(),
                    //scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                      return Column(
                       children: <Widget>[
                         Container(
                           //height: 60,
                           //height: MediaQuery.of(context).size.height/12,
                            decoration: BoxDecoration(
                              // border: Border.all(color:Colors.grey,width: 0.5)
                            ),
                            child: CheckboxListTile(
                              title: Text(selectedShortTermResultListModel[index].selectedShortgoaltext,
                               //style: TextStyle(fontSize: MediaQuery.of(context).size.height/60),
                               style: TextStyle(fontSize: 13),
                              
    
                              ),
                              value: selectedShortTermResultListModel[index].checkVal,
                              onChanged: (newValue) { 
                                setState(() {
                                  selectedShortTermResultListModel[index].checkVal = newValue;
                                });
                               },
                              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                            )
                          ),
                          Divider(color: Colors.black,)                  
                        ],
                      );
                    },  
                  ),
                ):Container(),
    
    
               goalsAndProgress?goalprogressReview():Container(),
               goalsAndProgress?Container(
                  height: MediaQuery.of(context).size.height/14,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color:Colors.grey)
                  ),
                  child: CheckboxListTile(
                    title: Text("Regression Noted?",
                      style: TextStyle(fontSize:12),
                    ),
                    value: checkedValue,
                    onChanged: (newValue) { 
                      setState(() {
                            checkedValue = newValue;
                      });
                      },
                    controlAffinity: ListTileControlAffinity.leading, 
                  )
                ):Container(),
               
                SizedBox(height:20),
                GestureDetector(
                  onTap: (){
                    setState(() {
    
                      activities =  !activities;
                      
                    });
    
                  },
                child:Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height/20,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff4A4A4A),
                  child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
    
                        Container(
    
                        alignment: Alignment.center,
                       child: Text("Activities", 
                       style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)
    
                    ),),
    
    
                      Container(
                       alignment: Alignment.centerRight,
                       
                     child:activities?Icon(Icons.arrow_drop_down,
                        color:Colors.white,
                        size: 35,
                      ) :Icon(Icons.arrow_right,
                        color:Colors.white,
                        size: 35,
                      ),),
                      ]
                    ), ///Text("Activities", 
                 
    
                  ),),
              
                
    
                activities? firstRowEditWidget():Container(),
                SizedBox(height:20),
                activities? secondRowEditWidget():Container(),
                GestureDetector(
                  onTap: (){
                    setState(() {
    
                      socialPragmaics =  !socialPragmaics;
                      
                    });
    
                  },
                child:Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height/20,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff4A4A4A),
                  child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
    
                        Container(
    
                        alignment: Alignment.center,
                       child: Text("Social Pragmatics", 
                       style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)
    
                    ),),
    
    
                      Container(
                       alignment: Alignment.centerRight,
                       
                     child:socialPragmaics?Icon(Icons.arrow_drop_down,
                        color:Colors.white,
                        size: 35,
                      ) :Icon(Icons.arrow_right,
                        color:Colors.white,
                        size: 35,
                      ),),
                      ]
                    ),  
                 
    
                  ),),
                
    
    
               socialPragmaics?Container(
                  margin: const EdgeInsets.only(left:5,right:5),
                  height:  MediaQuery.of(context).size.height/1.6,
                  width: MediaQuery.of(context).size.width,
                 
                  child: ListView.builder(
                    itemCount: sPcheckListItems.length,
                     physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      return Column(
                       children: <Widget>[
                         Container(
                           height: MediaQuery.of(context).size.height/15,
                            decoration: BoxDecoration(
                              // border: Border.all(color:Colors.grey,width: 0.5)
                            ),
                            child: CheckboxListTile(
                              title: Text(sPcheckListItems[index].title,
                               style: TextStyle(fontSize: MediaQuery.of(context).size.height/60),
                              ),
                              value: sPcheckListItems[index].checkVal,
                              onChanged: (newValue) { 
                                setState(() {
                                  sPcheckListItems[index].checkVal = newValue;
                                });
                               },
                              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                            )
                          ),
                         Divider(color: Colors.black,)                  
                        ],
                      );
                    }
                  ),
                ):Container(),
    
                 SizedBox(height:20),
                GestureDetector(
                  onTap: (){
                    setState(() {
    
                      seitIntervention =  !seitIntervention;
                      
                    });
    
                  },
                child:Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height/20,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff4A4A4A),
                  child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
    
                        Container(
    
                        alignment: Alignment.center,
                       child: Text("SEIT Intervention", 
                       style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)
    
                    ),),
    
    
                      Container(
                       alignment: Alignment.centerRight,
                       
                     child:seitIntervention?Icon(Icons.arrow_drop_down,
                        color:Colors.white,
                        size: 35,
                      ) :Icon(Icons.arrow_right,
                        color:Colors.white,
                        size: 35,
                      ),),
                      ]
                    ), ///Text("Activities", 
                 
    
                  ),),
    
                  
                 
    
    
                 seitIntervention?Container(
                  margin: const EdgeInsets.only(left:5,right:5),
                  height:  MediaQuery.of(context).size.height/1.2,
                  width: MediaQuery.of(context).size.width,
                 
                  child: ListView.builder(
                    itemCount: sIcheckListItems.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      return Column(
                       children: <Widget>[
                         Container(
                           alignment: Alignment.topCenter,
                           height: MediaQuery.of(context).size.height/15,
                            // padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              // color: Colors.red,
                              // border: Border.all(color:Colors.grey,width: 0.5)
                            ),
                            child: CheckboxListTile(
                              title: Text(sIcheckListItems[index].title,
                               style: TextStyle(fontSize:MediaQuery.of(context).size.height/60),
                              ),
                              value: sIcheckListItems[index].checkVal,
                              onChanged: (newValue) { 
                                setState(() {
                                  sIcheckListItems[index].checkVal = newValue;
                                });
                               },
                              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                            )
                          ),
                          Divider(color:Colors.black)                 
                        ],
                      );
                    }
                  ),
                ):Container(),
    
                 SizedBox(height:20),
    
                GestureDetector(
                  onTap: (){
                    setState(() {
    
                      competedActivites =  !competedActivites;
                      
                    });
    
                  },
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height/20,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff4A4A4A),
                  child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
    
                        Container(
    
                       alignment: Alignment.center,
                       child: Text("Completed activity", 
                       style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)
    
                    ),),
    
    
                      Container(
                       alignment: Alignment.centerRight,
                       
                     child:competedActivites?Icon(Icons.arrow_drop_down,
                        color:Colors.white,
                        size: 35,
                      ) :Icon(Icons.arrow_right,
                        color:Colors.white,
                        size: 35,
                      ),),
                      ]
                    ), ///Text("Activities", 
                 
    
                  ),),
    
    
                 
                competedActivites?completedActivityReview():Container(),
                
    
                 SizedBox(height:20),
    
                 GestureDetector(
                  onTap: (){
                    setState(() {
    
                      jointAttentionEyeContact =  !jointAttentionEyeContact;
                      
                    });
    
                  },
                child:Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height/20,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff4A4A4A),
                  child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
    
                        Container(
    
                        alignment: Alignment.center,
                       child: Text("Joint Attention / Eye Contact", 
                       style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)
    
                    ),),
    
    
                      Container(
                       alignment: Alignment.centerRight,
                       
                     child:jointAttentionEyeContact?Icon(Icons.arrow_drop_down,
                        color:Colors.white,
                        size: 35,
                      ) :Icon(Icons.arrow_right,
                        color:Colors.white,
                        size: 35,
                      ),),
                      ]
                    ), ///Text("Activities", 
                 
    
                  ),),
                 /* Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height/25,
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xff4A4A4A),
                    child: Text("Joint Attention / Eye Contact", 
                    style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)
                    ),
                 ),*/
                jointAttentionEyeContact? jointAttentionOrEyeContactReview():Container(),
                  
                 Container(
                    alignment: Alignment.bottomLeft,
                    height: MediaQuery.of(context).size.height/25,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left:20,right:20,top:5),
                    child:Text("Notes: (Optional)",
                    style: TextStyle(
                      fontSize:MediaQuery.of(context).size.height/60,
                      fontWeight: FontWeight.normal
                      
                     ),)   
                 ),
                   
                Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(left:20,right:20,top:2),
                    height: MediaQuery.of(context).size.height/3.5,
                    decoration:BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey,width: 1)
                    ) ,
                    child: TextField(
                      maxLines: 5,
                      
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        enabled: false,
                        hintText: noteText,
                         //widget.noteText == '' ? "Placeholder":widget.noteText,
                          hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.height/45,color: Colors.black),
                        border: InputBorder.none
                      ),
                      onChanged: (val){
                          setState(() {
                          
                          });
                      },
                    ),
                  ),
                 SizedBox(height:30),
                  /*Container(
                    height: MediaQuery.of(context).size.height/20,
                    width:  MediaQuery.of(context).size.width/2,
                    decoration: BoxDecoration(
                    ),
                    child: InkWell(
                      onTap: (){},
                      child: Container(
                        color: Colors.blue,
                        alignment: Alignment.center,
                        child: Text("Save",style: TextStyle(color:Colors.white),)
                      ),
                    ),
                  ), */
                  // SizedBox(height:10),
                ],
              ),
            ),
          ),
          ),
        );
      }
    
    
    
    
      Widget goalprogressReview(){
        return Container(
          margin: EdgeInsets.only(left:10 ,right: 10),
          height: MediaQuery.of(context).size.height/6,
          
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
               child: Container(
                height: 110,
                  width: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color:Colors.grey,width: 0.5)
                  ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.check_circle,
                        color:colorGPMadeProgress?Colors.green:Colors.grey,
                        size: 40,
                      ) ,
    
                      Container(height: 5),
    
    
                      Text("Made",
                        style: TextStyle(
                            color:colorGPMadeProgress?Colors.green:Colors.grey,fontSize: 10
                        ),
                      ),
                      Text("Progress",
                        style: TextStyle(
                            color:colorGPMadeProgress?Colors.green:Colors.grey,fontSize: 10
                        ),
                      ),
                    ],
                  ) ,
                ),
                onTap: (){
                  setState(() {
                    colorGPMadeProgress = true;
                    colorGPpartialProgress = false;
                    colorGPNoProgress = false;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 110,
                  width: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color:Colors.grey,width: 0.5)
                  ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.star_half,
                        color:colorGPpartialProgress?Colors.green:Colors.grey,
                        size: 40,
                      ) ,
    
                      Container(height: 5),
                    
                      Text("Partial",
                        style: TextStyle(
                            color:colorGPpartialProgress?Colors.green:Colors.grey,fontSize: 10
                          ),
                      ),
                        Text("Progress",
                           style: TextStyle(
                            color:colorGPpartialProgress?Colors.green:Colors.grey,fontSize: 10
                          ),
                        )
                    ],
                  )
                ),
                onTap: (){
                  setState(() {
                    colorGPMadeProgress = false;
                    colorGPpartialProgress = true;
                    colorGPNoProgress = false;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 110,
                  width: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color:Colors.grey,width: 0.5)
                  ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.not_interested,
                        color:colorGPNoProgress?Colors.green:Colors.grey,
                        size: 40,
                      ) ,
    
                      Container(height: 5),
                        Text("No",
                         style: TextStyle(
                            color:colorGPNoProgress?Colors.green:Colors.grey,fontSize: 10
                          ),
                        ),
                      Text("Progress",
                        style: TextStyle(
                            color:colorGPNoProgress?Colors.green:Colors.grey,fontSize: 10
                          ),
                      )
                    ],
                  )
                ),
                 onTap: (){
                  setState(() {
                    colorGPMadeProgress = false;
                    colorGPpartialProgress = false;
                    colorGPNoProgress = true;
                  });
                },
              ),
    
              
            ],
          ),
          
          
        );
      }
    
    
      Widget completedActivityReview(){
        return Container(
          margin: EdgeInsets.only(left:10 ,right: 10),
          height: MediaQuery.of(context).size.height/6,
          
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
               child: Container(
                height: 110,
                  width: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color:Colors.grey,width: 0.5)
                  ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.check_circle,
                        color:colorCAMadeProgress?Colors.green:Colors.grey,
                        size: 40,
                      ) ,
                      Text("Made",
                        style: TextStyle(
                            color:colorCAMadeProgress?Colors.green:Colors.grey,fontSize: 10
                          ),
                      ),
                      Text("Progress",
                        style: TextStyle(
                            color:colorCAMadeProgress?Colors.green:Colors.grey,fontSize: 10
                          ),
                      ),
                    ],
                  ) ,
                ),
                onTap: (){
                  setState(() {
                     colorCAMadeProgress = true;
                     colorCApartialProgress = false;
                     colorCANoProgress = false;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 110,
                  width: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color:Colors.grey,width: 0.5)
                  ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.star_half,
                        color:colorCApartialProgress?Colors.green:Colors.grey,
                        size: 40,
                      ) ,
                      Text("Partial",
                        style: TextStyle(
                            color:colorCApartialProgress?Colors.green:Colors.grey,fontSize: 10
                          ),
                      ),
                        Text("Progress",
                          style: TextStyle(
                            color:colorCApartialProgress?Colors.green:Colors.grey,fontSize: 10
                          ),
                        )
                    ],
                  )
                ),
                onTap: (){
                  setState(() {
                     colorCAMadeProgress = false;
                     colorCApartialProgress = true;
                     colorCANoProgress = false;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 110,
                  width: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color:Colors.grey,width: 0.5)
                  ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.not_interested,
                        color:colorCANoProgress?Colors.green:Colors.grey,
                        size: 40,
                      ) ,
                        Text("No",
                          style: TextStyle(
                            color:colorCANoProgress?Colors.green:Colors.grey,fontSize: 10
                          ),
                        ),
                      Text("Progress",
                        style: TextStyle(
                          color:colorCANoProgress?Colors.green:Colors.grey,fontSize: 10
                        ),
                      )
                    ],
                  )
                ),
                 onTap: (){
                  setState(() {
                    colorCAMadeProgress = false;
                     colorCApartialProgress = false;
                     colorCANoProgress = true;
                  });
                },
              ), 
            ],
          ),
          
        );
      }
    
    
      Widget jointAttentionOrEyeContactReview(){
        return Container(
          margin: EdgeInsets.only(left:10 ,right: 10),
          height: MediaQuery.of(context).size.height/6,
          
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
               child: Container(
                height: 110,
                  width: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color:Colors.grey,width: 0.5)
                  ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.check_circle,
                        color:colorJAPMadeProgress?Colors.green:Colors.grey,
                        size: 40,
                      ) ,
                      Text("Made",
                        style: TextStyle(
                              color:colorJAPMadeProgress?Colors.green:Colors.grey,fontSize: 10
                        ),
                      ),
                      Text("Progress",
                        style: TextStyle(
                          color:colorJAPMadeProgress?Colors.green:Colors.grey,fontSize: 10
                        ),
                      ),
                    ],
                  ) ,
                ),
                onTap: (){
                  setState(() {
                   colorJAPMadeProgress = true;
                    colorJApartialProgress = false;
                    colorJANoProgress = false;
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 110,
                  width: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color:Colors.grey,width: 0.5)
                  ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.star_half,
                        color:colorJApartialProgress?Colors.green:Colors.grey,
                        size: 40,
                      ) ,
                      Text("Partial",
                        style: TextStyle(
                              color:colorJApartialProgress?Colors.green:Colors.grey,fontSize: 10
                        ),
                      ),
                        Text("Progress",
                          style: TextStyle(
                              color:colorJApartialProgress?Colors.green:Colors.grey,fontSize: 10
                          ),
                        )
                    ],
                  )
                ),
                onTap: (){
                  setState(() {
                     
                     colorJAPMadeProgress = false;
                     colorJApartialProgress = true;
                     colorJANoProgress = false;
                     
                  });
                },
              ),
              InkWell(
                child: Container(
                  height: 110,
                  width: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color:Colors.grey,width: 0.5)
                  ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.not_interested,
                        color:colorJANoProgress?Colors.green:Colors.grey,
                        size: 40,
                      ) ,
                        Text("No",
                          style: TextStyle(
                            color:colorJANoProgress?Colors.green:Colors.grey,fontSize: 10
                          ),
                        ),
                        Text("Progress",
                          style: TextStyle(
                            color:colorJANoProgress?Colors.green:Colors.grey,fontSize: 10
                          ),
                        )
                    ],
                  )
                ),
                 onTap: (){
                  setState(() {
                    colorJAPMadeProgress = false;
                     colorJApartialProgress = false;
                     colorJANoProgress = true;
                  });
                },
              ),
    
              
            ],
          ),
          
        );
      }
    
    
    
      
      Widget editWidget(){
        return Container(
          height: MediaQuery.of(context).size.height/7,
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
                Text("No"),
              Text("Progress")
            ],
          )
        );
      }
    
    
      Widget firstRowEditWidget(){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: <Widget>[
           Container(
              height: MediaQuery.of(context).size.height/7,
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
                    Text("Painting"),
                  
                ],
              )
            ),
            Container(
              height: MediaQuery.of(context).size.height/7,
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
                    Text("Baking"),
                  
                ],
              )
            ),
            Container(
              height: MediaQuery.of(context).size.height/7,
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
                    Text("Vehicles"),
                 
                ],
              )
            ),
         ],
        );
      }
    
    
    
    
      Widget secondRowEditWidget(){
        return  Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: <Widget>[
           Container(
              height: MediaQuery.of(context).size.height/7,
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
                    Text("Excercise"),
                 
                ],
              )
            ),
            Container(
              height: MediaQuery.of(context).size.height/7,
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
                    Text("Glue"),
                  
                ],
              )
            ),
            Container(
              height: MediaQuery.of(context).size.height/7,
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
                    Text("Calender"),
                  
                ],
              )
            ),
         ],
        );
      }
    
      void callCompleteSessionApi() async {


        setState(() {
          _isLoading = true;
        });
  

      response = await completeSessionApi.getSessionDetails();


     int codeVal = completeSessionApi.statuscode; 

      print("code:"+codeVal.toString());

      if(codeVal == 200){

        setState(() {
          _isLoading = false;
          
        });

        noteText =  response.notes;
        locationHomeOrSchool = response.location;
        sessionType =  response.sessionType;

        //sessionType = "Service Provided, Makeup";

        if(sessionType ==  "Service Provided"){
          setState(() {


                                          sPSelected = true;
                                          sPmSelected = false;
                                          sASelected = false;
                                          pASelected = false;
                                          sUSelected = false;
            
          });



        }else if(sessionType ==  "Service Provided, Makeup"){

                                    setState(() {

                                         sPSelected = false;
                                          sPmSelected = true;
                                          sASelected = false;
                                          pASelected = false;
                                          sUSelected = false; 
                                      
                                    });

                                              




        }else if(sessionType ==  "Student Absent"){


          setState(() {

             sPSelected = false;
                                          sPmSelected = false;
                                          sASelected = true;
                                          pASelected = false;
                                          sUSelected = false;



            
          });


        }else if(sessionType ==  "Provider Absent"){

          setState(() {
                                          sPSelected = false;
                                          sPmSelected = false;
                                          sASelected = false;
                                          pASelected = true;
                                          sUSelected = false;
          });


        }else{

          setState(() {

                                          sPSelected = false;
                                          sPmSelected = false;
                                          sASelected = false;
                                          pASelected = false;
                                          sUSelected = true;
            
          });


        }

        if(locationHomeOrSchool.contains("School")){

          setState(() {

             locHomeSelectedButton = false;
              locBuildingSelectedButton = true;
            
          });

        }else{

          setState(() {

              locHomeSelectedButton = false;
              locBuildingSelectedButton = true;
            
          });

        }
        settingsGroupOrNot = response.group;

        if(settingsGroupOrNot == "1"){

          setState(() {

            settingGroupSelectedButton = true;
            settingPersonSelectedbutton = false;
            
          });

          


        }else{

          setState(() {

             settingGroupSelectedButton = false;
             settingPersonSelectedbutton = true;
            
          });

         


        }
        duration =  response.duration.toString();
        
        sessionDateTime = response.sessionDate+" "+response.sessionTime;
        print("From API datetime:"+sessionDateTime);
        toPassDate = new DateFormat("MM/dd/yy hh:mm:ss").parse(sessionDateTime);
        sessionTime = DateFormat.jm().format(toPassDate);

        print(sessionTime);

        endDateTime =  toPassDate.add(Duration(days: 0, hours:0 ,minutes: int.parse(duration)));

        sessionEndTime = DateFormat.jm().format(endDateTime);

        print(sessionEndTime);

        
        

        

        print("In Datetime format"+toPassDate.toString());
        
        

        
        





      }else{
        setState(() {
          _isLoading = false;
          
        });
        

      }



      }

}


class GPCheckList{
  String title;
  bool checkVal;
  GPCheckList({this.title, this.checkVal});
}
class SPCheckList{
  String title;
  bool checkVal;
  SPCheckList({this.title, this.checkVal});
}
class SICheckList{
  String title;
  bool checkVal;
  SICheckList({this.title, this.checkVal});
}


