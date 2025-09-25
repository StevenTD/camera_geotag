// This file contains the main camera viewfinder screen for the camera geotag app.
// It handles camera initialization, GPS tracking, photo capture, and UI overlays.

import 'dart:async'; // For async operations and timers

import 'package:camera/camera.dart'; // Flutter camera plugin for camera functionality
import 'package:flutter/foundation.dart'; // For platform detection (web vs mobile)
import 'package:flutter/material.dart'; // Flutter UI framework
import 'package:flutter/services.dart'; // For haptic feedback and system services
import 'package:geolocator/geolocator.dart'; // For GPS location services
import 'package:permission_handler/permission_handler.dart'; // For requesting app permissions
import 'package:sizer/sizer.dart'; // For responsive sizing (percentage-based dimensions)

// Import app-specific files
import '../../core/app_export.dart'; // App-wide exports and utilities
import '../../theme/app_theme.dart'; // App theme definitions
// Import custom widgets used in this screen
import './widgets/camera_controls_widget.dart'; // Camera control buttons (capture, gallery, etc.)
import './widgets/focus_ring_widget.dart'; // Animated focus ring when tapping to focus
import './widgets/gps_status_widget.dart'; // GPS status indicator (not used in current build)
import './widgets/logo_overlay_widget.dart'; // Logo watermark overlay
import './widgets/metadata_overlay_widget.dart'; // GPS coordinates and metadata display
import './widgets/status_bar_widget.dart'; // Top status bar with photo count and battery

/// Main camera viewfinder widget - the primary screen showing the camera preview
/// This is a StatefulWidget because it needs to manage camera state, GPS data, and UI interactions
class CameraViewfinder extends StatefulWidget {
  /// Constructor with optional key for widget identification
  const CameraViewfinder({Key? key}) : super(key: key);

  /// Creates the state object that will manage this widget's lifecycle and state
  @override
  State<CameraViewfinder> createState() => _CameraViewfinderState();
}

/// State class for CameraViewfinder widget
/// Manages all the state and lifecycle of the camera viewfinder screen
/// Uses WidgetsBindingObserver to handle app lifecycle changes (pause/resume)
/// Uses TickerProviderStateMixin for animations (focus ring)
class _CameraViewfinderState extends State<CameraViewfinder>
    with WidgetsBindingObserver, TickerProviderStateMixin {

  // ==================== CAMERA RELATED VARIABLES ====================
  /// Controls the camera hardware and preview
  /// Nullable because it might not be initialized yet
  CameraController? _cameraController;

  /// List of all available cameras on the device
  /// Populated when we call availableCameras()
  List<CameraDescription> _cameras = [];

  /// Flag to track if camera is ready to use
  /// Prevents showing camera preview before initialization
  bool _isCameraInitialized = false;

  /// Flag to prevent multiple photo captures at once
  /// Set to true when capture starts, false when complete
  bool _isCapturing = false;

  /// Whether we are currently disposing the camera controller.
  /// Used to avoid rendering CameraPreview while the controller is being disposed,
  /// which can cause CameraException("Disposed CameraController").
  bool _isCameraDisposing = false;

  /// Path to the most recently captured photo
  /// Used to show thumbnail in camera controls
  String? _lastPhotoPath;

  // ==================== GPS RELATED VARIABLES ====================
  /// Current GPS position with latitude, longitude, altitude, accuracy
  /// Updated continuously by GPS stream
  Position? _currentPosition;

  /// Whether GPS is currently active and providing location data
  bool _isGpsActive = false;

  /// Whether GPS is currently trying to get initial position
  bool _isGpsLoading = false;

  /// Current GPS accuracy in meters (lower is better)
  double _gpsAccuracy = 0.0;

  /// Subscription to GPS position updates
  /// Must be cancelled when widget is disposed to prevent memory leaks
  StreamSubscription<Position>? _positionStream;

  // ==================== UI STATE VARIABLES ====================
  /// Whether to show GPS coordinates and metadata overlay
  bool _isMetadataVisible = true;

  /// Position where user tapped to focus (relative to screen)
  /// Used to position the focus ring animation
  Offset? _focusPoint;

  /// Whether to show the animated focus ring
  bool _showFocusRing = false;

  /// Total number of photos taken (for display in status bar)
  int _photoCount = 0;

  /// Mock battery level percentage (for demo purposes)
  int _batteryLevel = 85;

  // ==================== MOCK DATA FOR DEMONSTRATION ====================
  /// Sample photo data for testing the gallery functionality
  /// In a real app, this would come from a database or file system
  final List<Map<String, dynamic>> _mockPhotos = [
    {
      "id": 1, // Unique identifier for the photo
      "path": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=400&fit=crop", // Image URL
      "timestamp": DateTime.now().subtract(const Duration(minutes: 5)), // When photo was taken
      "latitude": 40.7128, // GPS latitude coordinate
      "longitude": -74.0060, // GPS longitude coordinate
      "elevation": 10.5, // Altitude in meters
      "accuracy": 3.2, // GPS accuracy in meters
    },
    {
      "id": 2,
      "path": "https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg?w=400&h=400&fit=crop",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
      "latitude": 40.7589,
      "longitude": -73.9851,
      "elevation": 87.3,
      "accuracy": 5.1,
    },
  ];

  /// Called when the widget is first created
  /// Sets up observers for app lifecycle changes and starts initialization
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Listen for app pause/resume events
    _initializeApp(); // Start the initialization sequence
  }

  /// Called when the widget is being removed from the widget tree
  /// Cleans up resources to prevent memory leaks
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Stop listening for lifecycle events
    // Mark disposing so build won't attempt to use the controller.
    _isCameraDisposing = true;
    try {
      _cameraController?.dispose(); // Release camera resources
    } catch (e) {
      debugPrint('Error disposing camera controller in dispose(): $e');
    }
    _cameraController = null;
    _positionStream?.cancel(); // Stop GPS updates
    super.dispose();
  }

  /// Handles app lifecycle changes (pause, resume, etc.)
  /// Ensures camera is properly managed when app goes to background/foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return; // No camera to manage
    }

    if (state == AppLifecycleState.inactive) {
      // Clear the controller reference first so the build method won't try
      // to use a controller that is about to be disposed. Then dispose it.
      final CameraController? ctrlToDispose = cameraController;

      if (mounted) {
        setState(() {
          _cameraController = null;
          _isCameraInitialized = false;
        });
      }

      if (ctrlToDispose != null) {
        try {
          // Dispose asynchronously; we don't await here because this
          // lifecycle callback cannot be async. The reference has already
          // been cleared above so build won't see the disposed controller.
          ctrlToDispose.dispose();
        } catch (e) {
          debugPrint('Error disposing camera controller on inactive: $e');
        }
      }
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize camera when app resumes
      _initializeCamera();
    }
  }

  /// Main initialization method that sets up all app components
  /// Called once when the widget is first created
  Future<void> _initializeApp() async {
    await _requestPermissions(); // Ask for camera and location permissions
    await _initializeCamera(); // Set up camera hardware
    await _initializeGPS(); // Set up GPS location services
    _loadMockData(); // Load sample data for demonstration
  }

  /// Requests camera and location permissions from the user
  /// On web platform, permissions are handled differently so we skip this
  Future<void> _requestPermissions() async {
    if (kIsWeb) return; // Web handles permissions through browser APIs

    final cameraStatus = await Permission.camera.request(); // Request camera access
    final locationStatus = await Permission.location.request(); // Request GPS access

    // If either permission is denied, show dialog to guide user to settings
    if (cameraStatus.isDenied || locationStatus.isDenied) {
      _showPermissionDialog();
    }
  }

  /// Shows a dialog explaining that permissions are required
  /// Gives user option to go to app settings to enable permissions
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
            onPressed: () => Navigator.pop(context), // Close dialog
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              openAppSettings(); // Open device settings for this app
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  /// Initializes the camera hardware and sets up the camera controller
  /// This is an async operation that can take some time
  Future<void> _initializeCamera() async {
    try {
      // Mark camera as not ready while initializing
      setState(() {
        _isCameraInitialized = false;
      });

      // If there's an existing controller, dispose it first to ensure we
      // don't hold a reference to a disposed controller later.
      if (_cameraController != null) {
        _isCameraDisposing = true;
        try {
          await _cameraController!.dispose();
        } catch (e) {
          debugPrint('Error disposing previous camera controller: $e');
        }
        _cameraController = null;
        _isCameraDisposing = false;
      }

      // Get list of all available cameras on the device
      _cameras = await availableCameras();

      // Check if any cameras were found
      if (_cameras.isEmpty) {
        debugPrint('No cameras available'); // Log for debugging
        _showCameraError('No cameras found on this device'); // Show error to user
        return; // Exit early
      }

      // Choose which camera to use:
      // - On web: prefer front camera (for video calls)
      // - On mobile: prefer back camera (for photos)
      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front, // Front-facing camera
              orElse: () => _cameras.first, // Fallback to first available
            )
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back, // Back-facing camera
              orElse: () => _cameras.first, // Fallback to first available
            );

      // Create camera controller with selected camera
      _cameraController = CameraController(
        camera, // The camera we selected
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high, // Quality setting
        enableAudio: false, // We don't need audio for photos
      );

      // Initialize the camera controller (this takes time)
      await _cameraController!.initialize();

      // Apply additional camera settings (only on mobile, not web)
      if (!kIsWeb) {
        try {
          // Set focus to automatic
          await _cameraController!.setFocusMode(FocusMode.auto);
        } catch (e) {
          debugPrint('Focus mode setting failed: $e'); // Log but don't crash
        }

        try {
          // Set flash to automatic
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          debugPrint('Flash mode setting failed: $e'); // Log but don't crash
        }
      }

      // Update UI to show camera is ready
      if (mounted) { // Check if widget is still in the tree
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e'); // Log the error
      if (mounted) {
        _showCameraError('Camera initialization failed: ${e.toString()}'); // Show to user
      }
    }
  }

  /// Shows an error dialog when camera initialization fails
  /// Provides options to retry or go to settings
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
              color: Colors.grey[400], // Grey color to indicate error
            ),
            SizedBox(height: 2.h),
            Text(
              message, // The specific error message
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Please check camera permissions in your device settings.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600], // Subtle grey text
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _retryCamera(); // Try to initialize camera again
            },
            child: const Text('Retry'),
          ),
          if (!kIsWeb) // Settings button only on mobile
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                openAppSettings(); // Open device settings
              },
              child: const Text('Settings'),
            ),
        ],
      ),
    );
  }

  /// Retries camera initialization after a failure
  /// Requests permissions again and tries to initialize camera
  Future<void> _retryCamera() async {
    await _requestPermissions(); // Re-request permissions
    await _initializeCamera(); // Try to initialize camera again
  }

  /// Initializes GPS location services and starts position tracking
  /// This sets up continuous location updates for geotagging photos
  Future<void> _initializeGPS() async {
    try {
      // Show loading state while checking GPS
      setState(() {
        _isGpsLoading = true;
      });

      // Check if location services are enabled on the device
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are disabled
        setState(() {
          _isGpsLoading = false;
          _isGpsActive = false;
        });
        return; // Exit early
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();

      // If permission denied, request it
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // User denied permission
          setState(() {
            _isGpsLoading = false;
            _isGpsActive = false;
          });
          return; // Exit early
        }
      }

      // If permission permanently denied, can't proceed
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isGpsLoading = false;
          _isGpsActive = false;
        });
        return; // Exit early
      }

      // Get initial position (one-time high accuracy reading)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high, // Best possible accuracy
      );

      // Set up continuous position updates
      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, // High accuracy for geotagging
          distanceFilter: 1, // Update when moved 1 meter
        ),
      ).listen((Position position) {
        // Update position whenever GPS sends new data
        if (mounted) { // Check if widget still exists
          setState(() {
            _currentPosition = position; // Store latest position
            _gpsAccuracy = position.accuracy; // Store accuracy
            _isGpsActive = true; // GPS is working
            _isGpsLoading = false; // No longer loading
          });
        }
      });

      // Set initial position from the one-time reading
      if (mounted) {
        setState(() {
          _currentPosition = position; // Store initial position
          _gpsAccuracy = position.accuracy; // Store initial accuracy
          _isGpsActive = true; // GPS is active
          _isGpsLoading = false; // Loading complete
        });
      }
    } catch (e) {
      debugPrint('GPS initialization error: $e'); // Log error for debugging
      if (mounted) {
        setState(() {
          _isGpsLoading = false; // Stop loading
          _isGpsActive = false; // GPS not active
        });
      }
    }
  }

  /// Loads sample photo data for demonstration purposes
  /// In a real app, this would load from a database or file system
  void _loadMockData() {
    setState(() {
      _photoCount = _mockPhotos.length; // Set total photo count
      _lastPhotoPath = _mockPhotos.isNotEmpty ? _mockPhotos.first['path'] : null; // Set thumbnail path
    });
  }

  /// Captures a photo using the camera and saves it with GPS metadata
  /// This is the main photo capture functionality of the app
  Future<void> _capturePhoto() async {
    // Safety checks before capturing
    if (_cameraController == null || // Camera not initialized
        !_cameraController!.value.isInitialized || // Camera not ready
        _isCapturing) { // Already capturing
      return; // Exit early
    }

    try {
      // Mark as capturing to prevent multiple captures
      setState(() {
        _isCapturing = true;
      });

      // Provide haptic feedback to user
      HapticFeedback.mediumImpact();

      // Take the actual photo
      final XFile photo = await _cameraController!.takePicture();

      // Simulate processing time (in real app, this might be image processing)
      await Future.delayed(const Duration(milliseconds: 500));

      // Create metadata for the new photo
      final newPhoto = {
        "id": _mockPhotos.length + 1, // Unique ID
        "path": photo.path, // File path to the photo
        "timestamp": DateTime.now(), // When photo was taken
        "latitude": _currentPosition?.latitude, // GPS latitude
        "longitude": _currentPosition?.longitude, // GPS longitude
        "elevation": _currentPosition?.altitude, // Altitude in meters
        "accuracy": _currentPosition?.accuracy, // GPS accuracy in meters
      };

      // Update UI state with new photo
      setState(() {
        _mockPhotos.insert(0, newPhoto); // Add to beginning of list
        _photoCount = _mockPhotos.length; // Update count
        _lastPhotoPath = photo.path; // Update thumbnail
        _isCapturing = false; // Allow next capture
      });

      // Navigate to photo preview screen
      Navigator.pushNamed(
        context,
        '/photo-preview', // Route name
        arguments: {
          'image_path': photo.path, // Pass photo path to preview screen
          // Add other metadata as needed
        },
      );
    } catch (e) {
      debugPrint('Photo capture error: $e'); // Log error for debugging
      setState(() {
        _isCapturing = false; // Reset capture flag on error
      });
    }
  }

  // Handles tap-to-focus on the camera preview.
  // Converts the tap position to camera coordinates and sets focus and exposure points.
  void _onTapToFocus(TapDownDetails details) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return; // Camera not ready, do nothing.
    }

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final tapPosition = renderBox.globalToLocal(details.globalPosition);

    setState(() {
      _focusPoint = tapPosition; // Position to show focus ring.
      _showFocusRing = true; // Show focus ring animation.
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

  // Called when the focus ring animation finishes.
  // Hides the focus ring and clears the focus point.
  void _onFocusAnimationComplete() {
    setState(() {
      _showFocusRing = false;
      _focusPoint = null;
    });
  }

  // Refreshes GPS data when user taps the refresh button.
  // Provides light haptic feedback and reinitializes GPS.
  Future<void> _refreshGPS() async {
    HapticFeedback.lightImpact();
    await _initializeGPS();
  }

  // Toggles the GPS metadata overlay visibility.
  // Called from quick settings or UI controls.
  void _toggleMetadataVisibility() {
    setState(() {
      _isMetadataVisible = !_isMetadataVisible;
    });
  }

  // Navigates to the photo gallery screen.
  // Shows all captured photos with metadata.
  void _navigateToGallery() {
    Navigator.pushNamed(context, '/photo-detail-view');
  }

  // Navigates to the app settings screen.
  // Allows user to configure preferences and settings.
  void _navigateToSettings() {
    Navigator.pushNamed(context, '/settings');
  }

  /// Builds the main UI for the camera viewfinder screen
  /// Uses a Stack to layer camera preview with various overlays and controls
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent background for full-screen camera
      body: SizedBox.expand( // Makes the body fill the entire screen
        child: Stack( // Stack allows layering widgets on top of each other
          children: [
            // Camera Preview (bottom layer - fills entire screen)
            SizedBox.expand( // Makes the camera preview fill the entire screen
              child: (_cameraController != null && !_isCameraDisposing && _cameraController!.value.isInitialized)
                  ? GestureDetector(
                      onTapDown: _onTapToFocus,
                      child: CameraPreview(_cameraController!), // Live camera feed
                    )
                  : Container(color: Colors.black), // Placeholder while camera initializes
            ),

            // Logo Overlay (watermark on top of camera preview)
            LogoOverlayWidget(
              logoAssetPath: 'assets/images/logo.jpg', // Static logo asset path
            ),

            // Metadata Overlay (GPS coordinates and info)
            MetadataOverlayWidget(
              latitude: _currentPosition?.latitude, // Current latitude
              longitude: _currentPosition?.longitude, // Current longitude
              elevation: _currentPosition?.altitude, // Current altitude
              accuracy: _currentPosition?.accuracy, // GPS accuracy
              timestamp: DateTime.now(), // Current time
              isVisible: _isMetadataVisible, // Whether to show metadata
            ),

            // Focus Ring (animated ring when tapping to focus)
            FocusRingWidget(
              focusPoint: _focusPoint, // Position where user tapped
              isVisible: _showFocusRing, // Whether to show animation
              onAnimationComplete: _onFocusAnimationComplete, // Callback when animation ends
            ),

            // Camera Controls (capture button, gallery, settings, etc.)
            CameraControlsWidget(
              onCapturePressed: _capturePhoto, // Function to take photo
              onGalleryPressed: _navigateToGallery, // Function to go to gallery
              onSettingsPressed: _navigateToSettings, // Function to go to settings
              onGpsRefreshPressed: _refreshGPS, // Function to refresh GPS
              lastPhotoPath: _lastPhotoPath, // Path to last captured photo
              isCapturing: _isCapturing, // Whether currently capturing
            ),

            // Pull-down gesture area for quick settings (invisible overlay)
            Positioned(
              top: 0, // Top of screen
              left: 0, // Left edge
              right: 0, // Right edge
              height: 15.h, // 15% of screen height
              child: GestureDetector(
                onVerticalDragEnd: (DragEndDetails details) {
                  // Detect fast downward swipe
                  if (details.primaryVelocity != null && details.primaryVelocity! > 300) { // Velocity threshold
                    _showQuickSettings(); // Show quick settings modal
                  }
                },
                child: Container(color: Colors.transparent), // Invisible touch area
              ),
            ),
        ],
       
        ),
      ),
    );
  }
    

    // Shows a modal bottom sheet for quick settings.
    // Allows toggling metadata visibility quickly.
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
            SizedBox(height: 4.h),
            SwitchListTile(
              title: const Text('Show Metadata'),
              value: _isMetadataVisible,
              onChanged: (value) {
                _toggleMetadataVisibility();
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}
