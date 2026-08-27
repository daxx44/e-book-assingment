import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/constants/about_info.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/app_typography.dart';
import 'package:frontend/core/theme/library_shelf_theme.dart';
import 'package:frontend/widgets/app_icon.dart';
import 'package:frontend/widgets/library/wooden_shelf_background.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: LibraryShelfTheme.woodDark,
        body: Stack(
          fit: StackFit.expand,
          children: [
            const WoodenShelfBackground(),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'About',
                      style: AppTypography.headline(
                        fontSize: 24,
                        color: LibraryShelfTheme.headerText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'App info & credits',
                      style: AppTypography.body(
                        fontSize: 14,
                        color: LibraryShelfTheme.headerMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const Center(
                      child: AppIcon(size: 88, borderRadius: 22, showShadow: true),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      AboutInfo.appTitle,
                      style: AppTypography.headline(
                        fontSize: 22,
                        color: LibraryShelfTheme.headerText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Version ${AboutInfo.version}',
                      style: AppTypography.body(
                        fontSize: 14,
                        color: LibraryShelfTheme.headerMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _AboutCard(
                      title: 'Designed and developed by',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AboutInfo.developerName,
                            style: AppTypography.headline(
                              fontSize: 18,
                              color: LibraryShelfTheme.headerText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AboutInfo.developerRole,
                            style: AppTypography.body(
                              fontSize: 14,
                              color: LibraryShelfTheme.headerMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _AboutCard(
                      title: 'Technologies',
                      child: Column(
                        children: AboutInfo.technologies
                            .map(
                              (tech) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.fiber_manual_record,
                                      size: 7,
                                      color: LibraryShelfTheme.navActive.withValues(alpha: 0.9),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      tech,
                                      style: AppTypography.body(
                                        fontSize: 15,
                                        color: LibraryShelfTheme.headerText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _AboutCard(
                      child: Text(
                        AboutInfo.tagline,
                        style: AppTypography.body(
                          fontSize: 14,
                          color: LibraryShelfTheme.headerMuted,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      AboutInfo.copyright,
                      style: AppTypography.label(
                        fontSize: 12,
                        color: LibraryShelfTheme.headerMuted.withValues(alpha: 0.85),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Built with Flutter · Ruby on Rails',
                      style: AppTypography.label(
                        fontSize: 12,
                        color: LibraryShelfTheme.navActive,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.black.withValues(alpha: 0.2),
        border: Border.all(color: LibraryShelfTheme.wallRecessEdge.withValues(alpha: 0.55)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: AppTypography.label(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: LibraryShelfTheme.navActive,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
