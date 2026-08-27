import 'package:flutter/material.dart';
import 'package:frontend/core/theme/reader_theme.dart';

class ReaderProgressFooter extends StatelessWidget {
  const ReaderProgressFooter({
    super.key,
    required this.currentLabel,
    required this.progress,
    required this.percentText,
  });

  final String currentLabel;
  final double progress;
  final String percentText;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: ReaderTheme.footerBackground,
        border: Border(top: BorderSide(color: ReaderTheme.borderColor)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reading progress', style: ReaderTheme.footerLabelStyle),
                        const SizedBox(height: 4),
                        Text(currentLabel, style: ReaderTheme.footerPageStyle),
                      ],
                    ),
                  ),
                  Text(percentText, style: ReaderTheme.footerPercentStyle),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: clampedProgress > 0 ? clampedProgress : null,
                  minHeight: 6,
                  backgroundColor: ReaderTheme.progressTrack,
                  color: ReaderTheme.progressFill,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
