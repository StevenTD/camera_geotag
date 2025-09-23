import 'package:flutter/material.dart';
import '../presentation/photo_preview/photo_preview.dart';
import '../presentation/settings/settings.dart';
import '../presentation/camera_viewfinder/camera_viewfinder.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/photo_detail_view/photo_detail_view.dart';
import '../presentation/permission_onboarding/permission_onboarding.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String photoPreview = '/photo-preview';
  static const String settings = '/settings';
  static const String cameraViewfinder = '/camera-viewfinder';
  static const String splash = '/splash-screen';
  static const String photoDetailView = '/photo-detail-view';
  static const String permissionOnboarding = '/permission-onboarding';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    photoPreview: (context) => const PhotoPreview(),
    settings: (context) => const Settings(),
    cameraViewfinder: (context) => const CameraViewfinder(),
    splash: (context) => const SplashScreen(),
    photoDetailView: (context) => const PhotoDetailView(),
    permissionOnboarding: (context) => const PermissionOnboarding(),
    // TODO: Add your other routes here
  };
}
