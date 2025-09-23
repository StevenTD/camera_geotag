import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/map_thumbnail_widget.dart';
import './widgets/metadata_panel_widget.dart';
import './widgets/photo_viewer_widget.dart';

class PhotoDetailView extends StatefulWidget {
  const PhotoDetailView({Key? key}) : super(key: key);

  @override
  State<PhotoDetailView> createState() => _PhotoDetailViewState();
}

class _PhotoDetailViewState extends State<PhotoDetailView> {
  bool _isMetadataExpanded = false;
  int _currentPhotoIndex = 0;
  PageController? _pageController;

  // Mock photo data with comprehensive metadata
  final List<Map<String, dynamic>> _photoGallery = [
    {
      "id": 1,
      "imageUrl":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "latitude": 37.7749,
      "longitude": -122.4194,
      "elevation": 52.3,
      "accuracy": 3.2,
      "timestamp": "September 23, 2025 at 6:20 AM",
      "device": "iPhone 15 Pro",
      "camera": "Main Camera (48MP)",
      "fileSize": "4.2 MB",
      "resolution": "4032 x 3024",
      "title": "Construction Site Documentation",
      "description": "Foundation inspection - North corner verification"
    },
    {
      "id": 2,
      "imageUrl":
          "https://images.unsplash.com/photo-1541888946425-d81bb19240f5?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "latitude": 40.7128,
      "longitude": -74.0060,
      "elevation": 10.1,
      "accuracy": 2.8,
      "timestamp": "September 23, 2025 at 5:45 AM",
      "device": "Samsung Galaxy S24",
      "camera": "Wide Camera (50MP)",
      "fileSize": "3.8 MB",
      "resolution": "4000 x 3000",
      "title": "Property Survey Point",
      "description": "Boundary marker - Southwest property line"
    },
    {
      "id": 3,
      "imageUrl":
          "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "latitude": 34.0522,
      "longitude": -118.2437,
      "elevation": 87.5,
      "accuracy": 4.1,
      "timestamp": "September 23, 2025 at 4:30 AM",
      "device": "Google Pixel 8 Pro",
      "camera": "Main Camera (50MP)",
      "fileSize": "5.1 MB",
      "resolution": "4080 x 3072",
      "title": "Building Inspection",
      "description": "Structural assessment - East facade condition"
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPhotoIndex);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  Map<String, dynamic> get _currentPhoto => _photoGallery[_currentPhotoIndex];

  void _toggleMetadataPanel() {
    setState(() {
      _isMetadataExpanded = !_isMetadataExpanded;
    });
  }

  void _sharePhoto() {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "Sharing photo with embedded metadata...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _editPhoto() {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "Opening metadata overlay editor...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _deletePhoto() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Photo',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20.w,
                height: 15.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: _currentPhoto['imageUrl'],
                    width: 20.w,
                    height: 15.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Are you sure you want to delete this photo? This action cannot be undone.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Fluttertoast.showToast(
                  msg: "Photo deleted successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
                foregroundColor: Colors.white,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _exportPhoto() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Export Options',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'high_quality',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Original Quality with Metadata'),
                subtitle: Text('Full resolution with embedded GPS data'),
                onTap: () {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: "Exporting original quality photo...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'compress',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text('Compressed with Metadata'),
                subtitle: Text('Reduced file size, preserved GPS data'),
                onTap: () {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: "Exporting compressed photo...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _openInMaps() {
    HapticFeedback.lightImpact();
    final lat = _currentPhoto['latitude'];
    final lng = _currentPhoto['longitude'];
    if (lat != null && lng != null) {
      Fluttertoast.showToast(
        msg: "Opening location in Maps app...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Location data not available",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _onPhotoDoubleTap() {
    HapticFeedback.lightImpact();
  }

  void _onMapThumbnailTap() {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "Opening full map view...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          _currentPhoto['title'] ?? 'Photo Detail',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _sharePhoto,
            icon: CustomIconWidget(
              iconName: 'share',
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Photo viewer with swipe navigation
          PageView.builder(
            controller: _pageController,
            itemCount: _photoGallery.length,
            onPageChanged: (index) {
              setState(() {
                _currentPhotoIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return PhotoViewerWidget(
                imageUrl: _photoGallery[index]['imageUrl'],
                onDoubleTap: _onPhotoDoubleTap,
              );
            },
          ),

          // Photo counter indicator
          Positioned(
            top: 2.h,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentPhotoIndex + 1} of ${_photoGallery.length}',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Map thumbnail (when metadata is expanded)
          if (_isMetadataExpanded)
            Positioned(
              bottom: 68.h,
              left: 4.w,
              right: 4.w,
              child: MapThumbnailWidget(
                latitude: _currentPhoto['latitude'],
                longitude: _currentPhoto['longitude'],
                accuracy: _currentPhoto['accuracy'],
                onTap: _onMapThumbnailTap,
              ),
            ),

          // Metadata panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MetadataPanelWidget(
              photoData: _currentPhoto,
              isExpanded: _isMetadataExpanded,
              onToggleExpanded: _toggleMetadataPanel,
            ),
          ),

          // Action buttons (when metadata is not expanded)
          if (!_isMetadataExpanded)
            Positioned(
              bottom: 8.h,
              left: 0,
              right: 0,
              child: ActionButtonsWidget(
                onShare: _sharePhoto,
                onEdit: _editPhoto,
                onDelete: _deletePhoto,
                onExport: _exportPhoto,
                onOpenInMaps: _openInMaps,
              ),
            ),
        ],
      ),
    );
  }
}
