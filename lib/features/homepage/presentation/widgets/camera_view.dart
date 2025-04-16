// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:neways_face_attendance_pro/core/core/extensions/extensions.dart';
// import 'package:neways_face_attendance_pro/core/utils/consts/app_colors.dart';
// import 'package:neways_face_attendance_pro/features/widgets/custom_elevatedButton/custom_text.dart';
//
// class CameraView extends StatefulWidget {
//   const CameraView(
//       {Key? key, required this.onImage, required this.onInputImage})
//       : super(key: key);
//
//   final Function(Uint8List image) onImage;
//   final Function(InputImage inputImage) onInputImage;
//
//   @override
//   State<CameraView> createState() => _CameraViewState();
// }
//
// class _CameraViewState extends State<CameraView> {
//   File? _image;
//   ImagePicker? _imagePicker;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _imagePicker = ImagePicker();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//
//
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColorsList.green1,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(100.0)),
//               minimumSize: Size(100, 120)
//             ),
//             onPressed: _getImage,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 CustomSimpleText(
//                   text: DateFormat('kk:mm a').format(DateTime.now()),
//                   color: AppColorsList.white,
//                 ),
//                 5.ph,
//                 CustomSimpleText(
//                   text: "Check In",
//                   color: AppColorsList.white,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 12,
//         ),
//         Visibility(
//           visible: _image != null ? true : false,
//           child: Container(
//             margin: const EdgeInsets.symmetric(
//               horizontal: 20,
//               vertical: 10,
//             ),
//             width: double.infinity,
//             height: 300,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 color: const Color(0xff2E2E2E),
//               ),
//             ),
//             child: _image != null
//                 ? Image.file(
//               _image!,
//               fit: BoxFit.cover,
//             )
//                 : const Center(
//               child: Icon(
//                 Icons.camera_alt,
//                 size: 55,
//                 color: Color(0xff2E2E2E),
//               ),
//             ),
//           ),
//         ),
//
//         // SizedBox
//         const SizedBox(height: 12),
//       ],
//     );
//   }
//
//   Future _getImage() async {
//     setState(() {
//       _image = null;
//     });
//     final pickedFile = await _imagePicker?.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 400,
//         maxHeight: 400,
//         preferredCameraDevice: CameraDevice.front
//         // imageQuality: 50,
//         );
//     if (pickedFile != null) {
//       _setPickedFile(pickedFile);
//     }
//     setState(() {});
//   }
//
//   Future _setPickedFile(XFile? pickedFile) async {
//     final path = pickedFile?.path;
//     if (path == null) {
//       return;
//     }
//     setState(() {
//       _image = File(path);
//     });
//
//     Uint8List imageBytes = _image!.readAsBytesSync();
//     widget.onImage(imageBytes);
//
//     InputImage inputImage = InputImage.fromFilePath(path);
//     widget.onInputImage(inputImage);
//   }
// }
