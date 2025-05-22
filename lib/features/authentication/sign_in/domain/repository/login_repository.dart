import 'package:neways_face_attendance_pro/features/authentication/sign_in/data/model/login_different_model.dart';

import '../../../../../../core/source/model/api_response.dart';
import '../../data/model/get_attendance_model.dart';
import '../../data/model/get_roaster_model.dart';
import '../../data/model/login_model.dart';
import '../../data/model/otp_model.dart';
import '../../data/source/login_service.dart';

abstract class SignInRepository {
  final SignInService loginService;

  SignInRepository(this.loginService);

  Future<Response<LoginModel?>?> loginWithIdPass(
      {required String employee_id, required String password});

  Future<Response<LoginDifferentModel?>?> differentLoginWithIdPass(
      {required String employee_id, required String password});

  Future<Response<OTPModel?>?> sendOTP();
  Future<Response<GetRoasterModel?>?> getRoaster();
  Future<Response<GetAttendanceModel?>?> getAttendance();
}
