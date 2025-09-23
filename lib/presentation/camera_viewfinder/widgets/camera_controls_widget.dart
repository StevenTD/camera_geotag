import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraControlsWidget extends StatelessWidget {
  final VoidCallback onCapturePressed;
  final VoidCallback onGalleryPressed;
  final VoidCallback onSettingsPressed;
  final VoidCallback onGpsRefreshPressed;
  final String? lastPhotoPath;
  final bool isCapturing;

  const CameraControlsWidget({
    Key? key,
    required this.onCapturePressed,
    required this.onGalleryPressed,
    required this.onSettingsPressed,
    required this.onGpsRefreshPressed,
    this.lastPhotoPath,
    this.isCapturing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 4.h,
      left: 0,
      right: 0,
      child: Container(
        height: 12.h,
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gallery thumbnail
            GestureDetector(
              onTap: onGalleryPressed,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: lastPhotoPath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CustomImageWidget(
                          imageUrl: lastPhotoPath!,
                          width: 12.w,
                          height: 12.w,
                          fit: BoxFit.cover,
                        ),
                      )
                    : CustomIconWidget(
                        iconName: 'photo_library',
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 6.w,
                      ),
              ),
            ),

            // Capture button
            GestureDetector(
              onTap: isCapturing ? null : onCapturePressed,
              child: Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    width: 4,
                  ),
                ),
                child: isCapturing
                    ? Center(
                        child: SizedBox(
                          width: 8.w,
                          height: 8.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ),
                      )
                    : CustomIconWidget(
                        iconName: 'camera_alt',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 8.w,
                      ),
              ),
            ),

            // Settings and GPS refresh
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onSettingsPressed,
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'settings',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: onGpsRefreshPressed,
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'refresh',
                      color: Colors.white,
                      size: 6.w,
                    ),
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
