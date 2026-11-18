import '../../core/utils/result.dart';
import '../entities/pdf_metadata.dart';

/// PDF structure, edit, and security contracts.
/// Implementations can swap engines without touching UI.
abstract class PdfOperationsRepository {
  Future<Result<String>> merge(List<String> inputPaths, String outputPath);

  Future<Result<List<String>>> split(String inputPath, String outputDir);

  Future<Result<String>> extractPages({
    required String inputPath,
    required String outputPath,
    required List<int> pages,
  });

  Future<Result<String>> compress(String inputPath, String outputPath);

  Future<Result<String>> rotate({
    required String inputPath,
    required String outputPath,
    required int degrees,
  });

  Future<Result<String>> addWatermark({
    required String inputPath,
    required String outputPath,
    required String text,
  });

  Future<Result<String>> protect({
    required String inputPath,
    required String outputPath,
    required String password,
  });

  Future<Result<String>> unlock({
    required String inputPath,
    required String outputPath,
    required String password,
  });

  Future<Result<PdfMetadata>> readMetadata(String inputPath);
}
