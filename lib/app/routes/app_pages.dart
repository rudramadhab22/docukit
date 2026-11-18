import 'package:get/get.dart';

import '../../core/constants/app_routes.dart';
import '../../presentation/modules/home/bindings/home_binding.dart';
import '../../presentation/modules/home/views/home_view.dart';
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
  ];
}
