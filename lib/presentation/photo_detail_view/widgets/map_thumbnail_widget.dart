import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapThumbnailWidget extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final double? accuracy;
  final VoidCallback? onTap;

  const MapThumbnailWidget({
    Key? key,
    this.latitude,
    this.longitude,
    this.accuracy,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (latitude == null || longitude == null) {
      return Container(
        width: double.infinity,
        height: 20.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'location_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 32,
            ),
            SizedBox(height: 1.h),
            Text(
              'Location not available',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 20.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Static map image using Google Maps Static API
              CustomImageWidget(
                imageUrl:
                    'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=15&size=400x300&markers=color:red%7C$latitude,$longitude&key=YOUR_API_KEY',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              // Accuracy circle overlay
              if (accuracy != null)
                Positioned(
                  top: 2.h,
                  right: 2.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '±${accuracy!.toStringAsFixed(0)}m',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              // Tap indicator
              Positioned(
                bottom: 2.h,
                right: 2.w,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomIconWidget(
                    iconName: 'open_in_new',
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              // Center marker
              Center(
                child: CustomIconWidget(
                  iconName: 'location_on',
                  color: Colors.red,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
