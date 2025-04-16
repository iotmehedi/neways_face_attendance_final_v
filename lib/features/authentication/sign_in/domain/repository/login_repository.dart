import '../../../../../../core/source/model/api_response.dart';
import '../../data/model/login_model.dart';
import '../../data/source/login_service.dart';

abstract class SignInRepository {
  final SignInService loginService;

  SignInRepository(this.loginService);

  Future<Response<LoginModel?>?> loginWithIdPass(
      {required String employee_id, required String password});
}
