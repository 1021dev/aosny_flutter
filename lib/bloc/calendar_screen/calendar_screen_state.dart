
import 'package:aosny_services/models/history_model.dart';
import 'package:aosny_services/models/progress_amount_model.dart';
import 'package:aosny_services/screens/widgets/calendar_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CalendarScreenState extends Equatable {
  final bool isLoading;
  final List<HistoryModel> history;
  final List<DateTime> blackoutDates;

  CalendarScreenState({
    this.isLoading = false,
    this.history = const [],
    this.blackoutDates = const [],
  });

  @override
  List<Object> get props => [
    isLoading,
    history,
    blackoutDates,
  ];

  CalendarScreenState copyWith({
    bool isLoading,
    List<HistoryModel> history,
    List<DateTime> blackoutDates,
  }) {
    return CalendarScreenState(
      isLoading: isLoading ?? this.isLoading,
      history: history ?? this.history,
      blackoutDates: blackoutDates ?? this.blackoutDates,
    );
  }
}

class CalendarScreenStateSuccess extends CalendarScreenState {}

class CalendarScreenStateFailure extends CalendarScreenState {
  final String error;

  CalendarScreenStateFailure({@required this.error}) : super();

  @override
  String toString() => 'CalendarScreenStateFailure { error: $error }';
}

