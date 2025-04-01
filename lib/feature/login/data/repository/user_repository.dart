import 'package:demo_architecture/feature/login/data/datasources/local_data.dart';
import 'package:demo_architecture/feature/login/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository{
   final LocalUserData userData;

  UserRepositoryImpl(this.userData);

  @override
  bool loginUser(String userName, String password) {
    if(userName==userData.user.userName && password==userData.user.password){
      return true;
    }
    return false;
  }

}