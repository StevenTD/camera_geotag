import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FocusRingWidget extends StatefulWidget {
  final Offset? focusPoint;
  final bool isVisible;
  final VoidCallback? onAnimationComplete;

  const FocusRingWidget({
    Key? key,
    this.focusPoint,
    this.isVisible = false,
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  State<FocusRingWidget> createState() => _FocusRingWidgetState();
}

class _FocusRingWidgetState extends State<FocusRingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    ));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(FocusRingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible || widget.focusPoint == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: widget.focusPoint!.dx - 8.w,
      top: widget.focusPoint!.dy - 8.w,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.yellow,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
