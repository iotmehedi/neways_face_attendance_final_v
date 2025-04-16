import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:neways_face_attendance_pro/core/core/extensions/extensions.dart';
import 'package:neways_face_attendance_pro/core/utils/common_toast/custom_toast.dart';
import 'package:neways_face_attendance_pro/features/homepage/data/model/attendance_binding_model.dart';
import 'package:neways_face_attendance_pro/main.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/app_component/app_component.dart';
import '../../../../core/routes/route_name.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/utils/consts/app_assets.dart';
import '../../../../core/utils/consts/app_colors.dart';
import '../../../../core/utils/consts/app_sizes.dart';
import '../../../widgets/custom_elevatedButton/custom_text.dart';
import '../../data/model/get_employee_face_model.dart';
import '../../domain/repository/get_employee_face_repository.dart';
import '../../domain/usecase/get_employee_face_pass_usecase.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class GetEmployeeFaceController extends GetxController {
  var pickedImage = File("").obs;
  // Employee data
  final getEmployeeFaceModel = GetEmployeeFaceModel().obs;
  final attendanceBindingModel = AttendanceBindingModel().obs;
  final employeeImages = <int, Uint8List>{}.obs; // employeeId: imageBytes
  final employeeFaceArrays = <int, List>{}.obs; // employeeId: faceArray

  // State management
  final isEmployeeFaceLoading = false.obs;
  final isAttendanceBindingLoading = false.obs;
  final isImageHave = false.obs;
  final isLoading = false.obs;
  final isMatching = true.obs;
  final matchResult = false.obs;
  final similarityScore = 0.0.obs;
  final matchedEmployeeId = Rx<int?>(null);
  final errorMessage = Rx<String?>(null);
  CameraController? cameraController;
  var showPreview = false.obs;
  Rx<Uint8List?> capturedImage = Rx<Uint8List?>(null);

  var isCameraInitialized = false.obs;

  var similarity = "".obs;
  var trialNumber = 1.obs;
  var isMatchings = false.obs;
  var capturingImage = false.obs;
  dynamic matchedEmployee;
  var currentTime = ''.obs;
  Timer? timer;
  @override
  void onInit() async {
    super.onInit();
    updateTime();
    // Update time every second
    timer = Timer.periodic(Duration(seconds: 1), (timer) => updateTime());
    await getEmployeeFacetFunc();

  }
  @override
  void onClose() {
    timer?.cancel(); // Cancel timer when controller is closed
    super.onClose();
  }
  void updateTime() {
    final now = DateTime.now();
    currentTime.value = '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
  Future<void> initializeCamera(BuildContext context) async {
    // await _disposeCamera();
    capturingImage.value = false;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No cameras available');
      }

      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.yuv420
            : ImageFormatGroup.bgra8888,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      debugPrint('Error initializing camera: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera error: $e')),
      );
    }
  }

  Future<void> retakePicture(BuildContext context) async {
    try {
      await _disposeCamera();
      // Reset all states
      pickedImage.value = File("");
      capturedImage.value = null;
      showPreview.value = false;
      isCameraInitialized.value = false;

      await initializeCamera(context);
    } catch (e) {
      debugPrint('Error in _retakePicture: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retaking picture: $e')),
      );
    }
  }

  Future<void> _disposeCamera() async {
    try {
      if (cameraController != null) {
        await cameraController!.dispose();
        cameraController = null;
      }
      isCameraInitialized.value = false;
    } catch (e) {
      debugPrint('Error disposing camera: $e');
    }
  }

  Future<void> getEmployeeFacetFunc() async {
    isEmployeeFaceLoading.value = true;
    errorMessage.value = null;

    try {
      final useCase =
      GetEmployeeFacePassUseCase(locator<GetEmployeeFaceRepository>());
      final response = await useCase();

      if (response?.data?.employeeFaceAttendance != null) {
        getEmployeeFaceModel.value = response!.data!;
        isImageHave.value = true;
        print(
            "Employee image URL: ${getEmployeeFaceModel.value.employeeFaceAttendance?.first.imageUrl}");
      } else {
        print("image not found");
        isImageHave.value = false;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load employees: ${e.toString()}';
    } finally {
      isEmployeeFaceLoading.value = false;
    }
    update();
  }

  Future<void> attendanceBinding() async {
    isAttendanceBindingLoading.value = true;

    try {
      final useCase =
      AttendanceBindingPassUseCase(locator<GetEmployeeFaceRepository>());
      final response = await useCase();

      if (response?.data?.attendanceBinding != null) {
        attendanceBindingModel.value =
            response?.data ?? AttendanceBindingModel();
      } else {
        print("wifi information not found");
      }
    } catch (e) {
      isAttendanceBindingLoading.value = false;
      errorMessage.value = 'Failed to load employees: ${e.toString()}';
    } finally {
      isAttendanceBindingLoading.value = false;
    }
    update();
  }

  Future<void> setAttendance(
      {required String attendanceValue, required BuildContext context}) async {
    try {
      final useCase =
      SetAttendancePassUseCase(locator<GetEmployeeFaceRepository>());
      final response = await useCase(attendanceValue: attendanceValue);
      print("response $response");
      if (response != null) {
        if (response['message']
            .contains('You can update the Check-Out time 5 times')) {
          errorToast(
            context: context,
            msg: response['message'],
          );
        } else {
          final currentStatus = getShiftStatus();
          if (currentStatus == "Check In" || currentStatus == "Late") {
            // Perform check-in
            final formattedDate = "${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}";

            box.write("checkedIn", formattedDate);
            performCheckIn();
            successToast(context: context, msg: "Checked in successfully!");
          } else if (currentStatus == "Check Out" ||
              currentStatus == "Checked Out") {
            // Perform check-out
            final formattedDate = "${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}";

            box.write("checkedOut", formattedDate);
            performCheckOut();
            successToast(context: context, msg: "Checked out successfully!");
          } else if (currentStatus == "On Duty") {
            // Perform check-out
            performCheckOut();
            final formattedDate = "${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}";

            box.write("checkedOut", formattedDate);
            successToast(context: context, msg: "Checked out successfully!");
          } else if (currentStatus == "Already Checked In") {
            successToast(
                context: context, msg: "You've already checked in today");
          } else if (currentStatus == "Already Checked Out") {
            successToast(
                context: context, msg: "You've already checked out today");
          } else {
            successToast(context: context, msg: "${response['message']}");
          }
        }
      } else {
        throw Exception('No employee data received');
      }
    } catch (e) {
      capturingImage.value = false;
      errorMessage.value = 'Failed to load employees: ${e.toString()}';
    } finally {
      capturingImage.value = false;
    }
  }

  Future<void> captureImage({required BuildContext context}) async {
    if (cameraController == null ||
        !cameraController!.value.isInitialized ||
        cameraController!.value.isTakingPicture) {
      return null;
    }
    capturingImage.value = true;
    try {
      // Stop the image stream temporarily
      cameraController!.stopImageStream();

      final XFile picture = await cameraController!.takePicture();
      final File imageFile = File(picture.path);

      // Process the image with 400x400 resolution
      final processedImage = await processCapturedImage(
        await imageFile.readAsBytes(),
        isFrontCamera: cameraController!.description.lensDirection ==
            CameraLensDirection.front,
        targetWidth: 400,
        targetHeight: 520,
      );

      // Save to temporary directory
      final Directory extDir = await getTemporaryDirectory();
      final String filePath =
          '${extDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(filePath).writeAsBytes(processedImage);

      // Update state
      pickedImage.value = File(filePath);

      capturedImage.value = processedImage;
      // showPreview.value = true;

      imageMatching(image: pickedImage.value, context: context);
      // return pickedImage.value;
    } catch (e) {
      debugPrint('Error capturing image: $e');
      // capturingImage.value = false;
      // return null;
    } finally {
      // Restart the image stream if needed
      if (!showPreview.value &&
          cameraController?.value.isStreamingImages == false) {
        await cameraController?.startImageStream((image) {
          // Your image stream processing logic here
        });
      }
    }
  }

  Future<Uint8List> processCapturedImage(
      Uint8List originalBytes, {
        required bool isFrontCamera,
        int targetWidth = 400,
        int targetHeight = 520,
      }) async {
    try {
      final originalImage = img.decodeImage(originalBytes);
      if (originalImage == null) return originalBytes;

      img.Image processedImage = originalImage;

      // Flip if front camera
      if (isFrontCamera) {
        processedImage = img.flipHorizontal(processedImage);
      }

      // Adjust rotation
      processedImage = img.copyRotate(processedImage, angle: 360);

      // Resize to target dimensions while maintaining aspect ratio
      processedImage = img.copyResize(
        processedImage,
        width: targetWidth,
        height: targetHeight,
        interpolation: img.Interpolation.average, // Good quality resizing
      );

      // Convert to JPEG with quality 85 (adjust as needed)
      return Uint8List.fromList(img.encodeJpg(processedImage, quality: 85));
    } catch (e) {
      debugPrint('Error in processCapturedImage: $e');
      return originalBytes;
    }
  }

  Future<void> resetCameraState() async {
    showPreview.value = false;
    capturedImage.value = null;
    isCameraInitialized.value = false;
  }

  Future<void> imageMatching(
      {required File image, required BuildContext context}) async {
    try {
      const String apiUrl =
          "https://documents.neways3.com/face_attendance/recognize_face";
      final String employeeId = box.read("id").toString();

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['employee_id'] = employeeId;

      if (image.path.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
            filename: "profile_${DateTime.now().millisecondsSinceEpoch}.jpg",
            contentType: MediaType('image', 'png'),
          ),
        );
      }

      print("Sending request for employee: $employeeId");
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Get current shift status

        setAttendance(attendanceValue: "1", context: context);
        disposes();
        showPreview.value = false;
      } else if (response.statusCode == 404) {
        showPreview.value = true;
        errorToast(
          context: context,
          msg: responseData['message'] ??
              "Your face is not registered. Please add it first.",
        );
      } else {
        showPreview.value = true;
        errorToast(
          context: context,
          msg: responseData['message'] ??
              "Face recognition failed. Please try again.",
        );
      }
    } catch (e) {
      errorMessage.value = 'Failed to match image: ${e.toString()}';
      errorToast(
          context: context, msg: "Failed to process image. Please try again.");
      print("Error in imageMatching: $e");
    } finally {
      isMatching.value = false;

      update();
    }
    update();
  }

  LinearGradient getButtonColor() {
    final now = DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);
    final today = now.toString().split(' ')[0];

    // // Reset status after midnight
    // final lastCheckInDate = box.read("lastCheckInDate") as String?;
    // if (lastCheckInDate != today && currentTime.hour >= 0 && currentTime.minute >= 0) {
    //   box.write("isCheckedIn", false);
    //   box.write("isCheckedOut", false);
    // }

    final isCheckedIn = box.read("isCheckedIn") as bool? ?? false;
    final isCheckedOut = box.read("isCheckedOut") as bool? ?? false;

    if (isCheckedIn && isCheckedOut) {
      return LinearGradient(colors: [
        Color(0xFF000000),
        Color(0xFF0D47A1),
      ]); // Already Checked Out
      // return Colors.red; // Already Checked Out
    }

    // Get shift times
    final startTimeStr = box.read("dutyStartTime") ?? "00:00";
    final endTimeStr = box.read("dutyEndTime") ?? "00:00";

    TimeOfDay parseTime(String timeStr) {
      try {
        final parts = timeStr.split(':');
        return TimeOfDay(
            hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      } catch (e) {
        return TimeOfDay(hour: 9, minute: 0);
      }
    }

    final start = parseTime(startTimeStr);
    final end = parseTime(endTimeStr);

    int toMinutes(TimeOfDay time) => time.hour * 60 + time.minute;
    final nowMinutes = toMinutes(currentTime);
    final startMinutes = toMinutes(start);
    final endMinutes = toMinutes(end);

    // Night shift (spanning midnight)
    if (endMinutes < startMinutes) {
      if (nowMinutes >= startMinutes || nowMinutes < endMinutes) {
        if (isCheckedIn) {
          return nowMinutes >= (endMinutes - 20)
              ? LinearGradient(colors: [Color(0xFF000000), Colors.indigo])
              : LinearGradient(colors: [Color(0xFF000000), Colors.indigo]);
          // return nowMinutes >= (endMinutes - 20) ? Colors.orange : Colors.blue;
        }
        return nowMinutes > startMinutes
            ? LinearGradient(colors: [
          Color(0xFFF44336), Color(0xFFFFC107)
        ])
            : LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFFCDDC39)]);
        // return nowMinutes > startMinutes ? Colors.yellow : Colors.green;
      }
      return LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFFCDDC39)]);
      // return Colors.green;
    }
    // Day shift
    else {
      if (nowMinutes < startMinutes) {
        return LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFFCDDC39)]);
      } else if (nowMinutes > endMinutes) {
        // After duty end time, check if it's before or after midnight
        if (currentTime.hour < 24) { // Before 12:00 AM (midnight)
          if (isCheckedIn && !isCheckedOut || isCheckedIn && isCheckedOut) {
            return LinearGradient(colors: [ // Dark Purple
              Color(0xFF000000), Colors.indigo]); // Still in check-out period until midnight
          }
          return LinearGradient(colors: [ // Dark Purple
            Color(0xFF000000), Colors.indigo]); // Default if not checked in
        } else { // After 12:00 AM (midnight)
          return LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFFCDDC39)]); // New day, reset to "Check In"
        }

        return LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFFCDDC39)]);
      } else {
        if (isCheckedIn) {
          return nowMinutes >= (endMinutes - 20)
              ? LinearGradient(colors: [ // Dark Purple
            Color(0xFF000000), Colors.indigo])
              : LinearGradient(colors: [Color(0xFF000000), Colors.indigo]);
          // return nowMinutes >= (endMinutes - 20) ? Colors.orange : Colors.blue;
        }
        return nowMinutes > startMinutes
            ? LinearGradient(colors: [
          Color(0xFFF44336), Color(0xFFFFC107)
        ])
            : LinearGradient(colors: [Colors.cyan, Colors.indigo]);
        // return nowMinutes > startMinutes ? Colors.yellow : Colors.green;
      }
    }
  }

  void performCheckIn() {
    final now = DateTime.now();
    box.write("isCheckedIn", true);
    box.write("lastCheckInTime", now.toString());
    box.write("lastCheckInDate", now.toString().split(' ')[0]);
    box.write("isCheckedOut", false);
  }

  void performCheckOut() {
    final now = DateTime.now();
    box.write("isCheckedOut", true);
    box.write("lastCheckOutTime", now.toString());
    box.write("lastCheckOutDate", now.toString().split(' ')[0]);
  }

  // Modified getShiftStatus to include more detailed statuses
  String getShiftStatus() {
    final now = DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);
    final today = now.toString().split(' ')[0];

    final isCheckedIn = box.read("isCheckedIn") as bool? ?? false;
    final isCheckedOut = box.read("isCheckedOut") as bool? ?? false;

    if (isCheckedIn && isCheckedOut) {
      return "Checked Out";
    }

    // Get shift times
    final startTimeStr = box.read("dutyStartTime") ?? "09:00";
    final endTimeStr = box.read("dutyEndTime") ?? "17:00";

    TimeOfDay parseTime(String timeStr) {
      try {
        final parts = timeStr.split(':');
        return TimeOfDay(
            hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      } catch (e) {
        return TimeOfDay(hour: 9, minute: 0);
      }
    }

    final start = parseTime(startTimeStr);
    final end = parseTime(endTimeStr);

    int toMinutes(TimeOfDay time) => time.hour * 60 + time.minute;
    final nowMinutes = toMinutes(currentTime);
    final startMinutes = toMinutes(start);
    final endMinutes = toMinutes(end);

    // Handle night shift (spanning midnight)
    if (endMinutes < startMinutes) {
      if (nowMinutes >= startMinutes) {
        // After shift start, before midnight
        if (isCheckedIn) {
          if (nowMinutes >= (endMinutes - 20) && currentTime.hour < 24) {
            return "Check Out";
          }
          return "On Duty";
        }
        return "Check In";
      } else if (nowMinutes < endMinutes) {
        // After midnight, before shift end
        if (isCheckedIn) {
          return "Check Out"; // Keep showing Check Out until shift end time
        }
        return "Check In";
      } else {
        // After shift end, before shift start (next day)
        return "Check In";
      }
    }
    // Handle day shift
    else {
      if (nowMinutes < startMinutes) {
        return "Check In";
      } else if (nowMinutes > endMinutes) {
        // After duty end time, check if it's before or after midnight
        if (currentTime.hour < 24) { // Before 12:00 AM (midnight)
          if (isCheckedIn && !isCheckedOut || isCheckedIn && isCheckedOut) {
            return "Check Out"; // Still in check-out period until midnight
          }
          return "Check out"; // Default if not checked in
        } else { // After 12:00 AM (midnight)
          return "Check In"; // New day, reset to "Check In"
        }
      } else {
        if (isCheckedIn) {
          if (nowMinutes >= (endMinutes - 20)) {
            return "Check Out";
          }
          return "On Duty";
        }
        return "Check In";
      }
    }
  }

  String getShiftStatusTitle() {
    final now = DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);
    final today = now.toString().split(' ')[0];

    // Check if it's a new day (reset status after midnight)
    // final lastCheckInDate = box.read("lastCheckInDate") as String?;

    final isCheckedIn = box.read("isCheckedIn") as bool? ?? false;
    final isCheckedOut = box.read("isCheckedOut") as bool? ?? false;
    print("this is check in time e $isCheckedIn}");
    if (isCheckedIn && isCheckedOut) {
      return "Update Checked Out";
    }

    // Get shift times (replace with your actual data source)
    final startTimeStr = box.read("dutyStartTime") ?? "09:00";
    final endTimeStr = box.read("dutyEndTime") ?? "17:00";
    print("this is value ${box.read("dutyStartTime")}");
    print("this is value ${box.read("dutyEndTime")}");
    TimeOfDay parseTime(String timeStr) {
      try {
        final parts = timeStr.split(':');
        return TimeOfDay(
            hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      } catch (e) {
        return TimeOfDay(hour: 9, minute: 0);
      }
    }

    final start = parseTime(startTimeStr);
    final end = parseTime(endTimeStr);

    int toMinutes(TimeOfDay time) => time.hour * 60 + time.minute;
    final nowMinutes = toMinutes(currentTime);
    final startMinutes = toMinutes(start);
    final endMinutes = toMinutes(end);

    // Handle night shift (spanning midnight)
    if (endMinutes < startMinutes) {
      if (nowMinutes >= startMinutes || nowMinutes < endMinutes) {
        if (isCheckedIn) {
          if (nowMinutes >= (endMinutes - 20)) {
            return "Update Check Out";
          }
          return "Checkout pass";
        }
        return nowMinutes > startMinutes ? "Late Attendance" : "Early Bird";
      }
      return "Early Bird";
    }
    // Handle day shift
    else {
      if (nowMinutes < startMinutes) {
        return "Early Bird";
      } else if (nowMinutes > endMinutes) {
        // After duty end time, check if it's before or after midnight
        if (currentTime.hour < 24) { // Before 12:00 AM (midnight)
          if (isCheckedIn && !isCheckedOut) {
            if(isCheckedIn && isCheckedOut){
              return "Update Check Out";
            }
            return "Update Check Out"; // Still in check-out period until midnight
          }
          return "Update Check out"; // Default if not checked in
        } else { // After 12:00 AM (midnight)
          return "Check In"; // New day, reset to "Check In"
        }
      } else {
        if (isCheckedIn) {
          if (nowMinutes >= (endMinutes - 20)) {
            return "Update Check Out";
          }
          return "Checkout pass";
        }
        return nowMinutes > startMinutes ? "Late Attendance" : "Early Bird";
      }
    }
  }
  Map<String, String> getShiftStatusWithDate() {
    final now = DateTime.now();

    // Format date (YYYY-MM-DD)
    final formattedDate = "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}";
    return {
      'date': formattedDate,

    };
  }
// Call these functions when user performs check-in/out
  String formatTime(String time24) {
    try {
      final parsedTime = DateFormat("HH:mm").parse(time24);
      return DateFormat("hh:mm a").format(parsedTime); // → e.g., 02:30 PM
    } catch (e) {
      return time24; // fallback to original if parsing fails
    }
  }
  void disposes() {
    cameraController?.dispose();
    capturedImage.value = null;
    showPreview.value = false;
    pickedImage.value = File('');
    isCameraInitialized.value = false;
    isMatching.value = false;
  }

  void showCustomDialogLogOut({
    required BuildContext context,
  }) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppAssets.logout,
                      height: AppSizes.newSize(6),
                      width: AppSizes.newSize(6),
                    ),
                    10.ph,
                    CustomSimpleText(
                      text: "You're leaving.....",
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: AppSizes.size24,
                    ),
                    5.ph,
                    CustomSimpleText(
                      text: "Are you sure?",
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: AppSizes.size20,
                    ),
                    30.ph,
                    InkWell(
                      onTap: () {
                        RouteGenerator.pushNamedAndRemoveAll(
                            navigatorKey.currentContext!, Routes.signinPage);
                        box.erase();
                        Get.deleteAll();
                        disposes();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColorsList.green1),
                        padding: EdgeInsets.all(10),
                        child: CustomSimpleText(
                          text: "Log out",
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.size18,
                          color: AppColorsList.white,
                        ),
                      ),
                    ),
                    15.ph,
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColorsList.red, width: 0.3),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent),
                        padding:
                        EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                        child: CustomSimpleText(
                          text: "Cancel",
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.size18,
                          color: AppColorsList.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: -7,
                  right: -7,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.cancel,
                        size: AppSizes.newSize(3),
                        color: AppColorsList.red,
                      )))
            ],
          ),
        );
      },
    );
  }
}

