import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neways_face_attendance_pro/features/authentication/sign_in/data/model/login_different_model.dart';

import '../../features/authentication/sign_in/data/model/login_model.dart';

class SessionManager {
  final box = GetStorage();
  Future<bool> createSession(LoginDifferentModel? loginModelData,
      {String? idNumber, String? password}) async {
    try {
      box.write("id",loginModelData?.employee?.id);
     //  if(loginModelData?.attendance == null){
     //    box.write("isCheckedOut", false);
     //    box.write("isCheckedIn", false);
     //    box.write("checkedIn", null);
     //  } else if(loginModelData?.attendance?.checkinTime?.isNotEmpty ?? false || loginModelData?.attendance?.checkinTime != null){
     //    box.write("isCheckedIn", true);
     //    box.write("checkedIn", loginModelData?.attendance?.checkinTime);
     //  }else{
     //    box.write("isCheckedIn", false);
     //  }
     //  if((loginModelData?.attendanceStatus?.isNotEmpty ?? false) || (loginModelData?.attendanceStatus != null)){
     //    // box.write("isLate", loginModelData?.attendanceStatus.)
     //    for(var i in loginModelData!.attendanceStatus!){
     //      box.write("isLate", i.intiming);
     //    }
     //  }
     // if(loginModelData?.attendance == null){
     //   box.write("isCheckedOut", false);
     //   box.write("isCheckedIn", false);
     //   box.write("checkedOut", null);
     // } else if(loginModelData?.attendance?.checkoutTime?.isNotEmpty ?? false || loginModelData?.attendance?.checkoutTime != null){
     //    box.write("isCheckedOut", true);
     //    box.write("checkedOut", loginModelData?.attendance?.checkoutTime);
     //  }else{
     //    box.write("isCheckedOut", false);
     //  }
      box.write("employeeId",loginModelData?.employee?.employeeId);
      box.write("name",loginModelData?.employee?.fullName);
      box.write("photo",loginModelData?.employee?.avaterPhoto);
      box.write("email",loginModelData?.employee?.email);
      box.write("weekendDay",loginModelData?.employee?.weekenDayName);
      box.write("designation",loginModelData?.employee?.designationName);
      box.write("branchName",loginModelData?.employee?.branchName);
      box.write("personalNumber",loginModelData?.employee?.personalPhone);
      box.write("currentAddress",loginModelData?.employee?.currentAddress);
      box.write("departmentName",loginModelData?.employee?.departmentName);
      box.write("permanentAddress",loginModelData?.employee?.permanentAddress);
      // box.write("dutyStartTime", loginModelData?.employee?.startTime);
      // box.write("dutyEndTime", loginModelData?.employee?.endTime);
      // box.write("dutyEndTime", loginModelData?.user?.endTime);
      box.write("is_attendance_white_list", loginModelData?.employee?.isAttendanceWhiteList);
      // box.write("checkedInTime", loginModelData?.attendance?.checkinTime);
      // box.write("checkedOutTime", loginModelData?.attendance?.checkoutTime);
      // box.write('token', loginModelData?.accessToken);
      box.write('idNumber', idNumber);
      box.write("password", password);
      return true;
    } catch (e) {
      return false;
    }
  }
}
