import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/app_color.dart';
import 'package:talk_fo_me/common/service/service.dart';
import 'package:talk_fo_me/common/utils/screen_adapt.dart';
import 'package:talk_fo_me/widgets/app_image.dart';

import '../common/routes/app_pages.dart';

//用户等级信息
class UserLevelInfo extends StatelessWidget {
  Color? bgColor;
  UserLevelInfo({super.key,this.bgColor});

  //经验
  String merits(int exp){
    if(exp < 10000){
      return '$exp';
    }else{
      return '${exp ~/ 1000}k';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final levelMoneyInfo = SS.login.levelMoneyInfo;
      double compile(){
        return (levelMoneyInfo?.mavExp != null && levelMoneyInfo?.mavExp != 0) ? 94.rpx *
            (levelMoneyInfo!.mavExp/levelMoneyInfo.mavTotal) : 0;
      }
      return GestureDetector(
        onTap: (){
          Get.toNamed(AppRoutes.mineMeritVirtuePage);
        },
        child: Container(
          height: 54.rpx,
          width: 110.rpx,
          decoration: BoxDecoration(
            color: bgColor ?? AppColor.brown14,
            borderRadius: BorderRadius.circular(8.rpx),
          ),
          padding: EdgeInsets.symmetric(vertical: 4.rpx,horizontal: 8.rpx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppImage.network('${levelMoneyInfo?.mavIcon}',width: 24.rpx,height: 24.rpx,),
                  SizedBox(width: 6.rpx,),
                  Text(levelMoneyInfo!.mavLevelName.isNotEmpty ? levelMoneyInfo.mavLevelName : '暂无品阶',style: TextStyle(fontSize: 10.rpx,color: bgColor == null ? AppColor.brown36 : AppColor.gold),),
                  const Spacer(),
                  AppImage.asset('assets/images/common/return_right.png',width: 12.rpx,height: 12.rpx,),
                ],
              ),
              SizedBox(height: 3.rpx,),
              RichText(
                  text: TextSpan(
                      text: merits(levelMoneyInfo.mavExp ?? 0),
                      style: TextStyle(fontSize: 10.rpx,color: bgColor == null ? AppColor.brown36 : AppColor.gold,fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: "/${merits(levelMoneyInfo?.mavTotal ?? 0)}",
                            style: const TextStyle(fontWeight: FontWeight.normal,color: AppColor.brown36)
                        )
                      ]
                  )),
              SizedBox(height: 3.rpx,),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.brown37,
                      borderRadius: BorderRadius.circular(5.rpx),
                    ),
                    height: 4.rpx,
                    width: 94.rpx,
                  ),
                  Container(
                    width: compile(),
                    height: 4.rpx,
                    decoration: BoxDecoration(
                      color: bgColor == null ? AppColor.brown36 : AppColor.gold,
                      borderRadius: BorderRadius.circular(5.rpx),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
