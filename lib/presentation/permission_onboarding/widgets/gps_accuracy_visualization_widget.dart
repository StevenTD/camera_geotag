import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GpsAccuracyVisualizationWidget extends StatefulWidget {
  const GpsAccuracyVisualizationWidget({Key? key}) : super(key: key);

  @override
  State<GpsAccuracyVisualizationWidget> createState() =>
      _GpsAccuracyVisualizationWidgetState();
}

class _GpsAccuracyVisualizationWidgetState
    extends State<GpsAccuracyVisualizationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      height: 25.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Background map-like pattern
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.w),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue[50]!,
                  Colors.blue[100]!,
                ],
              ),
            ),
          ),

          // Grid pattern to simulate map
          CustomPaint(
            size: Size(70.w, 25.h),
            painter: MapGridPainter(),
          ),

          // GPS accuracy circles
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer accuracy circle (low accuracy)
                    Container(
                      width: 25.w * _pulseAnimation.value,
                      height: 25.w * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        color: Colors.red.withValues(alpha: 0.1),
                      ),
                    ),

                    // Middle accuracy circle (medium accuracy)
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.5),
                          width: 2,
                        ),
                        color: Colors.orange.withValues(alpha: 0.2),
                      ),
                    ),

                    // Inner accuracy circle (high accuracy)
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.green,
                          width: 2,
                        ),
                        color: Colors.green.withValues(alpha: 0.3),
                      ),
                    ),

                    // GPS pin
                    CustomIconWidget(
                      iconName: 'my_location',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 6.w,
                    ),
                  ],
                );
              },
            ),
          ),

          // Accuracy information overlay
          Positioned(
            top: 2.h,
            left: 3.w,
            right: 3.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(1.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'gps_fixed',
                        color: Colors.green,
                        size: 3.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'GPS Accuracy: ±3.2m',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Lat: 40.7128°, Lng: -74.0060°',
                    style: AppTheme.gpsCoordinateStyle(isLight: true).copyWith(
                      fontSize: 9.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Accuracy legend
          Positioned(
            bottom: 2.h,
            left: 3.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(1.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAccuracyLegendItem('High (±5m)', Colors.green),
                  SizedBox(height: 0.3.h),
                  _buildAccuracyLegendItem('Medium (±15m)', Colors.orange),
                  SizedBox(height: 0.3.h),
                  _buildAccuracyLegendItem('Low (±50m)', Colors.red),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 2.w,
          height: 2.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontSize: 8.sp,
          ),
        ),
      ],
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Draw grid lines to simulate map
    final double spacing = size.width / 8;

    // Horizontal lines
    for (int i = 0; i <= 8; i++) {
      canvas.drawLine(
        Offset(0, i * spacing),
        Offset(size.width, i * spacing),
        paint,
      );
    }

    // Vertical lines
    for (int i = 0; i <= 8; i++) {
      canvas.drawLine(
        Offset(i * spacing, 0),
        Offset(i * spacing, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
