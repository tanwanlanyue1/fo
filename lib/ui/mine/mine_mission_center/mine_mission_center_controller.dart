import 'package:get/get.dart';
import 'package:talk_fo_me/common/routes/app_pages.dart';

import 'mine_mission_center_state.dart';

class MineMissionCenterController extends GetxController {
  final MineMissionCenterState state = MineMissionCenterState();

  void onTapRewardPoints() {
    Get.toNamed(AppRoutes.mineRewardPoints);
  }
}
