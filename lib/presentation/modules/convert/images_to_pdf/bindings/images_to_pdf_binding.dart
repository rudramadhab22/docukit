import 'package:get/get.dart';

import '../controllers/images_to_pdf_controller.dart';

class ImagesToPdfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImagesToPdfController>(ImagesToPdfController.new);
  }
}
