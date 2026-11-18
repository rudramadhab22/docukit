import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/conversion_empty_state.dart';
import '../../../../shared/widgets/conversion_result_panel.dart';
import '../controllers/merge_pdf_controller.dart';

class MergePdfView extends GetView<MergePdfController> {
  const MergePdfView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Merge PDF')),
      body: Obx(() {
        if (controller.isBusy.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final output = controller.outputPath.value;
        if (output == null) {
          return ConversionEmptyState(
            icon: Icons.merge_type_outlined,
            title: 'Merge PDF files',
            message: 'Pick two or more PDFs and DocuKit will join them in order.',
            actionLabel: 'Choose PDFs',
            onAction: controller.merge,
          );
        }

        return ConversionResultPanel(
          title: 'Merge complete',
          paths: [output],
          onShare: controller.shareOutput,
          onConvertAnother: controller.reset,
        );
      }),
      floatingActionButton: Obx(() {
        if (controller.outputPath.value != null || controller.isBusy.value) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton.extended(
          onPressed: controller.merge,
          icon: const Icon(Icons.merge_type_outlined),
          label: const Text('Merge'),
        );
      }),
    );
  }
}
