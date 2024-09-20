import 'package:get/get.dart';
import 'package:talk_fo_me/common/network/api/model/talk_model.dart';

class UserCenterState {
  //作者id
  int authorId = 0;
  //是否关注
  bool isAttention = false;
  //作者信息
  UserModel authorInfo = UserModel.fromJson({});
  //创作数
  Map creation = {};
}
