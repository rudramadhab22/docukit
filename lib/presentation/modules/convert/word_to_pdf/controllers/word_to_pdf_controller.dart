import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/output_names.dart';
import '../../../../../domain/repositories/conversion_repository.dart';
import '../../../../../domain/repositories/file_repository.dart';
import '../../../../shared/controllers/base_controller.dart';

class WordToPdfController extends BaseController {
  WordToPdfController({
    FileRepository? fileRepository,
    ConversionRepository? conversionRepository,
  })  : _files = fileRepository ?? Get.find<FileRepository>(),
        _conversion = conversionRepository ?? Get.find<ConversionRepository>();

  final FileRepository _files;
  final ConversionRepository _conversion;

  final outputPath = RxnString();

  Future<void> convert() async {
    await runGuarded(() async {
      final pick = await _files.pickSingleDocument(
        extensions: const ['docx'],
      );

      await pick.fold(
        onFailure: (failure) async {
          if (failure is CancellationFailure) return;
          showFailure(failure);
        },
        onSuccess: (document) async {
          final out = await _files.resolveOutputPath(
            fileName: '${OutputNames.stamp(p.basenameWithoutExtension(document.name))}.pdf',
          );

          await out.fold(
            onFailure: (failure) async => showFailure(failure),
            onSuccess: (path) async {
              final result = await _conversion.wordToPdf(document.path, path);
              handleResult(
                result,
                onSuccess: (value) {
                  outputPath.value = value;
                  Get.snackbar(
                    'DocuKit',
                    'Word document converted to PDF.',
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
