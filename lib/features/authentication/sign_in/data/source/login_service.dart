import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:neways_face_attendance_pro/features/authentication/sign_in/data/model/get_attendance_model.dart';
import 'package:neways_face_attendance_pro/features/authentication/sign_in/data/model/otp_model.dart';

import '../../../../../../core/source/dio_client.dart';
import '../../../../../../core/source/model/api_response.dart';
import '../../../../../../core/source/session_manager.dart';
import '../../../../../core/app_component/app_component.dart';
import '../../../../../core/network/configuration.dart';
import '../../../../../core/status/status.dart';
import '../../../../../main.dart';
import '../model/get_roaster_model.dart';
import '../model/login_different_model.dart';
import '../model/login_model.dart';
import 'package:dio/dio.dart' as dio;

class SignInService {
  final DioClient _dioClient = locator<DioClient>();

// To decode the response if needed

  Future<Response<LoginModel>?> loginWithIdPass(
      String employee_id, String password) async {
    Response<LoginModel>? apiResponse;

    var formData = {
      "employee_id": employee_id,
      "password": password,
    };
    print("login credentials $formData");

    await _dioClient.post(
      path: NetworkConfiguration.login,
      request: formData,
      responseCallback: (response, message) {
        print(
            "API response login data 1 ${response}"); // Print the full response to check

        // Ensure you are passing the full response to the LoginModel
        var loginModel = LoginModel.fromJson(response);

        // Create a Response object with the parsed data
        apiResponse = Response.success(loginModel);
        logger.i("Login successful: $loginModel");
      },
      failureCallback: (message, status) {
        print("This is error message $message");
        apiResponse = Response.error(message, status);
      },
    );

    logger.e("API response login data ${apiResponse?.data?.accessToken}");
    return apiResponse;
  }

  Future<Response<LoginDifferentModel>?> differentLoginWithIdPass(
      String employee_id, String password) async {
    Response<LoginDifferentModel>? apiResponse;
    dio.FormData formData = dio.FormData.fromMap({
        "api_secret": "kAXan6SFy5U3UrzHMMQgCzFEHwU9jzuBF6kbsFMjRsCSY8fFVhwhRTZvBqrMbcK3",
        "username": employee_id,
        "password": password,
    });
    print("login credentials $formData");

    await _dioClient.post(
      path: NetworkConfiguration.login,
      request: formData,
      responseCallback: (response, message) {
        print(
            "API response login data 1 ${response}"); // Print the full response to check

        // Ensure you are passing the full response to the LoginModel
        var loginModel = LoginDifferentModel.fromJson(jsonDecode(response));

        // Create a Response object with the parsed data
        apiResponse = Response.success(loginModel);
        logger.i("Login successful: $loginModel");
      },
      failureCallback: (message, status) {
        print("This is error message $message");
        apiResponse = Response.error(message, status);
      },
    );

    logger.e("API response login data ${apiResponse?.data?.employee}");
    return apiResponse;
  }

  Future<Response<OTPModel>?> sendOTP() async {
    Response<OTPModel>? apiResponse;
    dio.FormData formData = dio.FormData.fromMap({
        "api_secret": "kAXan6SFy5U3UrzHMMQgCzFEHwU9jzuBF6kbsFMjRsCSY8fFVhwhRTZvBqrMbcK3",
        "employee_db_id": box.read("id"),
    });
    print("login credentials $formData");

    await _dioClient.post(
      path: NetworkConfiguration.sendOTP,
      request: formData,
      responseCallback: (response, message) {
        print(
            "API response otp data 1 ${response}"); // Print the full response to check

        // Ensure you are passing the full response to the LoginModel
        var otpModel = OTPModel.fromJson(jsonDecode(response));

        // Create a Response object with the parsed data
        apiResponse = Response.success(otpModel);
        logger.i("otp successful: $otpModel");
      },
      failureCallback: (message, status) {
        print("This is error message $message");
        apiResponse = Response.error(message, status);
      },
    );

    logger.e("API response login data ${apiResponse?.data?.code}");
    return apiResponse;
  }

  Future<Response<GetRoasterModel>?> getRoster() async {
    Response<GetRoasterModel>? apiResponse;
    dio.FormData formData = dio.FormData.fromMap({
        "api_secret": "kAXan6SFy5U3UrzHMMQgCzFEHwU9jzuBF6kbsFMjRsCSY8fFVhwhRTZvBqrMbcK3",
        "employee_db_id": box.read("id"),
    });
    print("login credentials $formData");

    await _dioClient.post(
      path: NetworkConfiguration.getRoster,
      request: formData,
      responseCallback: (response, message) {
        print(
            "API response roaster data 1 ${response}"); // Print the full response to check

        // Ensure you are passing the full response to the LoginModel
        var otpModel = GetRoasterModel.fromJson(jsonDecode(response));

        // Create a Response object with the parsed data
        apiResponse = Response.success(otpModel);
        logger.i("roaster successful: $otpModel");
      },
      failureCallback: (message, status) {
        print("This is error message $message");
        apiResponse = Response.error(message, status);
      },
    );

    logger.e("API response login data ${apiResponse?.data?.code}");
    return apiResponse;
  }

  Future<Response<GetAttendanceModel>?> getAttendance() async {
    Response<GetAttendanceModel>? apiResponse;
    dio.FormData formData = dio.FormData.fromMap({
        "api_secret": "kAXan6SFy5U3UrzHMMQgCzFEHwU9jzuBF6kbsFMjRsCSY8fFVhwhRTZvBqrMbcK3",
        "employee_db_id": box.read("id"),
        "attendance_date": DateFormat("yyyy-MM-dd").format(DateTime.now())
    });
    await _dioClient.post(
      path: NetworkConfiguration.getAttendance,
      request: formData,
      responseCallback: (response, message) {
        print(
            "API response attendance data 1 ${response}"); // Print the full response to check

        // Ensure you are passing the full response to the LoginModel
        var otpModel = GetAttendanceModel.fromJson(jsonDecode(response));

        // Create a Response object with the parsed data
        apiResponse = Response.success(otpModel);
        logger.i("attendance successful: $otpModel");
      },
      failureCallback: (message, status) {
        print("This is error message $message");
        apiResponse = Response.error(message, status);
      },
    );

    logger.e("API response login data ${apiResponse?.data?.code}");
    return apiResponse;
  }
}
