import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/conversion_empty_state.dart';
import '../../../../shared/widgets/conversion_result_panel.dart';
import '../controllers/extract_pages_controller.dart';

class ExtractPagesView extends GetView<ExtractPagesController> {
  const ExtractPagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Extract Pages')),
      body: Obx(() {
        if (controller.isBusy.value && controller.selectedDocument.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final output = controller.outputPath.value;
        if (output != null) {
          return ConversionResultPanel(
            title: 'Extract complete',
            paths: [output],
            onShare: controller.shareOutput,
            onConvertAnother: controller.reset,
          );
        }

        final document = controller.selectedDocument.value;
        if (document == null) {
          return ConversionEmptyState(
            icon: Icons.content_cut_outlined,
            title: 'Extract PDF pages',
            message:
                'Pick a PDF, choose pages (for example 1,3,5-7), then extract.',
            actionLabel: 'Choose PDF',
            onAction: controller.pickPdf,
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Text(
              document.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${controller.pageCount.value ?? 0} pages',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.rangeController,
              decoration: const InputDecoration(
                labelText: 'Pages to extract',
                hintText: '1,3,5-7',
                helperText: 'Use commas and ranges. Pages are 1-based.',
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: controller.isBusy.value ? null : controller.extract,
              icon: controller.isBusy.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.content_cut_outlined),
              label: Text(
                controller.isBusy.value ? 'Extracting…' : 'Extract pages',
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: controller.pickPdf,
              icon: const Icon(Icons.folder_open_outlined),
              label: const Text('Choose another PDF'),
            ),
          ],
        );
      }),
    );
  }
}
