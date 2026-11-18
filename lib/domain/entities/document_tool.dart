import 'delivery_phase.dart';
import 'tool_category.dart';
import 'tool_icon.dart';

class DocumentTool {
  const DocumentTool({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.route,
    required this.phase,
    required this.icon,
    this.isAvailable = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final ToolCategory category;
  final String route;
  final DeliveryPhase phase;
  final ToolIcon icon;
  final bool isAvailable;
}
