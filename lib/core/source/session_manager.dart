import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../features/authentication/sign_in/data/model/login_model.dart';

class SessionManager {
  final box = GetStorage();
  Future<bool> createSession(LoginModel? loginModelData,
      {String? idNumber, String? password}) async {
    try {
      print("The check in time test ${loginModelData?.attendance?.checkoutTime}");
      box.write("id",loginModelData?.user?.employeeId);
      if(loginModelData?.attendance == null){
        box.write("isCheckedOut", false);
        box.write("isCheckedIn", false);
        box.write("checkedIn", null);
      } else if(loginModelData?.attendance?.checkinTime?.isNotEmpty ?? false || loginModelData?.attendance?.checkinTime != null){
        box.write("isCheckedIn", true);
        box.write("checkedIn", loginModelData?.attendance?.checkinTime);
      }else{
        box.write("isCheckedIn", false);
      }
     if(loginModelData?.attendance == null){
       box.write("isCheckedOut", false);
       box.write("isCheckedIn", false);
       box.write("checkedOut", null);
     } else if(loginModelData?.attendance?.checkoutTime?.isNotEmpty ?? false || loginModelData?.attendance?.checkoutTime != null){
        box.write("isCheckedOut", true);
        box.write("checkedOut", loginModelData?.attendance?.checkoutTime);
      }else{
        box.write("isCheckedOut", false);
      }
      box.write("id",loginModelData?.user?.employeeId);
      box.write("name",loginModelData?.user?.fullName);
      box.write("photo",loginModelData?.user?.avaterPhoto);
      box.write("dutyStartTime", loginModelData?.user?.startTime);
      box.write("dutyEndTime", loginModelData?.user?.endTime);
      box.write("dutyEndTime", loginModelData?.user?.endTime);
      box.write("is_attendance_white_list", loginModelData?.user?.isAttendanceWhiteList);
      box.write("checkedInTime", loginModelData?.attendance?.checkinTime);
      box.write("checkedOutTime", loginModelData?.attendance?.checkoutTime);
      box.write('token', loginModelData?.accessToken);
      box.write('idNumber', idNumber);
      box.write("password", password);
      return true;
    } catch (e) {
      return false;
    }
  }
}
