import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../main.dart';
import '../network/configuration.dart';
import '../utils/common_methods/common_methods.dart';
import '../utils/consts/app_colors.dart';
import '../utils/consts/constants.dart';

class DioClient {
  final Dio dio;
  final box = GetStorage();
  DioClient(this.dio);

  Future<Response?> post({
    required String path,
    dynamic request,
    required Function(dynamic, String?) responseCallback,
    required Function(String?, int?) failureCallback,
    dynamic header,
  }) async {
    Response? response;
    var connectivityResult = await (Connectivity().checkConnectivity());
    // try {
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      response = await dio.post(
        (NetworkConfiguration.baseUrl) + path,
        data: request,
        // queryParameters: request,
        options: Options(
          method: "POST",
          receiveTimeout: const Duration(milliseconds: 30000),
        ),
      );
      print("response body ${response}");
      // var csrftoken = response.headers.remove('set-cookie').substring(10, 74);
      if (response.data != null) {
        logger.i("dio response $response");
        responseCallback(response.data, response.statusMessage);
      } else {
        failureCallback(response.statusMessage, response.statusCode);
      }
    } else {
      // CommonMethods.showToast(Constants.MESSAGE_NO_INTERNET, ThemeConfig.white);
    }
    // } catch (e) {
    //   // logger.d(e.toString());
    //   failureCallback("Something went wrong!", 400);
    // }
    return response;
  }


  Future<Response?> petch({
    required String path,
    dynamic request,
    required Function(dynamic, String?) responseCallback,
    required Function(String?, int?) failureCallback,
    dynamic header,
  }) async {
    Response? response;
    var connectivityResult = await (Connectivity().checkConnectivity());
    // try {
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      response = await dio.patch(
        (NetworkConfiguration.baseUrl) + path,
        data: request,
        // queryParameters: request,
        options: Options(
          method: "PATCH",
          headers: {
            'Authorization': 'Bearer ${box.read("token")}',
            'Accept': 'application/json'
          },
          receiveTimeout: const Duration(milliseconds: 30000),
        ),
      );
      // var csrftoken = response.headers.remove('set-cookie').substring(10, 74);
      if (response.data != null) {
        logger.i("dio response $response");
        logger.i("dio response111 ${response.data}");

        responseCallback(response.data, response.statusMessage);
      } else {
        failureCallback(response.statusMessage, response.statusCode);
      }
    } else {
      // CommonMethods.showToast(Constants.MESSAGE_NO_INTERNET, Colors.white);
    }
    // } catch (e) {
    //   // logger.d(e.toString());
    //   failureCallback("Something went wrong!", 400);
    // }
    return response;
  }

  Future<Response?> postMultiplatFormData({
    required String path,
    dynamic request,
    required Function(dynamic, String?) responseCallback,
    required Function(String?, int?) failureCallback,
    dynamic header,
  }) async {
    Response? response;
    var connectivityResult = await (Connectivity().checkConnectivity());
    try {
      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi)) {
        print("the url is ${NetworkConfiguration.baseUrl + path}");
        response = await dio.post(
          NetworkConfiguration.baseUrl + path,
          data: request,
          options: Options(
            headers: {
              "Content-Type": "multipart/form-data",
              "Accept": "*/*",
              'Authorization': 'Bearer ${box.read("token")}',
            },
            method: "POST",
            receiveTimeout: const Duration(milliseconds: 30000),
          ),
        );
        logger.i("dio response $response");
        if (response.data != null) {
          logger.i("dio response $response");
          responseCallback(response.data, response.statusMessage);
        } else {
          failureCallback(response.statusMessage, response.statusCode);
        }
      } else {
        CommonMethods.showToast(
            Constants.MESSAGE_NO_INTERNET, AppColorsList.white);
      }
    } catch (e) {
      logger.d(e.toString());
      failureCallback(e.toString(), 400);
    }
    return response;
  }

  // Future<Response?> postUpload({
  //   required String path,
  //   dynamic request,
  //   required Function(dynamic) responseCallback,
  //   required Function(String?, int?) failureCallback,
  //   dynamic header,
  // }) async {
  //   Response? response;
  //   var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  //   var formData = FormData.fromMap({
  //     'Image': '${request["Image"]}',
  //     'status': '${request["status"]}', //'101075',
  //     'Company': '${request["Company"]}',
  //     'DocumentType': '${request["DocumentType"]}'
  //   });
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   try {
  //     if (connectivityResult == ConnectivityResult.mobile ||
  //         connectivityResult == ConnectivityResult.wifi) {
  //       response = await dio.post(
  //           'https://corporate3.bdjobs.com/api/v1/Uddokta/DocumentUpload.aspx',
  //           data: formData,
  //           options: Options(headers: headers));
  //
  //       if (response.data != null && response.statusCode == HttpStatus.ok ||
  //           response.statusCode == 200) {
  //         responseCallback(response.data);
  //       } else {
  //         failureCallback(response.statusMessage, response.statusCode);
  //       }
  //     } else if (connectivityResult == ConnectivityResult.none) {
  //       failureCallback(noInternetConnectionMessage, 12029);
  //     }
  //   } catch (e) {
  //     logger.e("Response code: ${response?.statusCode}");
  //     logger.e(e);
  //     failureCallback(tryAgainErrorMessage, 400);
  //   }
  //   return response;
  // }

  Future<Response?> get({
    required String path,
    required Function(dynamic, String?) responseCallback,
    required Function(String?, int?) failureCallback,
    Map<String, Object>? queryParameters,
    bool? isNeedToken,
  }) async {
    Response? response;
    var connectivityResult = await (Connectivity().checkConnectivity());

    print("response.dataASDasdASDasds1 ${NetworkConfiguration.baseUrl + path}");
    try {
      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi)) {
        response = await dio.get(
          NetworkConfiguration.baseUrl + path,
          queryParameters: queryParameters,
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${box.read("token")}',
            },
            method: "GET",
            receiveTimeout: const Duration(milliseconds: 3000),
          ),
        );
        print(
            "response.dataASDasdASDasds user notification ${NetworkConfiguration.baseUrl + path} ${response.data} ${box.read("token")}");
        print("session token ${box.read("token")}");

        if (response.data != null) {
          logger.i("dio response $response");
          responseCallback(response.data, response.statusMessage);
        } else {
          failureCallback(response.statusMessage, response.statusCode);
        }
      } else if (connectivityResult.contains(ConnectivityResult.none)) {
        // failureCallback(noInternetConnectionMessage, 12029);
      }
    } on Exception catch (e, _) {
      // failureCallback(tryAgainErrorMessage, 400);
    }
    return response;
  }

  Future<Response?> delete({
    required String path,
    required Function(dynamic, String?) responseCallback,
    required Function(String?, int?) failureCallback,
    Map<String, Object>? queryParameters,
    bool? isNeedToken,
  }) async {
    Response? response;
    var connectivityResult = await (Connectivity().checkConnectivity());
    print("the url is ${NetworkConfiguration.baseUrl + path}");
    print("response.dataASDasdASDasds1 ${response} $queryParameters");
    try {
      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi)) {
        response = await dio.delete(
          NetworkConfiguration.baseUrl + path,
          queryParameters: queryParameters,
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${box.read("token")}',
            },
            method: "GET",
            receiveTimeout: const Duration(milliseconds: 3000),
          ),
        );
        print(
            "response.dataASDasdASDasds user ${box.read("token")} ${response.data}");
        print("session token ${box.read("token")}");

        if (response.data != null) {
          logger.i("dio response $response");
          responseCallback(response.data, response.statusMessage);
        } else {
          failureCallback(response.statusMessage, response.statusCode);
        }
      } else if (connectivityResult.contains(ConnectivityResult.none)) {
        // failureCallback(noInternetConnectionMessage, 12029);
      }
    } on Exception catch (e, _) {
      // failureCallback(tryAgainErrorMessage, 400);
    }
    return response;
  }
}
