import 'package:flutter/material.dart';

class ConversionResultPanel extends StatelessWidget {
  const ConversionResultPanel({
    required this.title,
    required this.paths,
    required this.onShare,
    required this.onConvertAnother,
    super.key,
  });

  final String title;
  final List<String> paths;
  final VoidCallback onShare;
  final VoidCallback onConvertAnother;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${paths.length} output file${paths.length == 1 ? '' : 's'} ready.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        ...paths.map(
          (path) => Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.45,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SelectableText(path),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: onShare,
          icon: const Icon(Icons.ios_share_outlined),
          label: const Text('Share'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onConvertAnother,
          icon: const Icon(Icons.refresh),
          label: const Text('Convert another'),
        ),
      ],
    );
  }
}
