// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
//
// import 'package:camera/camera.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// import 'package:flutter/services.dart';
// import 'package:neways_face_attendance_pro/core/network/configuration.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_face_api/face_api.dart' as regula;
// import '../../../../main.dart';
// import '../../data/model/get_employee_face_model.dart';
// import '../controller/get_employee_face_controller.dart';
// import '../model/user_model.dart';
// import '../widgets/authenticated_user_screen.dart';
// import 'package:http/http.dart' as http;
// class FaceDetectorView extends StatefulWidget {
//   const FaceDetectorView({Key? key}) : super(key: key);
//
//   @override
//   State<FaceDetectorView> createState() => _FaceDetectorViewState();
// }
//
// class _FaceDetectorViewState extends State<FaceDetectorView> {
//   final GetEmployeeFaceController _employeeController = Get.put(GetEmployeeFaceController());
//   final FaceDetector _faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableContours: true,
//       enableLandmarks: true,
//     ),
//   );
//   bool _canProcess = true;
//   bool _isBusy = false;
//   bool _isMatching = false;
//   CustomPaint? _customPaint;
//   String? _text;
//   var _cameraLensDirection = CameraLensDirection.front;
//
//   // Matching state
//   String? _similarity;
//   EmployeeFaceAttendance? _matchedEmployee;
//   int _trialNumber = 1;
//   var image1 = regula.MatchFacesImage();
//   var image2 = regula.MatchFacesImage();
//
//   @override
//   void dispose() {
//     _canProcess = false;
//     _faceDetector.close();
//     super.dispose();
//   }
//
//   Future<void> _processImage(InputImage inputImage) async {
//     if (!_canProcess || _isBusy || _isMatching) return;
//
//     _isBusy = true;
//     setState(() => _text = 'Processing...');
//
//     try {
//       final faces = await _faceDetector.processImage(inputImage);
//
//       if (faces.isNotEmpty) {
//         final imageBytes = await _inputImageToBytes(inputImage);
//         if (imageBytes != null && mounted) {
//           setState(() => _isMatching = true);
//
//           // Set the detected face to image2 for comparison
//           image2.bitmap = base64Encode(imageBytes);
//           image2.imageType = regula.ImageType.LIVE;
//           if(faces.isNotEmpty){
//             await _matchWithEmployeeFaces();
//           }
//
//         }
//       }
//
//       if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
//         _customPaint = CustomPaint(
//           painter: FaceDetectorPainter(
//             faces,
//             inputImage.metadata!.size,
//             inputImage.metadata!.rotation,
//             _cameraLensDirection,
//           ),
//         );
//       } else {
//         _text = 'Faces found: ${faces.length}';
//         _customPaint = null;
//       }
//     } catch (e) {
//       debugPrint('Face processing error: $e');
//       _text = 'Error processing face';
//     } finally {
//       _isBusy = false;
//       if (mounted) {
//         setState(() => _isMatching = false);
//       }
//     }
//   }
//
//   Future<Uint8List?> _inputImageToBytes(InputImage inputImage) async {
//     if (inputImage.filePath != null) {
//       return await File(inputImage.filePath!).readAsBytes();
//     } else if (inputImage.bytes != null) {
//       return inputImage.bytes;
//     } else if (inputImage.bytes?.buffer != null) {
//       return inputImage.bytes?.buffer.asUint8List();
//     }
//     return null;
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
//         final response = await http.get(Uri.parse("${NetworkConfiguration.imageUrl}${employeeFace.imageUrl}"));
//
//         if (response.statusCode == 200) {
//           // Set the API image to image1 for comparison
//           image1.bitmap = base64Encode(response.bodyBytes);
//           image1.imageType = regula.ImageType.PRINTED;
//
//           // Face comparing logic using Regula FaceSDK
//           var request = regula.MatchFacesRequest();
//           request.images = [image1, image2];
//           dynamic value = await regula.FaceSDK.matchFaces(jsonEncode(request));
//
//           var regulaResponse = regula.MatchFacesResponse.fromJson(json.decode(value));
//           dynamic str = await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
//               jsonEncode(regulaResponse!.results), 0.75);
//
//           var split = regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));
//
//           if (mounted) {
//             setState(() {
//               _similarity = split!.matchedFaces.isNotEmpty
//                   ? (split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)
//                   : "error";
//               debugPrint("similarity: $_similarity");
//
//               if (_similarity != "error" && double.parse(_similarity!) > 90.00) {
//                 faceMatched = true;
//                 _matchedEmployee = employeeFace;
//               }
//             });
//           }
//
//           if (faceMatched) break;
//         }
//       } catch (e) {
//         debugPrint("Error processing face ${employeeFace.id}: $e");
//       }
//     }
//
//     if (faceMatched && mounted) {
//       // Convert to UserModel if needed
//       UserModel user = UserModel(
//         id: _matchedEmployee?.id.toString(),
//         name: "Employee ${_matchedEmployee?.employeeId}",
//         image: _matchedEmployee?.imageUrl,
//       );
//
//       setState(() => _trialNumber = 1);
//
//       Navigator.of(navigatorKey.currentContext!).push(
//         MaterialPageRoute(
//           builder: (context) => AuthenticatedUserScreen(user: user),
//         ),
//       );
//     } else {
//       if (_trialNumber == 4) {
//         setState(() => _trialNumber = 1);
//         _showFailureDialog(
//           title: "Authentication Failed",
//           description: "Face doesn't match any registered employee.",
//         );
//       } else {
//         setState(() => _trialNumber++);
//         _showFailureDialog(
//           title: "Authentication Failed",
//           description: "Face doesn't match. Please try again.",
//         );
//       }
//     }
//   }
//
//   void _showFailureDialog({required String title, required String description}) {
//     showDialog(
//       context: navigatorKey.currentContext!,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(description),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         DetectorView(
//           title: 'Face Detector',
//           customPaint: _customPaint,
//           text: _text,
//           onImage: _processImage,
//           initialCameraLensDirection: _cameraLensDirection,
//           onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
//         ),
//         if (_isMatching)
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 16),
//                 Text(
//                   'Matching with employee database...\nTrial $_trialNumber/4',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                   textAlign: TextAlign.center,
//                 ),
//                 if (_similarity != null)
//                   Text(
//                     'Similarity: $_similarity%',
//                     style: TextStyle(color: Colors.white, fontSize: 14),
//                   ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }
// }
//
//
// class FaceDetectorPainter extends CustomPainter {
//   FaceDetectorPainter(
//       this.faces,
//       this.imageSize,
//       this.rotation,
//       this.cameraLensDirection,
//       );
//
//   final List<Face> faces;
//   final Size imageSize;
//   final InputImageRotation rotation;
//   final CameraLensDirection cameraLensDirection;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint1 = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0
//       ..color = Colors.red;
//     final Paint paint2 = Paint()
//       ..style = PaintingStyle.fill
//       ..strokeWidth = 1.0
//       ..color = Colors.green;
//
//     for (final Face face in faces) {
//       final left = translateX(
//         face.boundingBox.left,
//         size,
//         imageSize,
//         rotation,
//         cameraLensDirection,
//       );
//       final top = translateY(
//         face.boundingBox.top,
//         size,
//         imageSize,
//         rotation,
//         cameraLensDirection,
//       );
//       final right = translateX(
//         face.boundingBox.right,
//         size,
//         imageSize,
//         rotation,
//         cameraLensDirection,
//       );
//       final bottom = translateY(
//         face.boundingBox.bottom,
//         size,
//         imageSize,
//         rotation,
//         cameraLensDirection,
//       );
//
//       canvas.drawRect(
//         Rect.fromLTRB(left, top, right, bottom),
//         paint1,
//       );
//
//       void paintContour(FaceContourType type) {
//         final contour = face.contours[type];
//         if (contour?.points != null) {
//           for (final Point point in contour!.points) {
//             canvas.drawCircle(
//                 Offset(
//                   translateX(
//                     point.x.toDouble(),
//                     size,
//                     imageSize,
//                     rotation,
//                     cameraLensDirection,
//                   ),
//                   translateY(
//                     point.y.toDouble(),
//                     size,
//                     imageSize,
//                     rotation,
//                     cameraLensDirection,
//                   ),
//                 ),
//                 1,
//                 paint1);
//           }
//         }
//       }
//
//       void paintLandmark(FaceLandmarkType type) {
//         final landmark = face.landmarks[type];
//         if (landmark?.position != null) {
//           canvas.drawCircle(
//               Offset(
//                 translateX(
//                   landmark!.position.x.toDouble(),
//                   size,
//                   imageSize,
//                   rotation,
//                   cameraLensDirection,
//                 ),
//                 translateY(
//                   landmark.position.y.toDouble(),
//                   size,
//                   imageSize,
//                   rotation,
//                   cameraLensDirection,
//                 ),
//               ),
//               2,
//               paint2);
//         }
//       }
//
//       for (final type in FaceContourType.values) {
//         paintContour(type);
//       }
//
//       for (final type in FaceLandmarkType.values) {
//         paintLandmark(type);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) {
//     return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
//   }
// }
//
// double translateX(
//     double x,
//     Size canvasSize,
//     Size imageSize,
//     InputImageRotation rotation,
//     CameraLensDirection cameraLensDirection,
//     ) {
//   switch (rotation) {
//     case InputImageRotation.rotation90deg:
//       return x *
//           canvasSize.width /
//           (Platform.isIOS ? imageSize.width : imageSize.height);
//     case InputImageRotation.rotation270deg:
//       return canvasSize.width -
//           x *
//               canvasSize.width /
//               (Platform.isIOS ? imageSize.width : imageSize.height);
//     case InputImageRotation.rotation0deg:
//     case InputImageRotation.rotation180deg:
//       switch (cameraLensDirection) {
//         case CameraLensDirection.back:
//           return x * canvasSize.width / imageSize.width;
//         default:
//           return canvasSize.width - x * canvasSize.width / imageSize.width;
//       }
//   }
// }
//
// double translateY(
//     double y,
//     Size canvasSize,
//     Size imageSize,
//     InputImageRotation rotation,
//     CameraLensDirection cameraLensDirection,
//     ) {
//   switch (rotation) {
//     case InputImageRotation.rotation90deg:
//     case InputImageRotation.rotation270deg:
//       return y *
//           canvasSize.height /
//           (Platform.isIOS ? imageSize.height : imageSize.width);
//     case InputImageRotation.rotation0deg:
//     case InputImageRotation.rotation180deg:
//       return y * canvasSize.height / imageSize.height;
//   }
// }
//
// enum DetectorViewMode { liveFeed, gallery }
//
// class DetectorView extends StatefulWidget {
//   DetectorView({
//     Key? key,
//     required this.title,
//     required this.onImage,
//     this.customPaint,
//     this.text,
//     this.initialDetectionMode = DetectorViewMode.liveFeed,
//     this.initialCameraLensDirection = CameraLensDirection.back,
//     this.onCameraFeedReady,
//     this.onDetectorViewModeChanged,
//     this.onCameraLensDirectionChanged,
//   }) : super(key: key);
//
//   final String title;
//   final CustomPaint? customPaint;
//   final String? text;
//   final DetectorViewMode initialDetectionMode;
//   final Function(InputImage inputImage) onImage;
//   final Function()? onCameraFeedReady;
//   final Function(DetectorViewMode mode)? onDetectorViewModeChanged;
//   final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
//   final CameraLensDirection initialCameraLensDirection;
//
//   @override
//   State<DetectorView> createState() => _DetectorViewState();
// }
//
// class _DetectorViewState extends State<DetectorView> {
//   late DetectorViewMode _mode;
//
//   @override
//   void initState() {
//     _mode = widget.initialDetectionMode;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  CameraView(
//       customPaint: widget.customPaint,
//       onImage: widget.onImage,
//       onCameraFeedReady: widget.onCameraFeedReady,
//       // onDetectorViewModeChanged: _onDetectorViewModeChanged,
//       initialCameraLensDirection: widget.initialCameraLensDirection,
//       onCameraLensDirectionChanged: widget.onCameraLensDirectionChanged,
//       context: context
//     );
//   }
//
//   void _onDetectorViewModeChanged() {
//     if (_mode == DetectorViewMode.liveFeed) {
//       _mode = DetectorViewMode.gallery;
//     } else {
//       _mode = DetectorViewMode.liveFeed;
//     }
//     if (widget.onDetectorViewModeChanged != null) {
//       widget.onDetectorViewModeChanged!(_mode);
//     }
//     setState(() {});
//   }
// }
//
//
// class CameraView extends StatefulWidget {
//   CameraView(
//       {Key? key,
//         required this.customPaint,
//         required this.onImage,
//         this.onCameraFeedReady,
//         this.onDetectorViewModeChanged,
//         this.onCameraLensDirectionChanged,
//         this.initialCameraLensDirection = CameraLensDirection.back, required this.context})
//       : super(key: key);
//
//   final CustomPaint? customPaint;
//   final Function(InputImage inputImage) onImage;
//   final VoidCallback? onCameraFeedReady;
//   final VoidCallback? onDetectorViewModeChanged;
//   final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
//   final CameraLensDirection initialCameraLensDirection;
//   final BuildContext context;
//
//   @override
//   State<CameraView> createState() => _CameraViewState();
// }
//
// class _CameraViewState extends State<CameraView> {
//   static List<CameraDescription> _cameras = [];
//   CameraController? _controller;
//   int _cameraIndex = -1;
//   double _currentZoomLevel = 1.0;
//   double _minAvailableZoom = 1.0;
//   double _maxAvailableZoom = 1.0;
//   double _minAvailableExposureOffset = 0.0;
//   double _maxAvailableExposureOffset = 0.0;
//   double _currentExposureOffset = 0.0;
//   bool _changingCameraLens = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _initialize();
//   }
//
//   void _initialize() async {
//     if (_cameras.isEmpty) {
//       _cameras = await availableCameras();
//     }
//     for (var i = 0; i < _cameras.length; i++) {
//       if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
//         _cameraIndex = i;
//         break;
//       }
//     }
//     if (_cameraIndex != -1) {
//       _startLiveFeed();
//     }
//   }
//
//   @override
//   void dispose() {
//     _stopLiveFeed();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: _liveFeedBody());
//   }
//
//   Widget _liveFeedBody() {
//     if (_cameras.isEmpty) return Container();
//     if (_controller == null) return Container();
//     if (_controller?.value.isInitialized == false) return Container();
//     return ColoredBox(
//       color: Colors.black,
//       child: Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           Center(
//             child: _changingCameraLens
//                 ? Center(
//               child: const Text('Changing camera lens'),
//             )
//                 : CameraPreview(
//               _controller!,
//               child: widget.customPaint,
//             ),
//           ),
//           _backButton(),
//           _switchLiveCameraToggle(),
//           // _detectionViewModeToggle(),
//           // _zoomControl(),
//           // _exposureControl(),
//         ],
//       ),
//     );
//   }
//
//   Widget _backButton() => Positioned(
//     top: 40,
//     left: 8,
//     child: SizedBox(
//       height: 50.0,
//       width: 50.0,
//       child: FloatingActionButton(
//         heroTag: Object(),
//         onPressed: () => Navigator.of(widget.context).pop(),
//         backgroundColor: Colors.black54,
//         child: Icon(
//           Icons.arrow_back_ios_outlined,
//           size: 20,
//         ),
//       ),
//     ),
//   );
//
//   Widget _detectionViewModeToggle() => Positioned(
//     bottom: 8,
//     left: 8,
//     child: SizedBox(
//       height: 50.0,
//       width: 50.0,
//       child: FloatingActionButton(
//         heroTag: Object(),
//         onPressed: widget.onDetectorViewModeChanged,
//         backgroundColor: Colors.black54,
//         child: Icon(
//           Icons.photo_library_outlined,
//           size: 25,
//         ),
//       ),
//     ),
//   );
//
//   Widget _switchLiveCameraToggle() => Positioned(
//     bottom: 8,
//     right: 8,
//     child: SizedBox(
//       height: 50.0,
//       width: 50.0,
//       child: FloatingActionButton(
//         heroTag: Object(),
//         onPressed: _switchLiveCamera,
//         backgroundColor: Colors.black54,
//         child: Icon(
//           Platform.isIOS
//               ? Icons.flip_camera_ios_outlined
//               : Icons.flip_camera_android_outlined,
//           size: 25,
//         ),
//       ),
//     ),
//   );
//
//   Widget _zoomControl() => Positioned(
//     bottom: 16,
//     left: 0,
//     right: 0,
//     child: Align(
//       alignment: Alignment.bottomCenter,
//       child: SizedBox(
//         width: 250,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               child: Slider(
//                 value: _currentZoomLevel,
//                 min: _minAvailableZoom,
//                 max: _maxAvailableZoom,
//                 activeColor: Colors.white,
//                 inactiveColor: Colors.white30,
//                 onChanged: (value) async {
//                   setState(() {
//                     _currentZoomLevel = value;
//                   });
//                   await _controller?.setZoomLevel(value);
//                 },
//               ),
//             ),
//             Container(
//               width: 50,
//               decoration: BoxDecoration(
//                 color: Colors.black54,
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Center(
//                   child: Text(
//                     '${_currentZoomLevel.toStringAsFixed(1)}x',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
//
//   Widget _exposureControl() => Positioned(
//     top: 40,
//     right: 8,
//     child: ConstrainedBox(
//       constraints: BoxConstraints(
//         maxHeight: 250,
//       ),
//       child: Column(children: [
//         Container(
//           width: 55,
//           decoration: BoxDecoration(
//             color: Colors.black54,
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Center(
//               child: Text(
//                 '${_currentExposureOffset.toStringAsFixed(1)}x',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: RotatedBox(
//             quarterTurns: 3,
//             child: SizedBox(
//               height: 30,
//               child: Slider(
//                 value: _currentExposureOffset,
//                 min: _minAvailableExposureOffset,
//                 max: _maxAvailableExposureOffset,
//                 activeColor: Colors.white,
//                 inactiveColor: Colors.white30,
//                 onChanged: (value) async {
//                   setState(() {
//                     _currentExposureOffset = value;
//                   });
//                   await _controller?.setExposureOffset(value);
//                 },
//               ),
//             ),
//           ),
//         )
//       ]),
//     ),
//   );
//
//   Future _startLiveFeed() async {
//     final camera = _cameras[_cameraIndex];
//     _controller = CameraController(
//       camera,
//       // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
//       ResolutionPreset.high,
//       enableAudio: false,
//       imageFormatGroup: Platform.isAndroid
//           ? ImageFormatGroup.nv21
//           : ImageFormatGroup.bgra8888,
//     );
//     _controller?.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       _controller?.getMinZoomLevel().then((value) {
//         _currentZoomLevel = value;
//         _minAvailableZoom = value;
//       });
//       _controller?.getMaxZoomLevel().then((value) {
//         _maxAvailableZoom = value;
//       });
//       _currentExposureOffset = 0.0;
//       _controller?.getMinExposureOffset().then((value) {
//         _minAvailableExposureOffset = value;
//       });
//       _controller?.getMaxExposureOffset().then((value) {
//         _maxAvailableExposureOffset = value;
//       });
//       _controller?.startImageStream(_processCameraImage).then((value) {
//         if (widget.onCameraFeedReady != null) {
//           widget.onCameraFeedReady!();
//         }
//         if (widget.onCameraLensDirectionChanged != null) {
//           widget.onCameraLensDirectionChanged!(camera.lensDirection);
//         }
//       });
//       setState(() {});
//     });
//   }
//
//   Future _stopLiveFeed() async {
//     await _controller?.stopImageStream();
//     await _controller?.dispose();
//     _controller = null;
//   }
//
//   Future _switchLiveCamera() async {
//     setState(() => _changingCameraLens = true);
//     _cameraIndex = (_cameraIndex + 1) % _cameras.length;
//
//     await _stopLiveFeed();
//     await _startLiveFeed();
//     setState(() => _changingCameraLens = false);
//   }
//
//   void _processCameraImage(CameraImage image) {
//     final inputImage = _inputImageFromCameraImage(image);
//     if (inputImage == null) return;
//     widget.onImage(inputImage);
//   }
//
//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };
//
//   InputImage? _inputImageFromCameraImage(CameraImage image) {
//     if (_controller == null) return null;
//
//     // get image rotation
//     // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
//     // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
//     // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart
//     final camera = _cameras[_cameraIndex];
//     final sensorOrientation = camera.sensorOrientation;
//     // print(
//     //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
//     InputImageRotation? rotation;
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else if (Platform.isAndroid) {
//       var rotationCompensation =
//       _orientations[_controller!.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//       if (camera.lensDirection == CameraLensDirection.front) {
//         // front-facing
//         rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
//       } else {
//         // back-facing
//         rotationCompensation =
//             (sensorOrientation - rotationCompensation + 360) % 360;
//       }
//       rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
//       // print('rotationCompensation: $rotationCompensation');
//     }
//     if (rotation == null) return null;
//     // print('final rotation: $rotation');
//
//     // get image format
//     final format = InputImageFormatValue.fromRawValue(image.format.raw);
//     // validate format depending on platform
//     // only supported formats:
//     // * nv21 for Android
//     // * bgra8888 for iOS
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) {
//       return null;
//     }
//
//     // since format is constraint to nv21 or bgra8888, both only have one plane
//     if (image.planes.length != 1) return null;
//     final plane = image.planes.first;
//
//     // compose InputImage using bytes
//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       metadata: InputImageMetadata(
//         size: Size(image.width.toDouble(), image.height.toDouble()),
//         rotation: rotation, // used only in Android
//         format: format, // used only in iOS
//         bytesPerRow: plane.bytesPerRow, // used only in iOS
//       ),
//     );
//   }
// }
//
//
//
//
// Future<String> getAssetPath(String asset) async {
//   final path = await getLocalPath(asset);
//   await Directory(dirname(path)).create(recursive: true);
//   final file = File(path);
//   if (!await file.exists()) {
//     final byteData = await rootBundle.load(asset);
//     await file.writeAsBytes(byteData.buffer
//         .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//   }
//   return file.path;
// }
//
// Future<String> getLocalPath(String path) async {
//   return '${(await getApplicationSupportDirectory()).path}/$path';
// }