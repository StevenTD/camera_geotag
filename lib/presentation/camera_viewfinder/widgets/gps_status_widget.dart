import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GpsStatusWidget extends StatelessWidget {
  final bool isGpsActive;
  final double accuracy;
  final bool isLoading;

  const GpsStatusWidget({
    Key? key,
    required this.isGpsActive,
    required this.accuracy,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            SizedBox(
              width: 4.w,
              height: 4.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            )
          else
            CustomIconWidget(
              iconName: isGpsActive ? 'gps_fixed' : 'gps_off',
              color: isGpsActive
                  ? (accuracy <= 10
                      ? Colors.green
                      : accuracy <= 50
                          ? Colors.orange
                          : Colors.red)
                  : Colors.grey,
              size: 4.w,
            ),
          SizedBox(width: 2.w),
          Text(
            isLoading
                ? 'Acquiring GPS...'
                : isGpsActive
                    ? '±${accuracy.toStringAsFixed(0)}m'
                    : 'GPS Off',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
