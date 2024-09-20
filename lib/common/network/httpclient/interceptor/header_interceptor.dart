import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:talk_fo_me/common/utils/plugin_util.dart';
import 'package:talk_fo_me/common/utils/system_platform.dart';
import 'package:talk_fo_me/common/utils/app_info.dart';

///http请求头拦截器
class HeaderInterceptor extends Interceptor {
  final Locale? locale;
  const HeaderInterceptor(this.locale);

  static String? _deviceId;
  static String? _osName;
  static String? _osVersion;
  static String? _channel;
  static String? _appVersion;
  static String? _appVersionCode;
  static String? _brand;
  static String? _model;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll(await getAppHeaders());
    super.onRequest(options, handler);
  }

  ///android和iOS的请求头
  Future<Map<String, dynamic>> getAppHeaders() async {
    final lang = locale?.languageCode == 'en' ? 'en' : 'cn';
    _deviceId ??= await PluginUtil.getDeviceId();
    _osName ??= SystemPlatform.operatingSystem;
    _osVersion ??= await AppInfo.getOSVersion();
    _channel ??= AppInfo.channel;
    _appVersion ??= await AppInfo.getVersion();
    _appVersionCode ??= await AppInfo.getBuildNumber();
    _brand ??= await AppInfo.getBrand();
    _model ??= await AppInfo.getModel();

    return {
      'lang': lang,
      'deviceId': _deviceId,
      'osName': _osName,
      'osVersion': _osVersion,
      'channel': _channel,
      'appVersion': _appVersion,
      'appVersionCode': _appVersionCode,
      'brand': _brand,
      'model': _model,
    };
  }
}
