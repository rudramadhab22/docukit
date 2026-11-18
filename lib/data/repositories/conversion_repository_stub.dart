import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/conversion_repository.dart';

class ConversionRepositoryStub implements ConversionRepository {
  static const _pending = Err<String>(
    UnsupportedOperationFailure('Conversion engine not connected yet.'),
  );

  @override
  Future<Result<String>> wordToPdf(String inputPath, String outputPath) async =>
      _pending;

  @override
  Future<Result<List<String>>> pdfToImages(
    String inputPath,
    String outputDir,
  ) async {
    return const Err(
      UnsupportedOperationFailure('Conversion engine not connected yet.'),
    );
  }

  @override
  Future<Result<String>> imagesToPdf(
    List<String> imagePaths,
    String outputPath,
  ) async =>
      _pending;
}
