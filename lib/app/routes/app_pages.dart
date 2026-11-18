import 'package:get/get.dart';

import '../../core/constants/app_routes.dart';
import '../../presentation/modules/convert/images_to_pdf/bindings/images_to_pdf_binding.dart';
import '../../presentation/modules/convert/images_to_pdf/views/images_to_pdf_view.dart';
import '../../presentation/modules/convert/pdf_to_images/bindings/pdf_to_images_binding.dart';
import '../../presentation/modules/convert/pdf_to_images/views/pdf_to_images_view.dart';
import '../../presentation/modules/convert/word_to_pdf/bindings/word_to_pdf_binding.dart';
import '../../presentation/modules/convert/word_to_pdf/views/word_to_pdf_view.dart';
import '../../presentation/modules/home/bindings/home_binding.dart';
import '../../presentation/modules/home/views/home_view.dart';
import '../../presentation/modules/metadata/bindings/metadata_binding.dart';
import '../../presentation/modules/metadata/views/metadata_view.dart';
import '../../presentation/modules/structure/extract_pages/bindings/extract_pages_binding.dart';
import '../../presentation/modules/structure/extract_pages/views/extract_pages_view.dart';
import '../../presentation/modules/structure/merge_pdf/bindings/merge_pdf_binding.dart';
import '../../presentation/modules/structure/merge_pdf/views/merge_pdf_view.dart';
import '../../presentation/modules/structure/split_pdf/bindings/split_pdf_binding.dart';
import '../../presentation/modules/structure/split_pdf/views/split_pdf_view.dart';
import '../../presentation/modules/tool_workspace/bindings/tool_workspace_binding.dart';
import '../../presentation/modules/tool_workspace/views/tool_workspace_view.dart';

abstract final class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.home,
      page: HomeView.new,
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.toolWorkspace,
      page: ToolWorkspaceView.new,
      binding: ToolWorkspaceBinding(),
    ),
    GetPage(
      name: AppRoutes.metadata,
      page: MetadataView.new,
      binding: MetadataBinding(),
    ),
    GetPage(
      name: AppRoutes.wordToPdf,
      page: WordToPdfView.new,
      binding: WordToPdfBinding(),
    ),
    GetPage(
      name: AppRoutes.pdfToImages,
      page: PdfToImagesView.new,
      binding: PdfToImagesBinding(),
    ),
    GetPage(
      name: AppRoutes.imagesToPdf,
      page: ImagesToPdfView.new,
      binding: ImagesToPdfBinding(),
    ),
    GetPage(
      name: AppRoutes.mergePdf,
      page: MergePdfView.new,
      binding: MergePdfBinding(),
    ),
    GetPage(
      name: AppRoutes.splitPdf,
      page: SplitPdfView.new,
      binding: SplitPdfBinding(),
    ),
    GetPage(
      name: AppRoutes.extractPages,
      page: ExtractPagesView.new,
      binding: ExtractPagesBinding(),
    ),
  ];
}
