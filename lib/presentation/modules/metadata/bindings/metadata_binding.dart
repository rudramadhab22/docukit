import 'package:get/get.dart';

import '../controllers/metadata_controller.dart';

class MetadataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MetadataController>(MetadataController.new);
  }
}
