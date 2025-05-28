import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../../../../../core/source/dio_client.dart';
import '../../../../../../core/source/model/api_response.dart';
import '../../../../../core/app_component/app_component.dart';
import '../../../../../core/network/configuration.dart';
import '../../../../../core/status/status.dart';
import '../../../../../main.dart';
import '../../../../core/utils/common_toast/custom_toast.dart';
import '../model/update_profile_model.dart';
import 'package:dio/dio.dart' as dio;

class UpdateProfileService {
  final DioClient _dioClient = locator<DioClient>();
  Future<Response<UpdateProfileModel>?> updateProfilePass() async {
    Response<UpdateProfileModel>? apiResponse;
    await _dioClient.get(
      path: NetworkConfiguration.profile,

      responseCallback: (response, message) async {
            var responseModel = UpdateProfileModel.fromJson(jsonDecode(response));
            apiResponse = Response.success(responseModel);
      },
      failureCallback: (message, status) {
        print("this is mseeage $message , $status");
        // errorToast(context: navigatorKey.currentContext!, msg: "Already email or phone number exists");
        apiResponse = Response.error(message, status);
      },
    );
    // print("this is response11s ${response?.data}");
    return apiResponse;
  }
}
