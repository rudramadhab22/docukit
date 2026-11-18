import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/output_names.dart';
import '../../../../../core/utils/page_range_parser.dart';
import '../../../../../domain/entities/picked_document.dart';
import '../../../../../domain/repositories/file_repository.dart';
import '../../../../../domain/repositories/pdf_operations_repository.dart';
import '../../../../shared/controllers/base_controller.dart';

class ExtractPagesController extends BaseController {
  ExtractPagesController({
    FileRepository? fileRepository,
    PdfOperationsRepository? pdfRepository,
  })  : _files = fileRepository ?? Get.find<FileRepository>(),
        _pdf = pdfRepository ?? Get.find<PdfOperationsRepository>();

  final FileRepository _files;
  final PdfOperationsRepository _pdf;

  final rangeController = TextEditingController();
  final selectedDocument = Rxn<PickedDocument>();
  final pageCount = RxnInt();
  final outputPath = RxnString();

  @override
  void onClose() {
    rangeController.dispose();
    super.onClose();
  }

  Future<void> pickPdf() async {
    await runGuarded(() async {
      final pick = await _files.pickSingleDocument(extensions: const ['pdf']);

      await pick.fold(
        onFailure: (failure) async {
          if (failure is CancellationFailure) return;
          showFailure(failure);
        },
        onSuccess: (document) async {
          final meta = await _pdf.readMetadata(document.path);
          await meta.fold(
            onFailure: (failure) async => showFailure(failure),
            onSuccess: (metadata) async {
              selectedDocument.value = document;
              pageCount.value = metadata.pageCount;
              outputPath.value = null;
              rangeController.text = metadata.pageCount <= 1
                  ? '1'
                  : '1-${metadata.pageCount}';
            },
          );
        },
      );
    });
  }

  Future<void> extract() async {
    final document = selectedDocument.value;
    final total = pageCount.value;
    if (document == null || total == null) {
      showFailure(const FileFailure('Pick a PDF first.'));
      return;
    }

    await runGuarded(() async {
      late final List<int> pages;
      try {
        pages = PageRangeParser.parse(
          rangeController.text,
          pageCount: total,
        );
      } on AppException catch (e) {
        showFailure(FileFailure(e.message));
        return;
      }

      final out = await _files.resolveOutputPath(
        fileName:
            '${OutputNames.stamp('${p.basenameWithoutExtension(document.name)}_extract')}.pdf',
      );

      await out.fold(
        onFailure: (failure) async => showFailure(failure),
        onSuccess: (path) async {
          final result = await _pdf.extractPages(
            inputPath: document.path,
            outputPath: path,
            pages: pages,
          );
          handleResult(
            result,
            onSuccess: (value) {
              outputPath.value = value;
              Get.snackbar(
                'DocuKit',
                'Extracted ${pages.length} page(s).',
                snackPosition: SnackPosition.BOTTOM,
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
    selectedDocument.value = null;
    pageCount.value = null;
    outputPath.value = null;
    rangeController.clear();
    statusMessage.value = null;
  }
}
