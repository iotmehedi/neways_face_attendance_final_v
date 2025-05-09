import 'dart:convert';
import '../../../../../../core/source/dio_client.dart';
import '../../../../../../core/source/model/api_response.dart';
import '../../../../../../core/source/session_manager.dart';
import '../../../../../core/app_component/app_component.dart';
import '../../../../../core/network/configuration.dart';
import '../../../../../core/status/status.dart';
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
}
