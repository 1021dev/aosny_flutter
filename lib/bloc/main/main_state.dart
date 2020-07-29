import 'dart:html';

import 'package:aosny_services/models/history_model.dart';
import 'package:aosny_services/models/progress_amount_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class MainScreenState extends Equatable {
  final bool isLoading;
  final List<HistoryModel> history;
  final ProgressAmountModel progress;

  MainScreenState({
    this.isLoading = false,
    this.history = const [],
    this.progress,
  });

  @override
  List<Object> get props => [
    isLoading,
    history,
    progress
  ];

  MainScreenState copyWith({
    bool isLoading,
    List<HistoryModel> history,
    ProgressAmountModel progress,
  }) {
    return MainScreenState(
      isLoading: isLoading ?? this.isLoading,
      history: history ?? this.history,
      progress: progress ?? this.progress,
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

