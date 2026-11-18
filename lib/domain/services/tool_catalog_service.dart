import '../../core/constants/app_routes.dart';
import '../../core/constants/tool_ids.dart';
import '../entities/delivery_phase.dart';
import '../entities/document_tool.dart';
import '../entities/tool_category.dart';
import '../entities/tool_icon.dart';

/// Single source of truth for tools shown on Home.
/// Controllers consume this; they do not hardcode feature lists.
class ToolCatalogService {
  const ToolCatalogService();

  List<DocumentTool> get all => const [
        DocumentTool(
          id: ToolIds.wordToPdf,
          title: 'Word to PDF',
          subtitle: 'Convert DOCX documents into PDF',
          category: ToolCategory.convert,
          route: AppRoutes.wordToPdf,
          phase: DeliveryPhase.conversions,
          icon: ToolIcon.wordToPdf,
        ),
        DocumentTool(
          id: ToolIds.pdfToImages,
          title: 'PDF to Images',
          subtitle: 'Export each page as an image',
          category: ToolCategory.convert,
          route: AppRoutes.pdfToImages,
          phase: DeliveryPhase.conversions,
          icon: ToolIcon.pdfToImages,
        ),
        DocumentTool(
          id: ToolIds.imagesToPdf,
          title: 'Images to PDF',
          subtitle: 'Combine images into one PDF',
          category: ToolCategory.convert,
          route: AppRoutes.imagesToPdf,
          phase: DeliveryPhase.conversions,
          icon: ToolIcon.imagesToPdf,
        ),
        DocumentTool(
          id: ToolIds.mergePdf,
          title: 'Merge PDF',
          subtitle: 'Join multiple PDFs into one file',
          category: ToolCategory.structure,
          route: AppRoutes.mergePdf,
          phase: DeliveryPhase.structure,
          icon: ToolIcon.mergePdf,
        ),
        DocumentTool(
          id: ToolIds.splitPdf,
          title: 'Split PDF',
          subtitle: 'Break a PDF into separate files',
          category: ToolCategory.structure,
          route: AppRoutes.splitPdf,
          phase: DeliveryPhase.structure,
          icon: ToolIcon.splitPdf,
        ),
        DocumentTool(
          id: ToolIds.extractPages,
          title: 'Extract Pages',
          subtitle: 'Save selected pages as a new PDF',
          category: ToolCategory.structure,
          route: AppRoutes.extractPages,
          phase: DeliveryPhase.structure,
          icon: ToolIcon.extractPages,
        ),
        DocumentTool(
          id: ToolIds.compressPdf,
          title: 'Compress PDF',
          subtitle: 'Reduce file size with smart compression',
          category: ToolCategory.edit,
          route: AppRoutes.compressPdf,
          phase: DeliveryPhase.editOptimize,
          icon: ToolIcon.compressPdf,
        ),
        DocumentTool(
          id: ToolIds.rotatePdf,
          title: 'Rotate Pages',
          subtitle: 'Rotate one or more PDF pages',
          category: ToolCategory.edit,
          route: AppRoutes.rotatePdf,
          phase: DeliveryPhase.editOptimize,
          icon: ToolIcon.rotatePdf,
        ),
        DocumentTool(
          id: ToolIds.watermark,
          title: 'Add Watermark',
          subtitle: 'Stamp text across PDF pages',
          category: ToolCategory.edit,
          route: AppRoutes.watermark,
          phase: DeliveryPhase.editOptimize,
          icon: ToolIcon.watermark,
        ),
        DocumentTool(
          id: ToolIds.protectPdf,
          title: 'Protect PDF',
          subtitle: 'Lock a PDF with a password',
          category: ToolCategory.security,
          route: AppRoutes.protectPdf,
          phase: DeliveryPhase.security,
          icon: ToolIcon.protectPdf,
        ),
        DocumentTool(
          id: ToolIds.unlockPdf,
          title: 'Remove Password',
          subtitle: 'Unlock when you are authorized',
          category: ToolCategory.security,
          route: AppRoutes.unlockPdf,
          phase: DeliveryPhase.security,
          icon: ToolIcon.unlockPdf,
        ),
        DocumentTool(
          id: ToolIds.metadata,
          title: 'PDF Metadata',
          subtitle: 'Inspect document properties',
          category: ToolCategory.inspect,
          route: AppRoutes.metadata,
          phase: DeliveryPhase.coreUtilities,
          icon: ToolIcon.metadata,
          isAvailable: true,
        ),
      ];

  DocumentTool? byId(String id) {
    for (final tool in all) {
      if (tool.id == id) return tool;
    }
    return null;
  }

  Map<ToolCategory, List<DocumentTool>> groupedByCategory() {
    final map = <ToolCategory, List<DocumentTool>>{};
    for (final tool in all) {
      map.putIfAbsent(tool.category, () => []).add(tool);
    }
    return map;
  }
}
