import 'package:get/get.dart';

import '../../../core/errors/failures.dart';
import '../../../core/utils/result.dart';

/// Shared controller helpers so feature modules stay consistent.
abstract class BaseController extends GetxController {
  final isBusy = false.obs;
  final statusMessage = RxnString();

  Future<void> runGuarded(Future<void> Function() action) async {
    if (isBusy.value) return;
    isBusy.value = true;
    statusMessage.value = null;
    try {
      await action();
    } finally {
      isBusy.value = false;
    }
  }

  void handleResult<T>(
    Result<T> result, {
    required void Function(T value) onSuccess,
  }) {
    result.fold(
      onFailure: showFailure,
      onSuccess: onSuccess,
    );
  }

  void showFailure(Failure failure) {
    statusMessage.value = failure.message;
    Get.snackbar('DocuKit', failure.message, snackPosition: SnackPosition.BOTTOM);
  }
}
