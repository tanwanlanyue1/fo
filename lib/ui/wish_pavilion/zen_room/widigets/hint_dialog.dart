import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/extension/text_style_extension.dart';
import 'package:talk_fo_me/common/utils/screen_adapt.dart';

import '../../../../common/app_color.dart';
import '../../../../common/app_text_style.dart';
import '../../../../common/routes/app_pages.dart';
import '../../../../widgets/app_image.dart';

///提示弹窗
///tribute:是否贡品
///equally：是否相同
class HintDialog extends StatelessWidget {
  bool tribute;
  bool equally;
  Function? callBack;
  HintDialog({
    this.tribute = false,
    this.equally = false,
    this.callBack,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 326.rpx,
        height: 203.rpx,
        decoration: BoxDecoration(
          image: AppDecorations.backgroundImage(
              "assets/images/wish_pavilion/charm/dialog_top_up_bg.png"),
        ),
        child: Column(
          children: [
            SizedBox(height: 19.rpx),
            Text(
              "提示",
              style:
                  AppTextStyle.st.bold.size(18.rpx).textColor(AppColor.gray5),
            ),
            SizedBox(height: 24.rpx),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.rpx),
              child: Text(
                tribute?
                "已有供品，是否进行替换？":
                equally?
                "已有同款燃香，再次顶礼可自动累加时效。":
                "已有燃香，是否进行替换？如确定替换，则已有燃香的时效会被清除。",
                style:
                AppTextStyle.st.bold.size(14.rpx).textColor(AppColor.gray5),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    width: 121.rpx,
                    height: 39.rpx,
                    decoration: BoxDecoration(
                      image: AppDecorations.backgroundImage(
                        "assets/images/wish_pavilion/charm/dialog_cancel.png",
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "取消",
                      style: AppTextStyle.st.bold
                          .size(16.rpx)
                          .textColor(Colors.white),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    callBack?.call();
                  },
                  child: Container(
                    width: 121.rpx,
                    height: 39.rpx,
                    decoration: BoxDecoration(
                      image: AppDecorations.backgroundImage(
                        "assets/images/wish_pavilion/charm/dialog_confirm.png",
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tribute || !equally?
                      "确定替换":
                      "确定续时",
                      style: AppTextStyle.st.bold
                          .size(16.rpx)
                          .textColor(Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 31.rpx),
          ],
        ),
      ),
    );
  }
}
