import 'package:get/get.dart';
import 'package:talk_fo_me/common/extension/get_extension.dart';
import 'package:talk_fo_me/common/routes/middlewares/auth_middleware.dart';
import 'package:talk_fo_me/common/routes/middlewares/route_welcome.dart';
import 'package:talk_fo_me/common/routes/pages/login_pages.dart';
import 'package:talk_fo_me/common/routes/pages/mine_pages.dart';
import 'package:talk_fo_me/common/routes/pages/wish_pavilion_pages.dart';
import 'package:talk_fo_me/ui/ad/launch_ad/launch_ad_page.dart';
import 'package:talk_fo_me/ui/home/home_page.dart';
import 'package:talk_fo_me/ui/plaza/classification_square/classification_square_page.dart';
import 'package:talk_fo_me/ui/plaza/plaza_detail/plaza_detail_controller.dart';
import 'package:talk_fo_me/ui/plaza/plaza_detail/plaza_detail_page.dart';
import 'package:talk_fo_me/ui/plaza/plaza_history/plaza_history_page.dart';
import 'package:talk_fo_me/ui/plaza/release_dynamic/release_dynamic_page.dart';
import 'package:talk_fo_me/ui/plaza/user_center/user_center_page.dart';
import 'package:talk_fo_me/ui/welcome/welcome_page.dart';
import 'package:talk_fo_me/widgets/web/web_page.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();
  static const initial = AppRoutes.welcome;
  // static const initial = AppRoutes.home;

  static final routes = [
    ...WishPavilionPages.routes,
    ...LoginPages.routes,
    ...MinePages.routes,
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
    ),
    GetPage(
      name: AppRoutes.releaseDynamicPage,
      page: () => ReleaseDynamicPage(),
    ),
    GetPage(
      name: AppRoutes.classificationSquarePage,
      page: () => ClassificationSquarePage(
        topicItem: Get.tryGetArgs('topicItem'),
        type: Get.getArgs('type', 0),
      ),
    ),
    GetPage(
      name: AppRoutes.userCenterPage,
      page: () => UserCenterPage(
        userId: Get.getArgs('userId', null),
      ),
    ),
    GetPage(
        name: AppRoutes.plazaDetailPage,
        page: () => PlazaDetailPage(),
        binding: BindingsBuilder.put(() => PlazaDetailController(
              communityId: Get.tryGetArgs('communityId'),
              userId: Get.tryGetArgs('userId'),
            ))),
    GetPage(
      name: AppRoutes.plazaHistoryPage,
      page: () => PlazaHistoryPage(),
    ),
    GetPage(
      name: AppRoutes.webPage,
      page: () => WebPage(
        url: Get.getArgs('url', ''),
        title: Get.getArgs('title', ''),
      ),
    ),
    GetPage(
      name: AppRoutes.launchAd,
      page: () => LaunchAdPage(),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomePage(),
      middlewares: [
        RouteWelcomeMiddleware(),
      ],
    ),
  ].addMiddleware(AuthMiddleware());
}
