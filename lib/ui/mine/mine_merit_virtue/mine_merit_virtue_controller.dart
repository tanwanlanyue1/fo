import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/extension/date_time_extension.dart';
import 'package:talk_fo_me/common/network/api/api.dart';
import 'package:talk_fo_me/common/paging/default_paging_controller.dart';
import 'package:talk_fo_me/common/routes/app_pages.dart';
import 'package:talk_fo_me/common/service/service.dart';
import 'package:talk_fo_me/common/utils/screen_adapt.dart';
import 'mine_merit_virtue_state.dart';

class MineMeritVirtueController extends GetxController {
  final MineMeritVirtueState state = MineMeritVirtueState();

  final loginService = SS.login;

  static int firstPage = 1;

  final pagingController = DefaultPagingController<MeritVirtueLog>(
    firstPage: firstPage,
  );

  //logo,card,bg,sign
  String levelString(int index,String name){
    if(index == 0){
      return 'assets/images/common/class_0_$name.png';
    }else if(index < 4 && (name == 'bg' || name == 'card')){
      return 'assets/images/common/class_0_$name.png';
    }else{
      return 'assets/images/common/class_${index-1}_$name.png';
    }
  }

  //计算文字大小
  Size boundingTextSize(BuildContext context, String text,
      { double maxWidth = double.infinity}) {
    if (text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      locale: Localizations.maybeLocaleOf(context),
      text: TextSpan(text: text, style: TextStyle(fontSize: 10.rpx,color: Colors.white,height: 1,leadingDistribution: TextLeadingDistribution.even)),)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }
  //经验
  String merits(int exp){
    if(exp < 10000){
      return '$exp';
    }else{
      return '${exp ~/ 1000}k';
    }
  }

  void onTapRanking() {
    Get.toNamed(AppRoutes.meritListPage);
  }

  void onTapMore() {
    Get.toNamed(AppRoutes.mineMissionCenter);
  }

  void selectDate(int year, int month) {
    state.dateString.value = DateTime(year, month).formatYM;
    pagingController.refresh();
  }

  void _fetchPage(int page) async {
    final month = state.dateString.value;
    if(page == 1){
      await _fetchIcons();
    }

    final res = await UserApi.getMeritVirtueList(
      month: month,
      page: page,
      size: pagingController.pageSize,
    );

    if (!res.isSuccess) {
      res.showErrorMessage();
    }

    if (res.isSuccess) {
      state.todayMav.value = res.data?.todayMav ?? 0;
      state.monthMav.value = res.data?.currentMav ?? 0;

      final items = res.data?.mavLog ?? [];
      pagingController.appendPageData(items);
    } else {
      pagingController.error = res.errorMessage;
    }
  }

  Future<void> _fetchIcons() async{
    final icons = SS.appConfig.configRx()?.logTypeIcon;
    if(icons == null){
      await SS.appConfig.fetchData();
    }
    SS.appConfig
        .configRx()
        ?.logTypeIcon
        ?.where((element) => element.icon.isNotEmpty)
        .forEach((element) {
      state.logTypeIconMap[element.logType] = element.icon;
    });
  }

  @override
  void onInit() async {
    loginService.fetchLevelMoneyInfo();
    state.dateString.value = DateTime.now().formatYM;
    pagingController.addPageRequestListener(_fetchPage);
    super.onInit();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}
