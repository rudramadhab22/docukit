import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pdfx/pdfx.dart';

import '../../core/errors/exceptions.dart';
import '../../domain/entities/pdf_metadata.dart';
import 'pdf_info_parser.dart';

abstract class PdfLocalDataSource {
  Future<PdfMetadata> readMetadata(String inputPath);

  Future<int> pageCount(String inputPath);
}

class PdfLocalDataSourceImpl implements PdfLocalDataSource {
  PdfLocalDataSourceImpl({PdfInfoParser parser = const PdfInfoParser()})
      : _parser = parser;

  final PdfInfoParser _parser;

  @override
  Future<int> pageCount(String inputPath) async {
    final document = await PdfDocument.openFile(inputPath);
    try {
      return document.pagesCount;
    } finally {
      await document.close();
    }
  }

  @override
  Future<PdfMetadata> readMetadata(String inputPath) async {
    final file = File(inputPath);
    if (!await file.exists()) {
      throw const FileException('PDF file was not found.');
    }

    try {
      final bytes = await file.readAsBytes();
      final info = _parser.parseInfo(bytes);
      final pages = await pageCount(inputPath);
      final stat = await file.stat();

      return PdfMetadata(
        fileName: p.basename(inputPath),
        filePath: inputPath,
        sizeBytes: stat.size,
        pageCount: pages,
        title: info['Title'],
        author: info['Author'],
        subject: info['Subject'],
        keywords: info['Keywords'],
        creator: info['Creator'],
        producer: info['Producer'],
        createdAt: _parser.parsePdfDate(info['CreationDate']) ?? stat.changed,
        modifiedAt: _parser.parsePdfDate(info['ModDate']) ?? stat.modified,
      );
    } on AppException {
      rethrow;
    } catch (_) {
      throw const FileException('Failed to read PDF metadata.');
    }
  }
}
