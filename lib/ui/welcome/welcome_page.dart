import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/app_color.dart';
import 'package:talk_fo_me/common/app_text_style.dart';
import 'package:talk_fo_me/common/utils/screen_adapt.dart';
import 'package:talk_fo_me/ui/welcome/privacy_dialog.dart';
import 'package:talk_fo_me/widgets/app_image.dart';
import 'package:talk_fo_me/widgets/widgets.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: FEdgeInsets(bottom: max(48.rpx, Get.mediaQuery.padding.bottom)),
        alignment: Alignment.bottomCenter,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AppAssetImage('assets/images/common/ls_welcome.png'),
          ),
        ),
        child: Button.image(
          onPressed: PrivacyDialog.show,
          width: 156.rpx,
          height: 42.rpx,
          image: AppImage.asset('assets/images/common/experience.png'),
          child: Text(
            "立即体验",
            style: AppTextStyle.fs18m.copyWith(
              color: AppColor.brown14,
            ),
          ),
        ),
      ),
    );
  }
}
