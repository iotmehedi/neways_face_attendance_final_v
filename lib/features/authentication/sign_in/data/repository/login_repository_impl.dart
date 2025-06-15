import '../../../../../../core/source/model/api_response.dart';
import '../../domain/repository/login_repository.dart';
import '../model/get_attendance_model.dart';
import '../model/get_roaster_model.dart';
import '../model/login_different_model.dart';
import '../model/login_model.dart';
import '../model/otp_model.dart';
import '../source/login_service.dart';

class SignInRepositoryImpl extends SignInRepository {
  SignInRepositoryImpl(SignInService loginService) : super(loginService);

  @override
  Future<Response<LoginDifferentModel?>?> differentLoginWithIdPass(
      {required String employee_id, required String password}) async {
    Response<LoginDifferentModel>? apiResponse;
    apiResponse = await loginService.differentLoginWithIdPass(employee_id, password);
    return apiResponse;
  }
  @override
  Future<Response<OTPModel?>?> sendOTP() async {
    Response<OTPModel>? apiResponse;
    apiResponse = await loginService.sendOTP();
    return apiResponse;
  }
  @override
  Future<Response<GetRoasterModel?>?> getRoaster() async {
    Response<GetRoasterModel>? apiResponse;
    apiResponse = await loginService.getRoster();
    return apiResponse;
  }
  @override
  Future<Response<GetAttendanceModel?>?> getAttendance() async {
    Response<GetAttendanceModel>? apiResponse;
    apiResponse = await loginService.getAttendance();
    return apiResponse;
  }
}
