import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/app_color.dart';
import 'package:talk_fo_me/common/app_text_style.dart';
import 'package:talk_fo_me/common/extension/text_style_extension.dart';
import 'package:talk_fo_me/common/service/service.dart';
import 'package:talk_fo_me/common/utils/screen_adapt.dart';
import 'package:talk_fo_me/widgets/app_image.dart';
import 'package:talk_fo_me/widgets/dotted_line.dart';
import 'package:talk_fo_me/widgets/input_widget.dart';

import '../../../../../common/network/api/api.dart';

//兑换码弹窗
class ConversionDialog extends StatelessWidget {
  Function(String? str)? callBack;
  ConversionDialog({super.key,this.callBack});

  final TextEditingController cdkText = TextEditingController();
  final show = false.obs;
  CdkCopyWriting? cdkCopyWriting = SS.appConfig.configRx()?.cdkCopyWriting;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 326.rpx,
            height: 354.rpx,
            margin: EdgeInsets.only(top: 12.rpx,right: 8.rpx,left: 8.rpx),
            decoration: BoxDecoration(
              image: AppDecorations.backgroundImage(
                  "assets/images/wish_pavilion/charm/conversion_bg.png"),
            ),
            child: Column(
              children: [
                SizedBox(height: 22.rpx),
                Text(
                  "兑换码",
                  style:
                  AppTextStyle.st.bold.size(18.rpx).textColor(AppColor.gray5),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.brownC3.withOpacity(0.3),
                    borderRadius: BorderRadius.all(Radius.circular(4.rpx)),
                    border: Border.all(width: 1.rpx,color: AppColor.brownC3),
                  ),
                  height: 40.rpx,
                  margin: EdgeInsets.symmetric(horizontal: 38.rpx,vertical: 24.rpx),
                  child: InputWidget(
                    hintText: '请输入兑换码',
                    inputController: cdkText,
                    fillColor: AppColor.brownC3.withOpacity(0.1),
                    textAlign: TextAlign.center,
                    hintStyle: AppTextStyle.fs14m.copyWith(color: AppColor.brown37),
                    textStyle: AppTextStyle.fs14m.copyWith(color: AppColor.brown36),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8.rpx),
                    ),
                    onChanged: (val){
                      if(val.isNotEmpty){
                        show.value = true;
                      }else{
                        show.value = false;
                      }
                    },
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if(cdkText.text.isNotEmpty){
                      callBack?.call(cdkText.text);
                    }
                  },
                  child: Obx(() => Container(
                    width: 116.rpx,
                    height: 35.rpx,
                    decoration: BoxDecoration(
                      image: AppDecorations.backgroundImage(
                        "assets/images/wish_pavilion/charm/conversion_sure.png",
                      ),
                    ),
                    alignment: Alignment.center,
                    foregroundDecoration: BoxDecoration(
                        color: show.value ? Colors.transparent : Colors.white.withOpacity(0.5)
                    ),
                    child: Text("确定",style: TextStyle(color: Colors.white,fontSize: 16.rpx,fontWeight: FontWeight.bold),),
                  )),
                ),
                Container(
                  margin: EdgeInsets.all(24.rpx).copyWith(bottom: 12.rpx),
                  child: DottedLine(
                    height: 1.rpx,
                    color: AppColor.brown38,
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ...List.generate(cdkCopyWriting?.title?.length ?? 0, (index) => Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 8.rpx,left: 22.rpx,right: 20.rpx),
                        child: Text(cdkCopyWriting!.title![index],style: TextStyle(fontSize: 12.rpx,color: AppColor.gray9),),
                      )),
                      ...List.generate(cdkCopyWriting?.address?.length ?? 0, (index) => Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 8.rpx,left: 22.rpx),
                        child: RichText(
                          text: TextSpan(
                              text: "${cdkCopyWriting!.address![index].name}：",
                              style: TextStyle(
                                color: AppColor.gray9,
                                fontSize: 12.rpx,
                              ),
                              children: [
                                TextSpan(
                                  text: "${cdkCopyWriting!.address![index].number}",
                                  style: TextStyle(
                                    color: AppColor.gray30,
                                    fontSize: 12.rpx,
                                  ),
                                )
                              ]
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.rpx,
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: ()=>Get.back(),
              child: AppImage.asset("assets/images/wish_pavilion/charm/conversion_close.png",width: 32.rpx,height: 32.rpx,),
            ),
          ),
        ],
      ),
    );
  }
}
