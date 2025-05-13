import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';
import 'core/app_component/app_component.dart';
import 'core/routes/router.dart';
import 'core/source/session_manager.dart';
import 'core/status/status.dart';
import 'core/utils/internet_connectivity_servce/internet_connectivity_service.dart';
import 'features/homepage/data/repository/get_employee_face_repository_impl.dart';
import 'features/homepage/data/source/get_employee_face_service.dart';
import 'features/homepage/domain/repository/get_employee_face_repository.dart';
import 'features/homepage/presentation/controller/get_employee_face_controller.dart';




final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final session = SessionManager();
var internetCheck = true;
late ConnectivityService connectivityService;
final box = GetStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies

  await GetStorage.init();
  await init();
  connectivityService = ConnectivityService();

  runZonedGuarded(() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(const MyApp());
    });
  }, (error, stackTrace) {
    if (!kDebugMode) {
      // Handle production errors
    }
  });

  await initializeService();
}

Future<void> initializeService() async {
  if (box.read("token") != null) {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
      ),
    );

    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );

    await Workmanager().registerPeriodicTask(
      "notificationTask",
      "fetchNotifications",
      frequency: const Duration(minutes: 15),
    );
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Initialize dependencies in the background isolate
  await GetStorage.init();
await init();
  final controller = locator<GetEmployeeFaceController>();

  Timer.periodic(const Duration(seconds: 3), (timer) async {
    try {
      if (box.read("token") != null) {
        await controller.checkWifi();
        // await controller.attendanceBinding();

      }
    } catch (e) {
      print('Background service error: $e');
    }
  });
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await GetStorage.init();
    await init();
    final controller = locator<GetEmployeeFaceController>();
    await controller.attendanceBinding();
    return Future.value(true);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Neways Attendance',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      onGenerateRoute: RouteGenerator.onRouteGenerate,
    );
  }
}