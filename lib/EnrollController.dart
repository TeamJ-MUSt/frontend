import 'package:get/get.dart';

class EnrollController extends GetxController {
  var isLoading = false.obs;

  void startLoading() {
    isLoading.value = true;
    Get.snackbar(
      "등록 중",
      "노래 등록이 진행 중입니다...",
      showProgressIndicator: true,
      snackPosition: SnackPosition.TOP,
      duration: Duration(minutes: 10), // 충분히 긴 시간으로 설정
      isDismissible: false,
    );
  }

  void stopLoading() {
    isLoading.value = false;
    Get.closeAllSnackbars(); // 등록 완료 시 스낵바 닫기
    Get.snackbar(
      "등록 완료",
      "노래 등록이 완료되었습니다.",
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
    );
  }
}
