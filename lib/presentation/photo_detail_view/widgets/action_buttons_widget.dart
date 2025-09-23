import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onShare;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onExport;
  final VoidCallback? onOpenInMaps;

  const ActionButtonsWidget({
    Key? key,
    this.onShare,
    this.onEdit,
    this.onDelete,
    this.onExport,
    this.onOpenInMaps,
  }) : super(key: key);

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              backgroundColor ?? AppTheme.lightTheme.colorScheme.surface,
          foregroundColor:
              foregroundColor ?? AppTheme.lightTheme.colorScheme.onSurface,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon.codePoint.toString(),
              color:
                  foregroundColor ?? AppTheme.lightTheme.colorScheme.onSurface,
              size: 20,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: foregroundColor ??
                    AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildActionButton(
                label: 'Share',
                icon: Icons.share,
                onPressed: onShare,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              SizedBox(width: 2.w),
              _buildActionButton(
                label: 'Edit',
                icon: Icons.edit,
                onPressed: onEdit,
              ),
              SizedBox(width: 2.w),
              _buildActionButton(
                label: 'Export',
                icon: Icons.download,
                onPressed: onExport,
              ),
            ],
          ),
          SizedBox(height: 2.w),
          Row(
            children: [
              _buildActionButton(
                label: 'Maps',
                icon: Icons.map,
                onPressed: onOpenInMaps,
              ),
              SizedBox(width: 2.w),
              _buildActionButton(
                label: 'Delete',
                icon: Icons.delete,
                onPressed: onDelete,
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
                foregroundColor: Colors.white,
              ),
              Expanded(child: Container()), // Empty space to balance layout
            ],
          ),
        ],
      ),
    );
  }
}
