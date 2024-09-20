import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talk_fo_me/common/paging/default_paging_controller.dart';
import 'package:talk_fo_me/common/routes/app_pages.dart';
import 'package:talk_fo_me/common/service/service.dart';
import 'package:talk_fo_me/ui/wish_pavilion/charm/charm_controller.dart';
import 'package:talk_fo_me/widgets/loading.dart';

import '../../../../common/network/api/api.dart';
import 'my_charm_state.dart';

class MyCharmController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final MyCharmState state = MyCharmState();

  late TabController tabController;

  final loginService = SS.login;

  final pagingController = DefaultPagingController<CharmRecord>(
    refreshController: RefreshController(),
  );

  void onTapMe() {
    Get.toNamed(AppRoutes.myCharmPage);
  }

  void onTapPut(CharmRecord model) {
    final c = Get.find<CharmController>();
    c.state.charmRecord.value = model;
    Get.until((route) => Get.currentRoute == AppRoutes.charmPage);
  }

  void onGetMav(CharmRecord model,{required int index}) async {
    Loading.show();
    final res = await CharmApi.receiveMav(
      id: model.id,
    );
    Loading.dismiss();

    if (!res.isSuccess) {
      res.showErrorMessage();
      return;
    }
    Loading.showToast("功德 +${model.mav}");
    setState(index);
    loginService.fetchLevelMoneyInfo();
  }

  ///修改领取状态
  void setState(int index) async {
    final itemList = List.of(pagingController.itemList!);
    itemList[index].isGetMav = 1;
    pagingController.itemList = itemList;
  }

  void _fetchPage(int page) async {
    final res = await CharmApi.getStatisticsList(
      type: state.tabIndex.value,
      page: page,
      size: pagingController.pageSize,
    );

    if (res.isSuccess) {
      pagingController.appendPageData(res.data!);
    } else {
      pagingController.error = res.errorMessage;
    }
  }

  void onTapTabIndex(int index) {
    state.tabIndex.value = index;
    pagingController.refresh();
  }

  @override
  void onInit() {
    tabController = TabController(
      length: state.tabTitles.length,
      vsync: this,
    );
    pagingController.addPageRequestListener(_fetchPage);
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    pagingController.dispose();
    super.onClose();
  }
}
