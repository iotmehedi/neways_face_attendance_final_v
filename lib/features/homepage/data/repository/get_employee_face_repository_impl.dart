import '../../../../../../core/source/model/api_response.dart';
import '../../domain/repository/get_employee_face_repository.dart';
import '../model/attendance_binding_model.dart';
import '../model/get_employee_face_model.dart';

class GetEmployeeFaceRepositoryImpl extends GetEmployeeFaceRepository {
  GetEmployeeFaceRepositoryImpl(super.getEmployeeFaceService);

  @override
  Future<Response<GetEmployeeFaceModel>?> recommended() async {
    Response<GetEmployeeFaceModel>? apiResponse;
    apiResponse = await getEmployeeFaceService.recommended();
    return apiResponse;
  }

  @override
  Future<Map<String, dynamic>?> attendanceValue() async {
    Map<String, dynamic>? apiResponse;
    apiResponse = await getEmployeeFaceService.setAttendance();
    return apiResponse;
  }
  @override
  Future<Response<AttendanceBindingModel>?> attendanceBinding() async {
    Response<AttendanceBindingModel>? apiResponse;
    apiResponse = await getEmployeeFaceService.attendanceBinding();
    return apiResponse;
  }

}
