import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_spacing.dart';
import 'package:frontend/core/theme/reader_theme.dart';

Future<void> showReaderSettingsSheet(
  BuildContext context, {
  required double fontSize,
  required Future<void> Function(double) onFontSizeChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: ReaderTheme.toolbarBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      side: BorderSide(color: ReaderTheme.borderColor),
    ),
    builder: (context) {
      var localFontSize = fontSize;

      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: ReaderTheme.borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Reading settings',
                  style: ReaderTheme.titleSerif.copyWith(fontSize: 20),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Text('Font size', style: ReaderTheme.footerLabelStyle.copyWith(fontSize: 13)),
                    const Spacer(),
                    Text(
                      '${localFontSize.round()} pt',
                      style: ReaderTheme.authorStyle,
                    ),
                  ],
                ),
                Slider(
                  value: localFontSize,
                  min: 14,
                  max: 22,
                  divisions: 8,
                  activeColor: ReaderTheme.progressFill,
                  inactiveColor: ReaderTheme.progressTrack,
                  onChanged: (value) {
                    setState(() => localFontSize = value);
                    onFontSizeChanged(value);
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('Preview', style: ReaderTheme.chapterLabelStyle),
                const SizedBox(height: AppSpacing.sm),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: ReaderTheme.canvasBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ReaderTheme.borderColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      'The true essence of a private study lies not in its size, but in the quality of thought it inspires.',
                      style: ReaderTheme.bodySerif(localFontSize),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
