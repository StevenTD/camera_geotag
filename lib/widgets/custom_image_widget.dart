import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  /// Optional widget to show when the image fails to load.
  /// If null, a default asset image is shown.
  final Widget? errorWidget;

  const CustomImageWidget({
    Key? key,
    required this.imageUrl,
    this.width = 60,
    this.height = 60,
    this.fit = BoxFit.cover,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null &&
        (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://'))) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        errorWidget: (context, url, error) =>
            errorWidget ??
            Image.asset(
              "assets/images/no-image.jpg",
              fit: fit,
              width: width,
              height: height,
            ),
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image(
        image: FileImage(File(imageUrl!)),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ??
            Image.asset(
              "assets/images/no-image.jpg",
              fit: fit,
              width: width,
              height: height,
            ),
      );
    } else {
      return Image.asset(
        "assets/images/no-image.jpg",
        fit: fit,
        width: width,
        height: height,
      );
    }
  }
}
