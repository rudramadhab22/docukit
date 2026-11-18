import 'package:flutter/material.dart';

import '../../../domain/entities/tool_icon.dart';

abstract final class ToolIconMapper {
  static IconData toIconData(ToolIcon icon) {
    return switch (icon) {
      ToolIcon.wordToPdf => Icons.description_outlined,
      ToolIcon.pdfToImages => Icons.image_outlined,
      ToolIcon.imagesToPdf => Icons.collections_outlined,
      ToolIcon.mergePdf => Icons.merge_type_outlined,
      ToolIcon.splitPdf => Icons.call_split_outlined,
      ToolIcon.extractPages => Icons.content_cut_outlined,
      ToolIcon.compressPdf => Icons.compress_outlined,
      ToolIcon.rotatePdf => Icons.rotate_right_outlined,
      ToolIcon.watermark => Icons.branding_watermark_outlined,
      ToolIcon.protectPdf => Icons.lock_outline,
      ToolIcon.unlockPdf => Icons.lock_open_outlined,
      ToolIcon.metadata => Icons.info_outline,
    };
  }
}
