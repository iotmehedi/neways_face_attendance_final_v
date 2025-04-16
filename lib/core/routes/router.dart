import 'package:flutter/material.dart';
import 'package:neways_face_attendance_pro/features/homepage/presentation/ui/face_auth_screen.dart';
import '../../features/authentication/sign_in/presentation/view/sign_in_page.dart';

import '../../features/profile/presentation/ui/profile_page.dart';
import '../../features/splash_screen/presentation/splash_screen.dart';

import 'route_name.dart';

class RouteGenerator {
  static pushNamed(BuildContext context, String pageName) {
    return Navigator.pushNamed(context, pageName);
  }

  static pushReplacement(BuildContext context, String pageName) {
    return Navigator.of(context).pushReplacementNamed(pageName);
  }

  static pushNamedAndRemoveAll(BuildContext context, String pageName) {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil(pageName, (Route<dynamic> route) => false);
  }

  static pushNamedWithArguments(BuildContext context, String pageName,
      {List arguments = const []}) {
    return Navigator.pushNamed(context, pageName, arguments: arguments);
  }

  static void pushAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName, // Pass the route name
      (Route<dynamic> route) => false, // Remove all previous routes
      arguments: arguments, // Optional arguments
    );
  }

  static pushNamedforAdvanceSearch(
      BuildContext context, String pageName, Function filterActionEvent) {
    return Navigator.of(context).pushNamed(pageName);
  }

  static pushReplacementNamed(BuildContext context, String pageName,
      {List arguments = const []}) {
    return Navigator.pushReplacementNamed(context, pageName,
        arguments: arguments);
  }

  static pop(BuildContext context) {
    return Navigator.of(context).pop();
  }

  static popAndPushNamed(BuildContext context, String pageName,
      {List arguments = const []}) {
    return Navigator.popAndPushNamed(context, pageName, arguments: arguments);
  }

  static popAll(BuildContext context) {
    return Navigator.of(context).popUntil((route) => false);
  }

  static popUntil(BuildContext context, String pageName) {
    return Navigator.of(context).popUntil(ModalRoute.withName(pageName));
  }

  // static gotoWebPage({
  //   required BuildContext context,
  //   String? pageTitle,
  //   required String url,
  // }) {
  //   return Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => WebPage(
  //         pageTitle: pageTitle,
  //         url: url,
  //       ),
  //     ),
  //   );
  // }
  // ================================== Routing =============================================

  static Route<dynamic>? onRouteGenerate(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashScreenRouteName:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case Routes.signinPage:
        return MaterialPageRoute(
          builder: (context) => SignInPage(),
        );

      case Routes.profile:
        return MaterialPageRoute(
          builder: (context) => ProfilePageScreen(),
        );
      case Routes.homepage:
        return MaterialPageRoute(
          builder: (context) => FaceAuthScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${routeSettings.name}'),
            ),
          ),
        );
    }
  }
}
