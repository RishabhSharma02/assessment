import 'package:bhaada/sections/Onboarding/controllers/onboarding_controller.dart';
import 'package:bhaada/sections/Onboarding/views/pan_verification_screen.dart';
import 'package:bhaada/sections/Onboarding/views/vechicle_selection.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Constants/color_constants.dart';
import '../../../Constants/text_constants.dart';
import '../../common widgets/common_widgets.dart';
import 'DL_verification_screen.dart';
import 'RC_verification_screen.dart';
import 'adhhar_verification_screen.dart';
import 'face_verification_screen.dart';

class PersonalDetailsScreen extends StatelessWidget {
  PersonalDetailsScreen({super.key});
  final OnboardingController _onboardingController =
      Get.put(OnboardingController());
  List<CameraDescription> cameras = [];
  final PageController _pageController = PageController();
  final RxString gender = "Male".obs;
  final RxBool obsText = false.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Scaffold(
        backgroundColor: ColorConstants.bgColor,
        appBar: buildCommonAppbar("Personal Details".tr, true, true,context),
        body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [buildCompleteBottomSection(context), buildKycScreen(context)],
          ),
        ),
    );
  }

  Widget buildKycScreen(BuildContext context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSemiText(
                      "Let's get you verified quickly. Upload your documents / IDs".tr)
                  .paddingOnly(left: 27.w, bottom: 12.h, top: 12.h),
              Expanded(
                child: GetBuilder<OnboardingController>(
                  builder: (onboardingController) => ListView.builder(
                    itemBuilder: (context, i) {
                      return kycContainer(
                        TextConstants.kycHeads[i],
                        "assets/images/icon_doc.png",
                        onboardingController.verifiedKycs[i],
                              () async => {
                            if (i == 2) cameras = await availableCameras(),
                            Get.to(() => returnScreens(i, cameras))
                          });

                    },
                    itemCount: TextConstants.kycHeads.length,
                  ),
                ),
              ),
              Text(
                "2/2",
                style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorConstants.blackColor,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ).paddingOnly(left: 167.w),

                 GetBuilder<OnboardingController>(

                   builder:(ctrl)=> buildCommonButton(() async => {



                      Get.to(VehicleSelectionScreen())



                   },
                          "Continue".tr, ctrl.verifiedKycs[0]&&ctrl.verifiedKycs[1]&&ctrl.verifiedKycs[2]&&ctrl.verifiedKycs[3])
                      .paddingOnly(
                          left: 25.5.w, right: 25.5.w, bottom: 23.h, top: 23.h),
                 ),

            ],
          )
  );
  Widget buildText(String text) => Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: ColorConstants.blackColor,
        ),
      );

  Widget buildSemiText(String text) => Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 14.sp,
          color: ColorConstants.textColor,
        ),
      );

  Widget returnScreens(int idx, List<CameraDescription> cameras) {
    switch (idx) {
      case 0:
        return  AddharScreen();
      case 1:
        return DLVerificationScreen();
      case 2:
        return FaceVerification(cameras: cameras);
      case 3:
        return PanVerification();
      default:
        return const SizedBox();
    }
  }

  Widget buildCompleteBottomSection(BuildContext context) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextfield(_onboardingController.nameController.value,
                    TextConstants.fullNameText)
                .paddingOnly(top: 33.h, left: 24.w, right: 24.w),
            buildEmailTextfield(_onboardingController.emailController.value,
                    "Email ID (Optional)".tr)
                .paddingOnly(top: 20.h, left: 24.w, right: 24.w),
            buildDatePicker(_onboardingController.dateController.value, context)
                .paddingOnly(top: 20.h, left: 24.w, right: 24.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  value: "Male".tr,
                  groupValue: gender.value,
                  activeColor: ColorConstants.btnColor,
                  onChanged: (val) {
                    gender.value = val!;

                  },
                ),
                Text(
                  "Male".tr,
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: gender.value == "Male".tr
                          ? ColorConstants.textColor
                          : ColorConstants.unselectedColor),
                ),
                Spacer(),
                Radio(
                  value: "Female".tr,
                  groupValue: gender.value,
                  activeColor: ColorConstants.btnColor,
                  onChanged: (val) {
                    gender.value = val!;

                  },
                ),
                Text(
                  "Female".tr,
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: gender.value == "Female".tr
                          ? ColorConstants.textColor
                          : ColorConstants.unselectedColor),
                ),
                Spacer(),
                Radio(
                  value: "Others".tr,
                  activeColor: ColorConstants.btnColor,
                  groupValue: gender.value,
                  onChanged: (val) {
                    gender.value = val!;

                  },
                ),
                Text(
                  "Others".tr,
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: gender.value == "Others".tr
                          ? ColorConstants.textColor
                          : ColorConstants.unselectedColor),
                ),
                Spacer(),
              ],
            ).paddingOnly(top: 19.h, left: 24.w, right: 24.w),
            Text(
              "Is this your WhatsApp number? ".tr,
              style:
                  TextStyle(fontSize: 14.sp, color: ColorConstants.textColor),
            ).paddingOnly(top: 32.h, left: 24.w, right: 24.w),
            buildOtpPhoneTextfield(
                    _onboardingController.whatsAppController.value,
                    "Enter your Whatsapp Number(Optional)".tr)
                .paddingOnly(top: 11.h, left: 24.w, right: 24.w),
            Text(
              "By continuing, you agree to receive offers and promotional messages from Bhaada on Whatsapp".tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: ColorConstants.hintColor,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ).paddingOnly(top: 20.h, left: 24.w, right: 24.w),
            Text(
              "1/2",
              style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorConstants.blackColor,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ).paddingOnly(top: 160.h, left: 167.w),
            buildCommonButton(() {
              if (_onboardingController.nameController.value.text.isNotEmpty &&
                  _onboardingController.dateController.value.text.isNotEmpty&&validateEmail(_onboardingController.emailController.value.text)) {
                _onboardingController.currDriver.value.gender=gender.value;
                _onboardingController.currDriver.value.driverName =
                    _onboardingController.nameController.value.text;
                _onboardingController.currDriver.value.driverWhatsAppPhone =
                    _onboardingController.whatsAppController.value.text;
                _onboardingController.currDriver.value.email =
                    _onboardingController.emailController.value.text;
                _onboardingController.currDriver.value.driverDob =
                    _onboardingController.dateController.value.text;

                _pageController.animateToPage(1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              } else {
                OverlayLoader.instance().showOverlay(
                    title: "Error".tr,
                    context: context,
                    text: "Please fill in all details,or enter valid details!".tr,
                    isError: true,
                    isSuccess: false);
              }
            }, TextConstants.continueText, true)
                .paddingOnly(top: 23.h, left: 25.5.w, right: 25.5.w),
          ],
        ),
      );
}
