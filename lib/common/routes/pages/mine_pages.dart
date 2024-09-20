import 'package:get/get.dart';
import 'package:talk_fo_me/common/network/api/api.dart';
import 'package:talk_fo_me/ui/mine/attention_or_fans/attention_or_fans_page.dart';
import 'package:talk_fo_me/ui/mine/attention_or_fans/mine_attention/mine_attention_page.dart';
import 'package:talk_fo_me/ui/mine/attention_or_fans/mine_fans/mine_fans_page.dart';
import 'package:talk_fo_me/ui/mine/mine_merit_virtue/mine_merit_virtue_page.dart';
import 'package:talk_fo_me/ui/mine/mine_message/message_notice/message_notice_page.dart';
import 'package:talk_fo_me/ui/mine/mine_mission_center/mine_mission_center_page.dart';
import 'package:talk_fo_me/ui/mine/mine_practice/mine_practice_controller.dart';
import 'package:talk_fo_me/ui/mine/mine_practice/mine_practice_page.dart';
import 'package:talk_fo_me/ui/mine/mine_reward_points/mine_reward_points_page.dart';
import 'package:talk_fo_me/ui/mine/mine_reward_points_detail/mine_reward_points_detail_page.dart';
import 'package:talk_fo_me/ui/mine/mine_collect/mine_collect_page.dart';
import 'package:talk_fo_me/ui/mine/mine_setting/binding/binding_page.dart';
import '../app_pages.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:talk_fo_me/common/extension/get_extension.dart';
import 'package:talk_fo_me/ui/mine/mine_message/mine_message_page.dart';
import '../../../ui/mine/mine_comment/mine_comment_page.dart';
import '../../../ui/mine/mine_feedback/mine_feedback_page.dart';
import '../../../ui/mine/mine_gold_detail/mine_gold_detail_page.dart';
import '../../../ui/mine/mine_help/mine_help_page.dart';
import '../../../ui/mine/mine_message/message_session/message_session_page.dart';
import '../../../ui/mine/mine_message/message_setting/message_setting_page.dart';
import '../../../ui/mine/mine_praise/mine_praise_page.dart';
import '../../../ui/mine/mine_purchase/mine_purchase_page.dart';
import '../../../ui/mine/mine_record/mine_record_page.dart';
import '../../../ui/mine/mine_record/record_details/record_details_page.dart';
import '../../../ui/mine/mine_setting/about/about_page.dart';
import '../../../ui/mine/mine_setting/account_blacklist/account_blacklist_page.dart';
import '../../../ui/mine/mine_setting/account_data/account_data_page.dart';
import '../../../ui/mine/mine_setting/account_safety/account_safety_page.dart';
import '../../../ui/mine/mine_setting/mine_permissions/mine_permissions_page.dart';
import '../../../ui/mine/mine_setting/mine_setting_page.dart';
import '../../../ui/mine/mine_setting/update_info/update_info_page.dart';
import '../../../ui/mine/mine_setting/update_password/update_password_page.dart';

class MinePages {
  static final routes = [
    GetPage(
      name: AppRoutes.messageSettingPage,
      page: () => MessageSettingPage(),
    ),
    GetPage(
      name: AppRoutes.mineAttentionPage,
      page: () => MineAttentionPage(),
    ),
    GetPage(
      name: AppRoutes.attentionOrFansPage,
      page: () => AttentionOrFansPage(),
    ),
    GetPage(
      name: AppRoutes.mineFeedbackPage,
      page: () => MineFeedbackPage(),
    ),
    GetPage(
      name: AppRoutes.mineHelpPage,
      page: () => MineHelpPage(),
    ),
    GetPage(
      name: AppRoutes.mineMessage,
      page: () => MineMessagePage(),
    ),
    GetPage(
        name: AppRoutes.messageSessionPage,
        page: () {
          var args = Get.tryGetArgs("sessionId");
          return (args != null && args is String)
              ? MessageSessionPage()
              : MessageSessionPage();
        }),
    GetPage(
      name: AppRoutes.messageNotice,
      page: () => MessageNotice(),
    ),
    GetPage(
      name: AppRoutes.mineFans,
      page: () => MineFansPage(),
    ),
    GetPage(
      name: AppRoutes.mineComment,
      page: () => MineCommentPage(),
    ),
    GetPage(
      name: AppRoutes.minePraise,
      page: () => MinePraisePage(),
    ),
    GetPage(
      name: AppRoutes.minePurchase,
      page: () => MinePurchasePage(),
    ),
    GetPage(
      name: AppRoutes.mineGoldDetail,
      page: () => MineGoldDetailPage(),
    ),
    GetPage(
      name: AppRoutes.mineSettingPage,
      page: () => MineSettingPage(),
    ),
    GetPage(
      name: AppRoutes.accountDataPage,
      page: () => AccountDataPage(),
    ),
    GetPage(
      name: AppRoutes.updateInfoPage,
      page: () => UpdateInfoPage(
        type: Get.tryGetArgs('type'),
      ),
    ),
    GetPage(
      name: AppRoutes.accountSafetyPage,
      page: () => AccountSafetyPage(),
    ),
    GetPage(
      name: AppRoutes.updatePasswordPage,
      page: () => UpdatePasswordPage(),
    ),
    GetPage(
      name: AppRoutes.accountBlacklistPage,
      page: () => AccountBlacklistPage(),
    ),
    GetPage(
      name: AppRoutes.aboutPage,
      page: () => AboutPage(),
    ),
    GetPage(
      name: AppRoutes.permissions,
      page: () => MinePermissionsPage(),
    ),
    GetPage(
      name: AppRoutes.mineRecordPage,
      page: () => MineRecordPage(),
    ),
    GetPage(
        name: AppRoutes.recordDetailsPage,
        page: () {
          var args = Get.tryGetArgs('archivesInfo');
          if (args != null && args is ArchivesInfo) {
            return RecordDetailsPage(
              archivesInfo: args,
            );
          }
          return RecordDetailsPage();
        }),
    GetPage(
      name: AppRoutes.mineMissionCenter,
      page: () => MineMissionCenterPage(),
    ),
    GetPage(
      name: AppRoutes.mineRewardPoints,
      page: () => MineRewardPointsPage(),
    ),
    GetPage(
      name: AppRoutes.mineRewardPointsDetail,
      page: () => MineRewardPointsDetailPage(),
    ),
    GetPage(
      name: AppRoutes.mineCollectPage,
      page: () => MineCollectPage(),
    ),
    GetPage(
      name: AppRoutes.mineMeritVirtuePage,
      page: () => MineMeritVirtuePage(),
    ),
    GetPage(
      name: AppRoutes.minePracticePage,
      page: () => MinePracticePage(),
      binding: BindingsBuilder.put(() => MinePracticeController(
        type: Get.getArgs<int>('type', 0),
      ))
    ),
    GetPage(
      name: AppRoutes.bindingPage,
      page: () => BindingPage(),
    ),
  ];
}
