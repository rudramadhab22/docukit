import '../../core/utils/result.dart';
import '../entities/picked_document.dart';

/// Abstraction over local file access. Presentation never talks to plugins.
abstract class FileRepository {
  Future<Result<PickedDocument>> pickSingleDocument({
    required List<String> extensions,
  });

  Future<Result<List<PickedDocument>>> pickMultipleDocuments({
    required List<String> extensions,
  });

  Future<Result<String>> resolveOutputPath({
    required String fileName,
  });
}
