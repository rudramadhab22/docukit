import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/picked_document.dart';
import '../../domain/repositories/file_repository.dart';
import '../datasources/file_local_datasource.dart';

class FileRepositoryImpl implements FileRepository {
  FileRepositoryImpl(this._dataSource);

  final FileLocalDataSource _dataSource;

  @override
  Future<Result<PickedDocument>> pickSingleDocument({
    required List<String> extensions,
  }) async {
    try {
      final document = await _dataSource.pickSingle(extensions: extensions);
      return Success(document);
    } on CancelledException {
      return const Err(CancellationFailure());
    } on AppException catch (e) {
      return Err(FileFailure(e.message));
    } catch (_) {
      return const Err(UnexpectedFailure());
    }
  }

  @override
  Future<Result<List<PickedDocument>>> pickMultipleDocuments({
    required List<String> extensions,
  }) async {
    try {
      final documents = await _dataSource.pickMultiple(extensions: extensions);
      return Success(documents);
    } on CancelledException {
      return const Err(CancellationFailure());
    } on AppException catch (e) {
      return Err(FileFailure(e.message));
    } catch (_) {
      return const Err(UnexpectedFailure());
    }
  }

  @override
  Future<Result<String>> resolveOutputPath({required String fileName}) async {
    try {
      final path = await _dataSource.outputPathFor(fileName);
      return Success(path);
    } on AppException catch (e) {
      return Err(FileFailure(e.message));
    } catch (_) {
      return const Err(UnexpectedFailure());
    }
  }
}
