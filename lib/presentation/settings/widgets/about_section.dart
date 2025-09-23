import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AboutSection extends StatelessWidget {
  final VoidCallback onPrivacyPolicyTap;
  final VoidCallback onResetSettingsTap;

  const AboutSection({
    super.key,
    required this.onPrivacyPolicyTap,
    required this.onResetSettingsTap,
  });

  Widget _buildInfoItem({
    required String title,
    required String value,
    required String iconName,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
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
        value,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
      trailing: onTap != null
          ? CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
              size: 20,
            )
          : null,
      onTap: onTap,
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
              'About',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildInfoItem(
            title: 'App Version',
            value: '1.0.0 (Build 1)',
            iconName: 'info',
          ),
          Divider(
            height: 1,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            indent: 4.w,
            endIndent: 4.w,
          ),
          _buildInfoItem(
            title: 'GPS Accuracy',
            value: 'High precision mode enabled',
            iconName: 'gps_fixed',
          ),
          Divider(
            height: 1,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            indent: 4.w,
            endIndent: 4.w,
          ),
          _buildInfoItem(
            title: 'Privacy Policy',
            value: 'View our privacy policy',
            iconName: 'privacy_tip',
            onTap: onPrivacyPolicyTap,
          ),
          Divider(
            height: 1,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            indent: 4.w,
            endIndent: 4.w,
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onResetSettingsTap,
                icon: CustomIconWidget(
                  iconName: 'restore',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 20,
                ),
                label: Text(
                  'Reset All Settings',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.error,
                    width: 1.5,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
