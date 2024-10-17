import 'package:bhaada/Constants/color_constants.dart';
import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

import '../controllers/onboarding_controller.dart';

class DLVerificationScreen extends StatelessWidget {

  DLVerificationScreen({super.key});
  TextEditingController dlController = TextEditingController();
  final OnboardingController _onboardingController =
      Get.put(OnboardingController());
  TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: buildCommonButton(
              () async => {
                LoadingScreen.instance().show(
                    context: context,
                    desc:
                    "Please Wait,verifying".tr),
                    _onboardingController.verifyDL(dlController.text.trim(),
                        dateController.text, () {
                          LoadingScreen.instance().hide();
                          OverlayLoader.instance().showOverlay(
                              context: context,
                              title: "Success".tr,
                              text: "Successfully Verified Driving License".tr,
                              isSuccess: true,
                              isError: false);
                          _onboardingController.verifiedKycs.value[1]=true;
                          _onboardingController.update();
                          Navigator.pop(context);
                        }, () {
                          LoadingScreen.instance().hide();
                          OverlayLoader.instance().showOverlay(
                              context: context,
                              title: "Error!".tr,
                              text: "Invalid License!".tr,
                              isSuccess: false,
                              isError: true);

                        }, () {
                          LoadingScreen.instance().hide();
                          OverlayLoader.instance().showOverlay(
                              context: context,
                              title: "Error".tr,
                              text: "Driving License not active!".tr,
                              isSuccess: false,
                              isError: true);
                        }),

                  },
              "Verify".tr,
              true)
          .paddingOnly(left: 24.w, right: 24.w, bottom: 49.h, top: 10.h),
      backgroundColor: ColorConstants.bgColor,
      appBar: buildCommonAppbar("Your Driving License".tr, false, true,context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildText(
                    "Enter your Driving License number, and date of birth mentioned on your license.".tr)
                .paddingSymmetric(vertical: 24.h, horizontal: 15.w),
            buildImage().paddingOnly(top: 27.h, left: 79.w),
            buildSemiText("License number".tr)
                .paddingOnly(top: 39.h, left: 24.w, right: 24.w),
            buildDlTextfield(dlController, "Enter DL Number".tr)
                .paddingOnly(top: 11.h, left: 24.w, right: 24.w),
            buildSemiText("Date Of Birth".tr)
                .paddingOnly(top: 26.h, left: 24.w, right: 24.w),
            buildDatePicker(dateController, context)
                .paddingOnly(top: 11.h, left: 24.w, right: 24.w),
          ],
        ),
      ),
    );
  }

  Widget buildImage() => Image.asset(
        "assets/images/dl_card.png",
        fit: BoxFit.cover,
        width: 202.w,
        height: 124.h,
      );

  Widget buildSemiText(String text) => Text(
        text,
        style: TextStyle(fontSize: 11.sp, color: ColorConstants.blackColor),
      );

  Widget buildText(String text) => Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 14.sp, color: ColorConstants.textColor),
      );
}
