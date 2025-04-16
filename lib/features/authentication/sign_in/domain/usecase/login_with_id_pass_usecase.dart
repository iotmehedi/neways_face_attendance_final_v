import '../../../../../../core/source/model/api_response.dart';
import '../../data/model/login_model.dart';
import 'login_usecase.dart';

class SignInPassUseCase extends SignInUseCase {
  SignInPassUseCase(super.loginRepository);

  Future<Response<LoginModel?>?> call(
      {required String employee_id, required String password}) async {
    var response = await loginRepository.loginWithIdPass(
        employee_id: employee_id, password: password);
    return response;
  }
}
