import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_fo_me/common/app_config.dart';
import 'package:talk_fo_me/common/routes/app_pages.dart';
import 'package:talk_fo_me/ui/mine/mine_setting/app_update/app_update_manager.dart';
import 'package:talk_fo_me/ui/mine/widgets/setting_item.dart';
import 'package:talk_fo_me/widgets/app_image.dart';
import 'package:talk_fo_me/common/utils/screen_adapt.dart';
import 'package:talk_fo_me/widgets/web/web_page.dart';
import 'package:talk_fo_me/widgets/widgets.dart';

import 'about_controller.dart';

///关于我们页面
class AboutPage extends StatelessWidget {
  AboutPage({Key? key}) : super(key: key);

  final controller = Get.put(AboutController());
  final state = Get.find<AboutController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FE),
      appBar: AppBar(
        title: const Text("关于我们"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.rpx, vertical: 32.rpx),
        child: Obx(() {
          return Column(
            children: [
              AppImage.asset(
                'assets/images/login/login_logo.png',
                width: 68.rpx,
                height: 68.rpx,
              ),
              Text(
                "版本${state.version}",
                style: TextStyle(fontSize: 18.rpx),
              ),
              SizedBox(
                height: 40.rpx,
              ),
              // SettingItem(
              //   title: "新版检测",
              //   callBack: () {},
              // ),
              ...List.generate(
                  state.agreementList.length,
                  (i) => SettingItem(
                        title: state.agreementList[i]['title'],
                        bottom: 1.rpx,
                        borderRadius: i == 0
                            ? BorderRadius.only(
                                topLeft: Radius.circular(8.rpx),
                                topRight: Radius.circular(8.rpx),
                              )
                            : (i == state.agreementList.length - 1)
                                ? BorderRadius.only(
                                    bottomLeft: Radius.circular(8.rpx),
                                    bottomRight: Radius.circular(8.rpx),
                                  )
                                : BorderRadius.zero,
                        callBack: () {
                          if(state.agreementList[i]['title'] == '检测新版本'){
                            AppUpdateManager.instance.checkAppUpdate(userAction: true);
                            return;
                          }
                          WebPage.go(url: state.agreementList[i]['url'], title: state.agreementList[i]['title']);
                        },
                      )),
              const Spacer(),
              GestureDetector(
                onTap: () => WebPage.go(url: AppConfig.urlIcp),
                behavior: HitTestBehavior.translucent,
                child: Padding(
                  padding: FEdgeInsets(horizontal: 16.rpx, vertical: 4.rpx),
                  child: Text(
                    AppConfig.icp,
                    style:
                    TextStyle(color: const Color(0xff999999), fontSize: 12.rpx),
                  ),
                ),
              ),
              Text(
                "Copyright © 2015-2024 Aimiyou .ALL Rights Reserved",
                style:
                    TextStyle(color: const Color(0xff999999), fontSize: 12.rpx),
              ),
            ],
          );
        }),
      ),
    );
  }
}
