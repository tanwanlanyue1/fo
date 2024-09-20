
import 'package:flutter/material.dart';
import 'package:talk_fo_me/common/app_color.dart';
import 'package:talk_fo_me/common/app_text_style.dart';
import 'package:talk_fo_me/common/utils/screen_adapt.dart';
import 'package:talk_fo_me/widgets/app_image.dart';

///禅房圆形按钮
class ZenRoomCircleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const ZenRoomCircleButton({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.rpx,
        height: 48.rpx,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AppAssetImage('assets/images/wish_pavilion/zen_room/choose_fo_bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: DefaultTextStyle(
          style: AppTextStyle.fs12m.copyWith(
            color: AppColor.brown1,
            height: 1.3,
          ),
          child: child,
        ),
      ),
    );
  }
}
