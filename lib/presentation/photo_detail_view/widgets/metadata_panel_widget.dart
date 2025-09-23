import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MetadataPanelWidget extends StatefulWidget {
  final Map<String, dynamic> photoData;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;

  const MetadataPanelWidget({
    Key? key,
    required this.photoData,
    required this.isExpanded,
    required this.onToggleExpanded,
  }) : super(key: key);

  @override
  State<MetadataPanelWidget> createState() => _MetadataPanelWidgetState();
}

class _MetadataPanelWidgetState extends State<MetadataPanelWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isExpanded) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(MetadataPanelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildMetadataItem(String label, String value, IconData icon) {
    return GestureDetector(
      onLongPress: () => _copyToClipboard(value, label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        margin: EdgeInsets.only(bottom: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon.codePoint.toString(),
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    value,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'content_copy',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Container(
          height: widget.isExpanded ? 60.h * _slideAnimation.value : 8.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: widget.onToggleExpanded,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Column(
                    children: [
                      Container(
                        width: 10.w,
                        height: 0.5.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.outline,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'info',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Photo Details',
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName: widget.isExpanded
                                ? 'keyboard_arrow_down'
                                : 'keyboard_arrow_up',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.isExpanded)
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      children: [
                        _buildMetadataItem(
                          'GPS Coordinates',
                          '${widget.photoData['latitude']?.toStringAsFixed(6) ?? 'N/A'}, ${widget.photoData['longitude']?.toStringAsFixed(6) ?? 'N/A'}',
                          Icons.location_on,
                        ),
                        _buildMetadataItem(
                          'Timestamp',
                          widget.photoData['timestamp'] ?? 'N/A',
                          Icons.access_time,
                        ),
                        _buildMetadataItem(
                          'Elevation',
                          '${widget.photoData['elevation']?.toStringAsFixed(1) ?? 'N/A'} m',
                          Icons.terrain,
                        ),
                        _buildMetadataItem(
                          'GPS Accuracy',
                          '${widget.photoData['accuracy']?.toStringAsFixed(1) ?? 'N/A'} m',
                          Icons.gps_fixed,
                        ),
                        _buildMetadataItem(
                          'Device',
                          widget.photoData['device'] ?? 'Unknown Device',
                          Icons.phone_android,
                        ),
                        _buildMetadataItem(
                          'Camera',
                          widget.photoData['camera'] ?? 'Built-in Camera',
                          Icons.camera_alt,
                        ),
                        _buildMetadataItem(
                          'File Size',
                          widget.photoData['fileSize'] ?? 'N/A',
                          Icons.storage,
                        ),
                        _buildMetadataItem(
                          'Resolution',
                          widget.photoData['resolution'] ?? 'N/A',
                          Icons.photo_size_select_actual,
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
