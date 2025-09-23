import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorWidget({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalSteps, (index) {
            final isActive = index < currentStep;
            final isCurrent = index == currentStep - 1;

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isCurrent ? 4.w : 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  color: isActive || isCurrent
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1.w),
                ),
              ),
            );
          }),
        ),

        SizedBox(height: 1.h),

        // Step text
        Text(
          '$currentStep of $totalSteps',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
