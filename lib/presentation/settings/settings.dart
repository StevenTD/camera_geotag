import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/about_section.dart';
import './widgets/camera_preferences_section.dart';
import './widgets/export_section.dart';
import './widgets/gps_settings_section.dart';
import './widgets/logo_customization_section.dart';
import './widgets/metadata_display_section.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  late TabController _tabController;

  // Logo customization settings
  String? _currentLogoPath;
  int _selectedPosition = 8; // Bottom right
  double _logoSize = 0.3;
  double _logoOpacity = 0.8;

  // Metadata display settings
  bool _showGpsCoordinates = true;
  bool _showTimestamp = true;
  bool _showElevation = true;
  bool _showAccuracy = true;

  // GPS settings
  double _accuracyThreshold = 10.0;
  String _coordinateFormat = 'decimal';
  int _refreshInterval = 5;

  // Camera preferences
  String _photoQuality = 'high';
  bool _autoSave = true;
  bool _galleryIntegration = true;

  // Export settings
  String _defaultFormat = 'original';
  bool _preserveMetadata = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
    _loadSettings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _currentLogoPath = prefs.getString('logo_path');
      _selectedPosition = prefs.getInt('logo_position') ?? 8;
      _logoSize = prefs.getDouble('logo_size') ?? 0.3;
      _logoOpacity = prefs.getDouble('logo_opacity') ?? 0.8;

      _showGpsCoordinates = prefs.getBool('show_gps_coordinates') ?? true;
      _showTimestamp = prefs.getBool('show_timestamp') ?? true;
      _showElevation = prefs.getBool('show_elevation') ?? true;
      _showAccuracy = prefs.getBool('show_accuracy') ?? true;

      _accuracyThreshold = prefs.getDouble('accuracy_threshold') ?? 10.0;
      _coordinateFormat = prefs.getString('coordinate_format') ?? 'decimal';
      _refreshInterval = prefs.getInt('refresh_interval') ?? 5;

      _photoQuality = prefs.getString('photo_quality') ?? 'high';
      _autoSave = prefs.getBool('auto_save') ?? true;
      _galleryIntegration = prefs.getBool('gallery_integration') ?? true;

      _defaultFormat = prefs.getString('default_format') ?? 'original';
      _preserveMetadata = prefs.getBool('preserve_metadata') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    if (_currentLogoPath != null) {
      await prefs.setString('logo_path', _currentLogoPath!);
    }
    await prefs.setInt('logo_position', _selectedPosition);
    await prefs.setDouble('logo_size', _logoSize);
    await prefs.setDouble('logo_opacity', _logoOpacity);

    await prefs.setBool('show_gps_coordinates', _showGpsCoordinates);
    await prefs.setBool('show_timestamp', _showTimestamp);
    await prefs.setBool('show_elevation', _showElevation);
    await prefs.setBool('show_accuracy', _showAccuracy);

    await prefs.setDouble('accuracy_threshold', _accuracyThreshold);
    await prefs.setString('coordinate_format', _coordinateFormat);
    await prefs.setInt('refresh_interval', _refreshInterval);

    await prefs.setString('photo_quality', _photoQuality);
    await prefs.setBool('auto_save', _autoSave);
    await prefs.setBool('gallery_integration', _galleryIntegration);

    await prefs.setString('default_format', _defaultFormat);
    await prefs.setBool('preserve_metadata', _preserveMetadata);
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Reset Settings',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetAllSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: Text(
                'Reset',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetAllSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    setState(() {
      _currentLogoPath = null;
      _selectedPosition = 8;
      _logoSize = 0.3;
      _logoOpacity = 0.8;

      _showGpsCoordinates = true;
      _showTimestamp = true;
      _showElevation = true;
      _showAccuracy = true;

      _accuracyThreshold = 10.0;
      _coordinateFormat = 'decimal';
      _refreshInterval = 5;

      _photoQuality = 'high';
      _autoSave = true;
      _galleryIntegration = true;

      _defaultFormat = 'original';
      _preserveMetadata = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All settings have been reset to defaults'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Privacy Policy',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              'GeoStamp Camera Privacy Policy\n\n'
              'Location Data: We collect GPS coordinates only when you take photos. This data is stored locally on your device and embedded in your photos.\n\n'
              'Photo Storage: All photos are stored locally on your device. We do not upload or share your photos without your explicit consent.\n\n'
              'Permissions: We request camera and location permissions to provide core functionality. These permissions can be revoked at any time in your device settings.\n\n'
              'Data Sharing: Your location data and photos are never shared with third parties unless you explicitly choose to share them.\n\n'
              'For questions about this policy, please contact support.',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            icon: CustomIconWidget(
              iconName: 'camera_alt',
              color: _tabController.index == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 24,
            ),
            text: 'Camera',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'photo_library',
              color: _tabController.index == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 24,
            ),
            text: 'Gallery',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'settings',
              color: _tabController.index == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 24,
            ),
            text: 'Settings',
          ),
        ],
        onTap: (index) {
          if (index != 2) {
            // Navigate to other screens
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/camera-viewfinder');
                break;
              case 1:
                // Navigate to gallery - placeholder for now
                break;
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: _buildTabBar(),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Simulate GPS accuracy calibration update
            await Future.delayed(Duration(seconds: 1));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('GPS accuracy calibration updated'),
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              ),
            );
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 2.h),
                LogoCustomizationSection(
                  currentLogoPath: _currentLogoPath,
                  selectedPosition: _selectedPosition,
                  logoSize: _logoSize,
                  logoOpacity: _logoOpacity,
                  onLogoChanged: (path) {
                    setState(() => _currentLogoPath = path);
                    _saveSettings();
                  },
                  onPositionChanged: (position) {
                    setState(() => _selectedPosition = position);
                    _saveSettings();
                  },
                  onSizeChanged: (size) {
                    setState(() => _logoSize = size);
                    _saveSettings();
                  },
                  onOpacityChanged: (opacity) {
                    setState(() => _logoOpacity = opacity);
                    _saveSettings();
                  },
                ),
                MetadataDisplaySection(
                  showGpsCoordinates: _showGpsCoordinates,
                  showTimestamp: _showTimestamp,
                  showElevation: _showElevation,
                  showAccuracy: _showAccuracy,
                  onGpsCoordinatesChanged: (value) {
                    setState(() => _showGpsCoordinates = value);
                    _saveSettings();
                  },
                  onTimestampChanged: (value) {
                    setState(() => _showTimestamp = value);
                    _saveSettings();
                  },
                  onElevationChanged: (value) {
                    setState(() => _showElevation = value);
                    _saveSettings();
                  },
                  onAccuracyChanged: (value) {
                    setState(() => _showAccuracy = value);
                    _saveSettings();
                  },
                ),
                GpsSettingsSection(
                  accuracyThreshold: _accuracyThreshold,
                  coordinateFormat: _coordinateFormat,
                  refreshInterval: _refreshInterval,
                  onAccuracyThresholdChanged: (value) {
                    setState(() => _accuracyThreshold = value);
                    _saveSettings();
                  },
                  onCoordinateFormatChanged: (value) {
                    setState(() => _coordinateFormat = value);
                    _saveSettings();
                  },
                  onRefreshIntervalChanged: (value) {
                    setState(() => _refreshInterval = value);
                    _saveSettings();
                  },
                ),
                CameraPreferencesSection(
                  photoQuality: _photoQuality,
                  autoSave: _autoSave,
                  galleryIntegration: _galleryIntegration,
                  onPhotoQualityChanged: (value) {
                    setState(() => _photoQuality = value);
                    _saveSettings();
                  },
                  onAutoSaveChanged: (value) {
                    setState(() => _autoSave = value);
                    _saveSettings();
                  },
                  onGalleryIntegrationChanged: (value) {
                    setState(() => _galleryIntegration = value);
                    _saveSettings();
                  },
                ),
                ExportSection(
                  defaultFormat: _defaultFormat,
                  preserveMetadata: _preserveMetadata,
                  onDefaultFormatChanged: (value) {
                    setState(() => _defaultFormat = value);
                    _saveSettings();
                  },
                  onPreserveMetadataChanged: (value) {
                    setState(() => _preserveMetadata = value);
                    _saveSettings();
                  },
                ),
                AboutSection(
                  onPrivacyPolicyTap: _showPrivacyPolicy,
                  onResetSettingsTap: _showResetConfirmationDialog,
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
