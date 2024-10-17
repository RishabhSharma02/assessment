import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Constants/color_constants.dart';
import '../../common widgets/common_widgets.dart';
import '../controllers/onboarding_controller.dart';

class RcVerificationScreen extends StatelessWidget {
  RcVerificationScreen({super.key});
  TextEditingController rcController = TextEditingController();
  final OnboardingController _onboardingController =
  Get.put(OnboardingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgColor,
      bottomNavigationBar: buildCommonButton(
              () async =>
                  {
                    LoadingScreen.instance().show(
                        context: context,
                        desc:
                        "Please Wait,verifying".tr),
                    _onboardingController.verifyRc(rcController.text.trim(),
                         () {
                          LoadingScreen.instance().hide();
                          OverlayLoader.instance().showOverlay(
                              context: context,
                              title: "Success".tr,
                              text: "Successfully Verified RC ".tr,
                              isSuccess: true,
                              isError: false);
                          _onboardingController.verifiedVehicleKycs.value[0]=true;
                          _onboardingController.verifiedVehicleKycs.value[1]=true;
                          _onboardingController.verifiedVehicleKycs.value[2]=true;
                          _onboardingController.update();




                          Navigator.pop(context);
                        }, () {
                          LoadingScreen.instance().hide();
                          OverlayLoader.instance().showOverlay(
                              context: context,
                              title: "Error!".tr,
                              text: "Cannot add this RC!".tr,
                              isSuccess: false,
                              isError: true);

                        }, () {
                          LoadingScreen.instance().hide();
                          OverlayLoader.instance().showOverlay(
                              context: context,
                              title: "Error".tr,
                              text: "RC not verified!".tr,
                              isSuccess: false,
                              isError: true);
                        }),
                  },
              "Verify".tr,
              true)
          .paddingOnly(left: 24.w, right: 24.w, bottom: 49.h, top: 10.h),
      appBar: buildCommonAppbar("Registration Certificate (RC)".tr, false, true,context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildText(
                  "Enter your licence plate number and we’ll get the required information from the Indian Government agency or any trusted vendor. You can upload photo of your Registration Certificate (RC) also.".tr)
              .paddingSymmetric(vertical: 24.h, horizontal: 27.w),
          buildSemiText("Licence plate number".tr)
              .paddingOnly(top: 47.h, left: 24.w, right: 24.w),
          buildRcTextfield(rcController, "Enter RC Number".tr)
              .paddingOnly(top: 11.h, left: 24.w, right: 24.w)
        ],
      ),
    );
  }

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
