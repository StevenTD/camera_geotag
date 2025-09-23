import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MetadataOverlayWidget extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final double? elevation;
  final double? accuracy;
  final DateTime timestamp;
  final bool isVisible;

  const MetadataOverlayWidget({
    Key? key,
    this.latitude,
    this.longitude,
    this.elevation,
    this.accuracy,
    required this.timestamp,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Positioned(
      bottom: 15.h,
      left: 4.w,
      right: 4.w,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMetadataRow(
              'Time',
              '${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}',
            ),
            SizedBox(height: 1.h),
            _buildMetadataRow(
              'Latitude',
              latitude != null ? '${latitude!.toStringAsFixed(6)}°' : 'N/A',
            ),
            SizedBox(height: 0.5.h),
            _buildMetadataRow(
              'Longitude',
              longitude != null ? '${longitude!.toStringAsFixed(6)}°' : 'N/A',
            ),
            SizedBox(height: 0.5.h),
            _buildMetadataRow(
              'Elevation',
              elevation != null ? '${elevation!.toStringAsFixed(1)}m' : 'N/A',
            ),
            SizedBox(height: 0.5.h),
            _buildMetadataRow(
              'Accuracy',
              accuracy != null ? '±${accuracy!.toStringAsFixed(0)}m' : 'N/A',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20.w,
          child: Text(
            '$label:',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }
}
