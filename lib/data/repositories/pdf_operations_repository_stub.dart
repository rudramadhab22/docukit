import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/pdf_metadata.dart';
import '../../domain/repositories/pdf_operations_repository.dart';

/// Kept for tests / fallback; production uses [PdfOperationsRepositoryImpl].
class PdfOperationsRepositoryStub implements PdfOperationsRepository {
  static const _pending = Err<String>(
    UnsupportedOperationFailure('PDF engine not connected yet.'),
  );

  @override
  Future<Result<String>> merge(List<String> inputPaths, String outputPath) async =>
      _pending;

  @override
  Future<Result<List<String>>> split(String inputPath, String outputDir) async {
    return const Err(
      UnsupportedOperationFailure('PDF engine not connected yet.'),
    );
  }

  @override
  Future<Result<String>> extractPages({
    required String inputPath,
    required String outputPath,
    required List<int> pages,
  }) async =>
      _pending;

  @override
  Future<Result<String>> compress(String inputPath, String outputPath) async =>
      _pending;

  @override
  Future<Result<String>> rotate({
    required String inputPath,
    required String outputPath,
    required int degrees,
  }) async =>
      _pending;

  @override
  Future<Result<String>> addWatermark({
    required String inputPath,
    required String outputPath,
    required String text,
  }) async =>
      _pending;

  @override
  Future<Result<String>> protect({
    required String inputPath,
    required String outputPath,
    required String password,
  }) async =>
      _pending;

  @override
  Future<Result<String>> unlock({
    required String inputPath,
    required String outputPath,
    required String password,
  }) async =>
      _pending;

  @override
  Future<Result<PdfMetadata>> readMetadata(String inputPath) async {
    return const Err(
      UnsupportedOperationFailure('Metadata reader not connected yet.'),
    );
  }
}
