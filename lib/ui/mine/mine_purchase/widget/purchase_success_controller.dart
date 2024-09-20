import 'package:get/get.dart';
import 'package:talk_fo_me/common/service/service.dart';

class PurchaseSuccessController extends GetxController {
  @override
  void onInit() {
    SS.login.fetchLevelMoneyInfo();
    super.onInit();
  }
}
