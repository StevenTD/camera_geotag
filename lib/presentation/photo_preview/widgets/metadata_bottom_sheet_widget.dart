import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MetadataBottomSheetWidget extends StatelessWidget {
  final Map<String, dynamic> photoData;

  const MetadataBottomSheetWidget({
    Key? key,
    required this.photoData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Photo Metadata',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
              ],
            ),
          ),

          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            height: 1,
          ),

          // Metadata details
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    'GPS Coordinates',
                    '${photoData['latitude']?.toStringAsFixed(6) ?? 'N/A'}, ${photoData['longitude']?.toStringAsFixed(6) ?? 'N/A'}',
                    'location_on',
                    copyable: true,
                  ),
                  SizedBox(height: 3.h),
                  _buildDetailRow(
                    context,
                    'Elevation',
                    '${photoData['elevation']?.toStringAsFixed(1) ?? 'N/A'} meters above sea level',
                    'terrain',
                  ),
                  SizedBox(height: 3.h),
                  _buildDetailRow(
                    context,
                    'GPS Accuracy',
                    '±${photoData['accuracy']?.toStringAsFixed(1) ?? 'N/A'} meters',
                    'gps_fixed',
                    subtitle: _getAccuracyDescription(photoData['accuracy']),
                  ),
                  SizedBox(height: 3.h),
                  _buildDetailRow(
                    context,
                    'Timestamp',
                    photoData['timestamp'] ??
                        DateTime.now().toString().split('.')[0],
                    'access_time',
                    copyable: true,
                  ),
                  SizedBox(height: 3.h),
                  _buildDetailRow(
                    context,
                    'Device Information',
                    '${photoData['device'] ?? 'Unknown Device'} • ${photoData['app_version'] ?? 'GeoStamp v1.0'}',
                    'phone_android',
                  ),
                  SizedBox(height: 3.h),
                  _buildDetailRow(
                    context,
                    'File Size',
                    '${photoData['file_size'] ?? 'N/A'} MB',
                    'storage',
                  ),
                ],
              ),
            ),
          ),

          // Close button
          Padding(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String title,
    String value,
    String iconName, {
    String? subtitle,
    bool copyable = false,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontFamily: GoogleFonts.robotoMono().fontFamily,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (copyable)
            IconButton(
              onPressed: () => _copyToClipboard(context, value),
              icon: CustomIconWidget(
                iconName: 'copy',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              tooltip: 'Copy to clipboard',
            ),
        ],
      ),
    );
  }

  String _getAccuracyDescription(double? accuracy) {
    if (accuracy == null) return 'Accuracy unknown';
    if (accuracy <= 3) return 'Excellent accuracy';
    if (accuracy <= 5) return 'Good accuracy';
    if (accuracy <= 10) return 'Fair accuracy';
    if (accuracy <= 20) return 'Poor accuracy';
    return 'Very poor accuracy';
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
