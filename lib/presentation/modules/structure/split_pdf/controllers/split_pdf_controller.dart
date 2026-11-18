import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/output_names.dart';
import '../../../../../domain/repositories/file_repository.dart';
import '../../../../../domain/repositories/pdf_operations_repository.dart';
import '../../../../shared/controllers/base_controller.dart';

class SplitPdfController extends BaseController {
  SplitPdfController({
    FileRepository? fileRepository,
    PdfOperationsRepository? pdfRepository,
  })  : _files = fileRepository ?? Get.find<FileRepository>(),
        _pdf = pdfRepository ?? Get.find<PdfOperationsRepository>();

  final FileRepository _files;
  final PdfOperationsRepository _pdf;

  final outputPaths = <String>[].obs;

  Future<void> split() async {
    await runGuarded(() async {
      final pick = await _files.pickSingleDocument(extensions: const ['pdf']);

      await pick.fold(
        onFailure: (failure) async {
          if (failure is CancellationFailure) return;
          showFailure(failure);
        },
        onSuccess: (document) async {
          final folder = await _files.resolveOutputPath(
            fileName: OutputNames.stamp(
              '${p.basenameWithoutExtension(document.name)}_split',
            ),
          );

          await folder.fold(
            onFailure: (failure) async => showFailure(failure),
            onSuccess: (dirPath) async {
              final result = await _pdf.split(document.path, dirPath);
              handleResult(
                result,
                onSuccess: (paths) {
                  outputPaths.assignAll(paths);
                  Get.snackbar(
                    'DocuKit',
                    'Split into ${paths.length} PDF(s).',
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

  Future<void> shareOutputs() async {
    if (outputPaths.isEmpty) return;
    await SharePlus.instance.share(
      ShareParams(files: outputPaths.map(XFile.new).toList()),
    );
  }

  void reset() {
    outputPaths.clear();
    statusMessage.value = null;
  }
}
