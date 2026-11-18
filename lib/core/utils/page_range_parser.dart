import '../errors/exceptions.dart';

/// Parses user page selections like `1,3,5-7` into 1-based page numbers.
abstract final class PageRangeParser {
  static List<int> parse(String raw, {required int pageCount}) {
    if (pageCount < 1) {
      throw const FileException('PDF has no pages.');
    }

    final cleaned = raw.replaceAll(' ', '');
    if (cleaned.isEmpty) {
      throw const FileException('Enter at least one page number.');
    }

    final pages = <int>{};
    for (final part in cleaned.split(',')) {
      if (part.isEmpty) {
        throw const FileException('Invalid page selection.');
      }

      if (part.contains('-')) {
        final bounds = part.split('-');
        if (bounds.length != 2) {
          throw const FileException('Invalid page range.');
        }
        final start = int.tryParse(bounds[0]);
        final end = int.tryParse(bounds[1]);
        if (start == null || end == null || start < 1 || end < start) {
          throw const FileException('Invalid page range.');
        }
        if (end > pageCount) {
          throw FileException('Page $end is outside 1–$pageCount.');
        }
        for (var page = start; page <= end; page++) {
          pages.add(page);
        }
      } else {
        final page = int.tryParse(part);
        if (page == null || page < 1) {
          throw const FileException('Invalid page number.');
        }
        if (page > pageCount) {
          throw FileException('Page $page is outside 1–$pageCount.');
        }
        pages.add(page);
      }
    }

    final ordered = pages.toList()..sort();
    return ordered;
  }
}
