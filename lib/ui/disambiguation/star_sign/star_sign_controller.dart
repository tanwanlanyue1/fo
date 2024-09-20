import 'package:get/get.dart';
import 'package:talk_fo_me/common/network/api/api.dart';
import 'package:talk_fo_me/common/service/service.dart';
import 'package:talk_fo_me/widgets/ad_dialog.dart';
import 'package:talk_fo_me/widgets/loading.dart';

import '../../home/bottom_sheet_chat/bottom_sheet_chat_page.dart';
import 'star_sign_state.dart';

class StarSignController extends GetxController {
  final StarSignState state = StarSignState();

  @override
  void onInit() {
    
    startupCarousel();
    startupAdvertList();
    super.onInit();
  }

  /// 获取广告轮播 carousel
  Future<void> startupCarousel() async {
    final response = await OpenApi.startupAdvertList(
        type: 4,
        position: 3
    );
    if (response.isSuccess) {
      state.carousel = response.data ?? [];
      update();
    }
  }

  /// 获取广告弹窗
  void startupAdvertList() async {
    final response = await OpenApi.startupAdvertList(
        type: 3,
        position: 3,
        size: 1
    );
    if (response.isSuccess) {
      if(response.data?.isNotEmpty ?? false){
        AppAdDialog.show(response.data![0],"3");
      }
    }
  }
}
