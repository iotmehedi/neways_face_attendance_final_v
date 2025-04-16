import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../core/source/dio_client.dart';
import '../../../core/utils/consts/app_assets.dart';
import '../../../main.dart';
import '../custom_elevatedButton/custom_text.dart';

successToast(
    {required BuildContext context, required String msg, String? title}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    elevation: 6.0,
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    content: Row(
      children: [
        Icon(
          Icons.done,
          size: 50,
          color: Colors.white,
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? "Success",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                msg,
                overflow: TextOverflow.visible,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}

void errorToast({required BuildContext context, required String msg}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    elevation: 6.0,
    backgroundColor: Colors.red[400],
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    content: Row(
      children: [
        Icon(
          Icons.error,
          size: 50,
          color: Colors.white,
        ),
        const SizedBox(width: 16),
        Flexible(
          // Wrap the Column in Flexible
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Error",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                msg,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}
// void errorToast2({required BuildContext context, required String msg}) {
//   ToastContext().init(context);
//   Toast.show(msg, duration: Toast.lengthLong,backgroundColor: Colors.red,textStyle: TextStyle(color: Colors.white));
// }

showLoaderDialog(BuildContext context, String message) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        CircularProgressIndicator(backgroundColor: Colors.blue),
        Container(margin: EdgeInsets.only(left: 7), child: Text('$message...')),
      ],
    ),
  );

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showErrorDialog({required BuildContext context, required Widget widget}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
        ),
        insetPadding: EdgeInsets.all(10), // This makes the dialog take up the full width and height.
        child: widget, // Replace this with your dialog content widget.
      );
    },
  );

}

// viewPhotoZoomable(BuildContext context, String imageUrl) {
//   showDialog(
//       context: context,
//       builder: (context) => PhotoView(
//         imageProvider: CachedNetworkImageProvider((box.read("baseUrl") ?? '') +  imageUrl),
//       ));
// }


void errorToast1({required BuildContext context, required String msg,  Color? color, Color? iconColor, Color? headingTextColor, Color? valueTextColor}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    elevation: 6.0,
    backgroundColor: color ??  Colors.red[400],
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    content: Row(
      children: [
        Image.asset(AppAssets.noInternet, height: 30, width: 40,),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSimpleText(text: "Whops, No Internet Connetion ", fontWeight: FontWeight.w400,color: HexColor("437AFF")),
              Text(
                msg,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                style:  TextStyle(color: valueTextColor ?? Colors.white),
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}