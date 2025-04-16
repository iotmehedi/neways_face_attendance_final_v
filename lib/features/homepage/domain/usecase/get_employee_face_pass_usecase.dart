import 'dart:typed_data';

import 'package:neways_face_attendance_pro/features/homepage/data/model/attendance_binding_model.dart';

import '../../../../../../core/source/model/api_response.dart';
import '../../data/model/get_employee_face_model.dart';
import 'get_employee_face_usecase.dart';

class GetEmployeeFacePassUseCase extends GetEmployeeFaceUseCase {
  GetEmployeeFacePassUseCase(super.getEmployeeFaceRepository);

  Future<Response<GetEmployeeFaceModel>?> call() async {
    var response = await getEmployeeFaceRepository.recommended();
    return response;
  }
}

class SetAttendancePassUseCase extends GetEmployeeFaceUseCase {
  SetAttendancePassUseCase(super.getEmployeeFaceRepository);

  Future<Map<String, dynamic>?> call({required String attendanceValue}) async {
    var response = await getEmployeeFaceRepository.attendanceValue(attendanceValue: attendanceValue);
    return response;
  }
}


class AttendanceBindingPassUseCase extends GetEmployeeFaceUseCase {
  AttendanceBindingPassUseCase(super.getEmployeeFaceRepository);

  Future<Response<AttendanceBindingModel>?> call() async {
    var response = await getEmployeeFaceRepository.attendanceBinding();
    return response;
  }
}
