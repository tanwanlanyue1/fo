import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:talk_fo_me/common/app_color.dart';
import 'package:talk_fo_me/common/app_text_style.dart';
import 'package:talk_fo_me/common/extension/string_extension.dart';
import 'package:talk_fo_me/common/extension/text_style_extension.dart';
import 'package:talk_fo_me/common/network/api/api.dart';
import 'package:talk_fo_me/common/paging/default_paged_child_builder_delegate.dart';
import 'package:talk_fo_me/common/routes/app_pages.dart';
import 'package:talk_fo_me/common/service/service.dart';
import 'package:talk_fo_me/common/utils/screen_adapt.dart';
import 'package:talk_fo_me/widgets/app_back_button.dart';
import 'package:talk_fo_me/widgets/app_image.dart';
import 'mine_merit_virtue_controller.dart';

/// 功德
class MineMeritVirtuePage extends StatelessWidget {
  MineMeritVirtuePage({Key? key}) : super(key: key);

  final controller = Get.put(MineMeritVirtueController());
  final state = Get.find<MineMeritVirtueController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("修功业行善德",style: TextStyle(color: Colors.white),),
        leading: AppBackButton.light(),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          GestureDetector(
            onTap: controller.onTapRanking,
            child: Container(
              margin: EdgeInsets.only(right: 16.rpx),
              alignment: Alignment.center,
              child: Text(
                "功德榜",
                style: AppTextStyle.st.regular
                    .size(14.rpx)
                    .textColor(AppColor.gray3),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColor.brown14,
      body: Stack(
        children: [
          Obx(() => Positioned(
            top: 0,
            child: AppImage.asset(controller.levelString(controller.loginService.levelMoneyInfo?.mavLevel ?? 0, "bg"),width: Get.width,height: 328.rpx,),
          )),
          Positioned.fill(
            child: Column(
              children: [
                _buildHeader(context),
                _buildDateSelect(context),
                Expanded(
                  child: PagedListView(
                    padding: EdgeInsets.zero,
                    pagingController: controller.pagingController,
                    builderDelegate:
                        DefaultPagedChildBuilderDelegate<MeritVirtueLog>(
                      pagingController: controller.pagingController,
                      itemBuilder: (_, item, index) {
                        return _buildItem(item, index);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _buildItem(MeritVirtueLog item, int index) {
    final image = state.logTypeIconMap[item.logType] ?? item.image;
    return Column(
      children: [
        Container(
          height: 60.rpx,
          margin: EdgeInsets.symmetric(horizontal: 12.rpx),
          padding: EdgeInsets.symmetric(horizontal: 12.rpx),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.rpx),
          ),
          child: Row(
            children: [
              AppImage.network(
                image,
                width: 42.rpx,
                height: 42.rpx,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8.rpx),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.giftName,
                            maxLines: 1,
                            style: AppTextStyle.st
                                .size(14.rpx)
                                .textColor(AppColor.gray5),
                          ),
                        ),
                        SizedBox(width: 8.rpx),
                        Text(
                          '+${item.amount}',
                          style: AppTextStyle.st
                              .size(16.rpx)
                              .textColor(AppColor.primary).copyWith(fontFamily: "BEBAS"),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.rpx),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.extraName,
                            maxLines: 1,
                            style: AppTextStyle.st
                                .size(12.rpx)
                                .textColor(AppColor.gray9),
                          ),
                        ),
                        SizedBox(width: 8.rpx),
                        Text(
                          DateUtil.formatDate(item.createTime.dateTime,
                              format: 'MM-dd HH:mm'),
                          style: AppTextStyle.st
                              .size(12.rpx)
                              .textColor(AppColor.gray9).copyWith(fontFamily: "BEBAS"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
            height: index == controller.pagingController.length - 1
                ? 10.rpx + Get.mediaQuery.padding.bottom
                : 10.rpx),
      ],
    );
  }

  Widget _buildDateSelect(BuildContext context) {
    return Obx(() {
      return Container(
        margin:
            EdgeInsets.symmetric(horizontal: 12.rpx).copyWith(bottom: 12.rpx),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Pickers.showDatePicker(
                  context,
                  onConfirm: (val) {
                    if (val.year == null || val.month == null) return;
                    controller.selectDate(val.year!, val.month!);
                  },
                  mode: DateMode.YM,
                  pickerStyle: PickerStyle(
                    pickerTitleHeight: 65.rpx,
                    commitButton: Padding(
                      padding: EdgeInsets.only(right: 12.rpx),
                      child: Text(
                        "完成",
                        style: TextStyle(
                            fontSize: 14.rpx, color: const Color(0xff8D310F)),
                      ),
                    ),
                    cancelButton: Padding(
                      padding: EdgeInsets.only(left: 12.rpx),
                      child: AppImage.asset(
                        "assets/images/disambiguation/close.png",
                        width: 24.rpx,
                        height: 24.rpx,
                      ),
                    ),
                    headDecoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.rpx),
                        topRight: Radius.circular(20.rpx),
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                child: Wrap(
                  spacing: 1.rpx,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      state.dateString.value,
                      style: TextStyle(
                        color: const Color(0xFF333333),
                        fontSize: 14.rpx,
                          fontFamily: "BEBAS"
                      ),
                    ),
                    AppImage.asset("assets/images/mine/mine_arrow_down.png",
                        width: 16.rpx, height: 12.rpx),
                  ],
                ),
              ),
            ),
            Text.rich(
              TextSpan(
                text: "本月累计:",
                children: [
                  TextSpan(
                    text: "${state.monthMav}",
                    style:
                        AppTextStyle.st.size(14.rpx).copyWith(
                          color: AppColor.gray5,
                            fontFamily: "BEBAS",
                        ),
                  ),
                ],
              ),
              style: AppTextStyle.st.size(14.rpx).textColor(AppColor.gray9),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(BuildContext context) {
    return Obx(() {
      final levelMoneyInfo = controller.loginService.levelMoneyInfo;
      final mavLevelName = levelMoneyInfo!.mavLevelName.isNotEmpty ? levelMoneyInfo.mavLevelName : '暂无品阶';
      final nextMavLevelName = levelMoneyInfo.nextMavLevelName ?? "";
      final currentExp = levelMoneyInfo.mavExp ?? 0;
      final diffExp = levelMoneyInfo.mavExpDiff ?? 0;
      final mavLevel = levelMoneyInfo.mavLevel ?? 0;
      final totalExp = currentExp + diffExp;
      Size textSize = controller.boundingTextSize(context,"${controller.merits(currentExp)}/${controller.merits(totalExp)}");
      return SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.rpx)
              .copyWith(bottom: 20.rpx),
          child: Column(
            children: [
              SizedBox(
                height: 54.rpx,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: 24.rpx,
                            child: Text(
                              "${state.todayMav.value}",
                              style: AppTextStyle.st.bold.copyWith(
                                fontSize: 20.rpx,color: Colors.white,fontFamily: "BEBAS"
                              ),
                            ),
                          ),
                          Text(
                            "今日功德",
                            style: AppTextStyle.st
                                .size(14.rpx)
                                .textColor(AppColor.gray3),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: 24.rpx,
                            child: mavLevel == 0 ?
                            const Text("_",style: TextStyle(color: Colors.white),):
                            AppImage.asset(controller.levelString(mavLevel, "sign"),width: 70.rpx,height: 24.rpx,),
                          ),
                          Text(
                            "我的功德",
                            style: AppTextStyle.st
                                .size(14.rpx)
                                .textColor(AppColor.gray3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
                          GestureDetector(
                            onTap: (){
                              Get.toNamed(AppRoutes.minePracticePage,arguments: {"type":1});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0x33FFFFFF),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.rpx),
                                      bottomRight: Radius.circular(12.rpx)
                                  )
                              ),
                              width: 60.rpx,
                              height: 20.rpx,
                              alignment: Alignment.center,
                              child: Text("获取更多",style: TextStyle(fontSize: 10.rpx,color: Colors.white),),
                            ),
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
                                      child: Text("${controller.merits(currentExp)}/${controller.merits(totalExp)}",style: TextStyle(fontSize: 10.rpx,color: Colors.white,height: 1,leadingDistribution: TextLeadingDistribution.even,fontFamily: "BEBAS")),
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
                                    Visibility(
                                      visible: mavLevel != 10,
                                      replacement: Text("您已升至最高品阶",style: TextStyle(
                                        color: AppColor.gray2,
                                        fontSize: 12.rpx,
                                      ),),
                                      child: RichText(
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
                                                  fontFamily: "BEBAS"
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
            ],
          ),
        ),
      );
    });
  }
}
