import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/app_color.dart';
import 'package:talk_fo_me/common/app_text_style.dart';
import 'package:talk_fo_me/common/extension/list_extension.dart';
import 'package:talk_fo_me/common/extension/string_extension.dart';
import 'package:talk_fo_me/common/extension/text_style_extension.dart';
import 'package:talk_fo_me/common/utils/common_utils.dart';
import 'package:talk_fo_me/common/utils/screen_adapt.dart';
import 'package:talk_fo_me/widgets/input_widget.dart';
import 'package:talk_fo_me/widgets/user_level_info.dart';
import 'package:talk_fo_me/widgets/widgets.dart';
import '../../../../widgets/app_image.dart';
import 'lights_pray_invitation_controller.dart';

class LightsPrayInvitationPage extends StatelessWidget {
  final int position;
  final int direction;

  LightsPrayInvitationPage(
      {super.key, required this.position, required this.direction});

  final controller = Get.put(LightsPrayInvitationController());
  final state = Get.find<LightsPrayInvitationController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: AppBackButton.light(),
      ),
      body: Container(
        color: const Color(0xFFF6F1E7),
        child: Column(
          children: [
            Stack(
              children: [
                AppImage.asset(
                  "assets/images/wish_pavilion/lights_pray_bg.png",
                  height: 200.rpx,
                ),
              ],
            ),
            Expanded(
              child: Obx(() {
                final model =
                    state.lights.safeElementAt(state.selectIndex.value);

                final day =
                    CommonUtils.getSecondToDay(time: model?.periodTime ?? 0);

                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: 12.rpx).copyWith(
                    bottom: Get.mediaQuery.padding.bottom + 12.rpx,
                  ),
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.rpx),
                      alignment: Alignment.center,
                      child: Text(
                        "请灯",
                        style: AppTextStyle.st.bold
                            .size(16.rpx)
                            .textColor(AppColor.gray5),
                      ),
                    ),
                    _buildLightsItem(),
                    Container(
                      margin: EdgeInsets.only(top: 12.rpx),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.rpx, horizontal: 12.rpx),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBE2CF),
                        borderRadius: BorderRadius.circular(8.rpx),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                model?.name ?? "",
                                style: AppTextStyle.st.bold
                                    .size(16.rpx)
                                    .textColor(const Color(0xFF8D310F)),
                              ),
                              Text(
                                "可持续$day天",
                                style: AppTextStyle.st.medium
                                    .size(12.rpx)
                                    .textColor(AppColor.gray9),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.rpx),
                          Text(
                            model?.remark ?? "",
                            style: AppTextStyle.st.medium
                                .size(14.rpx)
                                .textColor(AppColor.gray5),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16.rpx),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "*",
                              style:
                                  AppTextStyle.st.medium.size(14.rpx).textColor(
                                        const Color(0xFF8D310F),
                                      ),
                              children: [
                                TextSpan(
                                  text: "供灯者姓名",
                                  style: AppTextStyle.st.textColor(
                                    AppColor.gray5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 46.rpx,
                            margin: EdgeInsets.only(top: 8.rpx),
                            padding: EdgeInsets.symmetric(horizontal: 12.rpx),
                            decoration: BoxDecoration(
                              // color: Colors.yellow,
                              border: Border.all(
                                color: const Color(0xFFEBE2CF),
                              ),
                              borderRadius: BorderRadius.circular(8.rpx),
                            ),
                            alignment: Alignment.center,
                            child: TextField(
                              controller: controller.nameController,
                              style: TextStyle(
                                fontSize: 14.rpx,
                                color: AppColor.gray5,
                              ),
                              decoration: InputDecoration(
                                hintText: "请输入您的真实姓名",
                                hintStyle: AppTextStyle.st.medium
                                    .size(14.rpx)
                                    .textColor(AppColor.gray9),
                                border: InputBorder.none,
                                // contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12.rpx),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "*",
                              style:
                                  AppTextStyle.st.medium.size(14.rpx).textColor(
                                        const Color(0xFF8D310F),
                                      ),
                              children: [
                                TextSpan(
                                  text: "生辰",
                                  style: AppTextStyle.st.textColor(
                                    AppColor.gray5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.onTapChooseBirth,
                            child: Container(
                              height: 46.rpx,
                              margin: EdgeInsets.only(top: 8.rpx),
                              padding: EdgeInsets.symmetric(horizontal: 12.rpx),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFEBE2CF),
                                ),
                                borderRadius: BorderRadius.circular(8.rpx),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Obx(() {
                                final style =
                                    AppTextStyle.st.medium.size(14.rpx);
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      state.birthday.isEmpty
                                          ? "请选择您的生辰"
                                          : state.birthday.value,
                                      style: state.birthday.isEmpty
                                          ? style.textColor(AppColor.gray9)
                                          : style.textColor(AppColor.gray5),
                                    ),
                                    AppImage.asset(
                                      "assets/images/common/ic_arrow_right_black.png",
                                      height: 20.rpx,
                                      width: 20.rpx,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12.rpx),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "*",
                                  style: AppTextStyle.st.medium
                                      .size(14.rpx)
                                      .textColor(
                                        const Color(0xFF8D310F),
                                      ),
                                  children: [
                                    TextSpan(
                                      text: "供灯回向",
                                      style: AppTextStyle.st.textColor(
                                        AppColor.gray5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => controller.onChangeOpen(),
                                child: Wrap(
                                  spacing: 6.rpx,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    AppImage.asset(
                                      state.isOpen.value
                                          ? "assets/images/wish_pavilion/lights_pray_choose_normal.png"
                                          : "assets/images/wish_pavilion/lights_pray_choose_select.png",
                                      height: 14.rpx,
                                      width: 14.rpx,
                                    ),
                                    Text(
                                      "内容供自己可见",
                                      style: AppTextStyle.st.medium
                                          .size(12.rpx)
                                          .textColor(AppColor.gray9),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => FocusScope.of(context)
                                .requestFocus(controller.contentFocusNode),
                            child: Container(
                              margin: EdgeInsets.only(top: 8.rpx),
                              padding: EdgeInsets.symmetric(horizontal: 12.rpx),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFEBE2CF),
                                ),
                                borderRadius: BorderRadius.circular(8.rpx),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10.rpx),
                                  Text(
                                    "以此供灯功德回向：",
                                    style: AppTextStyle.st.medium
                                        .size(14.rpx)
                                        .textColor(const Color(0xFF666666)),
                                  ),
                                  InputWidget(
                                    hintText: state.defaultContent,
                                    lines: 3,
                                    fillColor: Colors.transparent,
                                    inputController:
                                        controller.contentController,
                                    focusNode: controller.contentFocusNode,
                                    contentPadding: EdgeInsets.only(
                                        top: 6.rpx, bottom: 10.rpx),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(150),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
            Obx(() {
              final model =
              state.lights.safeElementAt(state.selectIndex.value);
              return Stack(
                children: [
                  Container(
                    color: Colors.white,
                    height: 70.rpx,
                    padding: EdgeInsets.only(left: 12.rpx,right: 16.rpx),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        UserLevelInfo(),
                        GestureDetector(
                          onTap: () => controller.onTapInvitation(
                              position: position, direction: direction),
                          child: Container(
                            height: 42.rpx,
                            width: 160.rpx,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8D310F),
                              borderRadius:
                              BorderRadius.circular(21.rpx),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "虔诚恭请",
                                  style: AppTextStyle.st.medium
                                      .size(16.rpx)
                                      .textColor(Colors.white),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 8.rpx,left: 16.rpx),
                                  child: Text(
                                    "(${model?.levelSurplus ?? 0}/${model?.levelCount ?? 0})",
                                    style: AppTextStyle.st.medium
                                        .size(12.rpx)
                                        .textColor(Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 16.rpx,
                    bottom: 40.rpx,
                    child: IgnorePointer(
                      child: Container(
                        width: 70.rpx,
                        height: 26.rpx,
                        decoration: BoxDecoration(
                            image: AppDecorations.backgroundImage(
                                "assets/images/wish_pavilion/lights_pray_bubble.png")),
                        alignment: Alignment.topCenter,
                        child: RichText(
                          text: TextSpan(
                            text: "恭请 ",
                            style: AppTextStyle.st.medium
                                .size(12.rpx)
                                .textColor(
                              const Color(0xFF8D310F),
                            ),
                            children: [
                              TextSpan(
                                text: "${CommonUtils.getSecondToDay(time: model?.periodTime ?? 0)}",
                                style: AppTextStyle.st.bold
                                    .size(16.rpx)
                                    .textColor(AppColor.brown36,),
                              ),
                              const TextSpan(
                                text: " 天",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLightsItem() {
    final length = 56.rpx;
    return SizedBox(
      height: 68.rpx,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.lights.length,
        itemBuilder: (BuildContext context, int index) {
          final model = state.lights[index];
          return GestureDetector(
            onTap: () {
              if(model.isOpen){
                controller.onChangeSelect(index);
              }
            },
            child: Stack(
              children: [
                Container(
                  width: 70.rpx,
                  height: 68.rpx,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: length,
                    width: length,
                    decoration: BoxDecoration(
                      color: const Color(0x268D310F),
                      borderRadius: BorderRadius.circular(4.rpx),
                      border: state.selectIndex.value == index
                          ? Border.all(color: const Color(0xFF8D310F))
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: model.svga.isSvga
                        ? AppImage.networkSvga(
                      model.svga,
                      width: length,
                      height: length,
                    )
                        : AppImage.network(
                      model.image,
                      width: length,
                      height: length,
                    ),
                  ),
                ),
                Visibility(
                  visible: !model.isOpen,
                  child: Positioned(
                    top: 0,
                    child: AppImage.network(model.openLevelIcon,width: 70.rpx,height: 24.rpx,),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
