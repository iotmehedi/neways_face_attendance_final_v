import '../repository/login_repository.dart';

abstract class SignInUseCase {
  final SignInRepository loginRepository;

  SignInUseCase(this.loginRepository);
}

