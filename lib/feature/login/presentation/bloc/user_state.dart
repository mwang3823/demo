import 'package:equatable/equatable.dart';
abstract class UserState extends Equatable{
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState{}

class UserLoading extends UserState{}

class ResultLogin extends UserState{
  final bool result;

  const ResultLogin({required this.result});

  @override
  List<Object> get props =>[];
}

class UserError extends UserState{
  final String message;

  const UserError({required this.message});

  @override
  List<Object> get props =>[];
}

class UserSuccess extends UserState{}
