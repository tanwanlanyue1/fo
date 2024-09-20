import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:talk_fo_me/common/app_color.dart';
import 'package:talk_fo_me/common/app_text_style.dart';
import 'package:talk_fo_me/common/network/api/api.dart';
import 'package:talk_fo_me/common/network/api/model/wish_pavilion/zen_room_gift_model.dart';
import 'package:talk_fo_me/common/utils/screen_adapt.dart';
import 'package:talk_fo_me/ui/wish_pavilion/zen_room/zen_room_state.dart';
import 'package:talk_fo_me/widgets/app_image.dart';
import 'package:talk_fo_me/widgets/widgets.dart';

import 'zen_room_gift_countdown.dart';

///供品列表项
class ZenRoomGiftListTile extends StatelessWidget {
  ///供品信息
  final ZenRoomGiftModel item;

  ///供品顶礼结束时间
  final DateTime? endTime;
  final bool isSelected;
  final VoidCallback? onTap;

  ///供品时效已结束回调
  final VoidCallback? offeringFinished;

  const ZenRoomGiftListTile({
    super.key,
    required this.item,
    this.endTime,
    required this.isSelected,
    this.onTap,
    this.offeringFinished,
  });

  @override
  Widget build(BuildContext context) {
    var image = item.image;
    if (item.thumbImg.startsWith('http')) {
      image = item.thumbImg;
    }

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 80.rpx,
          height: 116.rpx,
          padding: FEdgeInsets(bottom: 4.rpx),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.rpx),
            border: Border.all(
              color: isSelected ? const Color(0xFF8D310F) : Colors.transparent,
              width: 1.5.rpx,
            ),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppImage.network(
                    image,
                    width: 50.rpx,
                    height: 50.rpx,
                    fit: BoxFit.contain,
                  ),
                  Padding(
                    padding: FEdgeInsets(vertical: 4.rpx),
                    child: Text(
                      item.name,
                      style: AppTextStyle.fs12b.copyWith(
                        color: AppColor.gold,
                        height: 1,
                        fontFamily: '',
                      ),
                    ),
                  ),
                  buildPrice(),
                ],
              ),
              if (endTime != null)
                Positioned(
                  top: 2.rpx,
                  child: ZenRoomGiftCountdown(
                    textStyle: AppTextStyle.fs10m.copyWith(
                      color: AppColor.gold,
                      fontFamily: '',
                      height: 1.001,
                    ),
                    endTime: endTime!,
                    onFinish: offeringFinished,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPrice() {
    return Container(
      height: 22.rpx,
      width: 70.rpx,
      decoration: item.isOpen ? ShapeDecoration(
        color: const Color(0xFF413218),
        shape: StadiumBorder(
          side: BorderSide(
            color: const Color(0xFF765137),
            width: 1.5.rpx,
          ),
        ),
      ):null,
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: item.isOpen ? 60.rpx : 70.rpx),
        child: item.isOpen ? AutoSizeText(
          (item.type == 2 && item.openLevel == 0) ?
           "免费":
          "(${item.levelSurplus}/${item.levelCount})",
          maxLines: 1,
          minFontSize: 4,
          style: AppTextStyle.fs14m.copyWith(
            fontFamily: '',
            color: isSelected ? AppColor.gold : AppColor.gold7,
            leadingDistribution: TextLeadingDistribution.even
          ),
        ):
        AppImage.network(item.openLevelIcon,width: 70.rpx,height: 24.rpx,fit: BoxFit.fitHeight,),
      ),
    );
  }

}
