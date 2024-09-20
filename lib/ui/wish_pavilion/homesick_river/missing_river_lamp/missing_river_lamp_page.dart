import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/app_color.dart';
import 'package:talk_fo_me/common/app_text_style.dart';
import 'package:talk_fo_me/common/utils/common_utils.dart';
import 'package:talk_fo_me/common/utils/screen_adapt.dart';
import 'package:talk_fo_me/widgets/app_image.dart';
import 'package:talk_fo_me/widgets/input_widget.dart';
import 'package:talk_fo_me/widgets/user_level_info.dart';

import '../../../../common/network/api/model/talk_model.dart';
import 'missing_river_lamp_controller.dart';

///思念河灯-弹窗
class MissingRiverLampPage extends StatelessWidget {
  MissingRiverLampPage({Key? key}) : super(key: key);

  late final state = Get.find<MissingRiverLampController>().state;

  static void show({Function()? callback}) {
    Get.bottomSheet(
      isScrollControlled: true,
      MissingRiverLampPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MissingRiverLampController>(
      id: "MissingRiverLampController",
      init: MissingRiverLampController(),
      builder: (controller) {
        return Container(
          height: Get.height * 0.8,
          decoration: BoxDecoration(
            color: const Color(0xffF6F8FE),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.rpx),
              topRight: Radius.circular(20.rpx),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 50.rpx,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.rpx),
                      topRight: Radius.circular(20.rpx),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 40.rpx),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "思念河灯",
                            style: AppTextStyle.fs18b.copyWith(color: AppColor.brown26),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          width: 40.rpx,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.close,
                            color: Color(0xff684326),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(12.rpx),
                    children: [
                      SizedBox(
                        height: 112.rpx,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                if(state.votiveSkyLantern[index].isOpen){
                                  state.river = index;
                                  controller.getConfig(acquiesce: 1);
                                }
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: state.river == index
                                          ? AppColor.gold7
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8.rpx),
                                    ),
                                    width: 100.rpx,
                                    height: 100.rpx,
                                    margin: EdgeInsets.only(
                                        right: 8.rpx, bottom: 12.rpx),
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 92.rpx,
                                      width: 92.rpx,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.5.rpx,
                                              color: state.river == index
                                                  ? AppColor.gold8
                                                  : AppColor.gold7),
                                          borderRadius:
                                          BorderRadius.circular(8.rpx)),
                                      child: AppImage.network(
                                        state.votiveSkyLantern[index].image,
                                        width: 90.rpx,
                                        height: 90.rpx,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: !state.votiveSkyLantern[index].isOpen,
                                    child: Container(
                                      width: 100.rpx,
                                      height: 100.rpx,
                                      decoration: BoxDecoration(
                                        color: AppColor.gray33,
                                        borderRadius: BorderRadius.circular(8.rpx),
                                      ),
                                      alignment: Alignment.center,
                                      child: AppImage.network(state.votiveSkyLantern[index].openLevelIcon,width: 70.rpx,height: 24.rpx,),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: state.votiveSkyLantern.length,
                        ),
                        // child: ,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 8.rpx),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "左右滑动查看更多  ",
                              style: TextStyle(
                                  color: const Color(0xff666666),
                                  fontSize: 12.rpx),
                            ),
                            AppImage.asset(
                              'assets/images/wish_pavilion/homesick/slide.png',
                              width: 56.rpx,
                              height: 12.rpx,
                            ),
                          ],
                        ),
                      ),
                      state.votiveSkyLantern.isNotEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xffFFF1D5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.rpx))),
                              padding: EdgeInsets.only(
                                  top: 4.rpx,
                                  left: 12.rpx,
                                  right: 12.rpx,
                                  bottom: 8.rpx),
                              child: RichText(
                                text: TextSpan(
                                  text:
                                      "${state.votiveSkyLantern[state.river].name}\n",
                                  style: TextStyle(
                                      color: const Color(0xff8D310F),
                                      fontSize: 16.rpx,
                                      fontWeight: FontWeight.bold,
                                      height: 2),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: state
                                          .votiveSkyLantern[state.river].remark,
                                      style: TextStyle(
                                          color: const Color(0xff8D310F),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14.rpx,
                                          height: 1.4),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      Container(
                        margin: EdgeInsets.only(top: 12.rpx, bottom: 2.rpx),
                        child: Text(
                          "思念之情：",
                          style: AppTextStyle.fs16b
                              .copyWith(color: AppColor.gray5),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 1.rpx, color: AppColor.gray12),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.rpx))),
                        padding: EdgeInsets.only(
                            top: 6.rpx, bottom: 8.rpx, right: 6.rpx),
                        margin: EdgeInsets.only(bottom: 8.rpx),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputWidget(
                                hintText: '请写下您的思念或祝福',
                                lines: 5,
                                maxLength: 199,
                                counterText: '',
                                fillColor: Colors.white,
                                inputController: controller.missInputController,
                                onChanged: (val) {
                                  controller
                                      .update(['MissingRiverLampController']);
                                }),
                            Padding(
                              padding: EdgeInsets.all(6.rpx),
                              child: Row(
                                children: [
                                  Text(
                                    " ${controller.missInputController.text.length}/199",
                                    style: AppTextStyle.fs14m
                                        .copyWith(color: AppColor.gray9),
                                  ),
                                  const Spacer(),
                                  state.open == 1
                                      ? GestureDetector(
                                          onTap: () {
                                            controller.setOpen();
                                          },
                                          child: AppImage.asset(
                                            "assets/images/wish_pavilion/homesick/pitch_on.png",
                                            width: 20.rpx,
                                            height: 20.rpx,
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            controller.setOpen();
                                          },
                                          child: AppImage.asset(
                                            "assets/images/wish_pavilion/homesick/unselected.png",
                                            width: 20.rpx,
                                            height: 20.rpx,
                                          ),
                                        ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.setOpen();
                                    },
                                    child: Text(
                                      " 内容仅自己可见",
                                      style: AppTextStyle.fs14m
                                          .copyWith(color: AppColor.gray30),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Obx(() {
                        final agingCurrent =  state.agingCurrent.value;
                        return Row(
                          children: List.generate(
                              state.timeLimit.length > 4
                                  ? 4
                                  : state.timeLimit.length,
                                  (index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 8.rpx),
                                  child: buildAging(
                                      item: state.timeLimit[index],
                                      agingBool: agingCurrent ==
                                          state.timeLimit[index].id,
                                      callback: () {
                                        if(state.timeLimit[index].isOpen == true){
                                          state.agingCurrent.value =
                                              state.timeLimit[index].id;
                                        }
                                      }),
                                );
                              }),
                        );
                      }),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: 70.rpx,
                  padding: EdgeInsets.only(left: 12.rpx,right: 16.rpx),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UserLevelInfo(),
                      GestureDetector(
                        onTap: () {
                          controller.saveRecord();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.red1,
                            borderRadius: BorderRadius.circular(20.rpx),
                          ),
                          width: 160.rpx,
                          height: 40.rpx,
                          child: Center(
                            child: Text(
                              "确定",
                              style: AppTextStyle.fs16m.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //时效
  Widget buildAging(
      {Function? callback,
      required bool agingBool,
      required TimeConfigModel item}) {
    return GestureDetector(
      onTap: () {
        callback?.call();
      },
      child: Stack(
        children: [
          Container(
            width: 70.rpx,
            height: 70.rpx,
            decoration: BoxDecoration(
                color: agingBool ? AppColor.gold7 : Colors.white,
                border: Border.all(
                    width: 1.rpx,
                    color: agingBool ? AppColor.gold8 : AppColor.gray12),
                borderRadius: BorderRadius.all(Radius.circular(8.rpx))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  CommonUtils.getSecond(time: item.periodTime),
                  style: AppTextStyle.fs16b
                      .copyWith(color: agingBool ? AppColor.red1 : AppColor.gray30),
                ),
                Text(
                  "${item.levelSurplus ?? 0}/${item.levelCount ?? 0}",
                  style: AppTextStyle.fs16b.copyWith(
                      color: agingBool ? AppColor.red1 :  AppColor.gold),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !(item.isOpen ?? false),
            child: Container(
              width: 70.rpx,
              height: 70.rpx,
              decoration: BoxDecoration(
                color: AppColor.gray33,
                borderRadius: BorderRadius.circular(8.rpx),
              ),
              alignment: Alignment.center,
              child: AppImage.network(item.openLevelIcon ?? '',width: 70.rpx,height: 24.rpx,),
            ),
          ),
        ],
      ),
    );
  }
}
