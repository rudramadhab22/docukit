import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';

import '../../../../core/errors/failures.dart';
import '../../../../domain/entities/pdf_metadata.dart';
import '../../../../domain/entities/picked_document.dart';
import '../../../../domain/repositories/file_repository.dart';
import '../../../../domain/repositories/pdf_operations_repository.dart';
import '../../../shared/controllers/base_controller.dart';

class MetadataController extends BaseController {
  MetadataController({
    FileRepository? fileRepository,
    PdfOperationsRepository? pdfRepository,
  })  : _fileRepository = fileRepository ?? Get.find<FileRepository>(),
        _pdfRepository = pdfRepository ?? Get.find<PdfOperationsRepository>();

  final FileRepository _fileRepository;
  final PdfOperationsRepository _pdfRepository;

  final pickedDocument = Rxn<PickedDocument>();
  final metadata = Rxn<PdfMetadata>();
  final previewController = Rxn<PdfControllerPinch>();

  @override
  void onClose() {
    previewController.value?.dispose();
    super.onClose();
  }

  Future<void> pickAndInspect() async {
    await runGuarded(() async {
      final pickResult = await _fileRepository.pickSingleDocument(
        extensions: const ['pdf'],
      );

      await pickResult.fold(
        onFailure: (failure) async {
          if (failure is CancellationFailure) return;
          showFailure(failure);
        },
        onSuccess: (document) async {
          pickedDocument.value = document;
          await _loadMetadata(document.path);
          await _loadPreview(document.path);
        },
      );
    });
  }

  Future<void> _loadMetadata(String path) async {
    final result = await _pdfRepository.readMetadata(path);
    handleResult(
      result,
      onSuccess: (value) {
        metadata.value = value;
      },
    );
  }

  Future<void> _loadPreview(String path) async {
    previewController.value?.dispose();
    previewController.value = null;

    try {
      final controller = PdfControllerPinch(
        document: PdfDocument.openFile(path),
      );
      previewController.value = controller;
    } catch (_) {
      showFailure(
        const UnexpectedFailure('PDF preview could not be opened.'),
      );
    }
  }

  void clearSelection() {
    previewController.value?.dispose();
    previewController.value = null;
    pickedDocument.value = null;
    metadata.value = null;
    statusMessage.value = null;
  }
}
