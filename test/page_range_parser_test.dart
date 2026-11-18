import 'package:docukit/core/errors/exceptions.dart';
import 'package:docukit/core/utils/page_range_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses mixed page lists and ranges', () {
    final pages = PageRangeParser.parse('1,3,5-7', pageCount: 10);
    expect(pages, [1, 3, 5, 6, 7]);
  });

  test('rejects pages outside the document', () {
    expect(
      () => PageRangeParser.parse('1,12', pageCount: 10),
      throwsA(isA<FileException>()),
    );
  });
}
