// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:network_info_plus/network_info_plus.dart';
// import 'package:neways_face_attendance_pro/core/network/configuration.dart';
// import 'package:neways_face_attendance_pro/core/utils/common_methods/common_methods.dart';
// import 'package:neways_face_attendance_pro/core/utils/consts/app_colors.dart';
// import '../../data/model/get_employee_face_model.dart';
// import '../controller/get_employee_face_controller.dart';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:math' as math;
// import 'package:flutter_face_api/face_api.dart' as regula;
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:http/http.dart' as http;
//
// import '../model/face_features.dart';
// import '../model/user_model.dart';
// import '../services/extract_features.dart';
// import '../widgets/authenticated_user_screen.dart';
// import '../widgets/camera_view.dart';
//
// class Homepage extends StatefulWidget {
//   Homepage({super.key});
//
//   @override
//   State<Homepage> createState() => _HomepageState();
// }
//
// class _HomepageState extends State<Homepage> {
//   final GetEmployeeFaceController _employeeController = Get.put(GetEmployeeFaceController());
//   final NetworkInfo _networkInfo = NetworkInfo();
//   String _wifiName = 'Unknown';
//   String _wifiBSSID = 'Unknown';
//   String _wifiIP = 'Unknown';
//   String _wifiIPv6 = 'Unknown';
//   String _wifiSubmask = 'Unknown';
//   String _wifiGateway = 'Unknown';
//   String _wifiBroadcast = 'Unknown';
//   bool _isLoading = false;
//
//   Future<void> _getNetworkInfo() async {
//     setState(() => _isLoading = true);
//
//     try {
//       final wifiName = await _networkInfo.getWifiName();
//       final wifiBSSID = await _networkInfo.getWifiBSSID();
//       final wifiIP = await _networkInfo.getWifiIP();
//       final wifiIPv6 = await _networkInfo.getWifiIPv6();
//       final wifiSubmask = await _networkInfo.getWifiSubmask();
//       final wifiGateway = await _networkInfo.getWifiGatewayIP();
//       final wifiBroadcast = await _networkInfo.getWifiBroadcast();
//
//       setState(() {
//         _wifiName = wifiName ?? 'Unknown';
//         _wifiBSSID = wifiBSSID ?? 'Unknown';
//         _wifiIP = wifiIP ?? 'Unknown';
//         _wifiIPv6 = wifiIPv6 ?? 'Unknown';
//         _wifiSubmask = wifiSubmask ?? 'Unknown';
//         _wifiGateway = wifiGateway ?? 'Unknown';
//         _wifiBroadcast = wifiBroadcast ?? 'Unknown';
//       });
//     } catch (e) {
//       setState(() {
//         _wifiName = 'Error: ${e.toString()}';
//       });
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//   @override
//   void initState() {
//     super.initState();
//     // Load employee faces when screen initializes
//     _employeeController.getEmployeeFacetFunc();
//     _getNetworkInfo();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("User Authenticate"),
//         iconTheme: const IconThemeData(color: Colors.white),
//         elevation: 0,
//       ),
//       body: Obx(() {
//         if (_employeeController.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (_employeeController.errorMessage.value?.isNotEmpty ?? false) {
//           return Center(
//             child: Text(_employeeController.errorMessage.value ?? ''),
//           );
//         }
//
//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               CameraView(
//                 onImage: (image) {
//                   _setImage(image);
//                 },
//                 onInputImage: (inputImage) async {
//                   setState(() => isMatching = true);
//                   List<Face> faceList = await _faceDetector.processImage(inputImage);
//
//                   if (faceList.isEmpty) {
//                     setState(() {
//                       _canAuthenticate = false;
//                       isMatching = false;
//                     } );
//                     CommonMethods.showToast("No face detected", AppColorsList.white);
//                     return false;
//                   }else{
//                     _faceFeatures = await extractFaceFeatures(inputImage, _faceDetector);
//                     setState(() => isMatching = false);
//                     return _faceFeatures != null;
//                   }
//                    // Return whether face was detected
//                 },
//
//               ),
//               // ElevatedButton(onPressed: (){
//               //   Navigator.push(
//               //       context, MaterialPageRoute(builder: (context) => FaceDetectorView()));
//               // }, child: Text("data")),
//               if (_canAuthenticate)
//                 isMatching
//                     ? const Center(
//                   child: CircularProgressIndicator(),
//                 )
//                     : Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                   child: SizedBox(
//                     height: 55,
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ButtonStyle(
//                         shape: MaterialStateProperty.all(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         backgroundColor:
//                         MaterialStateProperty.all(Colors.deepPurple),
//                         foregroundColor:
//                         MaterialStateProperty.all(Colors.white),
//                       ),
//                       child: const Text("Authenticate"),
//                       onPressed: () async {
//                         setState(() => isMatching = true);
//                         await _matchWithEmployeeFaces();
//                       },
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 38),
//               _isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : SizedBox(
//                 height: 200,
//                     child: ListView(
//                                     children: [
//                     _buildInfoCard('WiFi Name (SSID)', _wifiName),
//                     _buildInfoCard('BSSID (MAC)', _wifiBSSID),
//                     _buildInfoCard('IP Address', _wifiIP),
//                     _buildInfoCard('IPv6 Address', _wifiIPv6),
//                     _buildInfoCard('Subnet Mask', _wifiSubmask),
//                     _buildInfoCard('Gateway IP', _wifiGateway),
//                     _buildInfoCard('Broadcast Address', _wifiBroadcast),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _getNetworkInfo,
//                       child: const Text('Refresh Information'),
//                     ),
//                                     ],
//                                   ),
//                   ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//   Widget _buildInfoCard(String title, String value) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               value,
//               style: const TextStyle(fontSize: 14),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   /// Member functions
//
//   Future _setImage(Uint8List imageToAuthenticate) async {
//     image2.bitmap = base64Encode(imageToAuthenticate);
//     image2.imageType = regula.ImageType.PRINTED;
//
//     setState(() {
//       _canAuthenticate = true;
//     });
//   }
//
//
//   double euclideanDistance(Points p1, Points p2) {
//     final sqr =
//     math.sqrt(math.pow((p1.x! - p2.x!), 2) + math.pow((p1.y! - p2.y!), 2));
//     return sqr;
//   }
//
//   Future<void> _matchWithEmployeeFaces() async {
//     if (_employeeController.getEmployeeFaceModel.value.employeeFaceAttendance == null ||
//         _employeeController.getEmployeeFaceModel.value.employeeFaceAttendance!.isEmpty) {
//       _showFailureDialog(
//         title: "No Employee Faces",
//         description: "No employee faces available for matching.",
//       );
//       return;
//     }
//
//     bool faceMatched = false;
//
//     for (var employeeFace in _employeeController.getEmployeeFaceModel.value.employeeFaceAttendance!) {
//       if (employeeFace.imageUrl == null) continue;
//
//       try {
//         // Then assign the value
//         final responses = await http.get(Uri.parse("${NetworkConfiguration.imageUrl}${employeeFace.imageUrl}"));
//
//         if (responses.statusCode == 200) {
//           image1.bitmap = base64Encode(responses.bodyBytes);
//           image1.imageType = regula.ImageType.PRINTED;
//
//           // Face comparing logic
//           var request = regula.MatchFacesRequest();
//           request.images = [image1, image2];
//           dynamic value = await regula.FaceSDK.matchFaces(jsonEncode(request));
//
//           var response = regula.MatchFacesResponse.fromJson(json.decode(value));
//           dynamic str = await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
//               jsonEncode(response!.results), 0.75);
//
//           var split = regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));
//
//           setState(() {
//             _similarity = split!.matchedFaces.isNotEmpty
//                 ? (split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)
//                 : "error";
//             log("similarity: $_similarity");
//
//             if (_similarity != "error" && double.parse(_similarity) > 90.00) {
//               faceMatched = true;
//               matchedEmployee = employeeFace;
//             }
//           });
//
//           if (faceMatched) break; // Stop if we found a match
//         }
//       } catch (e) {
//         log("Error processing face ${employeeFace.id}: $e");
//       }
//     }
//
//     if (faceMatched && mounted) {
//       // Convert to UserModel if needed
//       UserModel user = UserModel(
//         id: matchedEmployee?.id.toString(),
//         name: "Employee ${matchedEmployee?.employeeId}",
//         image: matchedEmployee?.imageUrl,
//         // Add other required fields
//       );
//       setState(() => trialNumber = 1);
//       if (mounted) {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => AuthenticatedUserScreen(user: user,),
//           ),
//         );
//       }
//     } else {
//       if (trialNumber == 4) {
//         setState(() => trialNumber = 1);
//         _showFailureDialog(
//           title: "Authentication Failed",
//           description: "Face doesn't match any registered employee.",
//         );
//       } else {
//         setState(() => trialNumber++);
//         _showFailureDialog(
//           title: "Authentication Failed",
//           description: "Face doesn't match. Please try again.",
//         );
//       }
//     }
//
//     setState(() => isMatching = false);
//   }
//
//   _showFailureDialog({
//     required String title,
//     required String description,
//   }) {
//     setState(() => isMatching = false);
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(description),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 "Ok",
//                 style: TextStyle(
//                   color: Colors.redAccent,
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//     );
//   }
//
//   void showToast(msg) {
//     Fluttertoast.showToast(
//       msg: msg,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//     );
//   }
//
//   /// Data Members
//   final FaceDetector _faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableLandmarks: true,
//       performanceMode: FaceDetectorMode.accurate,
//     ),
//   );
//   FaceFeatures? _faceFeatures;
//   var image1 = regula.MatchFacesImage();
//   var image2 = regula.MatchFacesImage();
//
//   bool _canAuthenticate = false;
//   String _similarity = "";
//   bool isMatching = false;
//   int trialNumber = 1;
//   EmployeeFaceAttendance? matchedEmployee;
//
//   @override
//   void dispose() {
//     _faceDetector.close();
//     super.dispose();
//   }
// }