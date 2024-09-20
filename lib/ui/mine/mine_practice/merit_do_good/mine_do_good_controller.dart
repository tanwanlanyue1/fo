import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/service/service.dart';
import 'package:talk_fo_me/common/utils/screen_adapt.dart';
import 'package:talk_fo_me/widgets/loading.dart';

import '../../../../common/network/api/api.dart';
import 'mine_do_good_state.dart';

class MineDoGoodController extends GetxController {
  final MineDoGoodState state = MineDoGoodState();
  final loginService = SS.login;


  //logo,card,bg,sign
  String levelString(int index,String name){
    if(index == 0){
      return 'assets/images/common/class_0_$name.png';
    }else if(index < 4 && (name == 'bg' || name == 'card')){
      return 'assets/images/common/class_0_$name.png';
    }else{
      return 'assets/images/common/class_${index-1}_$name.png';
    }
  }

  //计算文字大小
  Size boundingTextSize(BuildContext context, String text,
      { double maxWidth = double.infinity}) {
    if (text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      locale: Localizations.maybeLocaleOf(context),
      text: TextSpan(text: text, style: TextStyle(fontSize: 10.rpx,color: Colors.white,height: 1,leadingDistribution: TextLeadingDistribution.even)),)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }
  //经验
  String merits(int exp){
    if(exp < 10000){
      return '$exp';
    }else{
      return '${exp ~/ 1000}k';
    }
  }

  @override
  void onInit() async{
    // TODO: implement onInit
    Loading.show();
    final res = await OpenApi.getAllMavList();
    Loading.dismiss();

    if (res.isSuccess && res.data != null) {
      state.levelResList.value = res.data ?? [];
    }
    super.onInit();
  }
}
