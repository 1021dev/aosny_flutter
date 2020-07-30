
import 'package:aosny_services/models/history_model.dart';
import 'package:aosny_services/models/progress_amount_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MainScreenState extends Equatable {
  final bool isLoading;
  final List<HistoryModel> history;
  final List<ProgressAmountModel> progress;
  final String startDate;
  final String endDate;
  final String proStartDate;
  final String proEndDate;

  MainScreenState({
    this.isLoading = false,
    this.history = const [],
    this.progress = const [],
    this.startDate,
    this.endDate,
    this.proStartDate,
    this.proEndDate,
  });

  @override
  List<Object> get props => [
    isLoading,
    history,
    progress,
    startDate,
    endDate,
    proStartDate,
    proEndDate,
  ];

  MainScreenState copyWith({
    bool isLoading,
    List<HistoryModel> history,
    List<ProgressAmountModel> progress,
    String startDate,
    String endDate,
    String proStartDate,
    String proEndDate,
  }) {
    return MainScreenState(
      isLoading: isLoading ?? this.isLoading,
      history: history ?? this.history,
      progress: progress ?? this.progress,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      proEndDate: proEndDate ?? this.proEndDate,
      proStartDate: proStartDate ?? this.proStartDate,
    );
  }
}

class MainScreenStateSuccess extends MainScreenState {}

class MainScreenStateFailure extends MainScreenState {
  final String error;

  MainScreenStateFailure({@required this.error}) : super();

  @override
  String toString() => 'MainScreenStateFailure { error: $error }';
}

