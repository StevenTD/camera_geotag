import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GpsSettingsSection extends StatelessWidget {
  final double accuracyThreshold;
  final String coordinateFormat;
  final int refreshInterval;
  final Function(double) onAccuracyThresholdChanged;
  final Function(String) onCoordinateFormatChanged;
  final Function(int) onRefreshIntervalChanged;

  const GpsSettingsSection({
    super.key,
    required this.accuracyThreshold,
    required this.coordinateFormat,
    required this.refreshInterval,
    required this.onAccuracyThresholdChanged,
    required this.onCoordinateFormatChanged,
    required this.onRefreshIntervalChanged,
  });

  Widget _buildSliderSetting({
    required String title,
    required String subtitle,
    required String iconName,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String Function(double) labelFormatter,
    required Function(double) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: labelFormatter(value),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting({
    required String title,
    required String subtitle,
    required String iconName,
    required String value,
    required List<Map<String, String>> options,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                items: options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option['value'],
                    child: Text(
                      option['label']!,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    onChanged(newValue);
                  }
                },
              ),
            ),
          ),
        ],
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
              'GPS Settings',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildSliderSetting(
            title: 'Accuracy Threshold',
            subtitle: 'Minimum GPS accuracy required for photos',
            iconName: 'gps_not_fixed',
            value: accuracyThreshold,
            min: 1.0,
            max: 50.0,
            divisions: 49,
            labelFormatter: (value) => '${value.round()}m',
            onChanged: onAccuracyThresholdChanged,
          ),
          Divider(
            height: 1,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            indent: 4.w,
            endIndent: 4.w,
          ),
          _buildDropdownSetting(
            title: 'Coordinate Format',
            subtitle: 'Display format for GPS coordinates',
            iconName: 'place',
            value: coordinateFormat,
            options: [
              {'value': 'decimal', 'label': 'Decimal Degrees (DD)'},
              {'value': 'dms', 'label': 'Degrees Minutes Seconds (DMS)'},
            ],
            onChanged: onCoordinateFormatChanged,
          ),
          Divider(
            height: 1,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            indent: 4.w,
            endIndent: 4.w,
          ),
          _buildSliderSetting(
            title: 'Refresh Interval',
            subtitle: 'How often to update GPS location',
            iconName: 'refresh',
            value: refreshInterval.toDouble(),
            min: 1.0,
            max: 30.0,
            divisions: 29,
            labelFormatter: (value) => '${value.round()}s',
            onChanged: (value) => onRefreshIntervalChanged(value.round()),
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }
}
