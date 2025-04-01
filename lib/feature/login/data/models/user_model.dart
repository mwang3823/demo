import 'package:demo_architecture/feature/login/domain/entities/user_entity.dart';

class UserModel extends User{
  UserModel({required super.id, required super.userName, required super.password});

  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(id: json['id'], userName: json['userName'], password: json['password']);
  }

}