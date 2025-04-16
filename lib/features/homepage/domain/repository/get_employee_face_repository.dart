import 'dart:typed_data';

import 'package:neways_face_attendance_pro/features/homepage/data/model/attendance_binding_model.dart';

import '../../../../../../core/source/model/api_response.dart';
import '../../data/model/get_employee_face_model.dart';
import '../../data/source/get_employee_face_service.dart';

abstract class GetEmployeeFaceRepository {
  final GetEmployeeFaceService getEmployeeFaceService;

  GetEmployeeFaceRepository(this.getEmployeeFaceService);

  Future<Response<GetEmployeeFaceModel>?> recommended();
  Future<Response<AttendanceBindingModel>?> attendanceBinding();
  Future<Map<String, dynamic>?> attendanceValue({required String attendanceValue});
}
