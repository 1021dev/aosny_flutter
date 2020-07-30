import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MainScreenEvent extends Equatable {
  const MainScreenEvent();

  @override
  List<Object> get props => [];
}


@immutable
class MainScreenInitialEvent extends MainScreenEvent {}

@immutable
class GetHistoryEvent extends MainScreenEvent {
  final String startDate;
  final String endDate;

  GetHistoryEvent({this.startDate, this.endDate});
}

@immutable
class GetProgressEvent extends MainScreenEvent {
  final String startDate;
  final String endDate;

  GetProgressEvent({this.startDate, this.endDate});
}

class RefreshHistoryEvent extends MainScreenEvent {
  final String startDate;
  final String endDate;

  RefreshHistoryEvent({this.startDate, this.endDate});

}
class RefreshProgressEvent extends MainScreenEvent {
  final String startDate;
  final String endDate;

  RefreshProgressEvent({this.startDate, this.endDate});

}
class SetStartDateEvent extends MainScreenEvent {}
class SetEndDateEvent extends MainScreenEvent {}

