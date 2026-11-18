import '../../core/errors/exceptions.dart';
import '../../domain/entities/picked_document.dart';

/// Low-level file I/O boundary. Real pickers plug in here later.
abstract class FileLocalDataSource {
  Future<PickedDocument> pickSingle({required List<String> extensions});

  Future<List<PickedDocument>> pickMultiple({
    required List<String> extensions,
  });

  Future<String> outputPathFor(String fileName);
}

class FileLocalDataSourceImpl implements FileLocalDataSource {
  @override
  Future<PickedDocument> pickSingle({required List<String> extensions}) async {
    throw const UnsupportedOperationException(
      'File picker will be connected in Phase 2.',
    );
  }

  @override
  Future<List<PickedDocument>> pickMultiple({
    required List<String> extensions,
  }) async {
    throw const UnsupportedOperationException(
      'Multi-file picker will be connected in Phase 2.',
    );
  }

  @override
  Future<String> outputPathFor(String fileName) async {
    throw const UnsupportedOperationException(
      'Output path resolution will be connected in Phase 2.',
    );
  }
}
