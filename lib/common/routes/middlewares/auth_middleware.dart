import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/routes/app_pages.dart';
import 'package:talk_fo_me/common/service/login_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => -999;

  @override
  RouteSettings? redirect(String? route) {
    if (route == null || route.isEmpty) return null;

    if (!route.contains("/auth/")) return null;

    final service = Get.find<LoginService>();
    return service.isLogin ? null : const RouteSettings(name: AppRoutes.loginPage);
  }
}
