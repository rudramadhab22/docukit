import 'dart:io';
import 'dart:ui';

import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../core/errors/exceptions.dart';

/// Syncfusion-backed PDF structure operations (merge / split / extract).
class PdfStructureEngine {
  Future<String> merge(List<String> inputPaths, String outputPath) async {
    if (inputPaths.length < 2) {
      throw const FileException('Select at least two PDF files to merge.');
    }

    final merged = PdfDocument();
    merged.pageSettings.setMargins(0);

    try {
      for (final path in inputPaths) {
        final source = await _open(path);
        try {
          for (var i = 0; i < source.pages.count; i++) {
            _appendPage(merged, source.pages[i]);
          }
        } finally {
          source.dispose();
        }
      }

      return _save(merged, outputPath);
    } on AppException {
      merged.dispose();
      rethrow;
    } catch (_) {
      merged.dispose();
      throw const FileException('Failed to merge PDF files.');
    }
  }

  Future<List<String>> split(String inputPath, String outputDir) async {
    final source = await _open(inputPath);
    final outputs = <String>[];
    final baseName = p.basenameWithoutExtension(inputPath);

    try {
      await Directory(outputDir).create(recursive: true);

      for (var i = 0; i < source.pages.count; i++) {
        final single = PdfDocument();
        single.pageSettings.setMargins(0);
        try {
          _appendPage(single, source.pages[i]);
          final outPath = p.join(outputDir, '${baseName}_page_${i + 1}.pdf');
          outputs.add(await _save(single, outPath));
        } catch (_) {
          single.dispose();
          rethrow;
        }
      }

      if (outputs.isEmpty) {
        throw const FileException('No pages were split from the PDF.');
      }
      return outputs;
    } on AppException {
      rethrow;
    } catch (_) {
      throw const FileException('Failed to split PDF.');
    } finally {
      source.dispose();
    }
  }

  Future<String> extractPages({
    required String inputPath,
    required String outputPath,
    required List<int> pages,
  }) async {
    if (pages.isEmpty) {
      throw const FileException('Select at least one page to extract.');
    }

    final source = await _open(inputPath);
    final extracted = PdfDocument();
    extracted.pageSettings.setMargins(0);

    try {
      for (final pageNumber in pages) {
        if (pageNumber < 1 || pageNumber > source.pages.count) {
          throw FileException(
            'Page $pageNumber is outside 1–${source.pages.count}.',
          );
        }
        _appendPage(extracted, source.pages[pageNumber - 1]);
      }
      return _save(extracted, outputPath);
    } on AppException {
      extracted.dispose();
      rethrow;
    } catch (_) {
      extracted.dispose();
      throw const FileException('Failed to extract PDF pages.');
    } finally {
      source.dispose();
    }
  }

  Future<PdfDocument> _open(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw FileException('PDF not found: ${p.basename(path)}');
    }
    try {
      return PdfDocument(inputBytes: await file.readAsBytes());
    } catch (_) {
      throw FileException('Unable to open PDF: ${p.basename(path)}');
    }
  }

  void _appendPage(PdfDocument target, PdfPage sourcePage) {
    final size = sourcePage.size;
    target.pageSettings.size = size;
    final page = target.pages.add();
    page.graphics.drawPdfTemplate(
      sourcePage.createTemplate(),
      Offset.zero,
      size,
    );
  }

  Future<String> _save(PdfDocument document, String outputPath) async {
    try {
      final output = File(outputPath);
      await output.parent.create(recursive: true);
      final bytes = await document.save();
      await output.writeAsBytes(bytes, flush: true);
      return output.path;
    } finally {
      document.dispose();
    }
  }
}
