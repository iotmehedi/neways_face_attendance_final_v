import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neways_face_attendance_pro/core/core/extensions/extensions.dart';
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
  final box = GetStorage();
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

    SignInPassUseCase loginUseCase =
        SignInPassUseCase(locator<SignInRepository>());
    if (idController.value.text.isEmpty && (box.read("idNumber") == null)) {
      errorToast(context: context, msg: "Please enter phone number");
      // errorToastoast(context: context, msg: "Please enter phone");
    } else if (passwordController.value.text.isEmpty &&
        (box.read("password") == null)) {
      errorToast(context: context, msg: "Please enter password");
    } else {
      try {
        if (from == "signin") {
          isLoading.value = true;
        }
        update();
        response = await loginUseCase(
            employee_id: box.read("idNumber") ?? idController.value.text,
            password: box.read("password") ?? passwordController.value.text);
        print("response?.data12 ${response?.data}");
        if (response?.data != null) {
          session.createSession(response?.data,
              idNumber: idController.value.text,
              password: passwordController.value.text);
          RouteGenerator.pushNamedAndRemoveAll(context, Routes.homepage);
          if (!context.mounted) return;
          if ((box.read("email").toString().isEmpty) &&
              (box.read("password").toString().isEmpty)) {
            if (from == "signin") {
              successToast(
                  context: context, msg: response?.data?.message ?? '');
            }
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
