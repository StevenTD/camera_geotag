import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camera_preview_mockup_widget.dart';
import './widgets/gps_accuracy_visualization_widget.dart';
import './widgets/permission_card_widget.dart';
import './widgets/permission_explanation_bottom_sheet.dart';
import './widgets/progress_indicator_widget.dart';

class PermissionOnboarding extends StatefulWidget {
  const PermissionOnboarding({Key? key}) : super(key: key);

  @override
  State<PermissionOnboarding> createState() => _PermissionOnboardingState();
}

class _PermissionOnboardingState extends State<PermissionOnboarding>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int _currentPage = 0;
  final int _totalPages = 2;

  bool _cameraPermissionGranted = false;
  bool _locationPermissionGranted = false;
  bool _isRequestingPermission = false;

  final List<Map<String, dynamic>> _permissionData = [
    {
      'iconName': 'camera_alt',
      'title': 'Camera Access',
      'description':
          'Capture professional photos with embedded GPS metadata and customizable branding overlays for field documentation.',
      'useCases': [
        'Construction site progress documentation',
        'Real estate property inspection photos',
        'Insurance claim evidence collection',
        'Field survey and inspection reports',
      ],
      'permissionType': 'camera',
    },
    {
      'iconName': 'location_on',
      'title': 'Location Access',
      'description':
          'Embed precise GPS coordinates, elevation data, and accuracy measurements directly onto your photos.',
      'useCases': [
        'Accurate property boundary documentation',
        'Geological survey location marking',
        'Emergency response location verification',
        'Asset tracking and inventory management',
      ],
      'permissionType': 'location',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
    _checkExistingPermissions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _checkExistingPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final locationStatus = await Permission.locationWhenInUse.status;

    setState(() {
      _cameraPermissionGranted = cameraStatus.isGranted;
      _locationPermissionGranted = locationStatus.isGranted;
    });
  }

  Future<void> _requestPermission(String permissionType) async {
    if (_isRequestingPermission) return;

    setState(() {
      _isRequestingPermission = true;
    });

    try {
      PermissionStatus status;

      if (permissionType == 'camera') {
        status = await Permission.camera.request();
        setState(() {
          _cameraPermissionGranted = status.isGranted;
        });

        if (status.isGranted) {
          HapticFeedback.lightImpact();
          _showSuccessMessage('Camera access granted!');
        } else if (status.isPermanentlyDenied) {
          _showPermissionDeniedDialog('camera');
        }
      } else if (permissionType == 'location') {
        status = await Permission.locationWhenInUse.request();
        setState(() {
          _locationPermissionGranted = status.isGranted;
        });

        if (status.isGranted) {
          HapticFeedback.lightImpact();
          _showSuccessMessage('Location access granted!');
        } else if (status.isPermanentlyDenied) {
          _showPermissionDeniedDialog('location');
        }
      }
    } catch (e) {
      _showErrorMessage('Failed to request permission. Please try again.');
    } finally {
      setState(() {
        _isRequestingPermission = false;
      });
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showPermissionDeniedDialog(String permissionType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text('Permission Required'),
          ],
        ),
        content: Text(
          'To use GeoStamp Camera, please enable $permissionType access in your device settings.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipForNow() {
    Navigator.pushReplacementNamed(context, '/camera-viewfinder');
  }

  void _continueToApp() {
    // Show celebration micro-interaction
    HapticFeedback.mediumImpact();

    // Navigate to camera interface
    Navigator.pushReplacementNamed(context, '/camera-viewfinder');
  }

  bool get _allPermissionsGranted =>
      _cameraPermissionGranted && _locationPermissionGranted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header with progress
              Padding(
                padding: EdgeInsets.all(6.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back button (only show if not on first page)
                        _currentPage > 0
                            ? GestureDetector(
                                onTap: _previousPage,
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(2.w),
                                    border: Border.all(
                                      color: AppTheme
                                          .lightTheme.colorScheme.outline
                                          .withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'arrow_back',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    size: 5.w,
                                  ),
                                ),
                              )
                            : SizedBox(width: 9.w),

                        // Skip button
                        GestureDetector(
                          onTap: _skipForNow,
                          child: Text(
                            'Skip for Now',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Progress indicator
                    ProgressIndicatorWidget(
                      currentStep: _currentPage + 1,
                      totalSteps: _totalPages,
                    ),
                  ],
                ),
              ),

              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _totalPages,
                  itemBuilder: (context, index) {
                    final data = _permissionData[index];
                    final isGranted = data['permissionType'] == 'camera'
                        ? _cameraPermissionGranted
                        : _locationPermissionGranted;

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // Permission card
                          PermissionCardWidget(
                            iconName: data['iconName'],
                            title: data['title'],
                            description: data['description'],
                            useCases: List<String>.from(data['useCases']),
                            previewWidget: data['permissionType'] == 'camera'
                                ? const CameraPreviewMockupWidget()
                                : const GpsAccuracyVisualizationWidget(),
                          ),

                          SizedBox(height: 3.h),

                          // Why do you need this button
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: GestureDetector(
                              onTap: () =>
                                  PermissionExplanationBottomSheet.show(
                                context,
                                data['permissionType'],
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(2.w),
                                  border: Border.all(
                                    color: AppTheme
                                        .lightTheme.colorScheme.outline
                                        .withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'help_outline',
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      size: 4.w,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Why do you need this?',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 2.h),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom buttons
              Padding(
                padding: EdgeInsets.all(6.w),
                child: Column(
                  children: [
                    // Grant Permission / Continue button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isRequestingPermission
                            ? null
                            : () {
                                if (_allPermissionsGranted) {
                                  _continueToApp();
                                } else {
                                  final currentPermission =
                                      _permissionData[_currentPage]
                                          ['permissionType'];
                                  final isCurrentGranted =
                                      currentPermission == 'camera'
                                          ? _cameraPermissionGranted
                                          : _locationPermissionGranted;

                                  if (isCurrentGranted) {
                                    _nextPage();
                                  } else {
                                    _requestPermission(currentPermission);
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          backgroundColor: _allPermissionsGranted
                              ? Colors.green
                              : AppTheme.lightTheme.colorScheme.primary,
                        ),
                        child: _isRequestingPermission
                            ? SizedBox(
                                width: 5.w,
                                height: 5.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_allPermissionsGranted) ...[
                                    CustomIconWidget(
                                      iconName: 'check_circle',
                                      color: Colors.white,
                                      size: 5.w,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Continue to Camera',
                                      style: AppTheme
                                          .lightTheme.textTheme.labelLarge
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ] else ...[
                                    ...() {
                                      final currentPermission =
                                          _permissionData[_currentPage]
                                              ['permissionType'];
                                      final isCurrentGranted =
                                          currentPermission == 'camera'
                                              ? _cameraPermissionGranted
                                              : _locationPermissionGranted;

                                      if (isCurrentGranted) {
                                        return [
                                          Text(
                                            'Next',
                                            style: AppTheme
                                                .lightTheme.textTheme.labelLarge
                                                ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                          CustomIconWidget(
                                            iconName: 'arrow_forward',
                                            color: Colors.white,
                                            size: 5.w,
                                          ),
                                        ];
                                      } else {
                                        return [
                                          CustomIconWidget(
                                            iconName:
                                                currentPermission == 'camera'
                                                    ? 'camera_alt'
                                                    : 'location_on',
                                            color: Colors.white,
                                            size: 5.w,
                                          ),
                                          SizedBox(width: 2.w),
                                          Text(
                                            'Grant Permission',
                                            style: AppTheme
                                                .lightTheme.textTheme.labelLarge
                                                ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ];
                                      }
                                    }(),
                                  ],
                                ],
                              ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Permission status summary
                    if (_cameraPermissionGranted ||
                        _locationPermissionGranted) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2.w),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Permissions Granted:',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                color: Colors.green[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_cameraPermissionGranted) ...[
                                  CustomIconWidget(
                                    iconName: 'camera_alt',
                                    color: Colors.green,
                                    size: 4.w,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'Camera',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                                if (_cameraPermissionGranted &&
                                    _locationPermissionGranted) ...[
                                  SizedBox(width: 4.w),
                                  Container(
                                    width: 1.w,
                                    height: 4.w,
                                    color: Colors.green.withValues(alpha: 0.3),
                                  ),
                                  SizedBox(width: 4.w),
                                ],
                                if (_locationPermissionGranted) ...[
                                  CustomIconWidget(
                                    iconName: 'location_on',
                                    color: Colors.green,
                                    size: 4.w,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'Location',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
