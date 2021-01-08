
import 'dart:math';

import 'package:aosny_services/api/history_api.dart';
import 'package:aosny_services/bloc/bloc.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/history_model.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:aosny_services/screens/widgets/add_edit_session_note.dart';
import 'package:date_util/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'drawer/drawer_widget.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => new _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool isLoading = false;
  CalendarScreenBloc calendarScreenBloc;
  final dateUtility = DateUtil();

  // List<String> _subjectCollection;
  // List<Color> _colorCollection;

  CalendarController _calendarController;
  _MeetingDataSource _events;
  List<DateTime> _blackoutDates;

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule
  ];
  ScrollController _controller;
  DateTime _minDate, _maxDate;

  GlobalKey _globalKey;

  @override
  void initState() {
    calendarScreenBloc = CalendarScreenBloc(CalendarScreenState());
    _calendarController = CalendarController();
    _calendarController.view = CalendarView.month;
    _globalKey = GlobalKey();
    _controller = ScrollController();
    _blackoutDates = <DateTime>[];

    _events = _MeetingDataSource(<_Meeting>[]);
    _minDate = DateTime.now().subtract(const Duration(days: 365));
    _maxDate = DateTime.now().add(const Duration(days: 30));

    calendarScreenBloc.add(CalendarScreenInitEvent());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    calendarScreenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        cubit: calendarScreenBloc,
        listener: (BuildContext context, CalendarScreenState state) async {
        },
        child: BlocBuilder<CalendarScreenBloc, CalendarScreenState>(
            cubit: calendarScreenBloc,
            builder: (BuildContext context, CalendarScreenState state) {
              final Widget calendar = _getGettingStartedCalendar(_calendarController, _events,
                  _onViewChanged, _minDate, _maxDate, scheduleViewBuilder, state);
              final double screenHeight = MediaQuery.of(context).size.height;

              return Scaffold(
                key: _globalKey,
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                  title: Text('Calendar'),
                ),
                drawer: DrawerWidget(),
                body: ModalProgressHUD(
                  inAsyncCall: state.isLoading,
                  child: SafeArea(
                    child: Row(children: <Widget>[
                      Expanded(
                        child: _calendarController.view == CalendarView.month &&
                            screenHeight < screenHeight
                            ? Scrollbar(
                          isAlwaysShown: true,
                          controller: _controller,
                          child: ListView(
                            controller: _controller,
                            children: <Widget>[
                              Container(
                                color: Colors.white,
                                height: screenHeight,
                                child: calendar,
                              )
                            ],
                          ),
                        )
                            : Container(color: Colors.blue, child: calendar),
                      ),
                    ],
                    ),
                  ),
                ),
              );
            }
        )
    );

  }


  /// The method called whenever the calendar view navigated to previous/next
  /// view or switched to different calendar view, based on the view changed
  /// details new appointment collection added to the calendar
  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) async {
    final List<_Meeting> appointment = <_Meeting>[];
    _events.appointments.clear();
    print(visibleDatesChangedDetails.visibleDates.length);

    calendarScreenBloc.add(CalendarLoadingEvent(isLoading: true));
    DateTime sMonth = visibleDatesChangedDetails.visibleDates.first;
    DateTime eMonth = visibleDatesChangedDetails.visibleDates.last;

    if (_calendarController.view == CalendarView.schedule) {
      sMonth = DateTime.now().add(const Duration(days: -365));
      eMonth = DateTime.now();
    }

    String startDate = '${sMonth.month}/${sMonth.day}/${sMonth.year}';
    String endDate = '${eMonth.month}/${eMonth.day}/${eMonth.year}';

    List<HistoryModel> history = await HistoryApi().getHistoryList(
        sdate: startDate, endDate: endDate);
    if (history.length > 0) history.sort((a,b) => a.starttime.compareTo(b.starttime));

    final List<DateTime> blockedDates = <DateTime>[];
    DateTime firstDate = visibleDatesChangedDetails.visibleDates.first;
    for (int i = 0; i < dateUtility.daysInMonth(firstDate.month, firstDate.year); i++) {
      firstDate = firstDate.add(Duration(days: 1));
      if (!isAvailable(firstDate)) {
        blockedDates.add(firstDate);
      }
    }
    _blackoutDates = blockedDates;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      calendarScreenBloc.add(CalendarLoadingEvent(isLoading: false));
    });

    if (_calendarController.view != CalendarView.schedule) {
      for (int i = 0; i < visibleDatesChangedDetails.visibleDates.length; i++) {
        final DateTime date = visibleDatesChangedDetails.visibleDates[i];
        if (blockedDates != null &&
            blockedDates.isNotEmpty &&
            blockedDates.contains(date)) {
            print(date);
          if (isBlockOut(date) != '') {
            DateTime sdate = DateTime(date.year, date.month, date.day, 0, 0, 1);
            print(sdate);
            appointment.add(_Meeting(
              isBlockOut(date),
              sdate,
              sdate.add(Duration(hours: 23, minutes: 59)),
              Colors.red,
              false,
              null,
            ));
          }

          continue;
        }
        for (int j = 0; j < history.length; j++) {
          HistoryModel model = history[j];
          DateTime sdate = DateTime.parse('${model.sdate.split('/')[2]}-${model.sdate.split('/')[0]}-${model.sdate.split('/')[1]}');
          if (sdate.year == date.year && sdate.month == date.month && sdate.day == date.day) {
            String stime = model.stime;
            String etime = model.etime;
            String sh = stime.replaceAll(' AM', '').replaceAll(' PM', '').split(':').toList()[0];
            String sm = stime.replaceAll(' AM', '').replaceAll(' PM', '').split(':').toList()[1];
            String sa = stime.split(' ').toList()[1];
            String emin = etime.replaceAll(' AM', '').replaceAll(' PM', '').split(':').toList()[1];
            int duration = sm == emin ? 60: 30;
            int hour = int.parse(sh);
            int min = int.parse(sm);
            if (sa == 'PM' && sh != '12') {
              hour  = hour + 12;
            }
            final DateTime startDate = DateTime(date.year, date.month, date.day, hour, min);
            if (_calendarController.view == CalendarView.week || _calendarController.view == CalendarView.workWeek) {
              appointment.add(_Meeting(
                '${model.fname} ${model.lname}',
                startDate,
                startDate.add(Duration(minutes: duration)),
                getSessionColor(model.grp, model.sessionType),
                false,
                model,
              ));
            } else if (_calendarController.view == CalendarView.day){
              appointment.add(_Meeting(
                '${model.fname} ${model.lname}',
                startDate,
                startDate.add(Duration(minutes: duration)),
                getSessionColor(model.grp, model.sessionType),
                false,
                model,
              ));
            } else {
              appointment.add(_Meeting(
                '${model.fname} ${model.lname}',
                startDate,
                startDate.add(Duration(minutes: duration)),
                getSessionColor(model.grp, model.sessionType),
                false,
                model,
              ));
            }
          }
        }
      }
    } else {
      // DateTime rangeStartDate = visibleDatesChangedDetails.visibleDates.first;
      // DateTime rangeEndDate = visibleDatesChangedDetails.visibleDates.last;
      final DateTime rangeStartDate =
      DateTime.now().add(const Duration(days: -365));
      final DateTime rangeEndDate = DateTime.now();

      for (DateTime i = rangeStartDate; i.isBefore(rangeEndDate); i = i.add(const Duration(days: 1))) {
        final DateTime date = i;
        if (isBlockOut(date) != '') {
          DateTime sdate = DateTime(date.year, date.month, date.day, 0, 0, 1);
          print(sdate);
          appointment.add(_Meeting(
            isBlockOut(date),
            sdate,
            sdate.add(Duration(hours: 23, minutes: 59)),
            Colors.red,
            false,
            null,
          ));
        }
        for (int j = 0; j < history.length; j++) {
          HistoryModel model = history[j];
          DateTime sdate = DateTime.parse('${model.sdate.split('/')[2]}-${model.sdate.split('/')[0]}-${model.sdate.split('/')[1]}');
          if (sdate.year == date.year && sdate.month == date.month && sdate.day == date.day) {
            String stime = model.stime;
            String etime = model.etime;
            String sh = stime.replaceAll(' AM', '').replaceAll(' PM', '').split(':').toList()[0];
            String sm = stime.replaceAll(' AM', '').replaceAll(' PM', '').split(':').toList()[1];
            String sa = stime.split(' ').toList()[1];
            String emin = etime.replaceAll(' AM', '').replaceAll(' PM', '').split(':').toList()[1];
            int duration = sm == emin ? 60: 30;
            int hour = int.parse(sh);
            int min = int.parse(sm);
            if (sa == 'AM' && sh == '12') {
              hour = 0;
            } else if (sa == 'PM') {
              hour  = hour + 12;
            }
            final DateTime startDate = DateTime(date.year, date.month, date.day, hour, min);
            appointment.add(_Meeting(
                '${model.fname} ${model.lname}',
                startDate,
                startDate.add(Duration(minutes: duration)),
                getSessionColor(model.grp, model.sessionType),
                false,
                model,
            ));
          }
        }
      }
    }

    for (int i = 0; i < appointment.length; i++) {
      _events.appointments.add(appointment[i]);
    }

    /// Resets the newly created appointment collection to render
    /// the appointments on the visible dates.
    _events.notifyListeners(CalendarDataSourceAction.reset, appointment);

  }

  StudentsDetailsModel getStudent(int id) {
    List<StudentsDetailsModel> list = GlobalCall.globaleStudentList.where((element) => element.studentID.toInt() == id).toList();
    if (list != null && list.length > 0) {
      return list.first;
    } else {
      return null;
    }
  }

  Future<Null> updatedSessionNote() async {
    _calendarController.notifyPropertyChangedListeners('');
    await Future.delayed(Duration(seconds: 4));
    return null;
  }

  SfCalendar _getGettingStartedCalendar(
      [CalendarController _calendarController,
        CalendarDataSource _calendarDataSource,
        ViewChangedCallback viewChangedCallback,
        DateTime _minDate,
        DateTime _maxDate,
        dynamic scheduleViewBuilder,
        CalendarScreenState state,
      ]) {
    return SfCalendar(
        controller: _calendarController,
        dataSource: _calendarDataSource,
        allowedViews: _allowedViews,
        scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
        showNavigationArrow: false,
        showDatePickerButton: true,
        allowViewNavigation: false,
        onViewChanged: viewChangedCallback,
        blackoutDates: _blackoutDates,
        blackoutDatesTextStyle: TextStyle(
          decoration: TextDecoration.lineThrough,
          color: Colors.red,
        ),
        minDate: _minDate,
        maxDate: _maxDate,
        monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          showTrailingAndLeadingDates: true,
          appointmentDisplayCount: 3,
          agendaItemHeight: 50,
          showAgenda: true,
        ),
        appointmentTextStyle: TextStyle(
          fontSize: 7,
        ),
        timeSlotViewSettings: TimeSlotViewSettings(
            minimumAppointmentDuration: const Duration(minutes: 30)
        ),
      onTap: (details) async {
        print(details.resource);
        print(details.targetElement);
          if (details.targetElement == CalendarElement.agenda || details.targetElement == CalendarElement.appointment) {
            if (details.appointments == null) {
              return;
            }

            if (details.appointments.length == 0) {
              return;
            }
            final _Meeting meeting = details.appointments.first;
            HistoryModel model = meeting.model;
            if (model == null) {
              return;
            }

            GlobalCall.sessionID = model.iD.toString();
            String studentId = model.osis.toString().replaceAll('-', '');
            int id = int.parse(studentId);
            StudentsDetailsModel studentsDetailsModel = getStudent(id);
            if (studentsDetailsModel == null) {
              return ;
            }
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddEditSessionNote(
                  eventType: "Edit",
                  student: studentsDetailsModel,
                  sessionId: model.iD,
                  selectedStudentName: model.fname + ' ' + model.lname,
                  noteText: model.notes,
                  isEditable: model.confirmed == 0,
                ),
              ),
            );

            if (result != null) {
              await updatedSessionNote();
            }
          }
      },
    );
  }

  String isBlockOut(DateTime dateTime) {
    if (dateTime == null) {
      return '';
    }
    String isAvailable = '';
    String compareString = DateFormat('20yy-MM-dd').format(dateTime).toString();
    // print(compareString);
    GlobalCall.blockDates.forEach((element) {
      var dateString = element.startTime.split('T').first;
      if (dateString == compareString) {
        print(dateString);
        isAvailable = element.subject;
        // return isAvailable;
      }
    });
    return isAvailable;
  }

}

/// Returns the month name based on the month value passed from date.
String _getMonthDate(int month) {
  if (month == 01) {
    return 'January';
  } else if (month == 02) {
    return 'February';
  } else if (month == 03) {
    return 'March';
  } else if (month == 04) {
    return 'April';
  } else if (month == 05) {
    return 'May';
  } else if (month == 06) {
    return 'June';
  } else if (month == 07) {
    return 'July';
  } else if (month == 08) {
    return 'August';
  } else if (month == 09) {
    return 'September';
  } else if (month == 10) {
    return 'October';
  } else if (month == 11) {
    return 'November';
  } else {
    return 'December';
  }
}

/// Returns the builder for schedule view.
Widget scheduleViewBuilder(
    BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
  final String monthName = _getMonthDate(details.date.month);
  return GestureDetector(
    child: Stack(
      children: [
        Image(
            image: ExactAssetImage('assets/logo/' + monthName + '.png'),
            fit: BoxFit.cover,
            width: details.bounds.width,
            height: details.bounds.height),
        Positioned(
          left: 55,
          right: 0,
          top: 20,
          bottom: 0,
          child: Text(
            monthName + ' ' + details.date.year.toString(),
            style: TextStyle(fontSize: 18),
          ),
        )
      ],
    ),
  );
}
/// An object to set the appointment collection data source to collection, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class _MeetingDataSource extends CalendarDataSource {
  _MeetingDataSource(this.source);

  List<_Meeting> source;

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].to;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return source[index].eventName;
  }

  @override
  Color getColor(int index) {
    return source[index].background;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class _Meeting {
  _Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay, this.model);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  HistoryModel model;
}
