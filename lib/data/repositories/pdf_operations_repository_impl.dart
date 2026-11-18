import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/pdf_metadata.dart';
import '../../domain/repositories/pdf_operations_repository.dart';
import '../datasources/pdf_local_datasource.dart';

class PdfOperationsRepositoryImpl implements PdfOperationsRepository {
  PdfOperationsRepositoryImpl(this._pdfDataSource);

  final PdfLocalDataSource _pdfDataSource;

  static const _pending = Err<String>(
    UnsupportedOperationFailure('This PDF operation arrives in a later phase.'),
  );

  @override
  Future<Result<String>> merge(List<String> inputPaths, String outputPath) async {
    try {
      final path = await _pdfDataSource.merge(inputPaths, outputPath);
      return Success(path);
    } on AppException catch (e) {
      return Err(FileFailure(e.message));
    } catch (_) {
      return const Err(UnexpectedFailure('Failed to merge PDF files.'));
    }
  }

  @override
  Future<Result<List<String>>> split(String inputPath, String outputDir) async {
    try {
      final paths = await _pdfDataSource.split(inputPath, outputDir);
      return Success(paths);
    } on AppException catch (e) {
      return Err(FileFailure(e.message));
    } catch (_) {
      return const Err(UnexpectedFailure('Failed to split PDF.'));
    }
  }

  @override
  Future<Result<String>> extractPages({
    required String inputPath,
    required String outputPath,
    required List<int> pages,
  }) async {
    try {
      final path = await _pdfDataSource.extractPages(
        inputPath: inputPath,
        outputPath: outputPath,
        pages: pages,
      );
      return Success(path);
    } on AppException catch (e) {
      return Err(FileFailure(e.message));
    } catch (_) {
      return const Err(UnexpectedFailure('Failed to extract PDF pages.'));
    }
  }

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
    try {
      final metadata = await _pdfDataSource.readMetadata(inputPath);
      return Success(metadata);
    } on AppException catch (e) {
      return Err(FileFailure(e.message));
    } catch (_) {
      return const Err(UnexpectedFailure('Failed to read PDF metadata.'));
    }
  }
}
