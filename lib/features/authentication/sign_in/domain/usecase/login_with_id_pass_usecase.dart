import 'package:neways_face_attendance_pro/features/authentication/sign_in/data/model/login_different_model.dart';

import '../../../../../../core/source/model/api_response.dart';
import '../../data/model/get_attendance_model.dart';
import '../../data/model/get_roaster_model.dart';
import '../../data/model/login_model.dart';
import '../../data/model/otp_model.dart';
import 'login_usecase.dart';

class SignInDifferentPassUseCase extends SignInUseCase {
  SignInDifferentPassUseCase(super.loginRepository);

  Future<Response<LoginDifferentModel?>?> call(
      {required String employee_id, required String password}) async {
    var response = await loginRepository.differentLoginWithIdPass(
        employee_id: employee_id, password: password);
    return response;
  }
}

class SendOTPPassUseCase extends SignInUseCase {
  SendOTPPassUseCase(super.loginRepository);

  Future<Response<OTPModel?>?> call() async {
    var response = await loginRepository.sendOTP();
    return response;
  }
}

class GetRoasterPassUseCase extends SignInUseCase {
  GetRoasterPassUseCase(super.loginRepository);

  Future<Response<GetRoasterModel?>?> call() async {
    var response = await loginRepository.getRoaster();
    return response;
  }
}


class GetAttendancePassUseCase extends SignInUseCase {
  GetAttendancePassUseCase(super.loginRepository);

  Future<Response<GetAttendanceModel?>?> call() async {
    var response = await loginRepository.getAttendance();
    return response;
  }
}
