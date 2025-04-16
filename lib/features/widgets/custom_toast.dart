import 'package:flutter/material.dart';

import '../../core/helper/helper.dart';

successToast(
    {required BuildContext context, required String msg, String? title}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    elevation: 6.0,
    backgroundColor: Colors.green,
    // durationion: Duration(milliseconds: 500),
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    content: Row(
      children: [
        const Icon(
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
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                msg,
                overflow: TextOverflow.ellipsis,
                //textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
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
    duration: Duration(milliseconds: 500),
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.error,
          size: 50,
          color: Colors.white,
        ),
        const SizedBox(width: 16),
        Flexible( // Wrap the Column in Flexible
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Error",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: getWidth(context)*0.6,
                child: Text(
                  msg,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  //textDirection: TextDirection.rtl,
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}


showLoaderDialog(BuildContext context, String message){
  AlertDialog alert=AlertDialog(
    content:  Row(
      children: [
       const CircularProgressIndicator(),
        Container(margin: const EdgeInsets.only(left: 7),child:Text('$message...')),
      ],),
  );
  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}