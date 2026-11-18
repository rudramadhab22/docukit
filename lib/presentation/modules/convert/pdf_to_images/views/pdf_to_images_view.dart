import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/conversion_empty_state.dart';
import '../../../../shared/widgets/conversion_result_panel.dart';
import '../controllers/pdf_to_images_controller.dart';

class PdfToImagesView extends GetView<PdfToImagesController> {
  const PdfToImagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF to Images')),
      body: Obx(() {
        if (controller.isBusy.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.outputPaths.isEmpty) {
          return ConversionEmptyState(
            icon: Icons.image_outlined,
            title: 'Export PDF pages',
            message:
                'Pick a PDF and DocuKit will save each page as a PNG image.',
            actionLabel: 'Choose PDF',
            onAction: controller.convert,
          );
        }

        return ConversionResultPanel(
          title: 'Export complete',
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
          onPressed: controller.convert,
          icon: const Icon(Icons.collections_outlined),
          label: const Text('Export'),
        );
      }),
    );
  }
}
