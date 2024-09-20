import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/app_color.dart';
import 'package:talk_fo_me/common/app_text_style.dart';
import 'package:talk_fo_me/common/extension/int_extension.dart';
import 'package:talk_fo_me/common/extension/list_extension.dart';
import 'package:talk_fo_me/common/extension/text_style_extension.dart';
import 'package:talk_fo_me/common/utils/screen_adapt.dart';
import 'package:talk_fo_me/widgets/app_image.dart';
import 'package:talk_fo_me/widgets/widgets.dart';

import 'merit_do_good/mine_do_good_view.dart';
import 'mine_practice_controller.dart';

class MinePracticePage extends StatelessWidget {
  MinePracticePage({super.key});

  final controller = Get.find<MinePracticeController>();
  final state = Get.find<MinePracticeController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: _headTitle(),
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: controller.onTapRanking,
            child: Container(
              margin: EdgeInsets.only(right: 16.rpx),
              alignment: Alignment.center,
              child: Text(
                "排行榜",
                style: AppTextStyle.st.size(14.rpx).textColor(AppColor.gray5),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE8DDCB),
                    Color(0xFFF8F3E8),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: Get.mediaQuery.padding.top + kToolbarHeight + 112.rpx,
              decoration: BoxDecoration(
                image: AppDecorations.backgroundImage(
                  "assets/images/mine/practice_top_bg.png",
                ),
              ),
            ),
          ),
          Obx(() => Positioned.fill(
            left: 12.rpx,
            right: 12.rpx,
            child: state.titleIndex.value == 0 ?
            _buildBody():
            MineDoGoodView(),
          )),
        ],
      ),
    );
  }

  Widget _headTitle(){
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            state.titleIndex.value = 0;
          },
          child: Text("修行之路",style: TextStyle(fontSize: 18.rpx,color: state.titleIndex.value == 0 ? AppColor.gray5 : AppColor.gray30),),
        ),
        Container(
          width: 1.rpx,
          height: 21.rpx,
          color: AppColor.gray5,
          margin: EdgeInsets.symmetric(horizontal: 4.rpx),
        ),
        GestureDetector(
          onTap: (){
            state.titleIndex.value = 1;
          },
          child: Text("功德行善",style: TextStyle(fontSize: 18.rpx,color: state.titleIndex.value == 1 ? AppColor.gray5 : AppColor.gray30),),
        ),
      ],
    ));
  }

  Widget _buildList() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFE8DB),
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      child: Column(
        children: List.generate(state.levelResList.length, (index) {
          final item = state.levelResList.safeElementAt(index);

          if (item == null) return const SizedBox();

          final detail = index == 0
              ? "初始等级"
              : "修行值达到${item.requiredExp.toPracticeValue}；累计修行${item.requiredDays}天";

          return Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 100.rpx,
                      padding: EdgeInsets.all(12.rpx),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppImage.network(
                            item.icon,
                            width: 24.rpx,
                            height: 24.rpx,
                          ),
                          SizedBox(width: 4.rpx),
                          Text(
                            item.name,
                            style: AppTextStyle.st
                                .size(14.rpx)
                                .textColor(AppColor.gray5),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(
                      color: Color(0xFFF8F3E8),
                      thickness: 1,
                      width: 1,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12.rpx),
                        alignment: Alignment.center,
                        child: Text(
                          detail,
                          style: AppTextStyle.st
                              .size(14.rpx)
                              .textColor(AppColor.gray30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (state.levelResList.length - 1 != index)
                const Divider(
                  color: Color(0xFFF8F3E8),
                  thickness: 1,
                  height: 1,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBody(){
    return SafeArea(
      child: SingleChildScrollView(
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.rpx),
              _buildHeader(),
              SizedBox(height: 20.rpx),
              Text(
                "修行等级机制",
                style: AppTextStyle.st
                    .size(16.rpx)
                    .textColor(AppColor.gray5),
              ),
              SizedBox(height: 12.rpx),
              _buildList(),
              _buildTips(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    final levelMoneyInfo = controller.loginService.levelMoneyInfo;
    final cavIcon = levelMoneyInfo?.cavIcon ?? "";
    final cavLevelName = levelMoneyInfo?.cavLevelName ?? "";
    final nextCavLevelName = levelMoneyInfo?.nextCavLevelName ?? "";
    final cavDayDiff = levelMoneyInfo?.cavDayDiff ?? 0;
    final currentExp = levelMoneyInfo?.cavExp ?? 0;
    final diffExp = levelMoneyInfo?.cavExpDiff ?? 0;
    final totalExp = levelMoneyInfo?.nextCavLevelExp ?? 0;

    return SafeArea(
      bottom: false,
      child: Container(
        height: 100.rpx,
        decoration: BoxDecoration(
          image: AppDecorations.backgroundImage(
            "assets/images/mine/practice_content_bg.png",
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "我目前的等级",
                    maxLines: 1,
                    style:
                        AppTextStyle.st.size(12.rpx).textColor(AppColor.gray5),
                  ),
                  Container(
                    height: 38.rpx,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppImage.network(
                          cavIcon,
                          width: 30.rpx,
                          height: 30.rpx,
                        ),
                        SizedBox(width: 4.rpx),
                        Text(
                          cavLevelName,
                          style: AppTextStyle.st.bold
                              .size(18.rpx)
                              .textColor(const Color(0xFF684326)),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    maxLines: 1,
                    TextSpan(
                      text: "修行值：",
                      children: [
                        TextSpan(
                          text: currentExp.toString(),
                          style: AppTextStyle.st.bold
                              .size(12.rpx)
                              .textColor(AppColor.primary),
                        ),
                      ],
                    ),
                    style:
                        AppTextStyle.st.size(12.rpx).textColor(AppColor.gray30),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "距下一等级$nextCavLevelName",
                    maxLines: 1,
                    style:
                        AppTextStyle.st.size(12.rpx).textColor(AppColor.gray5),
                  ),
                  Container(
                    height: 38.rpx,
                    alignment: Alignment.center,
                    child: Text.rich(
                      maxLines: 1,
                      TextSpan(
                        text: "还需修行：",
                        children: [
                          TextSpan(
                            text: "$cavDayDiff天",
                            style: AppTextStyle.st.bold
                                .size(18.rpx)
                                .textColor(AppColor.gray5),
                          ),
                        ],
                      ),
                      style: AppTextStyle.st
                          .size(12.rpx)
                          .textColor(AppColor.gray30),
                    ),
                  ),
                  Text.rich(
                    maxLines: 1,
                    TextSpan(
                      text: "修行值：",
                      children: [
                        TextSpan(
                          text:
                              "$totalExp${currentExp >= totalExp ? "(完成)" : "(未完成)"}",
                          style: AppTextStyle.st.bold
                              .size(12.rpx)
                              .textColor(AppColor.primary),
                        ),
                      ],
                    ),
                    style:
                        AppTextStyle.st.size(12.rpx).textColor(AppColor.gray30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTips() {
    return Padding(
      padding: FEdgeInsets(
          top: 12.rpx, bottom: max(12.rpx, Get.mediaQuery.padding.bottom)),
      child: Text(
        '每天坚持修行，随着内心平静和智慧增长，超越自我，获得不同的等级称谓。(注意:以上称谓不具备现实认证效应)坚持修行，愿能断除烦恼，广修善缘，静心如意，福慧圆满。',
        style: AppTextStyle.fs12m.copyWith(color: AppColor.gray9),
      ),
    );
  }
}
