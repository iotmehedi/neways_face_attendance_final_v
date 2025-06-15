import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'core/app_component/app_component.dart';
import 'core/routes/router.dart';
import 'core/source/session_manager.dart';
import 'core/utils/internet_connectivity_servce/internet_connectivity_service.dart';


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