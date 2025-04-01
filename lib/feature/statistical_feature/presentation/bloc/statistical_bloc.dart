import 'package:demo_architecture/feature/statistical_feature/presentation/bloc/statistical_event.dart';
import 'package:demo_architecture/feature/statistical_feature/presentation/bloc/statistical_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/statistical_usecase.dart';

class StatisticalBloc extends Bloc<StatisticalEvent, StatisticalState>{
  final GetStatisticalUseCase getStatisticalUseCase;

  StatisticalBloc({required this.getStatisticalUseCase}):super(OnInitial()){
   on<GetStatistical>(_onGetStatistical);
  }
  void _onGetStatistical(StatisticalEvent event, Emitter<StatisticalState> emit){
    emit(OnLoading());
    try{
      final result= getStatisticalUseCase.getStatistical();

      emit(OnSuccess(statisticals: result));
    }catch(e){
      emit(OnStatisticalFailed(message: "Không thể lấy hóa đơn"));
    }
  }
}