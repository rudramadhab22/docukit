import '../../core/utils/result.dart';

abstract class ConversionRepository {
  Future<Result<String>> wordToPdf(String inputPath, String outputPath);

  Future<Result<List<String>>> pdfToImages(String inputPath, String outputDir);

  Future<Result<String>> imagesToPdf(
    List<String> imagePaths,
    String outputPath,
  );
}
