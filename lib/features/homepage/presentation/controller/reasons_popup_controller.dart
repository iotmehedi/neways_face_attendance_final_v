import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neways_face_attendance_pro/core/core/extensions/extensions.dart';
import 'package:neways_face_attendance_pro/core/utils/common_toast/custom_toast.dart';
import 'package:neways_face_attendance_pro/core/utils/consts/app_assets.dart';
import 'package:neways_face_attendance_pro/core/utils/consts/app_colors.dart';
import 'package:neways_face_attendance_pro/core/utils/consts/app_sizes.dart';
import 'package:neways_face_attendance_pro/features/widgets/custom_elevatedButton/custom_eleveted_button.dart';
import 'package:neways_face_attendance_pro/features/widgets/custom_elevatedButton/custom_text.dart';
import 'package:neways_face_attendance_pro/main.dart';

import '../../../../core/routes/route_name.dart';
import '../../../../core/routes/router.dart';
import '../../../widgets/custom_textfield/custom_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

mixin ReasonsPopupController on GetxController {
  var reasonController = TextEditingController().obs;
  final ImagePicker picker = ImagePicker();
  List<File?> images = <File?>[].obs;
  Rx<File> pickedImage = File("").obs;
  var isReasonPosting = false.obs;
  Future<void> sendReasonFunc({
    required BuildContext context,
    required String action,
    required String requestTitle,
    required String shortCode,
  }) async {
    try {
      isReasonPosting.value = true;
      if (reasonController.value.text.isNotEmpty) {
        const String apiUrl =
            "https://erp.neways3.com/api/employee/attendance/attendance-request";
        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
        request.headers.addAll({
          'Accept': 'application/json', // Optional
        });
        // Add text fields
        request.fields.addAll({
          'api_secret': 'kAXan6SFy5U3UrzHMMQgCzFEHwU9jzuBF6kbsFMjRsCSY8fFVhwhRTZvBqrMbcK3',
          'employee_db_id': box.read('id'),
          'action': action,
          'request_title': requestTitle,
          'attendance_reason_note': reasonController.value.text,
          'short_code': shortCode,
        });

        // Add all images as an array
        for (var image in images) {
          if (image?.path.isNotEmpty ?? false) {
            String fileExtension =
                image?.path.split('.').last.toLowerCase() ?? '';
            MediaType mediaType;

            // Determine MediaType based on file extension
            switch (fileExtension) {
              case 'jpg':
              case 'jpeg':
                mediaType = MediaType('image', 'jpeg');
                break;
              case 'png':
                mediaType = MediaType('image', 'png');
                break;
              case 'pdf':
                mediaType = MediaType('application', 'pdf');
                break;
              default:
                mediaType =
                    MediaType('application', 'octet-stream'); // Fallback
            }

            request.files.add(
              await http.MultipartFile.fromPath(
                'attachment', // API expects an array
                image?.path ?? '',
                filename:
                    "attachment_${DateTime.now().millisecondsSinceEpoch}.$fileExtension",
                contentType: mediaType,
              ),
            );
          }
        }

        // Send the request
        final response = await request.send();
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);
        if (response.statusCode == 200) {
          Navigator.pop(context);
          successToast(context: context, msg: jsonResponse['message']);
          isReasonPosting.value = false;
          reasonController.value.text = '';
          images.clear();
          RouteGenerator.pushNamedAndRemoveAll(navigatorKey.currentContext!, Routes.homepage);
        } else {
          isReasonPosting.value = false;
          errorToast(context: context, msg: "Failed to upload files");
          print("Error: $responseData");
        }
      } else {
        isReasonPosting.value = false;
        showEmptyDialog(context);
      }
    } catch (e) {
      isReasonPosting.value = false;
      print("this is error multi $e");
      print("Exception: $e");
    } finally {
      isReasonPosting.value = false;
    }
    update();
  }

  void showEmptyDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext c) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomSimpleText(
                      text: "Reason field is empty. Please enter reason"),
                  20.ph,
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColorsList.red,
                      ),
                      padding: EdgeInsets.all(10),
                      child: CustomSimpleText(
                        text: "Cancel",
                        color: AppColorsList.white,
                        fontSize: AppSizes.size12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void popupReasons({
    required BuildContext context,
    required String shortCode,
    required message,
    required String attendance,
    required MaterialColor warningTextColor,
    required String title,
    required action,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  10.ph,
                  Center(
                      child: Image.asset(
                    "assets/warning.png",
                    height: AppSizes.newSize(8),
                    width: AppSizes.newSize(8),
                  )),
                  20.ph,
                  CustomSimpleText(
                    text: "Warning",
                    fontWeight: FontWeight.bold,
                    fontSize: AppSizes.size20,
                  ),
                  10.ph,
                  CustomSimpleText(
                    text: "$message",
                    fontWeight: FontWeight.w500,
                    fontSize: AppSizes.size12,
                    color: warningTextColor,
                  ),
                  10.ph,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context); // Close the current dialog
                            showReasonFiled(
                                navigatorKey.currentContext!, attendance,
                                shortCode: shortCode,
                                title: title,
                                action:
                                    action); // Now safely show the next dialog
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: AppColorsList.green.withValues(alpha: 0.4),
                              ),
                              color: AppColorsList.green1,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  size: AppSizes.newSize(2),
                                  color: AppColorsList.white,
                                ),
                                Expanded(
                                  child: CustomSimpleText(
                                    text: attendance,
                                    fontSize: AppSizes.size11,
                                    color: AppColorsList.white,
                                    textAlignment: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        10.ph,
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: AppColorsList.red.withValues(alpha: 0.4),
                              ),
                              color: AppColorsList.red,
                            ),
                            child: CustomSimpleText(
                              text: "X No, Thanks",
                              fontSize: AppSizes.size11,
                              color: AppColorsList.white,
                              textAlignment: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  10.ph,
                ],
              ),
              Positioned(
                  top: -10,
                  right: -10,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: AppColorsList.red,
                      )))
            ],
          ),
        );
      },
    );
  }

  Future<void> pickImage(int index, ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      images[index] = File(pickedFile.path);
    }
  }

  void addContainer() {
    images.add(null);
  }

  void showPicker(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext bc) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row(
                  //   children: [
                  //     Expanded(
                  //         child: Container(
                  //           padding: EdgeInsets.all(10),
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10),
                  //             color: AppColorsList.g
                  //           ),
                  //           child: Icon(
                  //                                   Icons.photo,
                  //                                   size: AppSizes.newSize(3.5),
                  //                                 ),
                  //         )),
                  //   ],
                  // ),
                  Wrap(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('Photo Library'),
                        onTap: () {
                          pickImage(index, ImageSource.gallery);
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text('Camera'),
                        onTap: () {
                          pickImage(index, ImageSource.camera);
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.insert_drive_file),
                        title: Text('Files (PDF/Images)'),
                        onTap: () {
                          pickFiles(index); // New PDF+image picker
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                  right: -10,
                  top: -10,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: AppColorsList.red,
                      )))
            ],
          ),
        );
      },
    );
  }

  Future<void> pickFiles(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'mp4', 'mov', 'gif'],
        allowMultiple: false, // Single file per container
      );

      if (result != null && result.files.isNotEmpty) {
        images[index] = File(result.files.single.path!);
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  void showReasonFiled(BuildContext context, String attendance,
      {required String shortCode, required String title, required action}) {
    showDialog(
        context: context,
        builder: (BuildContext c) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      20.ph,
                      CustomSimpleText(
                          text: "${attendance}."),
                      5.ph,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomSimpleText(
                          text: "Attachment(If needed)",
                          fontSize: AppSizes.size12,
                          color: AppColorsList.red.withValues(alpha: 0.7),
                        ),
                      ),
                      5.ph,
                      Wrap(spacing: 8.0, runSpacing: 8.0, children: [
                        ...List.generate(images.length, (index) {
                          return GestureDetector(
                            onTap: () => showPicker(context, index),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppColorsList.green1.withOpacity(0.5),
                                  border: Border.all(
                                      color: AppColorsList.green1, width: 1)),
                              width:
                                  (MediaQuery.of(navigatorKey.currentContext!)
                                              .size
                                              .width /
                                          5) -
                                      16,
                              height: 60,
                              child: images[index] != null
                                  ? (images[index]!
                                          .path
                                          .toLowerCase()
                                          .endsWith('.pdf')
                                      ? Center(
                                          child: Icon(Icons.picture_as_pdf,
                                              color: Colors.red))
                                      : Image.file(images[index]!,
                                          fit: BoxFit.cover))
                                  : Center(
                                      child: Icon(Icons.add_photo_alternate,
                                          size: 22)),
                            ),
                          );
                        }),
                        GestureDetector(
                          onTap: addContainer,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: AppColorsList.green1.withOpacity(0.5),
                                border: Border.all(
                                    color: AppColorsList.green1, width: 1)),
                            width: (MediaQuery.of(navigatorKey.currentContext!)
                                        .size
                                        .width /
                                    5) -
                                16,
                            height: 60,
                            child: const Icon(Icons.add,
                                color: Colors.black, size: 30),
                          ),
                        ),
                      ]),
                      20.ph,
                      CustomTextfield(
                        controller: reasonController.value,
                        hintText: "Enter ${attendance.toLowerCase()} reason",
                        lebelText: "Reason",
                        textInputType: TextInputType.text,
                      ),
                      30.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColorsList.red,
                              ),
                              padding: EdgeInsets.all(10),
                              child: CustomSimpleText(
                                text: "Cancel",
                                fontSize: AppSizes.size12,
                                color: AppColorsList.white,
                              ),
                            ),
                          ),
                          10.pw,
                          isReasonPosting.value == true
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : InkWell(
                                  onTap: () {
                                    sendReasonFunc(
                                      context: context,
                                      action: action,
                                      requestTitle: title,
                                      shortCode: shortCode,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColorsList.green1,
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: CustomSimpleText(
                                      text: "Apply",
                                      fontSize: AppSizes.size12,
                                      color: AppColorsList.white,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      20.ph,
                    ],
                  ),
                )),
          );
        });
  }
}
