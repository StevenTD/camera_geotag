import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PreviewActionBarWidget extends StatelessWidget {
  final VoidCallback? onRetake;
  final VoidCallback? onSave;
  final VoidCallback? onShare;
  final bool isLoading;

  const PreviewActionBarWidget({
    Key? key,
    this.onRetake,
    this.onSave,
    this.onShare,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 1.h,
      left: 4.w,
      right: 4.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Retake button
          _buildActionButton(
            onPressed: isLoading ? null : onRetake,
            icon: 'refresh',
            label: 'Retake',
            backgroundColor: Colors.black.withValues(alpha: 0.6),
          ),

          // Share button (center)
          _buildActionButton(
            onPressed: isLoading ? null : onShare,
            icon: 'share',
            label: 'Share',
            backgroundColor:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.9),
          ),

          // Save button
          _buildActionButton(
            onPressed: isLoading ? null : onSave,
            icon: isLoading ? 'hourglass_empty' : 'save',
            label: isLoading ? 'Saving...' : 'Save',
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required String icon,
    required String label,
    required Color backgroundColor,
    bool isLoading = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : CustomIconWidget(
                        iconName: icon,
                        color: Colors.white,
                        size: 20,
                      ),
                SizedBox(width: 2.w),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
