import 'package:equatable/equatable.dart';

import '../../domain/entities/warterbill.dart';
class WaterBillState extends Equatable{
  const WaterBillState();

  @override
  List<Object> get props =>[];
}

class OnInitial extends WaterBillState{}

class OnLoading extends WaterBillState{}

class OnWaterBillSuccess extends WaterBillState{
  final List<WaterBill> list;
  const OnWaterBillSuccess({required this.list});

  @override
  List<Object> get props =>[list];
}

class OnFailed extends WaterBillState{}