import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/output_names.dart';
import '../../../../../domain/repositories/file_repository.dart';
import '../../../../../domain/repositories/pdf_operations_repository.dart';
import '../../../../shared/controllers/base_controller.dart';

class MergePdfController extends BaseController {
  MergePdfController({
    FileRepository? fileRepository,
    PdfOperationsRepository? pdfRepository,
  })  : _files = fileRepository ?? Get.find<FileRepository>(),
        _pdf = pdfRepository ?? Get.find<PdfOperationsRepository>();

  final FileRepository _files;
  final PdfOperationsRepository _pdf;

  final outputPath = RxnString();

  Future<void> merge() async {
    await runGuarded(() async {
      final pick = await _files.pickMultipleDocuments(extensions: const ['pdf']);

      await pick.fold(
        onFailure: (failure) async {
          if (failure is CancellationFailure) return;
          showFailure(failure);
        },
        onSuccess: (documents) async {
          if (documents.length < 2) {
            showFailure(
              const FileFailure('Select at least two PDF files to merge.'),
            );
            return;
          }

          final out = await _files.resolveOutputPath(
            fileName: '${OutputNames.stamp('merged')}.pdf',
          );

          await out.fold(
            onFailure: (failure) async => showFailure(failure),
            onSuccess: (path) async {
              final result = await _pdf.merge(
                documents.map((doc) => doc.path).toList(growable: false),
                path,
              );
              handleResult(
                result,
                onSuccess: (value) {
                  outputPath.value = value;
                  Get.snackbar(
                    'DocuKit',
                    'Merged ${documents.length} PDFs.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              );
            },
          );
        },
      );
    });
  }

  Future<void> shareOutput() async {
    final path = outputPath.value;
    if (path == null) return;
    await SharePlus.instance.share(ShareParams(files: [XFile(path)]));
  }

  void reset() {
    outputPath.value = null;
    statusMessage.value = null;
  }
}
