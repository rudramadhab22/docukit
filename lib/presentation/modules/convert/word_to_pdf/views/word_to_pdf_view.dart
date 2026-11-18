import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/conversion_empty_state.dart';
import '../../../../shared/widgets/conversion_result_panel.dart';
import '../controllers/word_to_pdf_controller.dart';

class WordToPdfView extends GetView<WordToPdfController> {
  const WordToPdfView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word to PDF')),
      body: Obx(() {
        if (controller.isBusy.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final output = controller.outputPath.value;
        if (output == null) {
          return ConversionEmptyState(
            icon: Icons.description_outlined,
            title: 'Convert DOCX to PDF',
            message:
                'Pick a Word (.docx) file and DocuKit will create a text-based PDF.',
            footnote:
                'Phase 3 extracts paragraph text from DOCX. Complex layouts may simplify.',
            actionLabel: 'Choose DOCX',
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
