import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

import '../../core/errors/exceptions.dart';

/// Extracts readable paragraph text from a DOCX (OOXML) package.
class DocxTextExtractor {
  const DocxTextExtractor();

  List<String> extractParagraphs(List<int> bytes) {
    Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (_) {
      throw const FileException('Invalid DOCX file.');
    }

    final documentFile = archive.findFile('word/document.xml');
    if (documentFile == null) {
      throw const FileException('DOCX is missing word/document.xml.');
    }

    final xml = utf8.decode(documentFile.content as List<int>);
    final document = XmlDocument.parse(xml);
    final paragraphs = <String>[];

    for (final paragraph in document.findAllElements('w:p')) {
      final text = paragraph
          .findAllElements('w:t')
          .map((node) => node.innerText)
          .join();
      final trimmed = text.trim();
      if (trimmed.isNotEmpty) {
        paragraphs.add(trimmed);
      }
    }

    if (paragraphs.isEmpty) {
      throw const FileException('No readable text found in the DOCX.');
    }

    return paragraphs;
  }
}
