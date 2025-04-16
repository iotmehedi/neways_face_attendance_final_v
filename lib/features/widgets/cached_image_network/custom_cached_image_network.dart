import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/consts/app_colors.dart';
import '../../../core/utils/consts/app_sizes.dart';

class CustomCachedImageNetwork extends StatelessWidget {
  final String imageUrl;
  final double? height, weight, placeholderImageSize;
  final BoxFit? boxfit;
  final bool? errorWidget;
  final Color? placeholderImageColor;
  const CustomCachedImageNetwork(
      {super.key,
      required this.imageUrl,
      this.height,
      this.weight,
      this.boxfit,
      this.errorWidget,
      this.placeholderImageColor,
      this.placeholderImageSize});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: weight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: boxfit ?? BoxFit.fill,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn),
          ),
        ),
      ),
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => errorWidget == true
          ? const SizedBox.shrink()
          : Icon(
              Icons.person,
              size: placeholderImageSize ?? AppSizes.newSize(4),
              color: placeholderImageColor,
            ),
    );
  }
}

class CustomCachedImageNetwork1 extends StatelessWidget {
  final String imageUrl;
  final double? height, weight, placeholderImageSize;
  final BoxFit? boxfit;
  final bool? errorWidget;
  final Color? placeholderImageColor;
  const CustomCachedImageNetwork1(
      {super.key,
      required this.imageUrl,
      this.height,
      this.weight,
      this.boxfit,
      this.errorWidget,
      this.placeholderImageColor,
      this.placeholderImageSize});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: weight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: boxfit ?? BoxFit.fill,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.colorBurn),
          ),
        ),
      ),
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => errorWidget == true
          ? const SizedBox.shrink()
          : Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.height * 0.12,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: AppColorsList.black,
                  borderRadius: BorderRadius.circular(500),
                  gradient: LinearGradient(
                    colors: [
                      AppColorsList.green1,
                      AppColorsList.black
                    ], // Gradient colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                        //offset: Offset(0, 4),
                        color: AppColorsList.black, //edited
                        spreadRadius: 4,
                        blurRadius: 10 //edited
                        )
                  ]),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: AppSizes.newSize(5),
                    color: AppColorsList.white,
                  ),
                  Icon(
                    Icons.add_circle_sharp,
                    size: AppSizes.newSize(2),
                    color: AppColorsList.black,
                  ),
                ],
              ),
            ),
    );
  }
}
