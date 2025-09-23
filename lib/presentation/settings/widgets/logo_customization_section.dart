import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LogoCustomizationSection extends StatefulWidget {
  final String? currentLogoPath;
  final Function(String?) onLogoChanged;
  final Function(int) onPositionChanged;
  final Function(double) onSizeChanged;
  final Function(double) onOpacityChanged;
  final int selectedPosition;
  final double logoSize;
  final double logoOpacity;

  const LogoCustomizationSection({
    super.key,
    this.currentLogoPath,
    required this.onLogoChanged,
    required this.onPositionChanged,
    required this.onSizeChanged,
    required this.onOpacityChanged,
    required this.selectedPosition,
    required this.logoSize,
    required this.logoOpacity,
  });

  @override
  State<LogoCustomizationSection> createState() =>
      _LogoCustomizationSectionState();
}

class _LogoCustomizationSectionState extends State<LogoCustomizationSection> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickLogo() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onLogoChanged(image.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: ${e.toString()}'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    }
  }

  Widget _buildPositionGrid() {
    final positions = [
      {'label': 'Top Left', 'icon': 'north_west'},
      {'label': 'Top Center', 'icon': 'north'},
      {'label': 'Top Right', 'icon': 'north_east'},
      {'label': 'Center Left', 'icon': 'west'},
      {'label': 'Center', 'icon': 'center_focus_strong'},
      {'label': 'Center Right', 'icon': 'east'},
      {'label': 'Bottom Left', 'icon': 'south_west'},
      {'label': 'Bottom Center', 'icon': 'south'},
      {'label': 'Bottom Right', 'icon': 'south_east'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: positions.length,
      itemBuilder: (context, index) {
        final isSelected = widget.selectedPosition == index;
        return GestureDetector(
          onTap: () => widget.onPositionChanged(index),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surface,
              border: Border.all(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: positions[index]['icon']!,
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  positions[index]['label']!,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontSize: 8.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Logo Customization',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            // Current Logo Preview
            Container(
              width: double.infinity,
              height: 12.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: widget.currentLogoPath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: widget.currentLogoPath!,
                        width: double.infinity,
                        height: 12.h,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'image',
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                          size: 32,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'No logo selected',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
            ),
            SizedBox(height: 2.h),

            // Upload Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickLogo,
                icon: CustomIconWidget(
                  iconName: 'upload',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text('Upload New Logo'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
            SizedBox(height: 3.h),

            // Position Selection
            Text(
              'Logo Position',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            _buildPositionGrid(),
            SizedBox(height: 3.h),

            // Size Slider
            Text(
              'Logo Size',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'photo_size_select_small',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 20,
                ),
                Expanded(
                  child: Slider(
                    value: widget.logoSize,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    label: '${(widget.logoSize * 100).round()}%',
                    onChanged: widget.onSizeChanged,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'photo_size_select_large',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 20,
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Opacity Slider
            Text(
              'Logo Opacity',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'opacity',
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.3),
                  size: 20,
                ),
                Expanded(
                  child: Slider(
                    value: widget.logoOpacity,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    label: '${(widget.logoOpacity * 100).round()}%',
                    onChanged: widget.onOpacityChanged,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'opacity',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
