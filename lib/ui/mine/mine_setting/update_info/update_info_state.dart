import 'package:get/get.dart';
import 'package:talk_fo_me/common/service/service.dart';

class UpdateInfoState {
  final nickName = SS.login.info?.nickname ?? "";

  final synopsis = SS.login.info?.signature ?? "";

  // 是否能点击保存按钮
  var canSave = false;
}
