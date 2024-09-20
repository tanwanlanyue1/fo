import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/app_color.dart';
import 'package:talk_fo_me/common/app_text_style.dart';
import 'package:talk_fo_me/common/extension/get_extension.dart';
import 'package:talk_fo_me/common/extension/string_extension.dart';
import 'package:talk_fo_me/common/network/api/api.dart';
import 'package:talk_fo_me/common/routes/app_pages.dart';
import 'package:talk_fo_me/common/service/service.dart';
import 'package:talk_fo_me/common/utils/screen_adapt.dart';
import 'package:talk_fo_me/ui/wish_pavilion/zen_room/widigets/zen_room_gift_panel.dart';
import 'package:talk_fo_me/ui/wish_pavilion/zen_room/zen_room_state.dart';
import 'package:talk_fo_me/widgets/app_image.dart';
import 'package:talk_fo_me/widgets/user_level_info.dart';
import 'package:talk_fo_me/widgets/widgets.dart';

import 'zen_room_gift_list_tile.dart';

///上香，供品列表View
class ZenRoomGiftsView extends StatelessWidget {

  final GiftPanelTabItem tab;

  ///是否已选中佛像
  final bool hasBuddha;

  ///供品列表
  final List<ZenRoomGiftModel> dataList;

  ///供品顶礼信息
  final OfferingGiftTuple<OfferingGiftInfoModel> offeringGifts;

  ///选中的供品ID
  final int? selectedId;

  ///点击供品回调
  final void Function(ZenRoomGiftModel item)? onTapItem;

  ///供奉的供品时效已结束 回调
  final void Function(ZenRoomGiftModel item)? onOfferingFinished;

  ///点击顶礼 回调
  final void Function()? onTapSubmit;

  ///点击恭请佛像 回调
  final void Function()? onTapChooseBuddha;

  const ZenRoomGiftsView({
    super.key,
    required this.tab,
    required this.hasBuddha,
    required this.dataList,
    required this.offeringGifts,
    this.selectedId,
    this.onTapItem,
    this.onOfferingFinished,
    this.onTapSubmit,
    this.onTapChooseBuddha,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/wish_pavilion/zen_room/gifts_bg_mask.png'),
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
              color: Color(0xFF261C14),
            ),
            child: ListView.builder(
              padding: FEdgeInsets(horizontal: 4.rpx),
              scrollDirection: Axis.horizontal,
              itemCount: dataList.length,
              itemBuilder: (_, index) {
                final item = dataList[index];
                return ZenRoomGiftListTile(
                  item: item,
                  endTime: offeringGifts.getOfferingEndTime(tab, item),
                  isSelected: item.id == selectedId,
                  onTap: () {
                    if(item.isOpen){
                      onTapItem?.call(item);
                    }
                  },
                  offeringFinished: (hasBuddha && item.isOpen)
                      ? () {
                          onOfferingFinished?.call(item);
                        }
                      : null,
                );
              },
            ),
          ),
        ),
        Padding(
          padding: FEdgeInsets(bottom: Get.padding.bottom),
          child: hasBuddha ? buildRecharge() : buildChooseBuddhaButton(),
        )
      ],
    );
  }

  Widget buildChooseBuddhaButton() {
    return GestureDetector(
      onTap: onTapChooseBuddha,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 48.rpx,
        alignment: Alignment.center,
        child: Text(
          '请先恭请佛像',
          style: AppTextStyle.fs16b.copyWith(
            color: AppColor.gold,
          ),
        ),
      ),
    );
  }

  Widget buildRecharge() {
    return Container(
      height: 62.rpx,
      padding: FEdgeInsets(horizontal: 12.rpx, vertical: 4.rpx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UserLevelInfo(
            bgColor: AppColor.gray33,
          ),
          Button.image(
            image: AppImage.asset(
                'assets/images/wish_pavilion/zen_room/顶礼按钮.png'),
            onPressed: onTapSubmit,
            width: 120.rpx,
            height: 40.rpx,
            child: Text('顶礼',
                style: AppTextStyle.fs18b.copyWith(
                  color: const Color(0xFFEEC88A),
                )),
          ),
        ],
      ),
    );
  }
}

extension on OfferingGiftTuple<OfferingGiftInfoModel> {
  ///获取供品供奉结束时间
  DateTime? getOfferingEndTime(GiftPanelTabItem tab, ZenRoomGiftModel gift) {
    switch(tab){
      case GiftPanelTabItem.incense:
        if(gift.id == center?.giftId){
          return center?.endTime.dateTime;
        }
        break;
      case GiftPanelTabItem.leftGift:
        if(gift.id == left?.giftId){
          return left?.endTime.dateTime;
        }
        break;
      case GiftPanelTabItem.rightGift:
        if(gift.id == right?.giftId){
          return right?.endTime.dateTime;
        }
        break;
      case GiftPanelTabItem.chantSutras:
        return null;
    }
    return null;
  }
}
