import 'package:bhaada/Constants/color_constants.dart';
import 'package:bhaada/sections/Onboarding/views/new_details_screen.dart';
import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../Constants/text_constants.dart';
import '../controllers/onboarding_controller.dart';

class AddharOtpScren extends StatelessWidget {
  AddharOtpScren({super.key});
  final FocusNode _focusNode = FocusNode();
  RxBool isVisible = true.obs;

  final OnboardingController _onboardingController =
      Get.put(OnboardingController());

  Rx<TextEditingController> pinController = TextEditingController().obs;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    return Obx(
      () => Scaffold(
        bottomNavigationBar: isVisible.value
            ? buildCommonButton(() {
                isVisible.value = false;
                _onboardingController.verifyOtpAadhaar(pinController.value.text,
                    () {
                  isVisible.value = false;
                  OverlayLoader.instance().showOverlay(
                      context: context,
                      title: "Success".tr,
                      text: "Successfully Verified Aadhaar Number".tr,
                      isSuccess: true,
                      isError: false);
                  _onboardingController.verifiedKycs.value[0] = true;
                  _onboardingController.update();
                  Navigator.pop(context);
                  Navigator.pop(context);
                }, () {
                  isVisible.value = false;
                  OverlayLoader.instance().showOverlay(
                      context: context,
                      title: "Failed to verify aadhaar".tr,
                      text: "Server Error! Try again!".tr,
                      isSuccess: false,
                      isError: true);
                });
              }, "Verify OTP".tr, true)
                .paddingOnly(left: 24.w, right: 24.w, bottom: 49.h, top: 10.h)
            : const SizedBox(),
        backgroundColor: ColorConstants.bgColor,
        appBar: buildCommonAppbar("Verify OTP".tr, true, false, context),
        body: buildVerifyBottomSection(context),
      ),
    );
  }

  Widget buildVerifyBottomSection(BuildContext context) => Column(
        children: [
          Text(
            "We have sent a verification code to the phone number registered to Aadhaar Number".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorConstants.textColor,
              fontWeight: FontWeight.w500,
            ),
          ).paddingOnly(top: 36.h),
          Pinput(
            focusNode: _focusNode,
            controller: pinController.value,
            length: 6,
            obscureText: false,
            onCompleted: (val) {},
            animationDuration: const Duration(milliseconds: 200),
            defaultPinTheme: PinTheme(
              decoration: BoxDecoration(
                border: Border.all(color: ColorConstants.borderColor),
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: TextStyle(
                fontSize: 18.sp,
                color: ColorConstants.textColor,
              ),
              width: 45.5.w,
              height: 48.h,
              margin: EdgeInsets.symmetric(
                  vertical:
                      39.h), // Added horizontal margin for increased spacing
            ),
          ),
          !isVisible.value
              ? const CircularProgressIndicator(color: ColorConstants.btnColor,).paddingOnly(top: 20.h)
              : const SizedBox()
        ],
      );
}
