import 'package:get/get.dart';
import 'package:talk_fo_me/common/network/api/model/wish_pavilion/cultivation_ranking_model.dart';
import 'package:talk_fo_me/common/network/api/wish_pavilion_api.dart';
import 'package:talk_fo_me/common/paging/default_paging_controller.dart';
import 'package:talk_fo_me/ui/wish_pavilion/zen_room/zen_room_state.dart';

import 'merit_ranking_state.dart';

class MeritRankingController extends GetxController {
  final MeritRankingState state = MeritRankingState();

  late final pagingController =
  DefaultPagingController<CultivationRankingModel>.single()
    ..addPageRequestListener(_fetchData);

  void _fetchData(_) async {
    final response = await WishPavilionApi.getRankingList(0);
    if (response.isSuccess) {
      final list = response.data ?? [];
      pagingController.appendPageData(list);
      state.selfRankingRx.value = list.firstWhereOrNull((element) => element.oneself == 1);
    } else {
      pagingController.error = response.errorMessage;
    }
  }

}
