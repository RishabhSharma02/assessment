import 'dart:async';

import 'package:bhaada/Constants/color_constants.dart';
import 'package:bhaada/sections/Onboarding/controllers/onboarding_controller.dart';
import 'package:bhaada/sections/Onboarding/views/new_details_screen.dart';
import 'package:bhaada/sections/Onboarding/views/vechicle_selection.dart';
import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:bhaada/sections/homescreen/views/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../Constants/text_constants.dart';

class OtpScreen extends StatefulWidget {
  final String verId;

  OtpScreen({super.key, required this.verId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final RxBool canPop=false.obs;

  final RxInt currIdx = 0.obs;

  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    Timer(const Duration(seconds: 15),(){
      canPop.value=true;

    });
    super.initState();
  }
  final OnboardingController _onboardingController =
      Get.put(OnboardingController());



  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    return Obx(()=>
      PopScope(
        onPopInvokedWithResult: (b,d){
          OverlayLoader.instance().showOverlay(
              context: context,
              title: "Error!".tr,
              text: "Please wait 30 second to request new OTP".tr,
              isSuccess: false,
              isError: true);
        },
        canPop: canPop.value,
        child: Scaffold(
          appBar: buildCommonAppbar("OTP Verification".tr, true, true,context),
          backgroundColor: ColorConstants.bgColor,
          body: SafeArea(
            child:  SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    buildVerifyBottomSection(context),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }

  Widget buildVerifyBottomSection(BuildContext context) => Column(
        children: [
          Text(
            TextConstants.verificationCodeSentText,
            style: TextStyle(
              fontSize: 18.sp,
              color: ColorConstants.textColor,
              fontWeight: FontWeight.w500,
            ),
          ).paddingOnly(top: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "+91-${_onboardingController.phoneNr.substring(3,_onboardingController.phoneNr.value.length)}",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorConstants.textColor,
                ),
              ),
              GestureDetector(
                onTap: () => {Navigator.pop(context)},
                child: const Icon(
                  Icons.edit,
                  color: ColorConstants.greenColor,
                ).paddingOnly(left: 5.w),
              )
            ],
          ).paddingOnly(top: 14.h),
          Obx(
  ()=> Pinput(
              focusNode: _focusNode,
              controller: _onboardingController.codeController.value,
              length: 6,
              obscureText: false,
              onCompleted: (val) {
                _onboardingController.signInPhone(
                  _onboardingController.phoneNr.value,
                  val,
                  () => {
                    OverlayLoader.instance().showOverlay(
                      context: context,
                      title: "Verified".tr,
                      text: "Successfully Verified Phone Number".tr,
                      isSuccess: true,
                    ),
                    if (_onboardingController.userAlreadyExists.value)
                      {
                        Get.offAll(() => NavScreen()),
                      }
                    else
                      {
                        Get.offAll(() => PersonalDetailsScreen()),
                      }
                  },
                  context,
                );
              },
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
          ),
          buildDynamicButton(
            () => {
              _onboardingController.sendOTP(
                _onboardingController.phoneNr.value,
                (s, i) {},
                (pac) {},
                context,
              ),
            },
            _onboardingController.tc.value == 0
                ? "Resend SMS".tr
                : "Resend SMS in ${_onboardingController.tc.value} s".tr,
            _onboardingController.tc.value == 0
                ? ColorConstants.btnColor
                : ColorConstants.bgColor,
            _onboardingController.tc.value == 0 ? false : true,
            ColorConstants.hintColor,
            ColorConstants.textColor,
          ),
        ],
      );

  Future<int> startTimer() async {
    const duration = Duration(seconds: 30);
    await Future.delayed(duration);
    return 0; // Timer completed, so return 0 seconds remaining
  }
}
