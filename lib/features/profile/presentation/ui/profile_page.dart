import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways_face_attendance_pro/core/core/extensions/extensions.dart';
import 'package:neways_face_attendance_pro/features/widgets/custom_textfield/custom_textfield.dart';

import '../../../../core/network/configuration.dart';
import '../../../../core/utils/consts/app_colors.dart';
import '../../../../core/utils/consts/app_sizes.dart';
import '../../../../main.dart';
import '../../../widgets/cached_image_network/custom_cached_image_network.dart';
import '../../../widgets/customAppBar_Widget.dart';
import '../../../widgets/custom_elevatedButton/custom_text.dart';
import '../controller/profile_controller.dart';

class ProfilePageScreen extends StatelessWidget {
  const ProfilePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          return Scaffold(
            appBar: CustomAppBar(
              title: CustomSimpleText(
                text: "Profile",
                fontWeight: FontWeight.bold,
                fontSize: AppSizes.size18,
                color: Colors.white,
              ),
              leadingWidget: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColorsList.white,
                ),
              ),
            ),
            body: Obx(() => controller.isLoading.value == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          20.ph,
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CustomCachedImageNetwork(
                                height: AppSizes.newSize(14),
                                weight: AppSizes.newSize(14),
                                boxfit: BoxFit.cover,
                                imageUrl:
                                    "${NetworkConfiguration.imageUrl}${controller.profileModel.value.user?.avaterPhoto}",
                              ),
                            ),
                          ),
                          20.ph,
                          controller.profileModel.value.user?.fullName
                                      ?.isEmpty ??
                                  false
                              ? SizedBox.shrink()
                              : CustomSimpleText(
                                  text: controller
                                          .profileModel.value.user?.fullName ??
                                      ''),
                          controller.profileModel.value.user?.email?.isEmpty ??
                                  false
                              ? SizedBox.shrink()
                              : CustomSimpleText(
                                  text: controller
                                          .profileModel.value.user?.email ??
                                      ''),
                          5.ph,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomRichText(
                                title: box.read("dutyStartTime"),
                                heading: "Check in:",
                                headingFontSize: AppSizes.size13,
                                titleFontSIze: AppSizes.size13,
                                titleTextColor: AppColorsList.blue,
                              ),
                              10.pw,
                              CustomRichText(
                                title: box.read("dutyEndTime"),
                                heading: "Check out:",
                                headingFontSize: AppSizes.size13,
                                titleFontSIze: AppSizes.size13,
                                titleTextColor: AppColorsList.blue,
                              ),
                            ],
                          ),
                          40.ph,
                          controller.profileModel.value.user?.weekenDayName
                                      ?.isEmpty ??
                                  false
                              ? SizedBox.shrink()
                              : CustomRow(
                                  title: "Weekend Day:",
                                  value: controller.profileModel.value.user
                                          ?.weekenDayName ??
                                      ''),
                          5.ph,
                          controller.profileModel.value.user?.designationName
                                      ?.isEmpty ??
                                  false
                              ? SizedBox.shrink()
                              : CustomRow(
                                  title: "Designation:",
                                  value: controller.profileModel.value.user
                                          ?.designationName ??
                                      ''),
                          5.ph,
                          controller.profileModel.value.user?.branchName
                                      ?.isEmpty ??
                                  false
                              ? SizedBox.shrink()
                              : CustomRow(
                                  title: "Branch Name:",
                                  value: controller.profileModel.value.user
                                          ?.branchName ??
                                      ''),
                          5.ph,
                          controller.profileModel.value.user?.personalPhone
                                      ?.isEmpty ??
                                  false
                              ? SizedBox.shrink()
                              : CustomRow(
                                  title: "Personal Number:",
                                  value: controller.profileModel.value.user
                                          ?.personalPhone ??
                                      ''),
                          5.ph,
                          controller.profileModel.value.user?.currentAddress
                                      ?.isEmpty ??
                                  false
                              ? SizedBox.shrink()
                              : CustomRow(
                                  title: "Currect Address:",
                                  value: controller.profileModel.value.user
                                          ?.currentAddress ??
                                      ''),
                          5.ph,
                          controller.profileModel.value.user?.departmentName
                                      ?.isEmpty ??
                                  false
                              ? SizedBox.shrink()
                              : CustomRow(
                                  title: "Department Name:",
                                  value: controller.profileModel.value.user
                                          ?.departmentName ??
                                      ''),
                          5.ph,
                          controller.profileModel.value.user?.permanentAddress
                                      ?.isEmpty ??
                                  false
                              ? SizedBox.shrink()
                              : CustomRow(
                                  title: "Permanent Address:",
                                  value: controller.profileModel.value.user
                                          ?.permanentAddress ??
                                      ''),
                          5.ph,
                        ],
                      ),
                    ),
                  )),
          );
        });
  }

  Widget CustomRow({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 2,
            child: CustomSimpleText(
              text: title,
              fontSize: AppSizes.size12,
              textAlignment: TextAlign.start,
              color: AppColorsList.blue,
            )),
        10.pw,
        Expanded(
            flex: 3,
            child: CustomSimpleText(
              text: value,
              fontSize: AppSizes.size12,
              textAlignment: TextAlign.start,
            )),
      ],
    );
  }
}
