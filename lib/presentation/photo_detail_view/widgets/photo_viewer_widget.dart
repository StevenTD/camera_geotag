import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_widget.dart';

class PhotoViewerWidget extends StatefulWidget {
  final String imageUrl;
  final VoidCallback? onDoubleTap;

  const PhotoViewerWidget({
    Key? key,
    required this.imageUrl,
    this.onDoubleTap,
  }) : super(key: key);

  @override
  State<PhotoViewerWidget> createState() => _PhotoViewerWidgetState();
}

class _PhotoViewerWidgetState extends State<PhotoViewerWidget>
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
    Offset position = _transformationController.toScene(
      Offset(50.w, 50.h),
    );

    if (_transformationController.value != Matrix4.identity()) {
      endMatrix = Matrix4.identity();
    } else {
      endMatrix = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          if (_animation != null) {
            _transformationController.value = _animation!.value;
          }
          return InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.5,
            maxScale: 5.0,
            constrained: false,
            child: GestureDetector(
              onDoubleTap: _onDoubleTap,
              child: Container(
                width: 100.w,
                height: 100.h,
                child: CustomImageWidget(
                  imageUrl: widget.imageUrl,
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
