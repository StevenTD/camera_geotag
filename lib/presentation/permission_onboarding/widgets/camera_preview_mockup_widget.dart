import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraPreviewMockupWidget extends StatelessWidget {
  const CameraPreviewMockupWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      height: 25.h,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Background pattern to simulate camera view
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.w),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[800]!,
                  Colors.grey[900]!,
                ],
              ),
            ),
          ),

          // Viewfinder grid
          CustomPaint(
            size: Size(70.w, 25.h),
            painter: ViewfinderGridPainter(),
          ),

          // Metadata overlay demonstration
          Positioned(
            top: 2.h,
            left: 3.w,
            right: 3.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(1.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: Colors.green,
                        size: 3.w,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          'GPS: 40.7128° N, 74.0060° W',
                          style: AppTheme.gpsCoordinateStyle(isLight: false)
                              .copyWith(
                            fontSize: 10.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: Colors.white70,
                        size: 3.w,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          '09/23/2025 06:19 AM',
                          style:
                              AppTheme.timestampStyle(isLight: false).copyWith(
                            fontSize: 10.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Center focus indicator
          Center(
            child: Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.8),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
          ),

          // Camera controls mockup
          Positioned(
            bottom: 2.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ViewfinderGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    // Draw grid lines
    final double horizontalSpacing = size.height / 3;
    final double verticalSpacing = size.width / 3;

    // Horizontal lines
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(0, i * horizontalSpacing),
        Offset(size.width, i * horizontalSpacing),
        paint,
      );
    }

    // Vertical lines
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(i * verticalSpacing, 0),
        Offset(i * verticalSpacing, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
