import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';

class LogoOverlayWidget extends StatelessWidget {
  final String? logoPath;
  final double opacity;
  final double size;
  final Alignment position;
  final bool isVisible;

  const LogoOverlayWidget({
    Key? key,
    this.logoPath,
    this.opacity = 0.8,
    this.size = 15.0,
    this.position = Alignment.topRight,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVisible || logoPath == null) return const SizedBox.shrink();

    return Positioned.fill(
      child: Align(
        alignment: position,
        child: Container(
          margin: EdgeInsets.all(4.w),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: size.w,
              height: size.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(2.w),
              child: CustomImageWidget(
                imageUrl: logoPath!,
                width: size.w - 4.w,
                height: size.w - 4.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
