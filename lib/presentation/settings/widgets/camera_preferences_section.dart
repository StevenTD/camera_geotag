import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraPreferencesSection extends StatelessWidget {
  final String photoQuality;
  final bool autoSave;
  final bool galleryIntegration;
  final Function(String) onPhotoQualityChanged;
  final Function(bool) onAutoSaveChanged;
  final Function(bool) onGalleryIntegrationChanged;

  const CameraPreferencesSection({
    super.key,
    required this.photoQuality,
    required this.autoSave,
    required this.galleryIntegration,
    required this.onPhotoQualityChanged,
    required this.onAutoSaveChanged,
    required this.onGalleryIntegrationChanged,
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
              'Camera Preferences',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildDropdownSetting(
            title: 'Photo Quality',
            subtitle: 'Resolution and compression settings',
            iconName: 'high_quality',
            value: photoQuality,
            options: [
              {'value': 'low', 'label': 'Low (1MP) - Fast capture'},
              {'value': 'medium', 'label': 'Medium (3MP) - Balanced'},
              {'value': 'high', 'label': 'High (8MP) - Best quality'},
              {'value': 'max', 'label': 'Maximum - Device limit'},
            ],
            onChanged: onPhotoQualityChanged,
          ),
          Divider(
            height: 1,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            indent: 4.w,
            endIndent: 4.w,
          ),
          _buildToggleItem(
            title: 'Auto Save',
            subtitle: 'Automatically save photos after capture',
            iconName: 'save',
            value: autoSave,
            onChanged: onAutoSaveChanged,
          ),
          Divider(
            height: 1,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            indent: 4.w,
            endIndent: 4.w,
          ),
          _buildToggleItem(
            title: 'Gallery Integration',
            subtitle: 'Show photos in device gallery',
            iconName: 'photo_library',
            value: galleryIntegration,
            onChanged: onGalleryIntegrationChanged,
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }
}
