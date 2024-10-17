import 'package:bhaada/Constants/color_constants.dart';
import 'package:bhaada/Constants/text_constants.dart';
import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

import '../controllers/onboarding_controller.dart';

class PanVerification extends StatelessWidget {
  PanVerification({super.key});
  TextEditingController panController = TextEditingController();
  final OnboardingController _onboardingController =
  Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildCommonButton(() => {
        LoadingScreen.instance().show(
            context: context,
            desc:
            "Please Wait,verifying".tr),
        _onboardingController.verifyPan(panController.text.trim(),
           () {
             LoadingScreen.instance().hide();
              OverlayLoader.instance().showOverlay(
                  context: context,
                  title: "Success".tr,
                  text: "Successfully Verified PAN card".tr,
                  isSuccess: true,
                  isError: false);
              _onboardingController.verifiedKycs.value[3]=true;
              _onboardingController.update();
             Navigator.pop(context);
            }, () {
              LoadingScreen.instance().hide();
              OverlayLoader.instance().showOverlay(
                  context: context,
                  title: "Error!".tr,
                  text: "Invalid PAN Card!".tr,
                  isSuccess: false,
                  isError: true);

            }, () {
              LoadingScreen.instance().hide();
              OverlayLoader.instance().showOverlay(
                  context: context,
                  title: "Error".tr,
                  text: "PAN card not active!".tr,
                  isSuccess: false,
                  isError: true);
            }),
      }, "Verify".tr, true)
          .paddingOnly(left: 24.w, right: 24.w, bottom: 49.h, top: 10.h),
      backgroundColor: ColorConstants.bgColor,
      appBar: buildCommonAppbar("Your PAN Card".tr, false, true,context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildText(
                    "Enter your PAN card number, and we'll verify your information. You can also upload your PAN card instead.".tr)
                .paddingSymmetric(vertical: 24.h, horizontal: 27.w),
            buildImage().paddingOnly(top: 27.h, left: 79.w),
            buildSemiText("Enter PAN number".tr)
                .paddingOnly(top: 39.h, left: 24.w, right: 24.w),
            buildPanTextfield(panController, "Enter PAN Number".tr)
                .paddingOnly(top: 11.h, left: 24.w, right: 24.w),
          ],
        ),
      ),
    );
  }

  Widget buildImage() => Image.asset(
        "assets/images/pan_card.png",
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
