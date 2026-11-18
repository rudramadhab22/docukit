import 'package:get/get.dart';

import '../controllers/pdf_to_images_controller.dart';

class PdfToImagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PdfToImagesController>(PdfToImagesController.new);
  }
}
