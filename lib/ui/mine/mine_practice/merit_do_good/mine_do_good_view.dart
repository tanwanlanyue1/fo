import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/app_color.dart';
import 'package:talk_fo_me/common/app_text_style.dart';
import 'package:talk_fo_me/common/extension/list_extension.dart';
import 'package:talk_fo_me/common/extension/text_style_extension.dart';
import 'package:talk_fo_me/common/utils/screen_adapt.dart';
import 'package:talk_fo_me/widgets/app_image.dart';
import 'package:talk_fo_me/widgets/edge_insets.dart';

import 'mine_do_good_controller.dart';

//功德行善
class MineDoGoodView extends StatelessWidget {
  MineDoGoodView({Key? key}) : super(key: key);

  final controller = Get.put(MineDoGoodController());
  final state = Get.find<MineDoGoodController>().state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Container(
              margin: EdgeInsets.only(top: 20.rpx,bottom: 12.rpx),
              child: Text(
                "功德品阶划分",
                style: AppTextStyle.st
                    .size(16.rpx)
                    .textColor(AppColor.gray5),
              ),
            ),
            _buildList(),
            _buildTips(),
          ],
        ),
      ),
    );
  }


  Widget _buildHeader(BuildContext context) {
    return Obx(() {
      final levelMoneyInfo = controller.loginService.levelMoneyInfo;
      final mavLevelName = levelMoneyInfo!.mavLevelName.isNotEmpty ? levelMoneyInfo.mavLevelName : '暂无品阶';
      final nextMavLevelName = levelMoneyInfo.nextMavLevelName;
      final currentExp = levelMoneyInfo.mavExp;
      final diffExp = levelMoneyInfo.mavExpDiff;
      final mavLevel = levelMoneyInfo.mavLevel;
      final totalExp = currentExp + diffExp;
      Size textSize = controller.boundingTextSize(context,"${controller.merits(currentExp)}/${controller.merits(totalExp)}");
      return SafeArea(
        child: Container(
          height: 144.rpx,
          margin: EdgeInsets.only(top: 20.rpx),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AppAssetImage(controller.levelString(mavLevel, "card")),
                fit: BoxFit.fill,),
              borderRadius: BorderRadius.circular(8.rpx)
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 60.rpx,
                      height: 20.rpx,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.rpx,left: 12.rpx),
                      child: Text(mavLevelName,style: TextStyle(color: Colors.white,fontSize: 24.rpx,fontWeight: FontWeight.bold),),
                    ),
                    LayoutBuilder(
                      builder: (_,constraints){
                        double compile = (currentExp != 0) ? (constraints.maxWidth-63.rpx)*(currentExp/totalExp) : 0;
                        double compileValue = compile > (constraints.maxWidth-63.rpx)/2 ? (compile-(textSize.width+20.rpx) < 0 ? 0 : (compile-(textSize.width+20.rpx))) : compile;
                        return Container(
                          padding: EdgeInsets.only(left: 12.rpx,top: 8.rpx),
                          width: constraints.maxWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: const Color(0x4d000000),
                                    borderRadius: BorderRadius.all(Radius.circular(2.rpx)).copyWith(bottomLeft: Radius.zero,bottomRight: Radius.zero)
                                ),
                                padding: EdgeInsets.symmetric(vertical: 3.rpx,horizontal: 8.rpx),
                                margin: EdgeInsets.only(
                                  left: compileValue,
                                ),
                                child: Text("${controller.merits(currentExp)}/${controller.merits(totalExp)}",style: TextStyle(fontSize: 10.rpx,color: Colors.white,height: 1,leadingDistribution: TextLeadingDistribution.even)),
                              ),
                              Transform.translate(
                                offset: Offset(compile > (constraints.maxWidth-63.rpx)/2 ? (compile-6.rpx):compile, -0.32.rpx),
                                child: AppImage.asset(
                                  compile > (constraints.maxWidth-63.rpx)/2 ?
                                  "assets/images/common/vector_right.png":
                                  "assets/images/common/numerical_value.png",
                                  width: 4.rpx,
                                  height: 4.rpx,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 4.rpx,),
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0x33ffffff),
                                      borderRadius: BorderRadius.circular(5.rpx),
                                    ),
                                    height: 4.rpx,
                                    width: constraints.maxWidth-63.rpx,
                                  ),
                                  Container(
                                    width: compile,
                                    height: 4.rpx,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.rpx),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.rpx,),
                              RichText(
                                text: TextSpan(
                                    text: '距$nextMavLevelName 还需',
                                    style: TextStyle(
                                      color: AppColor.gray2,
                                      fontSize: 12.rpx,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '$diffExp',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.rpx,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' 功德',
                                        style: TextStyle(
                                          color: AppColor.gray2,
                                          fontSize: 12.rpx,
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 25.rpx).copyWith(right: 16.rpx),
                child: AppImage.asset(controller.levelString(mavLevel, "logo"),width: 100.rpx,height: 100.rpx,),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildList() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x80FFFCF7),
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      child: Obx(() => Column(
        children: List.generate(state.levelResList.length, (index) {
          final item = state.levelResList.safeElementAt(index);

          if (item == null) return const SizedBox();

          final detail = index == 0
              ? "初始等级"
              : "晋升需 ${item.requiredExp} 功德";

          return Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 100.rpx,
                      padding: EdgeInsets.all(12.rpx),
                      alignment: Alignment.center,
                      child: index == 0 ?
                      Text("暂无品阶",style: TextStyle(fontSize: 14.rpx,color: AppColor.gray5),):
                      AppImage.network(
                        item.icon ?? '',
                        width: 70.rpx,
                        height: 24.rpx,
                      ),
                    ),
                    const VerticalDivider(
                      color: Color(0xffEEE5D5),
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
                  color: Color(0xffEEE5D5),
                  thickness: 1,
                  height: 1,
                ),
            ],
          );
        }),
      )),
    );
  }

  Widget _buildTips() {
    return Padding(
      padding: FEdgeInsets(
          top: 12.rpx, bottom: max(12.rpx, Get.mediaQuery.padding.bottom)),
      child: Text(
        '每天坚持修行和行善积德，随着内心平静和智慧增长，超越自我，获得不同的功德品阶称谓。(注意:以上称谓不具备现实认证效应)坚持修行，愿能断除烦恼，广修善缘，静心如意，福慧圆满。',
        style: AppTextStyle.fs12m.copyWith(color: AppColor.gray9),
      ),
    );
  }
}
