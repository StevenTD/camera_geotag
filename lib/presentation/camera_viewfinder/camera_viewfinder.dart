import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/camera_controls_widget.dart';
import './widgets/focus_ring_widget.dart';
import './widgets/gps_status_widget.dart';
import './widgets/logo_overlay_widget.dart';
import './widgets/metadata_overlay_widget.dart';
import './widgets/status_bar_widget.dart';

class CameraViewfinder extends StatefulWidget {
  const CameraViewfinder({Key? key}) : super(key: key);

  @override
  State<CameraViewfinder> createState() => _CameraViewfinderState();
}

class _CameraViewfinderState extends State<CameraViewfinder>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // Camera related variables
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  String? _lastPhotoPath;

  // GPS related variables
  Position? _currentPosition;
  bool _isGpsActive = false;
  bool _isGpsLoading = false;
  double _gpsAccuracy = 0.0;
  StreamSubscription<Position>? _positionStream;

  // UI state variables
  bool _isMetadataVisible = true;
  bool _isLogoVisible = true;
  Offset? _focusPoint;
  bool _showFocusRing = false;
  int _photoCount = 0;
  int _batteryLevel = 85;

  // Logo settings
  String? _logoPath;
  double _logoOpacity = 0.8;
  double _logoSize = 15.0;
  Alignment _logoPosition = Alignment.topRight;

  // Mock data for demonstration
  final List<Map<String, dynamic>> _mockPhotos = [
    {
      "id": 1,
      "path":
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=400&fit=crop",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
      "latitude": 40.7128,
      "longitude": -74.0060,
      "elevation": 10.5,
      "accuracy": 3.2,
    },
    {
      "id": 2,
      "path":
          "https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg?w=400&h=400&fit=crop",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
      "latitude": 40.7589,
      "longitude": -73.9851,
      "elevation": 87.3,
      "accuracy": 5.1,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeApp() async {
    await _requestPermissions();
    await _initializeCamera();
    await _initializeGPS();
    _loadMockData();
  }

  Future<void> _requestPermissions() async {
    if (kIsWeb) return;

    final cameraStatus = await Permission.camera.request();
    final locationStatus = await Permission.location.request();

    if (cameraStatus.isDenied || locationStatus.isDenied) {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Permissions Required',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Camera and location permissions are required for this app to function properly.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      setState(() {
        _isCameraInitialized = false;
      });

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        debugPrint('No cameras available');
        _showCameraError('No cameras found on this device');
        return;
      }

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first,
            )
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first,
            );

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      // Apply platform-specific settings with better error handling
      if (!kIsWeb) {
        try {
          await _cameraController!.setFocusMode(FocusMode.auto);
        } catch (e) {
          debugPrint('Focus mode setting failed: $e');
        }

        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          debugPrint('Flash mode setting failed: $e');
        }
      }

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      if (mounted) {
        _showCameraError('Camera initialization failed: ${e.toString()}');
      }
    }
  }

  void _showCameraError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Camera Error',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            SizedBox(height: 2.h),
            Text(
              message,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Please check camera permissions in your device settings.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _retryCamera();
            },
            child: const Text('Retry'),
          ),
          if (!kIsWeb)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: const Text('Settings'),
            ),
        ],
      ),
    );
  }

  Future<void> _retryCamera() async {
    await _requestPermissions();
    await _initializeCamera();
  }

  Future<void> _initializeGPS() async {
    try {
      setState(() {
        _isGpsLoading = true;
      });

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isGpsLoading = false;
          _isGpsActive = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isGpsLoading = false;
            _isGpsActive = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isGpsLoading = false;
          _isGpsActive = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1,
        ),
      ).listen((Position position) {
        if (mounted) {
          setState(() {
            _currentPosition = position;
            _gpsAccuracy = position.accuracy;
            _isGpsActive = true;
            _isGpsLoading = false;
          });
        }
      });

      if (mounted) {
        setState(() {
          _currentPosition = position;
          _gpsAccuracy = position.accuracy;
          _isGpsActive = true;
          _isGpsLoading = false;
        });
      }
    } catch (e) {
      debugPrint('GPS initialization error: $e');
      if (mounted) {
        setState(() {
          _isGpsLoading = false;
          _isGpsActive = false;
        });
      }
    }
  }

  void _loadMockData() {
    setState(() {
      _photoCount = _mockPhotos.length;
      _lastPhotoPath =
          _mockPhotos.isNotEmpty ? _mockPhotos.first['path'] : null;
      _logoPath =
          "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=200&h=200&fit=crop";
    });
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isCapturing) {
      return;
    }

    try {
      setState(() {
        _isCapturing = true;
      });

      HapticFeedback.mediumImpact();

      final XFile photo = await _cameraController!.takePicture();

      // Simulate processing time
      await Future.delayed(const Duration(milliseconds: 500));

      // Add new photo to mock data
      final newPhoto = {
        "id": _mockPhotos.length + 1,
        "path": photo.path,
        "timestamp": DateTime.now(),
        "latitude": _currentPosition?.latitude,
        "longitude": _currentPosition?.longitude,
        "elevation": _currentPosition?.altitude,
        "accuracy": _currentPosition?.accuracy,
      };

      setState(() {
        _mockPhotos.insert(0, newPhoto);
        _photoCount = _mockPhotos.length;
        _lastPhotoPath = photo.path;
        _isCapturing = false;
      });

      // Navigate to photo preview
      Navigator.pushNamed(context, '/photo-preview', arguments: newPhoto);
    } catch (e) {
      debugPrint('Photo capture error: $e');
      setState(() {
        _isCapturing = false;
      });
    }
  }

  void _onTapToFocus(TapDownDetails details) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final tapPosition = renderBox.globalToLocal(details.globalPosition);

    setState(() {
      _focusPoint = tapPosition;
      _showFocusRing = true;
    });

    try {
      final double x = tapPosition.dx / renderBox.size.width;
      final double y = tapPosition.dy / renderBox.size.height;

      _cameraController!.setFocusPoint(Offset(x, y));
      _cameraController!.setExposurePoint(Offset(x, y));
    } catch (e) {
      debugPrint('Focus error: $e');
    }
  }

  void _onFocusAnimationComplete() {
    setState(() {
      _showFocusRing = false;
      _focusPoint = null;
    });
  }

  Future<void> _refreshGPS() async {
    HapticFeedback.lightImpact();
    await _initializeGPS();
  }

  void _toggleMetadataVisibility() {
    setState(() {
      _isMetadataVisible = !_isMetadataVisible;
    });
  }

  void _navigateToGallery() {
    Navigator.pushNamed(context, '/photo-detail-view');
  }

  void _navigateToSettings() {
    Navigator.pushNamed(context, '/settings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Stack(
        children: [
          //ElevatedButton(onPressed: () {}, child: Text('data'))
          // Camera Preview with better error handling

          if (_isCameraInitialized &&
              _cameraController != null &&
              _cameraController!.value.isInitialized &&
              !_cameraController!.value.isRecordingVideo &&
              !_cameraController!.value.isStreamingImages)
            Expanded(
              child: GestureDetector(
                onTapDown: _onTapToFocus,
                onLongPress: _toggleMetadataVisibility,
                child: CameraPreview(_cameraController!),
              ),
            )
          else
            Positioned.fill(
              child: Container(
                color: Colors.green,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_cameras.isEmpty)
                        Column(
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 24.w,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'Camera Not Available',
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Please check camera permissions\nand try again',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[400]),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4.h),
                            ElevatedButton(
                              onPressed: _retryCamera,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppTheme.lightTheme.colorScheme.primary,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                              ),
                              child: Text(
                                'Retry Camera',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            SizedBox(
                              width: 12.w,
                              height: 12.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'Initializing Camera...',
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),

          // Logo Overlay
          LogoOverlayWidget(
            logoPath: _logoPath,
            opacity: _logoOpacity,
            size: _logoSize,
            position: _logoPosition,
            isVisible: _isLogoVisible,
          ),

          // Metadata Overlay
          MetadataOverlayWidget(
            latitude: _currentPosition?.latitude,
            longitude: _currentPosition?.longitude,
            elevation: _currentPosition?.altitude,
            accuracy: _currentPosition?.accuracy,
            timestamp: DateTime.now(),
            isVisible: _isMetadataVisible,
          ),

          // Focus Ring
          FocusRingWidget(
            focusPoint: _focusPoint,
            isVisible: _showFocusRing,
            onAnimationComplete: _onFocusAnimationComplete,
          ),

          // Camera Controls
          CameraControlsWidget(
            onCapturePressed: _capturePhoto,
            onGalleryPressed: _navigateToGallery,
            onSettingsPressed: _navigateToSettings,
            onGpsRefreshPressed: _refreshGPS,
            lastPhotoPath: _lastPhotoPath,
            isCapturing: _isCapturing,
          ),

          // Pull-down gesture area for quick settings
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 15.h,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity != null &&
                    details.primaryVelocity! > 300) {
                  _showQuickSettings();
                }
              },
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Quick Settings',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            SwitchListTile(
              title: const Text('Show Logo'),
              value: _isLogoVisible,
              onChanged: (value) {
                setState(() {
                  _isLogoVisible = value;
                });
                Navigator.pop(context);
              },
            ),
            SwitchListTile(
              title: const Text('Show Metadata'),
              value: _isMetadataVisible,
              onChanged: (value) {
                setState(() {
                  _isMetadataVisible = value;
                });
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
