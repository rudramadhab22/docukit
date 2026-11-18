import 'package:get/get.dart';

import '../controllers/word_to_pdf_controller.dart';

class WordToPdfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WordToPdfController>(WordToPdfController.new);
  }
}
