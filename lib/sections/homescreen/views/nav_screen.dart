import 'package:bhaada/sections/homescreen/controllers/home_screen_controller.dart';
import 'package:bhaada/sections/homescreen/views/home_screen.dart';
import 'package:bhaada/sections/homescreen/views/orders_screen.dart';
import 'package:bhaada/sections/homescreen/views/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../Constants/color_constants.dart';
import '../../common widgets/common_widgets.dart';

class NavScreen extends StatelessWidget {
  NavScreen({super.key});
  final RxBool canPop = false.obs;
  final RxBool isTapped = false.obs;
  final RxInt idx = 0.obs;
  final List<Widget> screens = [HomeScreen(), OrdersScreen(), WalletScreen()];
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: canPop.value,
        onPopInvokedWithResult: (b, d) {
          if (idx.value == 0) {
            canPop.value = true;
          } else {
            Get.showSnackbar( GetSnackBar(
              message: "Press again to exit!".tr,
              duration: Duration(seconds: 2),
              backgroundColor: ColorConstants.btnColor,
            ));
            idx.value = 0;
          }
        },
        child: Scaffold(
          bottomNavigationBar:
              buildNavbar((val) => {idx.value = val}, idx.value),
          backgroundColor: ColorConstants.bgColor,
          body: screens[idx.value],
        ),
      ),
    );
  }
}
