import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/conversion_empty_state.dart';
import '../../../../shared/widgets/conversion_result_panel.dart';
import '../controllers/images_to_pdf_controller.dart';

class ImagesToPdfView extends GetView<ImagesToPdfController> {
  const ImagesToPdfView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Images to PDF')),
      body: Obx(() {
        if (controller.isBusy.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final output = controller.outputPath.value;
        if (output == null) {
          return ConversionEmptyState(
            icon: Icons.collections_outlined,
            title: 'Combine images into PDF',
            message:
                'Pick one or more images (JPG, PNG, WEBP) to build a single PDF.',
            actionLabel: 'Choose images',
            onAction: controller.convert,
          );
        }

        return ConversionResultPanel(
          title: 'Conversion complete',
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
          onPressed: controller.convert,
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: const Text('Convert'),
        );
      }),
    );
  }
}
