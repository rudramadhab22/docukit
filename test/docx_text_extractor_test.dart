import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:docukit/data/datasources/docx_text_extractor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const extractor = DocxTextExtractor();

  test('extracts paragraph text from a minimal DOCX package', () {
    final documentXml = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    <w:p><w:r><w:t>Hello DocuKit</w:t></w:r></w:p>
    <w:p><w:r><w:t>Phase 3 conversion</w:t></w:r></w:p>
  </w:body>
</w:document>
''';

    final archive = Archive()
      ..addFile(
        ArchiveFile(
          'word/document.xml',
          documentXml.length,
          utf8.encode(documentXml),
        ),
      );
    final bytes = ZipEncoder().encode(archive);

    final paragraphs = extractor.extractParagraphs(bytes);

    expect(paragraphs, ['Hello DocuKit', 'Phase 3 conversion']);
  });
}
