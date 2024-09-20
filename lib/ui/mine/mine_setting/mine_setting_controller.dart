import 'package:get/get.dart';
import 'package:talk_fo_me/common/extension/get_extension.dart';
import 'package:talk_fo_me/common/service/service.dart';
import 'package:talk_fo_me/common/utils/app_info.dart';
import 'package:talk_fo_me/common/utils/image_cache_utils.dart';
import 'package:talk_fo_me/widgets/loading.dart';

import 'mine_setting_state.dart';

class MineSettingController extends GetxController {
  final MineSettingState state = MineSettingState();

  final version = "".obs;

  final cacheSize = "".obs;

  void onTapSignOut() async {
    Loading.show();
    final res = await SS.login.signOut();
    Loading.dismiss();
    res.when(
        success: (_) {},
        failure: (errorMessage) {
          Loading.showToast(errorMessage);
        });
    Get.backToRoot();
  }

  void onTapClearCache() {
    ImageCacheUtils.clearAllCacheImage();
    cacheSize.value = ImageCacheUtils.getAllSizeOfCacheImages();
  }

  @override
  void onInit() async {
    version.value = await AppInfo.getVersion();
    cacheSize.value = ImageCacheUtils.getAllSizeOfCacheImages();

    super.onInit();
  }
}
