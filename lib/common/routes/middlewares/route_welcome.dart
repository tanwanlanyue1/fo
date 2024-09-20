import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/routes/app_pages.dart';
import 'package:talk_fo_me/ui/ad/ad_manager.dart';
import 'package:talk_fo_me/ui/welcome/welcome_storage.dart';


/// 第一次欢迎页面
class RouteWelcomeMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route){
    if (!WelcomeStorage.isPrivacyAgree) {
      return null;
    } else {
      if(ADManager.instance.getLaunchAd() != null){
        return const RouteSettings(name: AppRoutes.launchAd);
      }
      return const RouteSettings(name: AppRoutes.home);
    }
  }
}
