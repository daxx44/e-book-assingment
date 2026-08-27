import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/routes/app_pages.dart';
import 'package:frontend/widgets/app_icon.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _entry;
  late final AnimationController _breath;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();
    _entry = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _breath = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat(reverse: true);

    _fade = CurvedAnimation(parent: _entry, curve: const Interval(0, 0.7, curve: Curves.easeOut));
    _scale = Tween<double>(begin: 0.78, end: 1).animate(
      CurvedAnimation(parent: _entry, curve: const Interval(0, 0.75, curve: Curves.easeOutBack)),
    );
    _breathScale = Tween<double>(begin: 1, end: 1.04).animate(CurvedAnimation(parent: _breath, curve: Curves.easeInOut));

    _entry.forward();
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) Get.offNamed(AppRoutes.library);
    });
  }

  @override
  void dispose() {
    _entry.dispose();
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.surfaceSoft.withValues(alpha: 0.6),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _breathScale,
                    child: const AppIcon(size: 120, borderRadius: 28, showShadow: true),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Ebook Library', style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Your personal reading space', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
