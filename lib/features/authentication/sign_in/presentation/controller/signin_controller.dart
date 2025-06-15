import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neways_face_attendance_pro/core/core/extensions/extensions.dart';
import 'package:neways_face_attendance_pro/features/authentication/sign_in/data/model/get_attendance_model.dart';
import 'package:neways_face_attendance_pro/features/authentication/sign_in/data/model/get_roaster_model.dart';
import '../../../../../../core/routes/route_name.dart';
import '../../../../../../core/routes/router.dart';
import '../../../../../../main.dart';
import '../../../../../core/app_component/app_component.dart';
import '../../../../../core/utils/consts/app_sizes.dart';
import '../../../../widgets/custom_elevatedButton/custom_text.dart';
import '../../../../widgets/custom_toast.dart';
import '../../domain/repository/login_repository.dart';
import '../../domain/usecase/login_with_id_pass_usecase.dart';

class SigninController extends GetxController {
  var obscureText = true.obs;
  var idController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var passwordVisibility = false.obs;
  var errorMessage = ''.obs;
  var isLoading = false.obs;
  var isOTPSendingLoading = false.obs;
  var isGetRoasterLoading = false.obs;
  var isGetAttendanceLoading = false.obs;
  final box = GetStorage();
  var code = "".obs;
  var fromPage = "".obs;
  var otpValue = ''.obs;
  var getRoasterModel = GetRoasterModel().obs;
  var getAttendanceModel = GetAttendanceModel().obs;
  @override
  void onInit() {
    initializeOfTextfield();
    super.onInit();
  }

  initializeOfTextfield() {
    if ((box.read("idNumber") != null) && (box.read("password") != null)) {
      idController.value.text = box.read("idNumber") ?? "";
      passwordController.value.text = box.read("password") ?? "";
    }
  }

  passwordVisibilityFun() {
    passwordVisibility.value = !passwordVisibility.value;
    print(passwordVisibility.value);
    update();
  }

  errorMessageHandling(String? s) {
    if (passwordController.value.text.isNotEmpty) {
      errorMessage.value = 'Password must be filled';
    } else {
      errorMessage.value = '';
    }
    update();
  }

  submitLoginData(BuildContext context, {required String from}) async {
    var response;

    SignInDifferentPassUseCase loginUseCase =
    SignInDifferentPassUseCase(locator<SignInRepository>());
    if (idController.value.text.isEmpty && (box.read("idNumber") == null)) {
      errorToast(context: context, msg: "Please enter phone number");
    } else if (passwordController.value.text.isEmpty &&
        (box.read("password") == null)) {
      errorToast(context: context, msg: "Please enter password");
    } else {
      try {
        if (from == "signin") {
          isLoading.value = true;
        }
        update();
      var  response = await loginUseCase(
            employee_id: box.read("idNumber") ?? idController.value.text,
            password: box.read("password") ?? passwordController.value.text);
        print("response?.data12 ${response?.data}");
        if (response?.data != null ) {
          print("this is the value of login ${response?.data?.code} ${response?.data?.message} ${box.read("idNumber")} ${box.read("password")}");
          if(response?.data?.code == "200"){
            session.createSession(response?.data,
                idNumber: idController.value.text,
                password: passwordController.value.text);
            if(box.read("otp") == null){
              RouteGenerator.pushNamed(context, Routes.otpScreen);
              await activeUserFunction(context: context, from: "Signin");
            }else{
              await getRoaster(context: context);
              await getAttendance(context: context);
              RouteGenerator.pushNamedAndRemoveAll(context, Routes.homepage);
            }
            idController.value.clear();
            passwordController.value.clear();
            if (!context.mounted) return;
            if ((box.read("email").toString().isEmpty) &&
                (box.read("password").toString().isEmpty)) {
              if (from == "signin") {
                // successToast(
                //     context: context, msg: response?.data?.message ?? '');
              }
            }
          }else if(response?.data?.code == "404"){
            errorToast(context: context, msg: response?.data?.message ?? '');
          }

        } else {
          if (!context.mounted) return;
          if (response?.data?.status == null) {
            errorToast(context: context, msg: "Invalid login credential!");
          }
        }
      } catch (e) {
        isLoading.value = false;
        if (e.toString().contains("404")) {
          errorToast(
              context: context,
              msg: "No user found. Incorrect Password or Email");
          box.erase();
          // RouteGenerator.pushNamedAndRemoveAll(context, Routes.signinPage);
        } else if(e.toString().contains("401")){
          errorToast(
              context: context,
              msg:
              "Password is wrong. Please enter correct password");

        } else if(e.toString().contains("500")){
          errorToast(
              context: context,
              msg:
              "Please enter correct credentials");
        } else {
          box.erase();
          // RouteGenerator.pushNamedAndRemoveAll(context, Routes.registrationPage);
          errorToast(
              context: context,
              msg:
                  "User not found or something went wrong. Please ensure your credentials");
        }

        print("response?.data?.status ${e.toString()}");

        print(e.toString() ?? '');
      } finally {
        isLoading.value = false;
      }
    }

    isLoading.value = false;
    update();
  }
  activeUserFunction(
      {required BuildContext context,required String from}) async {

    try {
      isOTPSendingLoading.value= true;
      SendOTPPassUseCase otpPassUseCase =
      SendOTPPassUseCase(locator<SignInRepository>());
      update();
      var response = await otpPassUseCase();
      print("otp response ${response?.data?.otp}");
      if (response?.data != null) {
        successToast(context: context, msg: "OTP send successfully");
        otpValue.value = response?.data?.otp.toString() ?? '';
        box.write("otp", response?.data?.otp);
        print("the otp is ${otpValue.value}");
        fromPage.value = from;
        update(['otp']);
        getRoaster(context: context);
        getAttendance(context: context);
      } else {
        if (!context.mounted) return;

        // if (response?.data?.message?.isNotEmpty ?? false) {
        //   errorToast(context: context, msg: response?.message ?? '');
        // }
      }
    } catch (e) {
      print("this is otp error ${e.toString()}");
      errorToast(context: context, msg: "Some thing went wrong. Please try again.");
      isOTPSendingLoading.value = false;
    } finally {
      isOTPSendingLoading.value = false;
    }
    isOTPSendingLoading.value = false;
    update();
  }
  getRoaster(
      {required BuildContext context}) async {
    isGetRoasterLoading.value= true;
    try {
      GetRoasterPassUseCase otpPassUseCase =
      GetRoasterPassUseCase(locator<SignInRepository>());
      update();

      var response = await otpPassUseCase();
      if (response?.data != null) {
        getRoasterModel.value = response?.data ?? GetRoasterModel();
        box.write("dutyStartTime", getRoasterModel.value.roastingInfo?.startTime);
        box.write("dutyEndTime", getRoasterModel.value.roastingInfo?.endTime);
        box.write("dutyEndTime", getRoasterModel.value.roastingInfo?.endTime);
      }
    } catch (e) {
      isGetRoasterLoading.value = false;
    } finally {
      isGetRoasterLoading.value = false;
    }
    isGetRoasterLoading.value = false;
    update();
  }
  getAttendance(
      {required BuildContext context}) async {
    isGetAttendanceLoading.value= true;
    try {
      GetAttendancePassUseCase getAttendancePassUseCase =
      GetAttendancePassUseCase(locator<SignInRepository>());
      update();

      var response = await getAttendancePassUseCase();
      print("get attendance ${response?.data?.attendance?.checkinTime}");
      if (response?.data != null) {
        getAttendanceModel.value = response?.data ?? GetAttendanceModel();
        box.write("checkedInTime", getAttendanceModel.value.attendance?.checkinTime);
        box.write("checkedOutTime", getAttendanceModel.value.attendance?.checkoutTime);
         if(getAttendanceModel.value.attendance == null){
           box.write("isCheckedOut", false);
           box.write("isCheckedIn", false);
           box.write("checkedIn", null);
         } else if(getAttendanceModel.value.attendance?.checkinTime?.isNotEmpty ?? false){
           box.write("isCheckedIn", true);
           box.write("checkedIn", getAttendanceModel.value.attendance?.checkinTime);
         }else{
           box.write("isCheckedIn", false);
         }
         if((getAttendanceModel.value.attendanceStatus?.isNotEmpty ?? false) || (getAttendanceModel.value.attendanceStatus != null)){
           for(var i in getAttendanceModel.value.attendanceStatus!){
             if(i.type?.toLowerCase() == "checkin" || i.type?.toLowerCase() == "check in"){
               box.write("checkinStatus", i.intiming);
               box.write("checkinType", i.type);
             }else if(i.type?.toLowerCase() == "checkout" || i.type?.toLowerCase() == "check out"){
               box.write("checkoutStatus", i.intiming);
               box.write("checkoutType", i.type);
             }
           }
           update();
         }
        if(getAttendanceModel.value.attendance == null){
          box.write("isCheckedOut", false);
          box.write("isCheckedIn", false);
          box.write("checkedOut", null);
        } else if(getAttendanceModel.value.attendance?.checkoutTime?.isNotEmpty ?? false || getAttendanceModel.value.attendance?.checkoutTime != null){
           box.write("isCheckedOut", true);
           box.write("checkedOut", getAttendanceModel.value.attendance?.checkoutTime);
           update();
         }else{
           box.write("isCheckedOut", false);
           update();
         }
      }
    } catch (e) {
      isGetAttendanceLoading.value = false;
    } finally {
      isGetAttendanceLoading.value = false;
    }
    isGetAttendanceLoading.value = false;
    update();
  }
  // submitLoginData(BuildContext context, {required String from}) async {
  //   var response;
  //
  //   SignInPassUseCase loginUseCase =
  //       SignInPassUseCase(locator<SignInRepository>());
  //   if (idController.value.text.isEmpty && (box.read("idNumber") == null)) {
  //     errorToast(context: context, msg: "Please enter phone number");
  //   } else if (passwordController.value.text.isEmpty &&
  //       (box.read("password") == null)) {
  //     errorToast(context: context, msg: "Please enter password");
  //   } else {
  //     try {
  //       if (from == "signin") {
  //         isLoading.value = true;
  //       }
  //       update();
  //       response = await loginUseCase(
  //           employee_id: box.read("idNumber") ?? idController.value.text,
  //           password: box.read("password") ?? passwordController.value.text);
  //       print("response?.data12 ${response?.data}");
  //       if (response?.data != null) {
  //         session.createSession(response?.data,
  //             idNumber: idController.value.text,
  //             password: passwordController.value.text);
  //         RouteGenerator.pushNamedAndRemoveAll(context, Routes.homepage);
  //         idController.value.clear();
  //         passwordController.value.clear();
  //         if (!context.mounted) return;
  //         if ((box.read("email").toString().isEmpty) &&
  //             (box.read("password").toString().isEmpty)) {
  //           if (from == "signin") {
  //             successToast(
  //                 context: context, msg: response?.data?.message ?? '');
  //           }
  //         }
  //       } else {
  //         if (!context.mounted) return;
  //         if (response?.data?.status == null) {
  //           errorToast(context: context, msg: "Invalid login credential!");
  //         }
  //       }
  //     } catch (e) {
  //       isLoading.value = false;
  //       if (e.toString().contains("404")) {
  //         errorToast(
  //             context: context,
  //             msg: "No user found. Incorrect Password or Email");
  //         box.erase();
  //         // RouteGenerator.pushNamedAndRemoveAll(context, Routes.signinPage);
  //       } else if(e.toString().contains("401")){
  //         errorToast(
  //             context: context,
  //             msg:
  //             "Password is wrong. Please enter correct password");
  //
  //       } else if(e.toString().contains("500")){
  //         errorToast(
  //             context: context,
  //             msg:
  //             "Please enter correct credentials");
  //       } else {
  //         box.erase();
  //         // RouteGenerator.pushNamedAndRemoveAll(context, Routes.registrationPage);
  //         errorToast(
  //             context: context,
  //             msg:
  //                 "User not found or something went wrong. Please ensure your credentials");
  //       }
  //
  //       print("response?.data?.status ${e.toString()}");
  //
  //       print(e.toString() ?? '');
  //     } finally {
  //       isLoading.value = false;
  //     }
  //   }
  //
  //   isLoading.value = false;
  //   update();
  // }

  void ErrorDialog(BuildContext context, {required String msg}) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Less curved corners
          ),
          title: CustomSimpleText(
            text: "Server Error",
            color: Colors.red,
            fontSize: AppSizes.size17,
          ),
          content: SingleChildScrollView(
            // Allows the content to scroll if it exceeds available height
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Ensures dialog adjusts to content height
              children: [
                CustomSimpleText(
                  text: msg,
                  color: Colors.black,
                  fontSize: AppSizes.size16,
                ),
                5.ph,
              ],
            ),
          ),
          // actions: [
          //   TextButton(
          //     onPressed: () {
          //       Navigator.of(context).pop(); // Close the dialog
          //     },
          //     child: CustomSimpleText(
          //       alignment: Alignment.centerRight,
          //       text: "Close",
          //       color: Colors.red,
          //       fontSize: AppSizes.size16,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ],
        );
      },
    );
  }
}
