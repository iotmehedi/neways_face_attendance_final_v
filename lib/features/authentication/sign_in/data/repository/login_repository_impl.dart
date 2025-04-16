import '../../../../../../core/source/model/api_response.dart';
import '../../domain/repository/login_repository.dart';
import '../model/login_model.dart';
import '../source/login_service.dart';

class SignInRepositoryImpl extends SignInRepository {
  SignInRepositoryImpl(SignInService loginService) : super(loginService);

  @override
  Future<Response<LoginModel?>?> loginWithIdPass(
      {required String employee_id, required String password}) async {
    Response<LoginModel>? apiResponse;
    apiResponse = await loginService.loginWithIdPass(employee_id, password);
    return apiResponse;
  }
}
