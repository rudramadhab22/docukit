import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/output_names.dart';
import '../../../../../domain/repositories/conversion_repository.dart';
import '../../../../../domain/repositories/file_repository.dart';
import '../../../../shared/controllers/base_controller.dart';

class PdfToImagesController extends BaseController {
  PdfToImagesController({
    FileRepository? fileRepository,
    ConversionRepository? conversionRepository,
  })  : _files = fileRepository ?? Get.find<FileRepository>(),
        _conversion = conversionRepository ?? Get.find<ConversionRepository>();

  final FileRepository _files;
  final ConversionRepository _conversion;

  final outputPaths = <String>[].obs;

  Future<void> convert() async {
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
              '${p.basenameWithoutExtension(document.name)}_images',
            ),
          );

          await folder.fold(
            onFailure: (failure) async => showFailure(failure),
            onSuccess: (dirPath) async {
              final result = await _conversion.pdfToImages(
                document.path,
                dirPath,
              );
              handleResult(
                result,
                onSuccess: (paths) {
                  outputPaths.assignAll(paths);
                  Get.snackbar(
                    'DocuKit',
                    'Exported ${paths.length} page image(s).',
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
