import 'dart:convert';

import 'package:docukit/data/datasources/pdf_info_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const parser = PdfInfoParser();

  test('parses literal Info dictionary fields', () {
    final pdf = utf8.encode(
      '%PDF-1.4\n'
      '1 0 obj\n'
      '<< /Title (DocuKit Sample) /Author (Rudramadhab) /Creator (DocuKit) >>\n'
      'endobj\n'
      'trailer\n'
      '<< /Info 1 0 R >>\n'
      '%%EOF\n',
    );

    final info = parser.parseInfo(pdf);

    expect(info['Title'], 'DocuKit Sample');
    expect(info['Author'], 'Rudramadhab');
    expect(info['Creator'], 'DocuKit');
  });

  test('parses PDF date strings', () {
    final date = parser.parsePdfDate('D:20261118120000Z');
    expect(date, DateTime.utc(2026, 11, 18, 12));
  });
}
