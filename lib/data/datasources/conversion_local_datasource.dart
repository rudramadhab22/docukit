import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart' as pdfx;

import '../../core/errors/exceptions.dart';
import 'docx_text_extractor.dart';

abstract class ConversionLocalDataSource {
  Future<String> wordToPdf(String inputPath, String outputPath);

  Future<List<String>> pdfToImages(String inputPath, String outputDir);

  Future<String> imagesToPdf(List<String> imagePaths, String outputPath);
}

class ConversionLocalDataSourceImpl implements ConversionLocalDataSource {
  ConversionLocalDataSourceImpl({
    DocxTextExtractor extractor = const DocxTextExtractor(),
  }) : _extractor = extractor;

  final DocxTextExtractor _extractor;

  @override
  Future<String> wordToPdf(String inputPath, String outputPath) async {
    final input = File(inputPath);
    if (!await input.exists()) {
      throw const FileException('Word document was not found.');
    }

    final extension = p.extension(inputPath).toLowerCase();
    if (extension != '.docx') {
      throw const FileException('Only .docx files are supported right now.');
    }

    try {
      final paragraphs = _extractor.extractParagraphs(await input.readAsBytes());
      final document = pw.Document();
      document.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(48),
          build: (context) => [
            for (final paragraph in paragraphs)
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Text(
                  paragraph,
                  style: const pw.TextStyle(fontSize: 12, lineSpacing: 2),
                ),
              ),
          ],
        ),
      );

      final output = File(outputPath);
      await output.parent.create(recursive: true);
      await output.writeAsBytes(await document.save(), flush: true);
      return output.path;
    } on AppException {
      rethrow;
    } catch (_) {
      throw const FileException('Failed to convert Word document to PDF.');
    }
  }

  @override
  Future<List<String>> pdfToImages(String inputPath, String outputDir) async {
    final input = File(inputPath);
    if (!await input.exists()) {
      throw const FileException('PDF file was not found.');
    }

    try {
      final directory = Directory(outputDir);
      await directory.create(recursive: true);

      final document = await pdfx.PdfDocument.openFile(inputPath);
      final outputs = <String>[];
      final baseName = p.basenameWithoutExtension(inputPath);

      try {
        for (var pageNumber = 1; pageNumber <= document.pagesCount; pageNumber++) {
          final page = await document.getPage(pageNumber);
          try {
            final pageImage = await page.render(
              width: page.width * 2,
              height: page.height * 2,
              format: pdfx.PdfPageImageFormat.png,
            );
            if (pageImage == null) {
              throw const FileException('Failed to render a PDF page.');
            }

            final outPath = p.join(
              outputDir,
              '${baseName}_page_$pageNumber.png',
            );
            await File(outPath).writeAsBytes(pageImage.bytes, flush: true);
            outputs.add(outPath);
          } finally {
            await page.close();
          }
        }
      } finally {
        await document.close();
      }

      if (outputs.isEmpty) {
        throw const FileException('No pages were exported from the PDF.');
      }
      return outputs;
    } on AppException {
      rethrow;
    } catch (_) {
      throw const FileException('Failed to convert PDF pages to images.');
    }
  }

  @override
  Future<String> imagesToPdf(
    List<String> imagePaths,
    String outputPath,
  ) async {
    if (imagePaths.isEmpty) {
      throw const FileException('Select at least one image.');
    }

    try {
      final document = pw.Document();

      for (final imagePath in imagePaths) {
        final file = File(imagePath);
        if (!await file.exists()) {
          throw FileException('Image not found: ${p.basename(imagePath)}');
        }

        final bytes = await file.readAsBytes();
        final decoded = await _decodeImage(bytes);
        final pageFormat = PdfPageFormat(
          decoded.width.toDouble(),
          decoded.height.toDouble(),
        );

        document.addPage(
          pw.Page(
            pageFormat: pageFormat,
            margin: pw.EdgeInsets.zero,
            build: (context) => pw.Image(
              pw.MemoryImage(bytes),
              fit: pw.BoxFit.fill,
            ),
          ),
        );
      }

      final output = File(outputPath);
      await output.parent.create(recursive: true);
      await output.writeAsBytes(await document.save(), flush: true);
      return output.path;
    } on AppException {
      rethrow;
    } catch (_) {
      throw const FileException('Failed to convert images to PDF.');
    }
  }

  Future<ui.Image> _decodeImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}
