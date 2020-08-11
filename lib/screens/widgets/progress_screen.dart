import 'package:aosny_services/bloc/bloc.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';




class ProgressScreen extends StatefulWidget {
  final MainScreenBloc mainScreenBloc;

  ProgressScreen({this.mainScreenBloc});

  @override
  _ProgressScreenState createState() => _ProgressScreenState();

}

class _ProgressScreenState extends State<ProgressScreen> with AutomaticKeepAliveClientMixin<ProgressScreen> {
  @override
  bool get wantKeepAlive => true;


  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool isFiltered = false;

  String startDate ='';
  String endDate='';
  String durationToString(int minutes) {
    var d = Duration(minutes:minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  showDateTimePicker(String whichStringType)async{

    if(whichStringType == 'Start Date'){
      final datePick= await showDatePicker(
        context: context,
        initialDate: GlobalCall.proStartDate ?? DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2030),
      );
      if(datePick != null && datePick != GlobalCall.proStartDate){
        setState(() {
          GlobalCall.proStartDate = datePick;
          startDate = DateFormat('MM/dd/yyyy').format(datePick);
          DateTime sevenDaysAgo = GlobalCall.proStartDate.add(new Duration(days: 7));
          GlobalCall.proStartDate = sevenDaysAgo;
          endDate = DateFormat('MM/dd/yyyy').format(sevenDaysAgo);
        });
        widget.mainScreenBloc.add(GetProgressEvent(startDate: startDate, endDate: endDate));
      }

    }else{
      final datePick= await showDatePicker(
        context: context,
        initialDate: GlobalCall.proEndDate ?? DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2030),
      );
      if(datePick != null && datePick != GlobalCall.proEndDate){
        setState(() {
          GlobalCall.proEndDate = datePick;
          endDate = DateFormat('MM/dd/yyyy').format(datePick);
          DateTime sevenDaysAgo = GlobalCall.proEndDate.subtract(new Duration(days: 7));
          GlobalCall.proStartDate = sevenDaysAgo;
          startDate = DateFormat('MM/dd/yyyy').format(sevenDaysAgo);
        });
        if (startDate != null) {
          widget.mainScreenBloc.add(GetProgressEvent(startDate: startDate, endDate: endDate));
        }
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener(
      cubit: widget.mainScreenBloc,
      listener: (BuildContext context, MainScreenState state) async {
      },
      child: BlocBuilder<MainScreenBloc, MainScreenState>(
          cubit: widget.mainScreenBloc,
          builder: (BuildContext context, MainScreenState state) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    GlobalCall.filterDates ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Start Date',
                              ),
                              FlatButton(
                                color: Colors.blue,
                                onPressed: () async {
                                  showDateTimePicker('Start Date');
                                },
                                child: Text(
                                  startDate,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'End Date',
                              ),
                              FlatButton(
                                color: Colors.blue,
                                onPressed: (){
                                  showDateTimePicker('End Date');
                                },
                                child: Text(
                                  endDate,
                                  style: TextStyle(
                                    color:Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                        :Container(),
                    Divider(height: 0, thickness: 0.5,),
                    Text('This Week',
                      style: TextStyle(color:Colors.grey, fontSize:16),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                        child: RefreshIndicator(
                          key: refreshKey,
                          child: state.progress.length == 0 ? Center(
                            child: Text(
                              'No progress data, please try to change start/end Date',
                            ),
                          ) : ListView.separated(
                              separatorBuilder: (context, index) {
                                return Divider(height: 0, thickness: 0.5,);
                              },
                              itemCount: state.progress.length,
                              itemBuilder: (context, index){
                                String mandatedMins = durationToString(state.progress[index].mandatedMins);
                                String serviceMins = durationToString(state.progress[index].serviceMins);
                                String mandatedNDMins = durationToString(state.progress[index].mandatedNDMins);
                                String nDMins = durationToString(state.progress[index].nDMins);

                                var sessionPercentInString= (int.parse(serviceMins.split(':')[0])/int.parse(mandatedMins.split(':')[0])).toString();
                                var sessionPercentResultInString =sessionPercentInString.substring(0,3);
                                var ndPercentInString = (int.parse(nDMins.split(':')[0])/int.parse(mandatedNDMins.split(':')[0])).toString();
                                var ndPercentResultInString =ndPercentInString.substring(0,3);
                                print('sessionPercentInString:$sessionPercentResultInString');
                                print('ndPercentInString:$ndPercentResultInString');

                                return Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(10,10,0,5),
                                      alignment: Alignment.topLeft,
                                      width: MediaQuery.of(context).size.width,
                                      height: 130,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                            child:Text(
                                              '${state.progress[index].fname} ${state.progress[index].lname}',
                                              style: TextStyle(
                                                fontWeight:FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Flexible(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    new CircularPercentIndicator(
                                                      radius: 64,
                                                      lineWidth: 5.5,
                                                      percent:double.parse(sessionPercentResultInString),
                                                      circularStrokeCap: CircularStrokeCap.round,
                                                      center: new Text(
                                                        '$serviceMins',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:Colors.grey,
                                                        ),
                                                      ),
                                                      progressColor: double.parse(sessionPercentResultInString) >= 0.5
                                                          ? Colors.blue
                                                          : double.parse(sessionPercentResultInString) >= 0.3 ? Colors.orange : Colors.red,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 8),
                                                    ),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                            'Sessions',
                                                            style: TextStyle(
                                                              fontWeight:FontWeight.bold,
                                                            ),
                                                          ),
                                                          SizedBox(height:5),
                                                          Text(
                                                            'of ${mandatedMins.split(':')[0]} Hour',
                                                            style: TextStyle(
                                                              color:Colors.grey,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          SizedBox(height:5),
                                                          SizedBox(
                                                            child: FittedBox(
                                                              child: Text(
                                                                '${int.parse(mandatedMins.split(':')[0])-int.parse(serviceMins.split(':')[0])} Hour Remaining',
                                                                style: TextStyle(color:Colors.red,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //------------non-direct----------------
                                              Padding(
                                                padding: EdgeInsets.only(left: 8),
                                              ),
                                              Flexible(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    new CircularPercentIndicator(
                                                        radius: 64,
                                                        lineWidth: 5.5,
                                                        percent:double.parse(ndPercentResultInString),//ndPercent
                                                        circularStrokeCap: CircularStrokeCap.round,
                                                        center: new Text('$nDMins',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:Colors.grey
                                                          ),
                                                        ),
                                                        progressColor: double.parse(ndPercentResultInString) >= 0.5
                                                            ? Colors.blue
                                                            : double.parse(ndPercentResultInString) >= 0.3 ? Colors.orange :Colors.red
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 8),
                                                    ),
                                                    Flexible(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                            'Non-Direct',
                                                            style: TextStyle(
                                                              fontWeight:FontWeight.bold,
                                                            ),
                                                          ),
                                                          SizedBox(height:5),
                                                          Text('of ${mandatedNDMins.split(':')[0]} Hour',
                                                            style: TextStyle(
                                                              color:Colors.grey,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          SizedBox(height:5),
                                                          SizedBox(
                                                            child: FittedBox(
                                                              child: Text(
                                                                '${int.parse(mandatedNDMins.split(':')[0])-int.parse(nDMins.split(':')[0])} Hour Remaining',
                                                                style: TextStyle(color:Colors.red,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height:10)
                                  ],
                                );
                              }
                          ),
                          onRefresh: refreshList,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    widget.mainScreenBloc.add(RefreshProgressEvent(startDate: startDate, endDate: endDate));
    await Future.delayed(Duration(seconds: 4));
    return null;
  }

  @override
  void initState() {

    startDate = DateFormat('MM/dd/yyyy').format(GlobalCall.proStartDate).toString();
    DateTime fiftyDaysAgo = GlobalCall.proStartDate.subtract(new Duration(days: 7));
    endDate =  DateFormat('MM/dd/yyyy').format(GlobalCall.proStartDate).toString();
    super.initState();
  }

}