import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/app_color.dart';
import 'package:talk_fo_me/common/app_text_style.dart';
import 'package:talk_fo_me/common/extension/list_extension.dart';
import 'package:talk_fo_me/common/extension/string_extension.dart';
import 'package:talk_fo_me/common/extension/text_style_extension.dart';
import 'package:talk_fo_me/common/service/service.dart';
import 'package:talk_fo_me/common/utils/screen_adapt.dart';
import 'package:talk_fo_me/ui/wish_pavilion/lights_pray/lights_pray_detail/lights_pray_detail_state.dart';
import 'package:talk_fo_me/widgets/app_image.dart';
import 'lights_pray_detail_controller.dart';

class LightsPrayDetailDialog extends GetView<LightsPrayDetailController> {
  LightsPrayDetailDialog({super.key});

  LightsPrayDetailState get state => controller.state;

  static void show(int lightId) {
    Get.dialog(
      GetBuilder<LightsPrayDetailController>(
        init: LightsPrayDetailController(lightId: lightId),
        builder: (controller) {
          return LightsPrayDetailDialog();
        },
      ),
      barrierDismissible: false,
      barrierColor: const Color(0x80000000),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = state.model;
    if (model == null) {
      return const SizedBox();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300.rpx,
          padding: EdgeInsets.symmetric(vertical: 20.rpx),
          decoration: BoxDecoration(
            image: AppDecorations.backgroundImage(
                "assets/images/wish_pavilion/lights_pray_detail_bg.png"),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  AppImage.asset(
                    "assets/images/wish_pavilion/lights_pray_detail_title.png",
                    width: 200.rpx,
                    height: 40.rpx,
                  ),
                  Text(
                    model.lanternName,
                    style: AppTextStyle.st.bold
                        .size(16.rpx)
                        .textColor(const Color(0xFFFBEDCE)),
                  ),
                ],
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: 100.rpx,
                  minHeight: 90.rpx,
                ),
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 12.rpx)
                    .copyWith(top: 12.rpx),
                padding:
                    EdgeInsets.symmetric(horizontal: 12.rpx, vertical: 10.rpx),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0D1),
                  borderRadius: BorderRadius.circular(8.rpx),
                ),
                child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "以此供灯功德回向：",
                                  style: AppTextStyle.st.medium
                                      .size(14.rpx)
                                      .textColor(const Color(0xFF666666)),
                                ),
                                Text(
                                  model.name,
                                  style: AppTextStyle.st.medium
                                      .size(12.rpx)
                                      .textColor(const Color(0xFF8D310F)),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.rpx),
                            model.open == 0 ?
                            Text(
                              model.back,
                              style: AppTextStyle.st.medium
                                  .size(14.rpx)
                                  .textColor(AppColor.gray5),
                            ):
                            Text(
                              "（供灯者选择不对外展示回向内容）",
                              style: AppTextStyle.st.medium
                                  .size(14.rpx)
                                  .textColor(const Color(0xFF666666)),
                            ),
                          ],
                        ),
                      ),
              ),
              Container(
                height: 20.rpx,
                margin: EdgeInsets.symmetric(horizontal: 12.rpx),
                alignment: Alignment.bottomRight,
                child: Visibility(
                  visible: model.uid == (SS.login.userId ?? 0),
                  child: Text(
                    "结束：${model.endTime}",
                    style: AppTextStyle.st.medium
                        .size(12.rpx)
                        .textColor(const Color(0xFF877556)),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 56.rpx,
                    height: 56.rpx,
                    decoration: BoxDecoration(
                        color: const Color(0x268D310F),
                        borderRadius: BorderRadius.circular(4.rpx)),
                    child: model.svga.isSvga
                        ? AppImage.networkSvga(
                            model.svga,
                            width: 56.rpx,
                            height: 56.rpx,
                          )
                        : AppImage.network(
                            model.lanternImg,
                            width: 56.rpx,
                            height: 56.rpx,
                          ),
                  ),
                  GestureDetector(
                    onTap: controller.onTapPraise,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 140.rpx,
                      height: 38.rpx,
                      decoration: BoxDecoration(
                        color: model.isBless
                            ? const Color(0x268D310F)
                            : AppColor.primary,
                        borderRadius: BorderRadius.circular(19.rpx),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!model.isBless)
                            Container(
                              margin: EdgeInsets.only(right: 4.rpx),
                              child: AppImage.asset(
                                "assets/images/wish_pavilion/lights_pray_detail_praise.png",
                                width: 24.rpx,
                                height: 24.rpx,
                              ),
                            ),
                          Text(
                            "阿弥陀佛",
                            style: AppTextStyle.st.medium
                                .size(16.rpx)
                                .textColor(Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.rpx),
              SizedBox(
                height: 30.rpx,
                child: model.blessAvatar.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Wrap(
                            spacing: -6.rpx,
                            children: List.generate(model.blessAvatar.length,
                                (index) {
                              final path =
                                  model.blessAvatar.safeElementAt(index);
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(15.rpx),
                                child: AppImage.network(
                                  path ?? "",
                                  width: 30.rpx,
                                  height: 30.rpx,
                                ),
                              );
                            }),
                          ),
                          SizedBox(width: 8.rpx),
                          Text(
                            "${model.bless}人",
                            style: AppTextStyle.st.medium
                                .size(14.rpx)
                                .textColor(AppColor.gray5),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.rpx),
        GestureDetector(
          onTap: Get.back,
          child: AppImage.asset(
            "assets/images/common/ic_dialog_close.png",
            width: 40.rpx,
            height: 40.rpx,
          ),
        ),
      ],
    );
  }
}
