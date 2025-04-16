import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways_face_attendance_pro/core/core/extensions/extensions.dart';
import '../../../../../core/app_component/app_component.dart';
import '../../../../../core/routes/route_name.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/utils/consts/app_assets.dart';
import '../../../../../core/utils/consts/app_colors.dart';
import '../../../../../core/utils/consts/app_sizes.dart';
import '../../../../widgets/custom_elevatedButton/custom_eleveted_button.dart';
import '../../../../widgets/custom_elevatedButton/custom_text.dart';
import '../../../../widgets/custom_textfield/custom_textfield.dart';
import '../controller/signin_controller.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});
  var controller = locator<SigninController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: AppColorsList.white,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      20.ph,
                      Image.asset(
                        AppAssets.logo,
                        height: 120,
                        width: 120,
                      ),
                      20.ph,
                      CustomSimpleText(
                        text: "Welcome",
                        textAlignment: TextAlign.start,
                        fontSize: AppSizes.size14,
                        fontWeight: FontWeight.w600,
                      ),
                      5.ph,
                      CustomSimpleText(
                        text: "Let's Get Started!",
                        textAlignment: TextAlign.start,
                        fontSize: AppSizes.size17,
                        fontWeight: FontWeight.w600,
                      ),
                      20.ph,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                30.ph,
                                CustomTextfield(
                                  controller: controller.idController.value,
                                  hintText: "Enter employee ID",
                                  lebelText: "Enter your ID number",
                                  textInputType: TextInputType.number,
                                ),
                                20.ph,
                                Obx(
                                  () => CustomTextfield(
                                    controller:
                                        controller.passwordController.value,
                                    hintText: "Enter your password",
                                    lebelText: "Password",
                                    needObscureText: true,
                                    obscureText: controller.obscureText.value,
                                    onPress: () {
                                      controller.obscureText.value =
                                          !controller.obscureText.value;
                                    },
                                  ),
                                ),
                                40.ph,
                                controller.isLoading.value == true
                                    ? const CircularProgressIndicator()
                                    : CustomElevatedButton(
                                        hexColor:
                                            AppColorsList.maroonDeepLittle,
                                        text: "Sign in",
                                        fontSize: AppSizes.size14,
                                        fontWeight: FontWeight.w600,
                                        onPress: () {
                                          controller.submitLoginData(context,
                                              from: "signin");
                                        },
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      30.ph,
                    ],
                  ),
                ),

              ],
            ),
          ),
        ));
  }
}
