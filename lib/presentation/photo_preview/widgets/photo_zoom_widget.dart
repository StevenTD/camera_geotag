import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoZoomWidget extends StatefulWidget {
  final String imagePath;
  final bool isNetworkImage;
  final VoidCallback? onDoubleTap;

  const PhotoZoomWidget({
    Key? key,
    required this.imagePath,
    this.isNetworkImage = false,
    this.onDoubleTap,
  }) : super(key: key);

  @override
  State<PhotoZoomWidget> createState() => _PhotoZoomWidgetState();
}

class _PhotoZoomWidgetState extends State<PhotoZoomWidget>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    Matrix4 endMatrix;
    if (_transformationController.value != Matrix4.identity()) {
      // Reset to fit screen
      endMatrix = Matrix4.identity();
    } else {
      // Zoom to 2x
      endMatrix = Matrix4.identity()..scale(2.0);
    }

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: endMatrix,
    ).animate(
        CurveTween(curve: Curves.easeInOut).animate(_animationController));

    _animationController.forward(from: 0).then((_) {
      _transformationController.value = endMatrix;
    });

    widget.onDoubleTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    print('Img: ' + widget.imagePath);
    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 0.5,
        maxScale: 4.0,
        constrained: false,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            if (_animation != null) {
              _transformationController.value = _animation!.value;
            }
            return Container(
              width: 100.w,
              height: 100.h,
              child: widget.isNetworkImage
                  ? CustomImageWidget(
                      imageUrl: widget.imagePath,
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.contain,
                    )
                  : Image.file(
                      File(widget.imagePath),
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100.w,
                          height: 100.h,
                          color: Colors.grey[900],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'broken_image',
                                color: Colors.white.withValues(alpha: 0.6),
                                size: 48,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Unable to load image',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}
