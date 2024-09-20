import 'package:get/get.dart';
import 'package:talk_fo_me/common/service/service.dart';

import '../../../../common/network/api/model/talk_model.dart';

class MissingRiverLampState {
  //选择的河灯下标
  int river = 0;
  //时效id
  final agingCurrent = Rxn<int>();
  //是否公开
  int open = 0;

  ///河灯-列表
  List<GiftModel> votiveSkyLantern = [];

  //默认时限
  List<TimeConfigModel> timeLimit = [];

  //全部的时限
  List<TimeConfigModel> allTime = [];

  final levelMoneyInfo = SS.login.levelMoneyInfo;
}
