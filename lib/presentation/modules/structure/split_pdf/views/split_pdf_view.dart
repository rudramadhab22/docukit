import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/conversion_empty_state.dart';
import '../../../../shared/widgets/conversion_result_panel.dart';
import '../controllers/split_pdf_controller.dart';

class SplitPdfView extends GetView<SplitPdfController> {
  const SplitPdfView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Split PDF')),
      body: Obx(() {
        if (controller.isBusy.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.outputPaths.isEmpty) {
          return ConversionEmptyState(
            icon: Icons.call_split_outlined,
            title: 'Split PDF pages',
            message:
                'Pick a PDF and DocuKit will save each page as its own PDF file.',
            actionLabel: 'Choose PDF',
            onAction: controller.split,
          );
        }

        return ConversionResultPanel(
          title: 'Split complete',
          paths: controller.outputPaths.toList(growable: false),
          onShare: controller.shareOutputs,
          onConvertAnother: controller.reset,
        );
      }),
      floatingActionButton: Obx(() {
        if (controller.outputPaths.isNotEmpty || controller.isBusy.value) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton.extended(
          onPressed: controller.split,
          icon: const Icon(Icons.call_split_outlined),
          label: const Text('Split'),
        );
      }),
    );
  }
}
