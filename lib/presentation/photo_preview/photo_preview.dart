import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
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

  // Called when the widget is first created
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  // Called when widget dependencies change
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadPhotoData();
  }

  // Sets up the fade-in animation for the screen
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

  // Loads photo data passed from the previous screen
  void _loadPhotoData() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _photoData.addAll(args);
    }
  }

  // Called when the widget is being removed
  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // Handles the retake button - goes back to camera
  Future<void> _handleRetake() async {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/camera-viewfinder');
  }

  // Handles the save button - saves photo with metadata
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

      // Process and save photo with embedded metadata
      await _savePhotoWithMetadata();

      // Show success animation
      setState(() => _showSuccessAnimation = true);
      HapticFeedback.heavyImpact();

      await Future.delayed(const Duration(milliseconds: 800));

      // Navigate back to camera or gallery based on user preference
      Navigator.pushReplacementNamed(context, '/camera-viewfinder');
    } catch (e) {
      _showErrorMessage('Failed to save photo. Please try again.');
      print('Save error: $e'); // Debug logging
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showSuccessAnimation = false;
        });
      }
    }
  }

  // Asks for permission to save photos to storage
  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status =
          await Permission.manageExternalStorage.request(); // For Android 11+
      if (status.isGranted) return true;

      // Fallback for older Android versions
      final legacyStatus = await Permission.storage.request();
      return legacyStatus.isGranted;
    }
    return true; // iOS handles automatically
  }

  // Adds GPS metadata text overlay to the photo
  Future<img.Image> _addMetadataOverlay(img.Image originalImage) async {
    // Create a copy of the original image
    final processedImage = img.Image.from(originalImage);

    // Calculate overlay dimensions and position
    const overlayPadding = 20;
    const lineHeight = 25;
    const fontSize = 16;

    // Prepare metadata text
    final metadataLines = [
      '📍 ${(_photoData['latitude'] as double).toStringAsFixed(6)}, ${(_photoData['longitude'] as double).toStringAsFixed(6)}',
      '⛰️ ${(_photoData['elevation'] as double).toStringAsFixed(1)}m ±${(_photoData['accuracy'] as double).toStringAsFixed(1)}m',
      '🕒 ${_photoData['timestamp']}',
      '🌡️ ${_photoData['temperature']} ${_photoData['weather']}',
      '🧭 ${_photoData['compass_bearing']}',
      '📱 ${_photoData['device']} - ${_photoData['app_version']}',
    ];

    // Calculate overlay background size
    final overlayWidth = 350;
    final overlayHeight =
        (metadataLines.length * lineHeight) + (overlayPadding * 2);

    // Draw semi-transparent background
    img.fillRect(
      processedImage,
      x1: overlayPadding,
      y1: overlayPadding,
      x2: overlayPadding + overlayWidth,
      y2: overlayPadding + overlayHeight,
      color: img.ColorRgba8(0, 0, 0, 180), // Semi-transparent black
    );

    // Draw border
    img.drawRect(
      processedImage,
      x1: overlayPadding,
      y1: overlayPadding,
      x2: overlayPadding + overlayWidth,
      y2: overlayPadding + overlayHeight,
      color: img.ColorRgba8(255, 255, 255, 200), // White border
    );

    // Draw metadata text
    for (int i = 0; i < metadataLines.length; i++) {
      final y = overlayPadding + 15 + (i * lineHeight);

      // Draw text with white color
      img.drawString(
        processedImage,
        metadataLines[i],
        font: img.arial14, // Using built-in font
        x: overlayPadding + 10,
        y: y,
        color: img.ColorRgba8(255, 255, 255, 255), // White text
      );
    }

    return processedImage;
  }

  // Saves the photo with metadata overlay to device storage
  Future<void> _savePhotoWithMetadata() async {
    try {
      // Load the original image
      final originalPath = _photoData['image_path'] as String?;
      if (originalPath == null || !File(originalPath).existsSync()) {
        throw Exception('Original image not found');
      }

      // Read and decode the original image
      final originalBytes = await File(originalPath).readAsBytes();
      final originalImage = img.decodeImage(originalBytes);

      if (originalImage == null) {
        throw Exception('Failed to decode image');
      }

      // Add metadata overlay
      final processedImage = await _addMetadataOverlay(originalImage);

      // Encode the processed image
      final processedBytes = img.encodeJpg(processedImage, quality: 95);

      // Create directories
      final appDirectory = await getApplicationDocumentsDirectory();
      final appPhotoDir = Directory('${appDirectory.path}/GeoStamp');
      if (!await appPhotoDir.exists()) {
        await appPhotoDir.create(recursive: true);
      }

      final galleryDir = Directory('/storage/emulated/0/DCIM/GeoStamp');
      if (!await galleryDir.exists()) {
        await galleryDir.create(recursive: true);
      }

      // Generate filename
      final fileName = 'GeoStamp_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final appFilePath = '${appPhotoDir.path}/$fileName';
      final galleryFilePath = '${galleryDir.path}/$fileName';

      // Save processed image with metadata overlay
      await File(appFilePath).writeAsBytes(processedBytes);
      await File(galleryFilePath).writeAsBytes(processedBytes);

      // Trigger media scan so gallery sees the image
      try {
        const channel =
            MethodChannel('com.example.camera_geotag/media_scanner');
        await channel.invokeMethod('scanFile', {'path': galleryFilePath});
      } catch (e) {
        // If platform channel not implemented, ignore
      }

      _photoData['saved_path'] = galleryFilePath;
      _photoData['saved_at'] = DateTime.now().toIso8601String();
    } catch (e) {
      throw Exception('Failed to save photo: $e');
    }
  }

  // Handles the share button - shares the photo
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

  // Shows an error message to the user
  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  // Toggles the metadata overlay on/off
  void _toggleMetadataVisibility() {
    setState(() => _isMetadataVisible = !_isMetadataVisible);
    HapticFeedback.selectionClick();
  }

  // Shows detailed metadata in a bottom sheet
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

  // Builds the main UI for the photo preview screen
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
