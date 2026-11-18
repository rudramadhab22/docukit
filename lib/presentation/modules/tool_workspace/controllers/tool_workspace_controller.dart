import 'package:get/get.dart';

import '../../../../domain/entities/document_tool.dart';
import '../../../../domain/services/tool_catalog_service.dart';
import '../../../shared/controllers/base_controller.dart';

class ToolWorkspaceController extends BaseController {
  ToolWorkspaceController({ToolCatalogService? catalog})
      : _catalog = catalog ?? Get.find<ToolCatalogService>();

  final ToolCatalogService _catalog;

  late final DocumentTool? tool;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    final toolId = args is Map ? args['toolId'] as String? : null;
    tool = toolId == null ? null : _catalog.byId(toolId);
  }
}
