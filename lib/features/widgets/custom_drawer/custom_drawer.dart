import 'package:flutter/material.dart';
import 'package:neways_face_attendance_pro/core/utils/extensions/extensions.dart';
import '../../../core/network/configuration.dart';
import '../../../core/routes/route_name.dart';
import '../../../core/routes/router.dart';
import '../../../core/utils/consts/app_colors.dart';
import '../../../core/utils/consts/app_sizes.dart';
import '../../../main.dart';
import '../cached_image_network/custom_cached_image_network.dart';
import '../custom_elevatedButton/custom_text.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool _isSubMenuVisible = false;
  // Track submenu visibility
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 30), // Space around content
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColorsList.deepYellow, // Background color
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        20.ph,
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CustomCachedImageNetwork(
                            imageUrl:
                                "${NetworkConfiguration.imageUrl}${box.read("image")}",
                            height: AppSizes.newSize(9),
                            weight: AppSizes.newSize(9),
                            boxfit: BoxFit.fill,
                          ),
                        ),
                        20.ph,
                        CustomSimpleText(
                          text: box.read('name'),
                          fontSize: AppSizes.size16,
                          color: AppColorsList.white,
                        ),
                        // CustomSimpleText(
                        //   text: box.read('email'),
                        //   fontSize: AppSizes.size16,
                        //   color: AppColorsList.white,
                        // ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.speed),
                    title: Text("Dashboard"),
                    onTap: () {
                      RouteGenerator.pushNamedAndRemoveAll(
                          navigatorKey.currentContext!, Routes.homepage);
                    },
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: AppSizes.newSize(2),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.wallet),
                    title: Text("Wallet"),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: AppSizes.newSize(2),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      RouteGenerator.pushNamed(
                          navigatorKey.currentContext!, Routes.wallet);
                      // setState(() {
                      //   _isSubMenuVisible = !_isSubMenuVisible; // Toggle visibility
                      // });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: AppSizes.newSize(2),
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      // setState(() {
                      //   _isSubMenuVisible = !_isSubMenuVisible; // Toggle visibility
                      // });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
