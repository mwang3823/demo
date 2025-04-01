import 'package:demo_architecture/feature/login/domain/usecases/user_login.dart';
import 'package:demo_architecture/feature/login/presentation/bloc/user_event.dart';
import 'package:demo_architecture/feature/login/presentation/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState>{
  final LoginUseCase loginUseCase;

  UserBloc({required this.loginUseCase}): super(UserInitial()){
    on<LoginEvent>(_onLogin);
  }

  void _onLogin(LoginEvent event, Emitter<UserState> emit){
    emit(UserLoading());
      final result=loginUseCase(event.email,event.password);
      if(result){
        emit(UserSuccess());
        print('${event.email} ${event.password}');

      }
      else{
        print('${event.email} ${event.password}');
        emit(UserError(message: 'Không thể lấy người dùng'));
      }
  }
}