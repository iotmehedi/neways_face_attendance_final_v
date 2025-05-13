import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
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
import '../../../widgets/wave_loading/web_loading.dart';
import '../controller/get_employee_face_controller.dart';
import '../../../../core/routes/route_name.dart';
import '../../../../core/routes/router.dart';
import '../services/permission_handler.dart';

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
    return Scaffold(
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
                    if (!_employeeController.isCameraInitialized.value &&
                        !_employeeController.showPreview.value)
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
                                  text: _employeeController.currentTime.value,
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
                                    text: _employeeController.formatTime(
                                        box.read("dutyStartTime") ?? ""
                                    ).isEmpty
                                        ? "00:00"
                                        : _employeeController.formatTime(box.read("dutyStartTime") ?? ""),
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
                                    text: _employeeController.formatTime(
                                        box.read("dutyEndTime") ?? ""
                                    ).isEmpty
                                        ? "00:00"
                                        : _employeeController.formatTime(box.read("dutyEndTime") ?? ""),
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
                    Visibility(
                        visible: _employeeController.wifiNameValue.value.isEmpty ? false : true,
                        child: Center(child: CustomRichText(title: " ${_employeeController.wifiNameValue.value}", heading: "You are connected with", titleFontSIze: AppSizes.size12, titleTextColor: AppColorsList.green, headingFontSize: AppSizes.size12, ))),
                    60.ph,
                    SizedBox(
                      // height: AppSizes.newSize(90),
                      width: MediaQuery.of(context).size.width,
                      child: Obx(()=> Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (!_employeeController.isCameraInitialized.value &&
                              !_employeeController.showPreview.value)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    child: Obx(()=> ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        // backgroundColor:
                                        //     _employeeController.getButtonColor(),

                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(500),
                                        ),
                                      ),
                                      onPressed: _employeeController
                                          .isEmployeeFaceLoading
                                          .value ==
                                          true
                                          ? null
                                          : _employeeController
                                          .isImageHave.value ==
                                          false
                                          ? () {
                                        errorToast(
                                            context: context,
                                            msg:
                                            "No Image found. Please contact with HR");
                                      }
                                          : () async {

                                        // bool granted = await _employeeController.getNetworkInfo(context);
                                       await _employeeController.checkWifi();
                                        print("is wifi matched name pp ${_employeeController.wifiNameValue.value} ${box.read("is_attendance_white_list")}");
                                        // if (granted) {
                                       if(_employeeController.attendanceBindingModel.value.approval == true){
                                         _employeeController.resetCameraState();
                                         WidgetsBinding.instance.addPostFrameCallback((_) {
                                           _employeeController.initializeCamera(context);
                                         });
                                       }else if(_employeeController.isWifiMatched.value == false && _employeeController.wifiNameValue.value.isEmpty){
                                         _employeeController.popupReasons(context: context, shortCode: 'wifi', message: "No Attendance Wifi Detect", attendance: "Request for Without attendance wifi.", warningTextColor: Colors.red, title: "Request for checkout again", action: "wifi_problem");
                                       }
                                      else if (_employeeController.isWifiMatched.value == false && box.read("is_attendance_white_list") == 0) {
                                          errorToast(context: context, msg: "Connect with authenticate wifi");
                                        } else {

                                          _employeeController.resetCameraState();
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            _employeeController.initializeCamera(context);
                                          });

                                        }
                                        // }
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomSimpleText(
                                                text: _employeeController
                                                    .getShiftStatusTitle(),
                                                color: AppColorsList.white,
                                              ),
                                              10.ph,
                                              Text(
                                                DateFormat('hh:mm a')
                                                    .format(DateTime.now()),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                _employeeController
                                                    .getShiftStatus(),
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          _employeeController
                                              .isEmployeeFaceLoading.value ==
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
                                      box.read("checkedIn") == null
                                          ? const SizedBox.shrink()
                                          : Align(
                                          alignment: Alignment.center,
                                          child: CustomSimpleText(
                                            text: "Today Check In Time",
                                            textAlignment:
                                            TextAlign.center,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      5.ph,
                                      box.read("checkedIn") == null
                                          ? const SizedBox.shrink()
                                          : Align(
                                          alignment: Alignment.center,
                                          child: CustomSimpleText(
                                            text: _employeeController
                                                .formatTime(box
                                                .read("checkedIn")),
                                            color: AppColorsList.blue,
                                            fontWeight: FontWeight.bold,
                                          )),

                                      box.read("checkedOut") == null
                                          ? const SizedBox.shrink()
                                          : Align(
                                          alignment: Alignment.center,
                                          child: CustomSimpleText(
                                            text: "Today Check Out Time",
                                            textAlignment:
                                            TextAlign.center,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      5.ph,
                                      box.read("checkedOut") == null
                                          ? const SizedBox.shrink()
                                          : Align(
                                          alignment: Alignment.center,
                                          child: CustomSimpleText(
                                            text: _employeeController
                                                .formatTime(box
                                                .read("checkedOut")),
                                            color: AppColorsList.red,
                                            fontWeight: FontWeight.bold,
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


                          // Camera preview section
                          if (_employeeController.isCameraInitialized.value &&
                              !_employeeController.showPreview.value)
                            Column(
                              children: [
                                Center(
                                  child: SizedBox(
                                    // height: 400,
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: _employeeController
                                              .capturedImage
                                              .value !=
                                              null &&
                                              _employeeController
                                                  .capturingImage
                                                  .value ==
                                                  true
                                              ? Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height *
                                                0.6,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: EdgeInsets.all(0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                              child: Image.memory(
                                                _employeeController
                                                    .capturedImage.value!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                              : Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10),
                                                border: Border.all()),
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                              child: CameraPreview(
                                                  _employeeController
                                                      .cameraController!),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Center(
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: _circleRadius * 1.6,
                                              height: _circleRadius * 1.6,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.green,
                                                  width: 4,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 20,
                                          left: 0,
                                          right: 0,
                                          child: Text(
                                            'Align your face in the circle frame',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 10,
                                                  color: Colors.black,
                                                  offset: Offset(1, 1),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        _employeeController
                                            .capturingImage.value ==
                                            true
                                            ? Positioned(
                                            top: 0,
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                                  0.6,
                                              margin: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10),
                                                color: Colors.grey
                                                    .withValues(alpha: 0.6),
                                              ),
                                              child: Column(
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center,
                                                children: [
                                                  Expanded(
                                                    child: Center(
                                                        child:
                                                        CustomSimpleText(
                                                          text:
                                                          "Image already taken. Now processing.....",
                                                          color: AppColorsList
                                                              .white,
                                                        )),
                                                  ),
                                                  // 80.ph,
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        bottom: 20),
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child:
                                                      WaveDotsAnimation(
                                                        dotSize: 8.3,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                            : const SizedBox.shrink()
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),
                                // Take Image button - only visible when camera is initialized
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    _employeeController.captureImage(
                                        context: context);
                                  },
                                  child: Center(
                                    child: Container(
                                      width: AppSizes.newSize(18),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          color: AppColorsList.green1),
                                      child: _employeeController
                                          .capturingImage.value ==
                                          true
                                          ? Center(
                                        child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child:
                                            CircularProgressIndicator()),
                                      )
                                          : Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: AppColorsList.white,
                                          ),
                                          5.pw,
                                          CustomSimpleText(
                                            text: "Confirm",
                                            fontWeight: FontWeight.bold,
                                            color: AppColorsList.white,
                                            textAlignment:
                                            TextAlign.center,
                                            textOverFlow:
                                            TextOverflow.visible,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          // Image preview section
                          if (_employeeController.showPreview.value &&
                              _employeeController.capturedImage.value != null)
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      // height: 400,
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.memory(
                                          _employeeController
                                              .capturedImage.value!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          onPressed: () {
                                            _employeeController
                                                .retakePicture(context);
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.camera_alt,
                                                color: AppColorsList.white,
                                              ),
                                              5.pw,
                                              CustomSimpleText(
                                                text: "Retake",
                                                fontWeight: FontWeight.bold,
                                                color: AppColorsList.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        // Obx(
                                        //   () => ElevatedButton(
                                        //     style: ElevatedButton.styleFrom(
                                        //       backgroundColor: Colors.green,
                                        //     ),
                                        //     onPressed: () async {
                                        //       _employeeController.imageMatching(
                                        //           image: _employeeController
                                        //               .pickedImage.value,
                                        //           context: context);
                                        //     },
                                        //     child: _employeeController
                                        //             .isMatching.value
                                        //         ? const CircularProgressIndicator(
                                        //             color: Colors.white)
                                        //         : Row(
                                        //             children: [
                                        //               Icon(
                                        //                 Icons.check_circle,
                                        //                 color: AppColorsList.white,
                                        //               ),
                                        //               5.pw,
                                        //               CustomSimpleText(
                                        //                 text: "Confirm",
                                        //                 fontWeight: FontWeight.bold,
                                        //                 color: AppColorsList.white,
                                        //               ),
                                        //             ],
                                        //           ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                        _employeeController.isCameraInitialized.value = false;
                        _employeeController.pickedImage.value = File('');
                      });
                    },
                    icon: const Icon(Icons.cancel, color: Colors.red),
                  ),
                )
            ],
          )),
    );
  }
}
