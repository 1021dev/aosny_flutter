import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CalendarScreenEvent extends Equatable {
  const CalendarScreenEvent();

  @override
  List<Object> get props => [];
}

@immutable
class CalendarScreenInitEvent extends CalendarScreenEvent {}

class GetMonthHistoryEvent extends CalendarScreenEvent {
  final DateTime month;

  GetMonthHistoryEvent({this.month});
}

class GetWeekHistoryEvent extends CalendarScreenEvent {
  final String startDate;
  final String endDate;

  GetWeekHistoryEvent({this.startDate, this.endDate});
}

class GetDayHistoryEvent extends CalendarScreenEvent {
  final String date;

  GetDayHistoryEvent({this.date});
}

class UpdateCalendarViewEvent extends CalendarScreenEvent {
  final String type;

  UpdateCalendarViewEvent({this.type});
}

class CalendarLoadingEvent extends CalendarScreenEvent {
  final bool isLoading;

  CalendarLoadingEvent({this.isLoading});
}
