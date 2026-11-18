import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/conversion_repository.dart';
import '../datasources/conversion_local_datasource.dart';

class ConversionRepositoryImpl implements ConversionRepository {
  ConversionRepositoryImpl(this._dataSource);

  final ConversionLocalDataSource _dataSource;

  @override
  Future<Result<String>> wordToPdf(String inputPath, String outputPath) async {
    try {
      final path = await _dataSource.wordToPdf(inputPath, outputPath);
      return Success(path);
    } on AppException catch (e) {
      return Err(FileFailure(e.message));
    } catch (_) {
      return const Err(UnexpectedFailure('Word to PDF conversion failed.'));
    }
  }

  @override
  Future<Result<List<String>>> pdfToImages(
    String inputPath,
    String outputDir,
  ) async {
    try {
      final paths = await _dataSource.pdfToImages(inputPath, outputDir);
      return Success(paths);
    } on AppException catch (e) {
      return Err(FileFailure(e.message));
    } catch (_) {
      return const Err(UnexpectedFailure('PDF to images conversion failed.'));
    }
  }

  @override
  Future<Result<String>> imagesToPdf(
    List<String> imagePaths,
    String outputPath,
  ) async {
    try {
      final path = await _dataSource.imagesToPdf(imagePaths, outputPath);
      return Success(path);
    } on AppException catch (e) {
      return Err(FileFailure(e.message));
    } catch (_) {
      return const Err(UnexpectedFailure('Images to PDF conversion failed.'));
    }
  }
}
