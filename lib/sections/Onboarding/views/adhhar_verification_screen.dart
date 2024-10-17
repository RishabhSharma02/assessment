import 'package:bhaada/Constants/color_constants.dart';
import 'package:bhaada/Constants/text_constants.dart';
import 'package:bhaada/main.dart';
import 'package:bhaada/sections/Onboarding/views/aadhar_otp_screen.dart';
import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

import '../controllers/onboarding_controller.dart';

class AddharScreen extends StatelessWidget {
  AddharScreen({super.key});
  final OnboardingController _onboardingController =
      Get.put(OnboardingController());
  RxBool isLoading=false.obs;
  @override
  Widget build(BuildContext context) {

    return Obx(
        ()=> Scaffold(
        bottomNavigationBar:!isLoading.value? buildCommonButton(
                () => {
                      isLoading.value=true,
                      _onboardingController.sendOtpAadhaar(
                          _onboardingController.aadhaarController.value.text, () {
                        isLoading.value=false;
                        Get.to(() => AddharOtpScren());

                      }, () {
                            isLoading.value=false;
                        OverlayLoader.instance().showOverlay(
                            context: context,
                            title: "Failed to verify aadhaar".tr,
                            text: "Server Error! Try again!".tr,
                            isSuccess: false,
                            isError: true);
                      }),
                    },
                "Verify".tr,
                true).paddingOnly(left: 24.w, right: 24.w, bottom: 49.h, top: 10.h):const SizedBox()
            .paddingOnly(left: 24.w, right: 24.w, bottom: 49.h, top: 10.h),
        backgroundColor: ColorConstants.bgColor,
        appBar: buildCommonAppbar("Your Aadhaar Card".tr, false, true,context),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildText("Enter your Aadhaar number, and we'll verify your information. By giving your Aadhaar details, you confirm that you're sharing them by your choice.".tr)
                  .paddingSymmetric(vertical: 24.h, horizontal: 27.w),
              buildImage().paddingOnly(top: 27.h, left: 79.w),
              buildSemiText().paddingOnly(top: 39.h, left: 24.w, right: 24.w),
              buildAdhharTextfield(_onboardingController.aadhaarController.value,
                      TextConstants.aadhaarNumberText)
                  .paddingOnly(top: 11.h, left: 24.w, right: 24.w),
              isLoading.value?const Center(child: CircularProgressIndicator(color: ColorConstants.btnColor,)).paddingOnly(top: 50.h):const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage() => Image.asset(
        "assets/images/aadhaar_card.png",
        fit: BoxFit.cover,
        width: 202.w,
        height: 124.h,
      );

  Widget buildSemiText() => Text(
        "Aadhaar Card Number",
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 11.sp, color: ColorConstants.blackColor),
      );

  Widget buildText(String text) => Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 14.sp, color: ColorConstants.textColor),
      );
}
