import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/extension/get_extension.dart';
import 'package:talk_fo_me/common/network/api/api.dart';
import 'package:talk_fo_me/common/routes/app_pages.dart';
import 'package:talk_fo_me/common/utils/local_storage.dart';
import 'package:talk_fo_me/common/utils/result.dart';
import 'package:talk_fo_me/ui/home/home_page.dart';
import 'package:talk_fo_me/widgets/loading.dart';
import 'package:talk_fo_me/widgets/widgets.dart';

import '../event/login_event.dart';
import 'service.dart';

/// 登录服务
/// 当用户完成请求完登录、绑定信息、获取等级境修币信息、用户基本信息才为成功登录，
/// 并保存用户数据到本地，全局可通过loginService全局调用。
/// 📢：isLogin 的改变是在请求完登录、获取其他各种用户信息之后才改变为登录状态
class LoginService extends GetxService {
  /// Open

  // 用户是否登录, 外部可通过obx监听改变
  bool get isLogin => _isLogin.value;

  // 当前登录用户信息, 外部可通过obx监听改变
  UserModel? get info => _info.value;

  // 提供外部修改用户信息
  void setInfo(void Function(UserModel? val) fn) {
    _info.update(fn);
  }

  // 当前登录用户绑定信息, 外部可通过obx监听改变
  BindingRes? get bindingInfo => _bindingInfo.value;

  // 当前登录用户等级境修币信息, 外部可通过obx监听改变
  LevelMoneyRes? get levelMoneyInfo => _levelMoneyInfo.value;

  // 用户 id
  int? get userId => _loginRes?.userId;

  // 用户 token
  String? get token => _loginRes?.token;

  /// Private 防止外部修改

  // 当前用户登录模型
  LoginRes? _loginRes;

  // 当前用户信息
  final Rxn<UserModel> _info = Rxn<UserModel>();

  // 当前用户绑定信息
  final Rxn<BindingRes> _bindingInfo = Rxn<BindingRes>();

  // 当前用户等级和境修币信息
  final Rxn<LevelMoneyRes> _levelMoneyInfo = Rxn<LevelMoneyRes>();

  // 用户是否登录
  final _isLogin = false.obs;

  static const _kLoginData = 'loginData';
  static const _kUserData = 'userData';
  static const _kBindingData = 'bindingData';
  static const _kLevelMoneyData = 'levelMoneyData';
  final _localStorage = LocalStorage('LoginService');

  Future<LoginService> init() async {
    final loginData = await _localStorage.getJson(_kLoginData);
    final userData = await _localStorage.getJson(_kUserData);
    final bindingData = await _localStorage.getJson(_kBindingData);
    final levelMoneyData = await _localStorage.getJson(_kLevelMoneyData);

    if (loginData == null ||
        userData == null ||
        bindingData == null ||
        levelMoneyData == null) {
      _isLogin.value = false;
      return this;
    }

    _isLogin.value = true;

    _loginRes = LoginRes.fromJson(loginData);
    _info.value = UserModel.fromJson(userData);
    _bindingInfo.value = BindingRes.fromJson(bindingData);
    _levelMoneyInfo.value = LevelMoneyRes.fromJson(levelMoneyData);

    return this;
  }

  ///需要登录授权才会执行runnable，否则跳转登录页
  void requiredAuthorized(VoidCallback runnable,
      {VoidCallback? onUnauthorized}) {
    if (isLogin) {
      runnable();
    } else {
      Loading.showToast('请先登录');
      Get.toNamed(AppRoutes.loginPage);
      onUnauthorized?.call();
    }
  }

  ///密码登录
  ///- phone 手机号
  ///- password 密码
  Future<Result<void, String>> loginByPassword({
    required String phone,
    required String password,
  }) {
    return _login(
      phone: phone,
      password: password,
      loginType: 1,
    );
  }

  ///验证码登录
  Future<Result<void, String>> loginByVerifyCode({
    required String phone,
    required String verifyCode,
  }) {
    return _login(
      phone: phone,
      verifyCode: verifyCode,
      loginType: 2,
    );
  }

  ///注册登录
  Future<Result<void, String>> loginByRegister({
    required String account,
    required String password,
  }) {
    return _login(
      phone: account,
      password: password,
      loginType: 5,
    );
  }

  ///本机号码一键登录
  ///- token 取号token
  Future<Result<void, String>> loginByOneKey(String token) {
    return _login(
      loginType: 4,
      code: token,
    );
  }

  ///微信登录
  ///- code 授权code
  ///- phone 手机号
  ///- verifyCode 验证码
  Future<Result<void, String>> loginByWeChat({
    required String code,
    String? phone,
    String? verifyCode,
  }) {
    return _login(
      phone: phone,
      verifyCode: verifyCode,
      loginType: 3,
      code: code,
    );
  }

  ///Apple登录
  ///- userIdentifier 用户唯一标识
  ///- identityToken 授权token
  ///- phone 手机号
  ///- verifyCode 验证码
  Future<Result<void, String>> loginByApple({
    required String userIdentifier,
    required String identityToken,
    String? phone,
    String? verifyCode,
  }) {
    return _login(
      phone: phone,
      verifyCode: verifyCode,
      loginType: 6,
      userIdentifier: userIdentifier,
      identityToken: identityToken,
    );
  }

  /// 用户登录
  ///- phone: 用户手机号
  ///- loginType：用户登录类型(1:密码登录,2:验证码登录,3:微信登录,4:一键登录,5:注册账号)
  ///- password：用户密码
  ///- verifyCode：验证码
  ///- code：第三方登录code
  /// return 错误信息
  Future<Result<void, String>> _login({
    required int loginType,
    String? phone,
    String? password,
    String? verifyCode,
    String? code,
    String? userIdentifier,
    String? identityToken,
  }) async {
    // 先请求登录接口
    final res = await OpenApi.login(
      phone: phone,
      loginType: loginType,
      password: password,
      verifyCode: verifyCode,
      code: code,
      appleId: userIdentifier,
      identityToken: identityToken,
    );

    if (!res.isSuccess) {
      return ResultFailure(res.errorMessage ?? "data error");
    }

    final loginRes = res.data;
    if (loginRes == null || loginRes.token.isEmpty || loginRes.userId == 0) {
      await _clearData();
      return const ResultFailure("data error");
    }

    // 保存登录信息, 后续接口需要根据请求头参数进行校验，保证先存到本地
    await _setupLoginData(loginRes: loginRes);

    // 获取并保存绑定信息
    final bindingRes = await fetchBindingInfo();
    final bindingProcess = await bindingRes.whenAsync(success: (res) async {
      // 保存用户绑定信息
      await _setupBindingData(res: res);
      return null;
    }, failure: (errorMessage) async {
      await _clearData();
      return errorMessage;
    });

    if (bindingProcess != null) {
      return ResultFailure(bindingProcess);
    }

    // 获取并保存等级境修币信息
    final levelMoneyRes = await fetchLevelMoneyInfo();
    final levelMoneyProcess = await levelMoneyRes.whenAsync(success: (_) async {
      return null;
    }, failure: (errorMessage) async {
      await _clearData();
      return errorMessage;
    });

    if (levelMoneyProcess != null) {
      return ResultFailure(levelMoneyProcess);
    }

    // 获取用户信息并修改登录状态
    return await fetchMyInfo()
        .then((value) => value.whenAsync(success: (_) async {
              // 修改登录状态
              _isLogin.value = true;
              LoginEvent(true).emit();
              return const ResultSuccess(null);
            }, failure: (errorMessage) async {
              await _clearData();
              return ResultFailure(errorMessage);
            }));
  }

  /// 根据id获取用户信息
  /// userId: 用户id
  Future<Result<UserModel, String>> fetchInfo({
    required int userId,
  }) async {
    final res = await UserApi.info(uid: userId);
    if (!res.isSuccess) {
      return ResultFailure(res.errorMessage ?? "data error");
    }

    final data = res.data;
    if (data == null) {
      return const ResultFailure("data error");
    }

    return ResultSuccess(data);
  }

  /// 获取当前用户信息（默认自动保存）
  /// autoSave: 是否自动保存到本地
  Future<Result<UserModel, String>> fetchMyInfo({
    bool autoSave = true,
  }) async {
    final res = await fetchInfo(userId: userId ?? 0);
    res.whenAsync(
        success: (user) async {
          // 保存当前用户信息
          await _setupUserData(userModel: user);
        },
        failure: (_) async {});
    return res;
  }

  /// 获取绑定信息（默认自动保存）
  /// autoSave: 是否自动保存到本地
  Future<Result<BindingRes, String>> fetchBindingInfo(
      {bool autoSave = true}) async {
    final res = await UserApi.getBindingInfo();
    if (!res.isSuccess) {
      return ResultFailure(res.errorMessage ?? "data error");
    }

    final data = res.data;
    if (data == null) {
      return const ResultFailure("data error");
    }

    if (autoSave) await _setupBindingData(res: data);

    return ResultSuccess(data);
  }

  /// 获取等级境修币信息（默认自动保存）
  /// autoSave: 是否自动保存到本地
  Future<Result<LevelMoneyRes, String>> fetchLevelMoneyInfo(
      {bool autoSave = true}) async {
    final res = await UserApi.getLevelAndMoney();
    if (!res.isSuccess) {
      return ResultFailure(res.errorMessage ?? "data error");
    }

    final data = res.data;
    if (data == null) {
      return const ResultFailure("data error");
    }

    if (autoSave) await _setupLevelMoneyData(res: data);

    return ResultSuccess(data);
  }

  /// 用户退出登录
  /// - userAction 是否是用户主动点击退出登录
  Future<Result<void, String>> signOut({bool userAction = true}) async {
    if(userAction){
      final res = await UserApi.signOut();
      // 清空数据
      await _clearData();
      LoginEvent(false).emit();
      if (!res.isSuccess) {
        return ResultFailure(res.errorMessage ?? "data error");
      }
    }else{
      // 清空数据
      await _clearData();
      LoginEvent(false).emit();
    }
    return const ResultSuccess(null);
  }

  /// 发送手机验证码
  /// phone: 用户手机号
  Future<Result<void, String>> fetchSms({
    required String phone,
  }) async {
    final res = await OpenApi.sms(account: phone);
    if (!res.isSuccess) {
      return ResultFailure(res.errorMessage ?? "data error");
    }

    return const ResultSuccess(null);
  }

  /// 忘记密码或者修改密码
  /// phone: 用户手机号
  /// verifyCode：验证码
  /// password：用户密码
  /// confirmPassword：确认密码
  Future<Result<void, String>> forgotOrResetPassword({
    required String phone,
    required String verifyCode,
    required String password,
    required String confirmPassword,
  }) async {
    final res = await OpenApi.forgotOrResetPassword(
      phone: phone,
      verifyCode: verifyCode,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (!res.isSuccess) {
      return ResultFailure(res.errorMessage ?? "data error");
    }

    return const ResultSuccess(null);
  }

  Future<void> _setupLoginData({
    required LoginRes loginRes,
  }) async {
    await _localStorage.setJson(_kLoginData, loginRes.toJson());

    _loginRes = loginRes;
  }

  Future<void> _setupUserData({
    required UserModel userModel,
  }) async {
    await _localStorage.setJson(_kUserData, userModel.toJson());

    _info.value = userModel;
  }

  Future<void> _setupBindingData({
    required BindingRes res,
  }) async {
    await _localStorage.setJson(_kBindingData, res.toJson());

    _bindingInfo.value = res;
  }

  Future<void> _setupLevelMoneyData({
    required LevelMoneyRes res,
  }) async {
    await _localStorage.setJson(_kLevelMoneyData, res.toJson());

    _levelMoneyInfo.value = res;
  }

  Future<void> _clearData() async {
    await _localStorage.remove(_kLoginData);
    await _localStorage.remove(_kUserData);
    await _localStorage.remove(_kBindingData);
    await _localStorage.remove(_kLevelMoneyData);

    _loginRes = null;
    _info.value = null;
    _bindingInfo.value = null;
    _levelMoneyInfo.value = null;

    _isLogin.value = false;
  }

  ///用户未登录，接口401回调
  void onUnauthorized() async {
    if(!isLogin || ConfirmDialog.isVisible){
      //如果用户本来就没有登录，则不需要弹窗提示
      return;
    }
    final result = await ConfirmDialog.show(
      message: const Text('登录已过期，请重新登录'),
      okButtonText: const Text('重新登录'),
    );
    await signOut(userAction: false);
    Get.backToRoot();
    if (result) {
      Future.delayed(
        const Duration(milliseconds: 100),
            () => Get.toNamed(AppRoutes.loginPage),
      );
    }
  }
}
