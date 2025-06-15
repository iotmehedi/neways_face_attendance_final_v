import 'dart:convert';

import 'package:neways_face_attendance_pro/features/homepage/data/model/get_employee_face_model.dart';
import '../../../../../../core/source/dio_client.dart';
import '../../../../../../core/source/model/api_response.dart';
import '../../../../core/app_component/app_component.dart';
import '../../../../core/network/configuration.dart';
import '../../../../core/status/status.dart';
import '../../../../main.dart';
import '../model/attendance_binding_model.dart';
import 'package:dio/dio.dart' as dio;
class GetEmployeeFaceService {
  final DioClient _dioClient = locator<DioClient>();
  Future<Response<GetEmployeeFaceModel>?> recommended() async {
    Response<GetEmployeeFaceModel>? apiResponse;
    await _dioClient.get(
      path: NetworkConfiguration.getEmployeeFace,
      responseCallback: (response, message) {
        var products = GetEmployeeFaceModel.fromJson(response);

        apiResponse = Response.success(products);
      },
      failureCallback: (message, status) {
        apiResponse = Response.error(message, status);
      },
    );

    return apiResponse;
  }
  Future<Map<String, dynamic>?> setAttendance({required String wifiname, required String geoLocation}) async {
    Map<String, dynamic>? apiResponse;
    dio.FormData formData = dio.FormData.fromMap({
      "api_secret": "kAXan6SFy5U3UrzHMMQgCzFEHwU9jzuBF6kbsFMjRsCSY8fFVhwhRTZvBqrMbcK3",
      "employee_db_id": box.read("id"),
      "wifi_from" : wifiname,
      "geo_location": geoLocation
    });
// Convert FormData back to a readable Map
    final formDataMap = {
      "api_secret": formData.fields.firstWhere((field) => field.key == "api_secret").value,
      "employee_db_id": formData.fields.firstWhere((field) => field.key == "employee_db_id").value,
      "wifi_from": formData.fields.firstWhere((field) => field.key == "wifi_from").value,
      "geo_location": formData.fields.firstWhere((field) => field.key == "geo_location").value,
    };

    print("FormData contents: $formDataMap");

    await _dioClient.post(
      path: NetworkConfiguration.setAttendance,
      request: formData,
      responseCallback: (response, message) {
        print("API response login data 1 ${response}"); // Print the full response to check
        apiResponse = jsonDecode(response);
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
    dio.FormData formData = dio.FormData.fromMap({
      "api_secret": "kAXan6SFy5U3UrzHMMQgCzFEHwU9jzuBF6kbsFMjRsCSY8fFVhwhRTZvBqrMbcK3",
      "employee_db_id": box.read("id"),
    });
    print("hudai wifi $formData ${box.read("id")}");
    await _dioClient.post(
      request: formData,
      path: NetworkConfiguration.attendanceBinding,
      responseCallback: (response, message) {
        print("wi-fi information found 1212 ioio ${response} ${box.read("id")}");
        var products = AttendanceBindingModel.fromJson(jsonDecode(response));
        print("wi-fi information found 1212ppp ${products.attendanceBinding?.first.wifiAddress} ${box.read("id")}");
        apiResponse = Response.success(products);
      },
      failureCallback: (message, status) {
        apiResponse = Response.error(message, status);
      },
    );
    print("wi-fi information found 1212 jkjk ${apiResponse} ${box.read("id")}");
    return apiResponse;
  }
}
