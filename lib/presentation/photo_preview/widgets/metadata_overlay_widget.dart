import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MetadataOverlayWidget extends StatelessWidget {
  final Map<String, dynamic> photoData;
  final bool isVisible;
  final VoidCallback? onToggleVisibility;

  const MetadataOverlayWidget({
    Key? key,
    required this.photoData,
    this.isVisible = true,
    this.onToggleVisibility,
  }) : super(key: key);

  // Builds the metadata overlay widget
  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Positioned(
      bottom: 2.h,
      left: 2.w,
      right: 2.w,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMetadataRow(
              'GPS',
              '${photoData['latitude']?.toStringAsFixed(6) ?? 'N/A'}, ${photoData['longitude']?.toStringAsFixed(6) ?? 'N/A'}',
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
            ),
            SizedBox(height: 1.h),
            _buildMetadataRow(
              'Elevation',
              '${photoData['elevation']?.toStringAsFixed(1) ?? 'N/A'} m',
              CustomIconWidget(
                iconName: 'terrain',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
            ),
            SizedBox(height: 1.h),
            _buildMetadataRow(
              'Accuracy',
              '±${photoData['accuracy']?.toStringAsFixed(1) ?? 'N/A'} m',
              CustomIconWidget(
                iconName: 'gps_fixed',
                color: _getAccuracyColor(photoData['accuracy']),
                size: 16,
              ),
            ),
            SizedBox(height: 1.h),
            _buildMetadataRow(
              'Timestamp',
              photoData['timestamp'].toString() ??
                  DateTime.now().toString().split('.')[0],
              CustomIconWidget(
                iconName: 'access_time',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Creates a row showing metadata label, value, and icon
  Widget _buildMetadataRow(String label, String value, Widget icon) {
    return Row(
      children: [
        icon,
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.robotoMono(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Returns color based on GPS accuracy level
  Color _getAccuracyColor(double? accuracy) {
    if (accuracy == null) return Colors.grey;
    if (accuracy <= 5) return Colors.green;
    if (accuracy <= 10) return Colors.orange;
    return Colors.red;
  }
}
