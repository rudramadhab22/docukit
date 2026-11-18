import 'package:get/get.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../domain/entities/document_tool.dart';
import '../../../../domain/entities/tool_category.dart';
import '../../../../domain/services/tool_catalog_service.dart';
import '../../../shared/controllers/base_controller.dart';

class HomeController extends BaseController {
  HomeController({ToolCatalogService? catalog})
      : _catalog = catalog ?? Get.find<ToolCatalogService>();

  final ToolCatalogService _catalog;

  late final Map<ToolCategory, List<DocumentTool>> groupedTools;

  @override
  void onInit() {
    super.onInit();
    groupedTools = _catalog.groupedByCategory();
  }

  void openTool(DocumentTool tool) {
    Get.toNamed(
      AppRoutes.toolWorkspace,
      arguments: {'toolId': tool.id},
    );
  }
}
