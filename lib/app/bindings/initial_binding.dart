import 'package:get/get.dart';

import '../../data/datasources/file_local_datasource.dart';
import '../../data/repositories/conversion_repository_stub.dart';
import '../../data/repositories/file_repository_impl.dart';
import '../../data/repositories/pdf_operations_repository_stub.dart';
import '../../domain/repositories/conversion_repository.dart';
import '../../domain/repositories/file_repository.dart';
import '../../domain/repositories/pdf_operations_repository.dart';
import '../../domain/services/tool_catalog_service.dart';

/// App-wide dependencies. Feature modules register their own bindings.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ToolCatalogService>(const ToolCatalogService(), permanent: true);

    Get.lazyPut<FileLocalDataSource>(
      FileLocalDataSourceImpl.new,
      fenix: true,
    );

    Get.lazyPut<FileRepository>(
      () => FileRepositoryImpl(Get.find<FileLocalDataSource>()),
      fenix: true,
    );

    // Concrete PDF engines plug in later; UI depends only on these contracts.
    Get.lazyPut<PdfOperationsRepository>(
      PdfOperationsRepositoryStub.new,
      fenix: true,
    );

    Get.lazyPut<ConversionRepository>(
      ConversionRepositoryStub.new,
      fenix: true,
    );
  }
}
