import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/metadata_bottom_sheet_widget.dart';
import './widgets/metadata_overlay_widget.dart';
import './widgets/photo_zoom_widget.dart';
import './widgets/preview_action_bar_widget.dart';

class PhotoPreview extends StatefulWidget {
  const PhotoPreview({Key? key}) : super(key: key);

  @override
  State<PhotoPreview> createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _isMetadataVisible = true;
  bool _isLoading = false;
  bool _showSuccessAnimation = false;

  // Mock photo data with embedded GPS metadata
  final Map<String, dynamic> _photoData = {
    "id": "photo_${DateTime.now().millisecondsSinceEpoch}",
    "image_path": "/storage/emulated/0/DCIM/GeoStamp/IMG_20250923_061947.jpg",
    "latitude": 40.748817,
    "longitude": -73.985428,
    "elevation": 10.5,
    "accuracy": 3.2,
    "timestamp": "2025-09-23 06:19:47",
    "device": "Pixel 7 Pro",
    "app_version": "GeoStamp v1.2.0",
    "file_size": "4.2",
    "logo_position": "bottom_right",
    "logo_opacity": 0.8,
    "metadata_overlay": true,
    "capture_mode": "professional",
    "weather": "Clear",
    "temperature": "22°C",
    "compass_bearing": "NE 45°",
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadPhotoData();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  void _loadPhotoData() {
    // Simulate loading photo data from arguments or storage
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _photoData.addAll(args);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleRetake() async {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/camera-viewfinder');
  }

  Future<void> _handleSave() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    try {
      // Request storage permission
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        _showErrorMessage('Storage permission required to save photos');
        return;
      }

      // Simulate photo processing and saving
      await Future.delayed(const Duration(milliseconds: 1500));

      // Save photo with embedded metadata
      await _savePhotoWithMetadata();

      // Show success animation
      setState(() => _showSuccessAnimation = true);
      HapticFeedback.heavyImpact();

      await Future.delayed(const Duration(milliseconds: 800));

      // Navigate back to camera or gallery based on user preference
      Navigator.pushReplacementNamed(context, '/camera-viewfinder');
    } catch (e) {
      _showErrorMessage('Failed to save photo. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showSuccessAnimation = false;
        });
      }
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true; // iOS handles automatically
  }

  Future<void> _savePhotoWithMetadata() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final photoDir = Directory('${directory.path}/GeoStamp');

      if (!await photoDir.exists()) {
        await photoDir.create(recursive: true);
      }

      // Simulate saving photo with embedded metadata
      final fileName = 'GeoStamp_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${photoDir.path}/$fileName';

      // In a real implementation, this would:
      // 1. Load the original image
      // 2. Draw metadata overlay using Canvas
      // 3. Embed GPS data in EXIF
      // 4. Save the processed image

      _photoData['saved_path'] = filePath;
      _photoData['saved_at'] = DateTime.now().toIso8601String();
    } catch (e) {
      throw Exception('Failed to save photo: $e');
    }
  }

  Future<void> _handleShare() async {
    HapticFeedback.lightImpact();

    try {
      // Simulate sharing functionality
      await Future.delayed(const Duration(milliseconds: 500));

      // In a real implementation, this would use share_plus package
      // to share the photo with preserved metadata

      Fluttertoast.showToast(
        msg: "Photo shared successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        textColor: Colors.white,
      );
    } catch (e) {
      _showErrorMessage('Failed to share photo');
    }
  }

  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void _toggleMetadataVisibility() {
    setState(() => _isMetadataVisible = !_isMetadataVisible);
    HapticFeedback.selectionClick();
  }

  void _showMetadataBottomSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => MetadataBottomSheetWidget(
          photoData: _photoData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Photo with zoom functionality
            GestureDetector(
              onTap: _toggleMetadataVisibility,
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity != null &&
                    details.primaryVelocity! > 300) {
                  // Swipe down to dismiss
                  Navigator.pop(context);
                } else if (details.primaryVelocity != null &&
                    details.primaryVelocity! < -300) {
                  // Swipe up to show metadata
                  _showMetadataBottomSheet();
                }
              },
              child: PhotoZoomWidget(
                imagePath: _photoData['image_path'] ?? '',
                isNetworkImage: false,
                onDoubleTap: () => HapticFeedback.lightImpact(),
              ),
            ),

            // Metadata overlay
            MetadataOverlayWidget(
              photoData: _photoData,
              isVisible: _isMetadataVisible,
              onToggleVisibility: _toggleMetadataVisibility,
            ),

            // Action bar
            PreviewActionBarWidget(
              onRetake: _handleRetake,
              onSave: _handleSave,
              onShare: _handleShare,
              isLoading: _isLoading,
            ),

            // Success animation overlay
            if (_showSuccessAnimation)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: Colors.white,
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Photo Saved!',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'With GPS metadata embedded',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // GPS accuracy warning (if poor accuracy)
            if ((_photoData['accuracy'] as double?) != null &&
                (_photoData['accuracy'] as double) > 10)
              Positioned(
                top: MediaQuery.of(context).padding.top + 10.h,
                left: 4.w,
                right: 4.w,
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'warning',
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'GPS accuracy is poor (±${(_photoData['accuracy'] as double).toStringAsFixed(1)}m). Consider retaking for better location data.',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
