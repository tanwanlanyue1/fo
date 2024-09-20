import 'package:get/get.dart';
import 'package:talk_fo_me/common/network/api/model/wish_pavilion/offering_record_model.dart';
import 'package:talk_fo_me/common/network/api/wish_pavilion_api.dart';
import 'package:talk_fo_me/common/paging/default_paging_controller.dart';

import 'tribute_detail_state.dart';

class TributeDetailController extends GetxController {
  final TributeDetailState state = TributeDetailState();
  late final pagingController =
  DefaultPagingController<OfferingRecordModel>.single()
    ..addPageRequestListener(_fetchData);

  void _fetchData(_) async {
    final response = await WishPavilionApi.getRecordCountByType(2);
    if (response.isSuccess) {
      pagingController.appendPageData(response.data ?? []);
    } else {
      pagingController.error = response.errorMessage;
    }
  }
}
