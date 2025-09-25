import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LogoOverlayWidget extends StatelessWidget {
  final String logoAssetPath;
  final double opacity;
  final double size;
  final Alignment position;

  const LogoOverlayWidget({
    Key? key,
    required this.logoAssetPath,
    this.opacity = 0.8,
    this.size = 15.0,
    this.position = Alignment.topRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: Image.asset(
                logoAssetPath,
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
