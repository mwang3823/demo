import 'package:equatable/equatable.dart';

import '../../domain/entities/Statistical.dart';
abstract class StatisticalState extends Equatable{
  const StatisticalState();

  @override
  List<Object> get props =>[];
}

class OnInitial extends StatisticalState{}

class OnLoading extends StatisticalState{}

class OnSuccess extends StatisticalState {
  final List<Statistical>? statisticals;

  const OnSuccess({required this.statisticals});

  @override
  List<Object> get props => [statisticals!];
}



class OnStatisticalFailed extends StatisticalState{
  final String message;

  const OnStatisticalFailed({required this.message});

  @override
  List<Object> get props =>[message];
}