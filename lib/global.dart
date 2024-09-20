import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/extension/string_extension.dart';
import 'package:talk_fo_me/common/network/config/server_config.dart';
import 'package:talk_fo_me/common/network/httpclient/http_client.dart';
import 'package:talk_fo_me/common/utils/app_logger.dart';
import 'package:talk_fo_me/ui/ad/ad_manager.dart';
import 'package:talk_fo_me/ui/welcome/welcome_storage.dart';
import 'package:talk_fo_me/widgets/lunar/lunar_manager.dart';
import 'package:wechat_kit/wechat_kit.dart';

import 'common/app_config.dart';
import 'common/app_localization.dart';
import 'common/database/app_database.dart';
import 'common/routes/app_pages.dart';
import 'common/service/service.dart';

/// 全局静态数据
class Global {
  Global._();

  static Completer<bool>? _completer;

  /// 初始化
  static Future<bool> initialize() async {
    if (_completer?.isCompleted == true) {
      return true;
    }
    final completer = _completer;
    if (completer != null) {
      return completer.future;
    }
    _completer = Completer<bool>();

    //android状态栏透明
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      );
    }

    try {
      //数据库初始化
      await AppDatabase.instance.initialize();

      //多语言支持
      await AppLocalization.instance.initialize();

      //TODO 循环过多，看怎么优化
      LunarManager.generateSolarYears();
      LunarManager.generateLunarYears();

      //网络请求客户端初始化
      HttpClient.initialize(
        authenticationHeaderProvider: getAuthorizedHeaders,
        onUnauthorized: () => SS.login.onUnauthorized(),
        logger: TBHttpClientLogger(
          responseHeader: false,
          responseBody: true,
          logPrint: AppLogger.d,
        ),
      );

      await WelcomeStorage.initialize();
      WelcomeStorage.saveAdFirstOpen([]);
      if(WelcomeStorage.isPrivacyAgree){
        await _initAfterPrivacyPolicy();
      }
    } catch (ex) {
      AppLogger.w(ex);
    }
    _completer?.complete(true);
    return true;
  }

  ///用户点击同意隐私政策
  static Future<void> agreePrivacyPolicy() async{
    await WelcomeStorage.savePrivacyAgree();
    await _initAfterPrivacyPolicy();
    Get.offNamed(AppRoutes.home);
  }


  ///用户同意隐私政策之后执行初始化，androidId，第三方sdk等敏感信息需要用户同意隐私政策才可以获取，否则应用市场审核不过
  static Future<void> _initAfterPrivacyPolicy() async {
    //初始化服务
    await SS.initServices();

    //广告
    await ADManager.instance.initialize();

    //微信SDK
    WechatKitPlatform.instance.registerApp(
      appId: AppConfig.wechatAppId,
      universalLink: AppConfig.iosUniversalLink,
    );
  }

  static Future<Map<String, dynamic>> getAuthorizedHeaders() async {
    final loginService = SS.login;

    final userId = loginService.userId;

    // 如果用户id为空，代表未登录，直接返回空Map
    if (userId == null) {
      return {};
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final token =
        "${loginService.token ?? ""}${loginService.userId ?? ""}$timestamp";

    final headers = <String, dynamic>{
      'timeStamp': timestamp,
      'userId': userId.toString(),
      "token": token.md5String,
    };

    return headers;
  }
}
