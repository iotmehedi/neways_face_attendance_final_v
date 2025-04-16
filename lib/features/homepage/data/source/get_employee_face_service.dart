import 'package:neways_face_attendance_pro/features/homepage/data/model/get_employee_face_model.dart';
import '../../../../../../core/source/dio_client.dart';
import '../../../../../../core/source/model/api_response.dart';
import '../../../../core/app_component/app_component.dart';
import '../../../../core/network/configuration.dart';
import '../../../../core/status/status.dart';
import '../model/attendance_binding_model.dart';

class GetEmployeeFaceService {
  final DioClient _dioClient = locator<DioClient>();
  Future<Response<GetEmployeeFaceModel>?> recommended() async {
    Response<GetEmployeeFaceModel>? apiResponse;
    await _dioClient.get(
      path: NetworkConfiguration.getEmployeeFace,
      responseCallback: (response, message) {
        var products = GetEmployeeFaceModel.fromJson(response);
        print(
            "this is value image ${products.employeeFaceAttendance?.first.imageUrl}");
        apiResponse = Response.success(products);
      },
      failureCallback: (message, status) {
        print("this is value image error $message $status");
        apiResponse = Response.error(message, status);
      },
    );

    return apiResponse;
  }
  Future<Map<String, dynamic>?> setAttendance({required String attendanceValue}) async {
    Map<String, dynamic>? apiResponse;
    var formData = {
      "faceMatch": attendanceValue,
    };
    print("login credentials $formData");

    await _dioClient.post(
      path: NetworkConfiguration.setAttendance,
      request: formData,
      responseCallback: (response, message) {
        print("API response login data 1 ${response}"); // Print the full response to check

        apiResponse = response;

      },
      failureCallback: (message, status) {
        print("This is error message $message");
        apiResponse = {"error": message, "status": status};
      },
    );

    logger.e("API response login data ${apiResponse}");
    return apiResponse;
  }
  Future<Response<AttendanceBindingModel>?> attendanceBinding() async {
    Response<AttendanceBindingModel>? apiResponse;
    await _dioClient.get(
      path: NetworkConfiguration.attendanceBinding,
      responseCallback: (response, message) {
        var products = AttendanceBindingModel.fromJson(response);

        apiResponse = Response.success(products);
      },
      failureCallback: (message, status) {
        print("this is value image error $message $status");
        apiResponse = Response.error(message, status);
      },
    );

    return apiResponse;
  }
}
