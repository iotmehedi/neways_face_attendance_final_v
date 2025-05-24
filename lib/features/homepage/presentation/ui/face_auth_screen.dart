import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:neways_face_attendance_pro/core/core/extensions/extensions.dart';
import 'package:neways_face_attendance_pro/core/utils/common_toast/custom_toast.dart';
import 'package:neways_face_attendance_pro/core/utils/consts/app_colors.dart';
import 'package:neways_face_attendance_pro/core/utils/consts/app_sizes.dart';
import 'package:neways_face_attendance_pro/features/widgets/cached_image_network/custom_cached_image_network.dart';
import 'package:neways_face_attendance_pro/features/widgets/custom_elevatedButton/custom_text.dart';
import '../../../../core/network/configuration.dart';
import '../../../../main.dart';
import '../../../widgets/circular_dot_animation/circular_dot_animation.dart';
import '../controller/get_employee_face_controller.dart';
import '../../../../core/routes/route_name.dart';
import '../../../../core/routes/router.dart';
import 'camera_page.dart';

class FaceAuthScreen extends StatefulWidget {
  const FaceAuthScreen({super.key});

  @override
  State<FaceAuthScreen> createState() => _FaceAuthScreenState();
}

class _FaceAuthScreenState extends State<FaceAuthScreen> {
  final GetEmployeeFaceController _employeeController =
      Get.put(GetEmployeeFaceController());

  @override
  void dispose() {
    _employeeController.cameraController?.dispose();
    _employeeController.capturedImage.value = null;
    _employeeController.showPreview.value = false;
    _employeeController.pickedImage.value = File('');
    super.dispose();
  }

  Offset _circleCenter = Offset.zero;
  Size? _screenSize;
  final double _circleRadius = 150;
  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _circleCenter = Offset(_screenSize!.width / 2, _screenSize!.height / 2);
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          _employeeController.isCameraInitialized.value = false;
          _employeeController.showPreview.value = false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CustomCachedImageNetwork(
                        height: AppSizes.newSize(4),
                        weight: AppSizes.newSize(4),
                        imageUrl:
                            "${NetworkConfiguration.imageUrl}${box.read("photo")}",
                      ),
                    ),
                    10.pw,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSimpleText(text: "Welcome👋"),
                        CustomSimpleText(
                          text: box.read("name"),
                          fontSize: AppSizes.size12,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          _employeeController.showCustomDialogLogOut(
                              context: context);
                        },
                        icon: Icon(Icons.logout)),
                    IconButton(
                        onPressed: () {
                          RouteGenerator.pushNamed(
                              navigatorKey.currentContext!, Routes.profile);
                        },
                        icon: Icon(Icons.person)),
                  ],
                )
              ],
            ),
          ),
          body: Obx(() => Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_month),
                                    5.pw,
                                    CustomSimpleText(
                                      text:
                                          "${_employeeController.getShiftStatusWithDate()['date']}",
                                      fontSize: AppSizes.size18,
                                    ),
                                  ],
                                ),
                                5.ph,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timelapse),
                                    5.pw,
                                    CustomSimpleText(
                                      text:
                                          _employeeController.currentTime.value,
                                      fontSize: AppSizes.size18,
                                    ),
                                  ],
                                ),
                                10.ph,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // CustomRichText(
                                    //   title: box.read("dutyStartTime"),
                                    //   heading: "Check in:",
                                    //   headingFontSize: AppSizes.size13,
                                    //   titleFontSIze: AppSizes.size13,
                                    //   titleTextColor: AppColorsList.blue,
                                    // ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: CustomSimpleText(
                                          text: "Check In Time",
                                          textAlignment: TextAlign.center,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    5.ph,
                                    Align(
                                      alignment: Alignment.center,
                                      child: CustomSimpleText(
                                        text: _employeeController
                                                .formatTime(
                                                    box.read("dutyStartTime") ??
                                                        "")
                                                .isEmpty
                                            ? "00:00"
                                            : _employeeController.formatTime(
                                                box.read("dutyStartTime") ??
                                                    ""),
                                        color: AppColorsList.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    Align(
                                        alignment: Alignment.center,
                                        child: CustomSimpleText(
                                          text: "Check Out Time",
                                          textAlignment: TextAlign.center,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    5.ph,
                                    Align(
                                      alignment: Alignment.center,
                                      child: CustomSimpleText(
                                        text: _employeeController
                                                .formatTime(
                                                    box.read("dutyEndTime") ??
                                                        "")
                                                .isEmpty
                                            ? "00:00"
                                            : _employeeController.formatTime(
                                                box.read("dutyEndTime") ?? ""),
                                        color: AppColorsList.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    // CustomRichText(
                                    //   title: box.read("dutyEndTime"),
                                    //   heading: "Check out:",
                                    //   headingFontSize: AppSizes.size13,
                                    //   titleFontSIze: AppSizes.size13,
                                    //   titleTextColor: AppColorsList.blue,
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        20.ph,
                        // Center(child: CustomSimpleText(text: , fontWeight: FontWeight.w500, fontSize: AppSizes.size12,)),

                        _employeeController.wifiNameValue.value.isEmpty ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomSimpleText(
                                text: "You are connected with",
                                fontSize: AppSizes.size16,
                                fontWeight: FontWeight.w600,
                                textAlignment: TextAlign.center,
                              ),
                              3.ph,
                              CustomSimpleText(
                                text:
                                "Mobile cellular network",
                                fontSize: AppSizes.size17,
                                fontWeight: FontWeight.bold,
                                color: _employeeController.isConnectedWithAuthorizedWifi.value == true ? AppColorsList.green : AppColorsList.red,
                              ),
                            ],
                          ),
                        ) :  Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomSimpleText(
                                text: _employeeController.isConnectedWithAuthorizedWifi.value == true ?"You are connected with authorized wifi" : "Connected with unauthorized wifi",
                                fontSize: AppSizes.size16,
                                fontWeight: FontWeight.w600,
                                textAlignment: TextAlign.center,
                              ),
                              3.ph,
                              CustomSimpleText(
                                text:
                                    _employeeController.wifiNameValue.value,
                                fontSize: AppSizes.size17,
                                fontWeight: FontWeight.bold,
                                color: _employeeController.isConnectedWithAuthorizedWifi.value == true ? AppColorsList.green : AppColorsList.red,
                              ),
                            ],
                          ),
                        ),
                        60.ph,
                        SizedBox(
                          // height: AppSizes.newSize(90),
                          width: MediaQuery.of(context).size.width,
                          child: Obx(() => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // if (!_employeeController
                                  //         .isCameraInitialized.value &&
                                  //     !_employeeController.showPreview.value)
                                    Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Container(
                                                height: 200,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  gradient: _employeeController
                                                      .getButtonColor(),
                                                  borderRadius:
                                                      BorderRadius.circular(500),
                                                ),
                                                child: Obx(() => ElevatedButton(
                                                      style:
                                                          ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shadowColor:
                                                            Colors.transparent,
                                                        // backgroundColor:
                                                        //     _employeeController.getButtonColor(),

                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  500),
                                                        ),
                                                      ),
                                                      onPressed: _employeeController.isAttendanceBindingLoading.value == true ? null : () async {
                                                        // bool granted = await _employeeController.getNetworkInfo(context);
                                                        await _employeeController
                                                            .checkWifi();
                                                        // print("is wifi matched name pp ${_employeeController.wifiNameValue.value} ${box.read("is_attendance_white_list")}");
                                                        // if (granted) {
                                                        if (_employeeController
                                                                .attendanceBindingModel
                                                                .value
                                                                .approval ==
                                                            true) {
                                                          _employeeController
                                                              .resetCameraState();
                                                          WidgetsBinding.instance
                                                              .addPostFrameCallback(
                                                                  (_) {
                                                            _employeeController
                                                                .initializeCamera(
                                                                    context);
                                                          });
                                                        } else if (_employeeController
                                                                    .isWifiMatched
                                                                    .value ==
                                                                false &&
                                                            _employeeController
                                                                .wifiNameValue
                                                                .value
                                                                .isEmpty) {
                                                          _employeeController.popupReasons(
                                                              context: context,
                                                              shortCode: 'wifi',
                                                              message:
                                                                  "No Attendance Wifi Detect",
                                                              attendance:
                                                                  "Request for Without attendance wifi.",
                                                              warningTextColor:
                                                                  Colors.red,
                                                              title:
                                                                  "Request for checkout again",
                                                              action:
                                                                  "wifi_problem");
                                                        } else if (_employeeController
                                                                    .isWifiMatched
                                                                    .value ==
                                                                false &&
                                                            box.read(
                                                                    "is_attendance_white_list") ==
                                                                "0") {
                                                          errorToast(
                                                              context: context,
                                                              msg:
                                                                  "Please connect with authenticate wifi");
                                                        } else if (_employeeController
                                                                    .isWifiMatched
                                                                    .value ==
                                                                false &&
                                                            _employeeController
                                                                    .attendanceBindingModel
                                                                    .value
                                                                    .approval ==
                                                                false) {
                                                          errorToast(
                                                              context: context,
                                                              msg:
                                                                  "Please connect with authenticate wifi");
                                                        } else {
                                                        if(await _employeeController.isCameraPermissionHave() == true){
                                                          _employeeController
                                                              .resetCameraState();
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) =>  CameraPage()),
                                                          );
                                                        }else{
                                                          _employeeController.showPermissionDeniedDialog();
                                                        }

                                                        }

                                                      },
                                                      child: Stack(
                                                        alignment: Alignment.center,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize.min,
                                                            children: [
                                                              CustomSimpleText(
                                                                text: _employeeController
                                                                    .getShiftStatusTitle(),
                                                                color: AppColorsList
                                                                    .white,
                                                              ),
                                                              10.ph,
                                                              Text(
                                                                DateFormat(
                                                                        'hh:mm a')
                                                                    .format(DateTime
                                                                        .now()),
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .white),
                                                              ),
                                                              const SizedBox(
                                                                  height: 8),
                                                              Text(
                                                                box
                                                                            .read(
                                                                                "isLate")
                                                                            .toString()
                                                                            .toLowerCase()
                                                                            .contains(
                                                                                "late") &&
                                                                        box.read(
                                                                                "isLate") !=
                                                                            null
                                                                    ? box
                                                                        .read(
                                                                            "isLate")
                                                                        .toString()
                                                                    : _employeeController
                                                                        .getShiftStatus(),
                                                                style: TextStyle(
                                                                    fontSize: 22,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                          _employeeController
                                                                      .signInController
                                                                      .isGetAttendanceLoading
                                                                      .value ==
                                                                  true
                                                              ? const CircularDotsAnimation(
                                                                  dotSize: 8,
                                                                  radius: 20,
                                                                  padding: 1,
                                                                )
                                                              : SizedBox.shrink()
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            ),
                                            // CustomElevatedButton(text: "text popup", onPress: (){
                                            //   _employeeController.popupReasons(context: context, shortCode: 'CA', message: "hello brothr", attendance: "Check out", warningTextColor: Colors.red, title: 'update', action: "update_limit");
                                            // },),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // CustomRichText(
                                                  //   title: box.read("dutyStartTime"),
                                                  //   heading: "Check in:",
                                                  //   headingFontSize: AppSizes.size13,
                                                  //   titleFontSIze: AppSizes.size13,
                                                  //   titleTextColor: AppColorsList.blue,
                                                  // ),
                                                  20.ph,
                                                  Align(
                                                      alignment: Alignment.center,
                                                      child: CustomSimpleText(
                                                        text: "Today Check In Time",
                                                        textAlignment:
                                                            TextAlign.center,
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                  5.ph,
                                                  box.read("checkedIn") == null
                                                      ? const Center(
                                                          child: CustomSimpleText(
                                                          text: "----------",
                                                          textAlignment:
                                                              TextAlign.center,
                                                        ))
                                                      : Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              CustomSimpleText(
                                                                text: _employeeController
                                                                    .formatTime(box.read(
                                                                        "checkedIn")),
                                                                color:
                                                                    AppColorsList.blue,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                              ),
                                                              Text(
                                                                " ${box
                                                                    .read(
                                                                    "isLate")
                                                                    .toString()
                                                                    .toLowerCase()
                                                                    .contains(
                                                                    "late") &&
                                                                    box.read(
                                                                        "isLate") !=
                                                                        null
                                                                    ? "(${box
                                                                    .read(
                                                                    "isLate")
                                                                    .toString()} present)"
                                                                    : ''}",
                                                                style: TextStyle(
                                                                    fontSize: AppSizes.size13,
                                                                    color: box
                                                                        .read(
                                                                        "isLate")
                                                                        .toString()
                                                                        .toLowerCase()
                                                                        .contains(
                                                                        "late") &&
                                                                        box.read(
                                                                            "isLate") !=
                                                                            null ? Colors.orangeAccent : Colors
                                                                        .black,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                            ],
                                                          )),
                                                  10.ph,
                                                  Align(
                                                      alignment: Alignment.center,
                                                      child: CustomSimpleText(
                                                        text:
                                                            "Today Check Out Time",
                                                        textAlignment:
                                                            TextAlign.center,
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                  5.ph,
                                                  box.read("checkedOut") == null
                                                      ? Center(
                                                          child:
                                                              const CustomSimpleText(
                                                          text: "----------",
                                                          textAlignment:
                                                              TextAlign.center,
                                                        ))
                                                      : Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: CustomSimpleText(
                                                            text: _employeeController
                                                                .formatTime(box.read(
                                                                    "checkedOut")),
                                                            color:
                                                                AppColorsList.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),

                                                  // CustomRichText(
                                                  //   title: box.read("dutyEndTime"),
                                                  //   heading: "Check out:",
                                                  //   headingFontSize: AppSizes.size13,
                                                  //   titleFontSIze: AppSizes.size13,
                                                  //   titleTextColor: AppColorsList.blue,
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        _employeeController.isAttendanceBindingLoading.value == true ? Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 80),
                                            child: CircularDotsAnimation(),
                                          ),
                                        ) : SizedBox.shrink()
                                      ],
                                    ),

                                  // Camera preview section


                                  // Image preview section

                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                  if (_employeeController.showPreview.value &&
                      _employeeController.capturedImage.value != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _employeeController.showPreview.value = false;
                            _employeeController.capturedImage.value = null;
                            _employeeController.isCameraInitialized.value =
                                false;
                            _employeeController.pickedImage.value = File('');
                          });
                        },
                        icon: const Icon(Icons.cancel, color: Colors.red),
                      ),
                    )
                ],
              )),
        ));
  }
}
