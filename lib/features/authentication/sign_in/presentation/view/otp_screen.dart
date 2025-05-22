import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways_face_attendance_pro/core/core/extensions/extensions.dart';
import 'package:neways_face_attendance_pro/features/authentication/sign_in/presentation/controller/signin_controller.dart';
import 'package:neways_face_attendance_pro/features/widgets/custom_elevatedButton/custom_text.dart';
import '../../../../../core/app_component/app_component.dart';
import '../../../../../core/routes/route_name.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/utils/common_toast/custom_toast.dart';
import '../../../../../core/utils/consts/app_assets.dart';
import '../../../../../core/utils/consts/app_colors.dart';
import '../../../../../core/utils/consts/app_sizes.dart';
import '../../../../../main.dart';
import '../../../../widgets/custom_elevatedButton/custom_eleveted_button.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  // var controller = locator<ActiveUserController>();

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  Timer? _timer;
  int _remainingTime = 5 * 60; // 5 minutes in seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  // String _formatTime(int totalSeconds) {
  //   final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
  //   final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
  //   return '$minutes:$seconds';
  // }

  void _onChanged(String value, int index) {
    if (value.length == 1) {
      if (index < _focusNodes.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus(); // Close keyboard on the last field
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SigninController>(
        id: 'otp',
        init: SigninController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColorsList.maroonDeepLittle,
              title: Text(
                'Verification',
                style: TextStyle(color: AppColorsList.white),
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: AppColorsList.white,
                  )),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    150.ph,
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Image.asset(
                        AppAssets.passwordImage,
                        height: AppSizes.newSize(17),
                        width: AppSizes.newSize(17),
                      ),
                    ),
                    20.ph,
                    const Text(
                      'Enter Verification Code',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Check you phone or what's app number to activate your account",
                      style: TextStyle(
                          fontSize: AppSizes.size14,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 50,
                          child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 2),
                                ),
                              ),
                              onChanged: (value) {
                                _onChanged(value, index);
                                controller.code.value = _controllers
                                    .map((controller) => controller.text)
                                    .join();
                                print("Updated OTP: ${controller.code.value}");
                                controller.code.refresh();
                                if (controller.code.value.length ==
                                    _controllers.length) {
                                  if (controller.code.value.toString() ==
                                      box.read('otp').toString()) {
                                    if (controller.fromPage.value ==
                                        "Forget Password") {
                                      RouteGenerator.pushNamedAndRemoveAll(
                                          context, Routes.signinPage);
                                    } else {
                                      RouteGenerator.pushNamedAndRemoveAll(
                                          context, Routes.homepage);
                                    }
                                  } else {
                                    print(
                                        "The otp value is ${controller.code.value} ${controller.code.value.runtimeType} ${box.read('otp')} ${box.read('otp').runtimeType}");
                                    errorToast(
                                        context: context,
                                        msg: "Please enter correct otp");
                                  }
                                }
                              }),
                        );
                      }),
                    ),
                    30.ph,
                    InkWell(
                      onTap: (){
                        controller.activeUserFunction(context: context, from: "signin");
                      },
                      child: CustomRichText(
                        title: "RESEND",
                        titleFontWeight: FontWeight.bold,
                        titleFontSIze: AppSizes.size12,
                        titleTextColor: AppColorsList.maroonDeepLittle,
                        heading: "Didn't get any otp?",
                        headingFontSize: AppSizes.size12,
                        headingFontWeight: FontWeight.bold,
                        headingTextColor: AppColorsList.black,
                      ),
                    ),
                    10.ph,
                    Obx(() => controller.isOTPSendingLoading.value
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox()),
                    const SizedBox(height: 30),
                    // Obx(() => controller.isLoading.value
                    //     ? Center(
                    //         child: CircularProgressIndicator(),
                    //       )
                    //     : CustomElevatedButton(
                    //         text: controller.code.value ==
                    //             box.read('otp').toString() ? "Verified" : "Verify",
                    //         hexColor: AppColorsList.orange,
                    //         onPress: () {
                    //           controller.code.value = _controllers
                    //               .map((controller) => controller.text)
                    //               .join();
                    //
                    //
                    //         },
                    //       ))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
