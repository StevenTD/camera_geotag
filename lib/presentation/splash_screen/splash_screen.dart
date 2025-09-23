import 'dart:async';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _loadingAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Initializing services...';
  bool _hasLocationPermission = false;
  bool _hasCameraPermission = false;
  bool _isCameraReady = false;
  bool _isGpsReady = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _hideSystemUI();
    _startInitialization();
  }

  void _setupAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    _logoAnimationController.forward();
    _loadingAnimationController.repeat();
  }

  void _hideSystemUI() {
    if (!kIsWeb && Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _startInitialization() async {
    try {
      // Step 1: Check and request permissions
      await _checkPermissions();

      // Step 2: Initialize camera services
      await _initializeCameraServices();

      // Step 3: Initialize GPS services
      await _initializeGpsServices();

      // Step 4: Load user preferences
      await _loadUserPreferences();

      // Step 5: Complete initialization
      await _completeInitialization();
    } catch (e) {
      _handleInitializationError(e);
    }
  }

  Future<void> _checkPermissions() async {
    setState(() {
      _initializationStatus = 'Checking permissions...';
    });

    if (kIsWeb) {
      _hasLocationPermission = true;
      _hasCameraPermission = true;
      return;
    }

    // Check location permission
    final locationStatus = await Permission.location.status;
    _hasLocationPermission = locationStatus.isGranted;

    // Check camera permission
    final cameraStatus = await Permission.camera.status;
    _hasCameraPermission = cameraStatus.isGranted;

    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _initializeCameraServices() async {
    setState(() {
      _initializationStatus = 'Initializing camera...';
    });

    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _isCameraReady = true;
      }
    } catch (e) {
      _isCameraReady = false;
    }

    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _initializeGpsServices() async {
    setState(() {
      _initializationStatus = 'Preparing GPS services...';
    });

    try {
      // Simulate GPS initialization
      await Future.delayed(const Duration(milliseconds: 1000));
      _isGpsReady = true;
    } catch (e) {
      _isGpsReady = false;
    }
  }

  Future<void> _loadUserPreferences() async {
    setState(() {
      _initializationStatus = 'Loading preferences...';
    });

    // Simulate loading user logo preferences and settings
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _completeInitialization() async {
    setState(() {
      _initializationStatus = 'Ready!';
      _isInitializing = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    _navigateToNextScreen();
  }

  void _handleInitializationError(dynamic error) {
    setState(() {
      _initializationStatus = 'Initialization failed';
      _isInitializing = false;
    });

    // Show error dialog after a brief delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      _showErrorDialog();
    });
  }

  void _navigateToNextScreen() {
    // Restore system UI before navigation
    if (!kIsWeb && Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    // Navigation logic based on permissions and initialization status
    if (!_hasLocationPermission || !_hasCameraPermission) {
      Navigator.pushReplacementNamed(context, '/permission-onboarding');
    } else if (_isCameraReady && _isGpsReady) {
      Navigator.pushReplacementNamed(context, '/camera-viewfinder');
    } else {
      Navigator.pushReplacementNamed(context, '/settings');
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Initialization Error',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Unable to initialize camera or GPS services. Please check your device settings and try again.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startInitialization();
              },
              child: Text(
                'Retry',
                style: TextStyle(color: AppTheme.lightTheme.primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/settings');
              },
              child: Text(
                'Settings',
                style: TextStyle(color: AppTheme.lightTheme.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.lightTheme.primaryColor,
              AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
              AppTheme.accentLight,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Section
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Opacity(
                          opacity: _logoFadeAnimation.value,
                          child: _buildLogo(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Loading Section
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Loading Indicator
                    AnimatedBuilder(
                      animation: _loadingAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 60.w,
                          height: 0.5.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 60.w * _loadingAnimation.value,
                              height: 0.5.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Status Text
                    Text(
                      _initializationStatus,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 1.h),

                    // Service Status Indicators
                    if (_isInitializing) _buildServiceStatusIndicators(),
                  ],
                ),
              ),

              // Version Info
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  'GeoStamp Camera v1.0.0',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'camera_alt',
            color: AppTheme.lightTheme.primaryColor,
            size: 8.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'GeoStamp',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceStatusIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatusIndicator(
          'GPS',
          _isGpsReady,
          CustomIconWidget(
            iconName: 'location_on',
            color: _isGpsReady
                ? AppTheme.successLight
                : Colors.white.withValues(alpha: 0.5),
            size: 4.w,
          ),
        ),
        SizedBox(width: 4.w),
        _buildStatusIndicator(
          'Camera',
          _isCameraReady,
          CustomIconWidget(
            iconName: 'camera_alt',
            color: _isCameraReady
                ? AppTheme.successLight
                : Colors.white.withValues(alpha: 0.5),
            size: 4.w,
          ),
        ),
        SizedBox(width: 4.w),
        _buildStatusIndicator(
          'Permissions',
          _hasLocationPermission && _hasCameraPermission,
          CustomIconWidget(
            iconName: 'security',
            color: (_hasLocationPermission && _hasCameraPermission)
                ? AppTheme.successLight
                : Colors.white.withValues(alpha: 0.5),
            size: 4.w,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(String label, bool isReady, Widget icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: isReady
                ? AppTheme.successLight.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: isReady
                  ? AppTheme.successLight
                  : Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: icon,
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 8.sp,
          ),
        ),
      ],
    );
  }
}
