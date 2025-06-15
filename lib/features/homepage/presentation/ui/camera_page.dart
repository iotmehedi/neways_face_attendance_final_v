import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways_face_attendance_pro/core/core/extensions/extensions.dart';
import 'package:neways_face_attendance_pro/core/utils/consts/app_assets.dart';
import 'package:neways_face_attendance_pro/features/widgets/custom_appbar/custom_appbar.dart';
import '../../../../core/routes/route_name.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/utils/consts/app_colors.dart';
import '../../../../core/utils/consts/app_sizes.dart';
import '../../../widgets/custom_elevatedButton/custom_text.dart';
import '../../../widgets/custom_processing_text/custom_processing_text_animation.dart';
import '../../../widgets/wave_loading/web_loading.dart';
import '../controller/get_employee_face_controller.dart';

class CameraPage extends StatefulWidget {
  CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final GetEmployeeFaceController _employeeController =
      Get.put(GetEmployeeFaceController());

  @override
  void initState() {
    super.initState();
    _employeeController.resetCameraState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _employeeController.initializeCamera(context);
    });
  }

  @override
  void dispose() {
    _employeeController.cameraController?.dispose();
    _employeeController.capturedImage.value = null;
    _employeeController.showPreview.value = false;
    _employeeController.pickedImage.value = File('');
    _employeeController.isCameraInitialized.value = false;

    super.dispose();
  }

  Offset _circleCenter = Offset.zero;
  Size? _screenSize;
  final double _circleRadius = 150;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: CustomAppBar(
            title: "",
            onBackPressed: () {
              RouteGenerator.pushNamedAndRemoveAll(context, Routes.homepage);
            },
          ),
          body: Stack(
            children: [
              if (_employeeController.showPreview.value == false)
                if (_employeeController.capturedImage.value != null &&
                    _employeeController.capturingImage.value == true)
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(AppAssets.imageProcessing, color: AppColorsList.blue,),
                        20.ph,
                         ProcessingTextWithDots(
                          text: "Now processing",
                          dotColor: AppColorsList.blue,
                          dotSize: 6.0,
                          animationDuration: Duration(milliseconds: 800),
                        )
                      ],
                    )),
                  )
                else
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        20.ph,
                        Center(
                          child: SizedBox(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      _employeeController.capturedImage.value !=
                                              null
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
                                                    BorderRadius.circular(10),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.memory(
                                                  _employeeController
                                                      .capturedImage.value!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : _employeeController
                                                      .isCameraInitialized
                                                      .value &&
                                                  _employeeController
                                                          .cameraController !=
                                                      null &&
                                                  _employeeController
                                                      .cameraController!
                                                      .value
                                                      .isInitialized
                                              ? Container(
                                                  // height: MediaQuery.of(context).size.height * 0.6,
                                                  // width: MediaQuery.of(context).size.width,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9),
                                                    border: Border.all(),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: CameraPreview(
                                                        _employeeController
                                                            .cameraController!),
                                                  ),
                                                )
                                              : Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.6,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(),
                                                  ),
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()),
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
                                _employeeController.capturingImage.value
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
                                                BorderRadius.circular(10),
                                            color: Colors.grey
                                                .withValues(alpha: 0.6),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Center(
                                                  child: CustomSimpleText(
                                                    text:
                                                        "The picture is being taken.",
                                                    color: AppColorsList.white,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20),
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: WaveDotsAnimation(
                                                    dotSize: 8.3,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            _employeeController.captureImage(context: context);
                          },
                          child: Center(
                            child: Container(
                              width: AppSizes.newSize(18),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColorsList.green1,
                              ),
                              child: _employeeController.capturingImage.value
                                  ? Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(),
                                      ),
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
                                          textAlignment: TextAlign.center,
                                          textOverFlow: TextOverflow.visible,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              if (_employeeController.capturedImage.value != null &&
                  _employeeController.showPreview.value)
                Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              _employeeController.capturedImage.value!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                _employeeController.retakePicture(context);
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
                            // Uncomment and implement confirm button logic if needed
                            // ElevatedButton(
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: Colors.green,
                            //   ),
                            //   onPressed: () async {
                            //     _employeeController.imageMatching(
                            //       image: _employeeController.pickedImage.value,
                            //       context: context,
                            //     );
                            //   },
                            //   child: _employeeController.isMatching.value
                            //       ? const CircularProgressIndicator(color: Colors.white)
                            //       : Row(
                            //           children: [
                            //             Icon(
                            //               Icons.check_circle,
                            //               color: AppColorsList.white,
                            //             ),
                            //             5.pw,
                            //             CustomSimpleText(
                            //               text: "Confirm",
                            //               fontWeight: FontWeight.bold,
                            //               color: AppColorsList.white,
                            //             ),
                            //           ],
                            //         ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ));
  }
}
