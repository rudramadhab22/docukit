import 'package:get/get.dart';

import '../controllers/extract_pages_controller.dart';

class ExtractPagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExtractPagesController>(ExtractPagesController.new);
  }
}
