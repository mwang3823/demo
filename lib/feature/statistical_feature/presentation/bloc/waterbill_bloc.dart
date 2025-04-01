import 'package:demo_architecture/feature/statistical_feature/presentation/bloc/waterbill_event.dart';
import 'package:demo_architecture/feature/statistical_feature/presentation/bloc/waterbill_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/warterbill_usecase.dart';

class WaterBillBloc extends Bloc<WaterBillEvent, WaterBillState>{
  final WaterBillUseCase waterBillUseCase;
  WaterBillBloc({required this.waterBillUseCase}):super(OnInitial()){
    on<GetAllWaterBill>(_onGetAllWaterBill);
  }

  void _onGetAllWaterBill(WaterBillEvent event, Emitter<WaterBillState> emit){
    emit(OnLoading());
    try{
      final result=waterBillUseCase.repository.getAllWaterBill();
      emit(OnWaterBillSuccess(list: result));
    }catch(e){
      emit(OnFailed());
    }
  }
}