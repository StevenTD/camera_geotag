import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PermissionExplanationBottomSheet extends StatelessWidget {
  final String permissionType;
  final String title;
  final String explanation;
  final List<String> technicalReasons;
  final List<String> securityNotes;

  const PermissionExplanationBottomSheet({
    Key? key,
    required this.permissionType,
    required this.title,
    required this.explanation,
    required this.technicalReasons,
    required this.securityNotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 12.w,
              height: 1.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(0.5.w),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Title
          Row(
            children: [
              CustomIconWidget(
                iconName:
                    permissionType == 'camera' ? 'camera_alt' : 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Explanation
          Text(
            explanation,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),

          SizedBox(height: 3.h),

          // Technical reasons
          _buildSection(
            'Technical Requirements:',
            technicalReasons,
            'info',
            AppTheme.lightTheme.colorScheme.primary,
          ),

          SizedBox(height: 2.h),

          // Security notes
          _buildSection(
            'Privacy & Security:',
            securityNotes,
            'security',
            Colors.green,
          ),

          SizedBox(height: 4.h),

          // Close button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: Text(
                'Got it',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildSection(
      String title, List<String> items, String iconName, Color iconColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: iconColor,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ...items.map((item) => Padding(
              padding: EdgeInsets.only(bottom: 0.5.h, left: 6.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 1.w),
                    width: 1.w,
                    height: 1.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  static void show(BuildContext context, String permissionType) {
    final Map<String, Map<String, dynamic>> permissionData = {
      'camera': {
        'title': 'Why Camera Access?',
        'explanation':
            'GeoStamp Camera needs camera access to capture photos with embedded location metadata and professional branding overlays for field documentation.',
        'technicalReasons': [
          'Real-time camera preview with live GPS overlay display',
          'Photo capture with embedded metadata directly onto images',
          'Custom logo and branding overlay rendering during capture',
          'Professional documentation with timestamp and location data',
        ],
        'securityNotes': [
          'Photos are stored locally on your device only',
          'No images are uploaded or shared without your permission',
          'Camera access is only used when app is active',
          'You can revoke permission anytime in device settings',
        ],
      },
      'location': {
        'title': 'Why Location Access?',
        'explanation':
            'Precise GPS location data is essential for professional field documentation, providing accurate coordinates, elevation, and timestamp information.',
        'technicalReasons': [
          'Real-time GPS coordinate capture and display',
          'Elevation data retrieval for comprehensive metadata',
          'GPS accuracy measurement for documentation reliability',
          'Automatic location embedding directly onto captured photos',
        ],
        'securityNotes': [
          'Location data is embedded in photos locally only',
          'No location tracking when app is not in use',
          'GPS data is not transmitted to external servers',
          'Location access can be disabled in device settings',
        ],
      },
    };

    final data = permissionData[permissionType]!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PermissionExplanationBottomSheet(
        permissionType: permissionType,
        title: data['title'],
        explanation: data['explanation'],
        technicalReasons: List<String>.from(data['technicalReasons']),
        securityNotes: List<String>.from(data['securityNotes']),
      ),
    );
  }
}
