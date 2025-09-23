import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatusBarWidget extends StatelessWidget {
  final int photoCount;
  final int batteryLevel;
  final bool isGpsActive;

  const StatusBarWidget({
    Key? key,
    required this.photoCount,
    required this.batteryLevel,
    required this.isGpsActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 2.h,
      left: 4.w,
      right: 4.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // GPS Status
            Row(
              children: [
                CustomIconWidget(
                  iconName: isGpsActive ? 'gps_fixed' : 'gps_off',
                  color: isGpsActive ? Colors.green : Colors.red,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  isGpsActive ? 'GPS Active' : 'GPS Off',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            // Photo Count
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'photo_camera',
                  color: Colors.white,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  '$photoCount',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            // Battery Level
            Row(
              children: [
                CustomIconWidget(
                  iconName:
                      batteryLevel > 20 ? 'battery_full' : 'battery_alert',
                  color: batteryLevel > 20 ? Colors.white : Colors.orange,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  '$batteryLevel%',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
