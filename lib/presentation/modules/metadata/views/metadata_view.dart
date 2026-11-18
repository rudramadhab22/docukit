import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';

import '../controllers/metadata_controller.dart';
import '../widgets/metadata_entries_list.dart';

class MetadataView extends GetView<MetadataController> {
  const MetadataView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Metadata'),
        actions: [
          Obx(() {
            if (controller.pickedDocument.value == null) {
              return const SizedBox.shrink();
            }
            return IconButton(
              tooltip: 'Clear',
              onPressed: controller.clearSelection,
              icon: const Icon(Icons.close),
            );
          }),
        ],
      ),
      body: Obx(() {
        final isBusy = controller.isBusy.value;
        final metadata = controller.metadata.value;
        final preview = controller.previewController.value;

        if (isBusy && metadata == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (metadata == null) {
          return _EmptyState(onPick: controller.pickAndInspect);
        }

        return Column(
          children: [
            Expanded(
              flex: 5,
              child: preview == null
                  ? Center(
                      child: Text(
                        'Preview unavailable',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : PdfViewPinch(controller: preview),
            ),
            const Divider(height: 1),
            Expanded(
              flex: 6,
              child: MetadataEntriesList(entries: metadata.entries),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.pickAndInspect,
        icon: const Icon(Icons.picture_as_pdf_outlined),
        label: const Text('Pick PDF'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onPick});

  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 56, color: scheme.primary),
              const SizedBox(height: 16),
              Text(
                'Inspect a PDF',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pick a PDF to preview pages and view file properties, '
                'page count, and document info.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onPick,
                icon: const Icon(Icons.folder_open_outlined),
                label: const Text('Choose PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
