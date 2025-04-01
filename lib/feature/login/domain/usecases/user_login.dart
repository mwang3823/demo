import 'package:demo_architecture/feature/login/domain/repositories/user_repository.dart';

class LoginUseCase{
  final UserRepository repository;

  LoginUseCase(this.repository);

  bool call(String userName, String password) {
    return repository.loginUser(userName, password);
  }
}