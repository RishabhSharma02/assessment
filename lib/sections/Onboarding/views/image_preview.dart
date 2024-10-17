import 'dart:io';

import 'package:bhaada/Constants/color_constants.dart';
import 'package:bhaada/sections/Onboarding/controllers/onboarding_controller.dart';
import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ImagePreview extends StatelessWidget {
  ImagePreview({super.key});
  final OnboardingController _onboardingController =
      Get.put(OnboardingController());
  @override
  Widget build(BuildContext context) {
    LoadingScreen.instance().hide();
    return Scaffold(
      backgroundColor: ColorConstants.bgColor,
      appBar: buildCommonAppbar("Your Selfie Photo".tr, true, true,context),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildImageBox(_onboardingController.imageFile.value)
                .paddingOnly(left: 65.w, right: 65.w, top: 70.h),
            buildText("Want to use this photo?".tr)
                .paddingOnly(left: 65.w, right: 65.w, top: 23.h),
            buildSemiText(
                    "By tapping SAVE, you agree that Bhaada or a trusted partner can collect and use your photo to verify your identity.".tr)
                .paddingOnly(left: 30.w, right: 30.w, top: 23.h),
            buildButtons(context).paddingOnly(top: 169.h)
          ],
        ),
      ),
    );
  }

  Widget buildButtons(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildPreviewButton(() {
            Navigator.pop(context);
          }, "Retake".tr, false)
              .paddingOnly(right: 16.w),
          buildPreviewButton(() {
            _onboardingController.uploadImageFile(context);
            _onboardingController.verifiedKycs.value[2]=true;
            _onboardingController.update();
            Navigator.pop(context);
            Navigator.pop(context);
          }, "Save".tr, true),
        ],
      );
  Widget buildText(String text) => Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.sp, color: ColorConstants.blackColor),
      );
  Widget buildSemiText(String text) => Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 14.sp,
          color: ColorConstants.textColor,
        ),
      );
  Widget buildImageBox(XFile xFile) => Image.file(
        File(xFile.path),
        width: 230.w,
        height: 260.h,
        fit: BoxFit.cover,
      );
}
