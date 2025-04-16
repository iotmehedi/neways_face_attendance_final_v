import 'package:get/get.dart';
import '../../../../../core/routes/route_name.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../main.dart';
import '../../../core/app_component/app_component.dart';
import '../../authentication/sign_in/presentation/controller/signin_controller.dart';

class SplashScreenController extends GetxController {
  var signInController = locator<SigninController>();
  @override
  void onInit() {
    checkApplicationInformation();
    super.onInit();
  }

  void checkApplicationInformation() async {
    // box.erase();
    Future.delayed(const Duration(seconds: 3), () async {
      print("the value2222 ${box.read("idNumber")} ${box.read("password")}");
      if ((box.read("idNumber")?.toString().isNotEmpty ?? false) &&
          (box.read("password")?.toString().isNotEmpty ?? false)) {
        signInController.submitLoginData(navigatorKey.currentContext!,
            from: "splash");
      } else {
        RouteGenerator.pushNamedAndRemoveAll(
            navigatorKey.currentContext!, Routes.signinPage);
        box.erase();
      }
    });
  }
}
