import 'package:get/get.dart';

import '../controllers/tool_workspace_controller.dart';

class ToolWorkspaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToolWorkspaceController>(ToolWorkspaceController.new);
  }
}
