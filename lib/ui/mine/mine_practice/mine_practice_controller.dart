import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/network/api/api.dart';
import 'package:talk_fo_me/common/routes/app_pages.dart';
import 'package:talk_fo_me/common/service/service.dart';
import 'package:talk_fo_me/widgets/loading.dart';

import 'mine_practice_state.dart';

class MinePracticeController extends GetxController {
  final int type;

  MinePracticeController({
    required this.type,
});

  final MinePracticeState state = MinePracticeState();
  final loginService = SS.login;

  void onTapRanking() {
    Get.toNamed(
      AppRoutes.meritListPage,
      arguments: {"initialIndex": state.titleIndex.value},
    );
  }

  @override
  void onInit() async {
    state.titleIndex.value = type;
    loginService.fetchLevelMoneyInfo();

    Loading.show();
    final res = await UserApi.getLevelList(type: 1);
    Loading.dismiss();

    if (res.isSuccess && res.data != null) {
      state.levelResList.value = res.data!;
    }

    super.onInit();
  }
}
