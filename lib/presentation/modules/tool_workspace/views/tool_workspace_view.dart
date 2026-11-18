import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/coming_soon_body.dart';
import '../controllers/tool_workspace_controller.dart';

class ToolWorkspaceView extends GetView<ToolWorkspaceController> {
  const ToolWorkspaceView({super.key});

  @override
  Widget build(BuildContext context) {
    final tool = controller.tool;

    return Scaffold(
      appBar: AppBar(
        title: Text(tool?.title ?? 'Tool'),
      ),
      body: tool == null
          ? const Center(child: Text('Tool not found.'))
          : ComingSoonBody(tool: tool),
    );
  }
}
