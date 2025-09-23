import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MetadataDisplaySection extends StatelessWidget {
  final bool showGpsCoordinates;
  final bool showTimestamp;
  final bool showElevation;
  final bool showAccuracy;
  final Function(bool) onGpsCoordinatesChanged;
  final Function(bool) onTimestampChanged;
  final Function(bool) onElevationChanged;
  final Function(bool) onAccuracyChanged;

  const MetadataDisplaySection({
    super.key,
    required this.showGpsCoordinates,
    required this.showTimestamp,
    required this.showElevation,
    required this.showAccuracy,
    required this.onGpsCoordinatesChanged,
    required this.onTimestampChanged,
    required this.onElevationChanged,
    required this.onAccuracyChanged,
  });

  Widget _buildToggleItem({
    required String title,
    required String subtitle,
    required String iconName,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: value
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: value
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline,
          ),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            color: value
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
            size: 20,
          ),
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 1.h),
            child: Text(
              'Metadata Display',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildToggleItem(
            title: 'GPS Coordinates',
            subtitle: 'Show latitude and longitude on photos',
            iconName: 'gps_fixed',
            value: showGpsCoordinates,
            onChanged: onGpsCoordinatesChanged,
          ),
          Divider(
            height: 1,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            indent: 4.w,
            endIndent: 4.w,
          ),
          _buildToggleItem(
            title: 'Timestamp',
            subtitle: 'Show date and time on photos',
            iconName: 'access_time',
            value: showTimestamp,
            onChanged: onTimestampChanged,
          ),
          Divider(
            height: 1,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            indent: 4.w,
            endIndent: 4.w,
          ),
          _buildToggleItem(
            title: 'Elevation',
            subtitle: 'Show altitude above sea level',
            iconName: 'terrain',
            value: showElevation,
            onChanged: onElevationChanged,
          ),
          Divider(
            height: 1,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            indent: 4.w,
            endIndent: 4.w,
          ),
          _buildToggleItem(
            title: 'GPS Accuracy',
            subtitle: 'Show location accuracy in meters',
            iconName: 'my_location',
            value: showAccuracy,
            onChanged: onAccuracyChanged,
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }
}
