import 'dart:io';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talk_fo_me/common/app_config.dart';
import 'package:talk_fo_me/common/routes/app_pages.dart';
import 'package:talk_fo_me/common/service/service.dart';
import 'package:talk_fo_me/common/utils/app_link.dart';
import 'package:talk_fo_me/ui/home/home_controller.dart';
import 'package:talk_fo_me/ui/home/widget/home_drawer_controller.dart';
import 'package:talk_fo_me/widgets/loading.dart';
import 'package:talk_fo_me/widgets/web/web_page.dart';
import 'mine_state.dart';

class MineController extends GetxController {
  final MineState state = MineState();

  final refreshController = RefreshController();

  late final loginService = SS.login;

  @override
  void onInit() {
    
    super.onInit();
  }

  void onRefresh() async {
    if (loginService.isLogin) {
      await loginService.fetchMyInfo();
      loginService
          .fetchLevelMoneyInfo()
          .whenComplete(() => refreshController.refreshCompleted());
    } else {
      refreshController.refreshCompleted();
    }
  }

  void onTapLogin() {
    Get.toNamed(AppRoutes.loginPage);
  }

  void onTapMissionCenter() {
    Get.toNamed(AppRoutes.mineMissionCenter);
  }

  void onTapGoldDetails() {
    Get.toNamed(AppRoutes.mineGoldDetail);
  }

  void onTapPurchase() {
    Get.toNamed(AppRoutes.minePurchase);
  }

  void onTapMeritVirtue() {
    Get.toNamed(AppRoutes.mineMeritVirtuePage);
  }

  void onTapPractice() {
    Get.toNamed(AppRoutes.minePracticePage);
  }

  void onTapItem(MineItemType type) {
    switch (type) {
      case MineItemType.homework:
        Get.toNamed(AppRoutes.practiceDetailPage);
        break;
      case MineItemType.disabuse:
        final homeController = Get.find<HomeController>();
        homeController.setInitPage = 0;
        break;
      case MineItemType.invitation:
        final jumpLink = SS.appConfig.configRx()?.jumpLink;
        if(jumpLink != null){
          AppLink.jump(jumpLink);
          return;
        }
        Loading.showToast("暂未开放，敬请期待");
        break;
      case MineItemType.ranking:
        Get.toNamed(AppRoutes.meritListPage);
        break;
      case MineItemType.myCreation:
        Get.toNamed(AppRoutes.userCenterPage);
        break;
      case MineItemType.collection:
        Get.toNamed(AppRoutes.mineCollectPage);
        break;
      case MineItemType.browsingHistory:
        Get.toNamed(AppRoutes.plazaHistoryPage);
        break;
      case MineItemType.myQuestionsAndAnswers:
        HomeDrawerController.open();
        break;
      case MineItemType.message:
        Get.toNamed(AppRoutes.mineMessage);
        break;
      case MineItemType.myArchive:
        Get.toNamed(AppRoutes.mineRecordPage);
        break;
      case MineItemType.myAttention:
        Get.toNamed(AppRoutes.mineAttentionPage);
        break;
      case MineItemType.feedback:
        Get.toNamed(AppRoutes.mineFeedbackPage);
        break;
      case MineItemType.setting:
        Get.toNamed(AppRoutes.mineSettingPage);
        break;
      case MineItemType.help:
        WebPage.go(title: '客服与帮助', url: '${AppConfig.urlHelp}?t=${DateTime.now().millisecondsSinceEpoch}');
        break;
      case MineItemType.attentionOrFans:
        Get.toNamed(AppRoutes.attentionOrFansPage);
        break;
    }
  }
}
