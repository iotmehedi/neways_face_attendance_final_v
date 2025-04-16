import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import '../../../core/utils/consts/app_assets.dart';
import '../../../core/utils/consts/app_colors.dart';

class CommonMethods{
  static showToast(String message, color) {
    Fluttertoast.showToast(
      msg: message,
      textColor: color,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 4,
      gravity: ToastGravity.TOP,
      backgroundColor: AppColorsList.red,
    );
  }
  static Widget notFound() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            AppAssets.noFoundImage,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(right: 22),
            child:  Text(
              "No applicant found",
              textDirection: TextDirection.ltr,
              style:  TextStyle(
                color: AppColorsList.blue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget notFoundArc({String title = "No Data found"}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            AppAssets.noFoundImage,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(right: 22),
            child: Text(
              title,
              textDirection: TextDirection.ltr,
              style:  TextStyle(
                color: AppColorsList.blue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  viewPhotoZoomable(BuildContext context, String imageUrl) {
    showDialog(
        context: context,
        builder: (context) => PhotoView(
          imageProvider: CachedNetworkImageProvider(imageUrl),
        ));
  }
}