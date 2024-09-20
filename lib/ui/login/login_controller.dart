import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:talk_fo_me/common/app_config.dart';
import 'package:talk_fo_me/common/extension/get_extension.dart';
import 'package:talk_fo_me/common/network/api/api.dart';
import 'package:talk_fo_me/common/routes/app_pages.dart';
import 'package:talk_fo_me/common/service/service.dart';
import 'package:talk_fo_me/common/utils/app_logger.dart';
import 'package:talk_fo_me/common/utils/result.dart';
import 'package:talk_fo_me/ui/login/widgets/privacy_policy_dialog.dart';
import 'package:talk_fo_me/widgets/loading.dart';
import 'package:talk_fo_me/widgets/web/web_page.dart';
import 'package:wechat_kit/wechat_kit.dart';
import 'login_state.dart';
import 'one_key_login_manager.dart';

class LoginController extends GetxController with GetAutoDisposeMixin {
  final LoginState state = LoginState();

  // 验证码
  TextEditingController accountController = TextEditingController();
  TextEditingController smsCodeController = TextEditingController();

  // 密码
  TextEditingController passwordAccountController = TextEditingController();
  TextEditingController passwordCodeController = TextEditingController();

  // 注册专用
  TextEditingController registerAccountController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController registerConfirmPasswordController =
      TextEditingController();

  // 协议点击手势
  TapGestureRecognizer protocolProtocolRecognizer = TapGestureRecognizer();
  TapGestureRecognizer privacyProtocolRecognizer = TapGestureRecognizer();

  final _oneKeyLoginManager = OneKeyLoginManager();

  Timer? _timer;
  var _remainingSeconds = 60;

  void changeVisible() {
    state.isVisible.value = !state.isVisible.value;
  }

  void onTapToProtocol() {
    WebPage.go(url: AppConfig.urlUserService, title: '用户服务协议');
  }

  void onTapToPrivacy() {
    WebPage.go(url: AppConfig.urlPrivacyPolicy, title: '隐私政策');
  }

  void changeSelectPrivacy() {
    state.isSelectPrivacy.value = !state.isSelectPrivacy.value;
  }

  void onTapToUpdatePasswordPage() async {
    Get.toNamed(AppRoutes.updatePasswordPage);
  }

  void onTapToAccountRegisterPage() async {
    Get.toNamed(AppRoutes.loginPage,
        arguments: {"type": 2}, preventDuplicates: false);
  }

  void onTapToPasswordLoginPage() {
    Get.toNamed(AppRoutes.loginPage,
        arguments: {"type": 1}, preventDuplicates: false);
  }

  void onAppleLogin() async {
    if (!(await _verifyPrivacy())) return;

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
      ],
    );
    final userIdentifier = credential.userIdentifier ?? '';
    final identityToken = credential.identityToken ?? '';
    if (userIdentifier.isEmpty) {
      AppLogger.w('苹果登录userIdentifier为空');
      return;
    }

    Loading.show();

    //查询是否已绑定手机
    final response =
        await OpenApi.checkBindPhone(type: 2, code: userIdentifier);
    if (!response.isSuccess) {
      Loading.dismiss();
      response.showErrorMessage();
      return;
    }
    //未绑定手机，则先绑定
    if (response.data != true) {
      Loading.dismiss();
      Get.toNamed(AppRoutes.loginPhoneBindingPage, arguments: {
        'code': identityToken,
        'userIdentifier': userIdentifier,
        'identityToken': identityToken,
        'loginType': 6,
      });
      return;
    }

    final result = await SS.login.loginByApple(
      userIdentifier: userIdentifier,
      identityToken: identityToken,
    );
    Loading.dismiss();
    result.when(success: (_) {
      Get.backToRoot();
    }, failure: (errorMessage) {
      Loading.showToast(errorMessage);
    });
  }

  void onFetchSms() async {
    FocusScope.of(Get.context!).unfocus();

    if (accountController.text.isEmpty) {
      Loading.showToast("请输入手机号码");
      return;
    }

    Loading.show();
    final res = await SS.login.fetchSms(phone: accountController.text);
    Loading.dismiss();
    res.when(success: (_) {
      Loading.showToast("短信发送成功");
      _startTimer();
    }, failure: (errorMessage) {
      Loading.showToast(errorMessage);
    });
  }

  ///微信登录
  void onWechatLogin() async {
    if (!(await _verifyPrivacy())) return;

    await WechatKitPlatform.instance.auth(scope: ['snsapi_userinfo']);
    final resp = await WechatKitPlatform.instance.respStream().first;
    if (resp is WechatAuthResp) {
      final code = resp.code;
      if (code == null || code.isEmpty) {
        return;
      }
      Loading.show();

      //查询是否已绑定手机
      final response = await OpenApi.checkBindPhone(type: 1, code: code);
      if (!response.isSuccess) {
        Loading.dismiss();
        response.showErrorMessage();
        return;
      }
      //未绑定手机，则先绑定
      if (response.data != true) {
        Loading.dismiss();
        Get.toNamed(AppRoutes.loginPhoneBindingPage, arguments: {
          'code': code,
          'loginType': 3,
        });
        return;
      }

      final result = await SS.login.loginByWeChat(code: code);
      Loading.dismiss();
      result.when(success: (_) {
        Get.backToRoot();
      }, failure: (errorMessage) {
        Loading.showToast(errorMessage);
      });
    }
  }

  ///本机号码一键登录
  void onOneKeyLogin() async {
    if (!(await _verifyPrivacy())) return;

    _oneKeyLoginManager.openAuthPage(
      isPhoneBinding: false,
    );
  }

  void onLogin(int type) async {
    FocusScope.of(Get.context!).unfocus();

    if (!(await _verifyPrivacy())) return;

    if (type == 2) {
      if (registerPasswordController.text !=
          registerConfirmPasswordController.text) {
        Loading.showToast("两次输入的密码不一致");
        return;
      }
    }

    Loading.show();

    Result<void, String> result;
    if (type == 0) {
      result = await SS.login.loginByVerifyCode(
        phone: accountController.text,
        verifyCode: smsCodeController.text,
      );
    } else if (type == 1) {
      result = await SS.login.loginByPassword(
        phone: passwordAccountController.text,
        password: passwordCodeController.text,
      );
    } else {
      result = await SS.login.loginByRegister(
        account: registerAccountController.text,
        password: registerPasswordController.text,
      );
    }
    Loading.dismiss();
    result.when(success: (_) {
      Get.backToRoot();
    }, failure: (errorMessage) {
      Loading.showToast(errorMessage);
    });
  }

  bool _isValidAccountText(String text) {
    final onlyAlphabeticRegex = RegExp(r'^[a-zA-Z]+$');
    final onlyNumericRegex = RegExp(r'^[0-9]+$');
    final onlySpecialCharRegex = RegExp(r'^[^a-zA-Z0-9]+$');

    return !(onlyAlphabeticRegex.hasMatch(text) ||
        onlyNumericRegex.hasMatch(text) ||
        onlySpecialCharRegex.hasMatch(text));
  }

  bool _isValidPasswordText(String text) {
    final hasAlphabetic = RegExp(r'[a-zA-Z]').hasMatch(text);
    final hasNumeric = RegExp(r'[0-9]').hasMatch(text);
    final onlyAlphaNumeric = RegExp(r'^[a-zA-Z0-9]+$').hasMatch(text);

    return hasAlphabetic && hasNumeric && onlyAlphaNumeric;
  }

  void _startTimer() {
    _resetCountdown();

    state.isCountingDown.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        state.smsButtonText.value = "${_remainingSeconds}s";
      } else {
        _resetCountdown();
      }
    });
  }

  void _resetCountdown() {
    _timer?.cancel();
    _timer = null;

    _remainingSeconds = 60;
    state.isCountingDown.value = false;
    state.smsButtonText.value = "获取验证码";
  }

  // 校验是否点击下方协议
  Future<bool> _verifyPrivacy() async {
    if (!state.isSelectPrivacy.value) {
      final res = await PrivacyPolicyDialog.show();
      if (!(res ?? false)) return false;

      state.isSelectPrivacy.value = true;
      return true;
    }
    return true;
  }

  ///初始化一键登录
  void _initOneKeyLogin() {
    autoCancel(_oneKeyLoginManager.onEnvAvailableStream.listen((isAvailable) {
      state.hasOneKeyLogin.value = isAvailable;
    }));

    autoCancel(
        _oneKeyLoginManager.onFetchTokenSuccessStream.listen((token) async {
      Loading.show();
      final result = await SS.login.loginByOneKey(token);
      Loading.dismiss();
      result.when(success: (_) {
        Get.backToRoot();
      }, failure: (errorMessage) {
        Loading.showToast(errorMessage);
      });
    }));

    _oneKeyLoginManager.initialize();
  }

  void _smsTextChanged() {
    state.isSmsReady.value =
        accountController.text.isNotEmpty && smsCodeController.text.isNotEmpty;
  }

  void _passwordTextChanged() {
    state.isPasswordReady.value = passwordAccountController.text.isNotEmpty &&
        passwordCodeController.text.isNotEmpty;
  }

  void _registerTextChanged() {
    state.isRegisterReady.value = registerAccountController.text.isNotEmpty &&
        registerPasswordController.text.isNotEmpty &&
        registerConfirmPasswordController.text.isNotEmpty;

    state.isRegisterAccountReady.value =
        registerAccountController.text.isNotEmpty;
  }

  @override
  void onInit() async {
    accountController.addListener(_smsTextChanged);
    smsCodeController.addListener(_smsTextChanged);

    passwordAccountController.addListener(_passwordTextChanged);
    passwordCodeController.addListener(_passwordTextChanged);

    registerAccountController.addListener(_registerTextChanged);
    registerPasswordController.addListener(_registerTextChanged);
    registerConfirmPasswordController.addListener(_registerTextChanged);
    _initOneKeyLogin();

    state.hasWXLogin.value = await WechatKitPlatform.instance.isInstalled();
    super.onInit();
  }

  @override
  void onClose() {
    accountController.removeListener(_smsTextChanged);
    smsCodeController.removeListener(_smsTextChanged);

    passwordAccountController.removeListener(_passwordTextChanged);
    passwordCodeController.removeListener(_passwordTextChanged);

    registerAccountController.removeListener(_registerTextChanged);
    registerPasswordController.removeListener(_registerTextChanged);
    registerConfirmPasswordController.removeListener(_registerTextChanged);

    accountController.dispose();
    smsCodeController.dispose();

    passwordAccountController.dispose();
    passwordCodeController.dispose();

    registerAccountController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();

    protocolProtocolRecognizer.dispose();
    privacyProtocolRecognizer.dispose();

    _oneKeyLoginManager.dispose();
    _timer?.cancel();

    super.onClose();
  }
}
