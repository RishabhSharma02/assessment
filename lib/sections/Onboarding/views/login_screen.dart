import 'package:bhaada/Constants/color_constants.dart';
import 'package:bhaada/sections/Onboarding/controllers/onboarding_controller.dart';
import 'package:bhaada/sections/Onboarding/views/new_details_screen.dart';
import 'package:bhaada/sections/Onboarding/views/otp_screen.dart';
import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pinput/pinput.dart';

import '../../../Constants/text_constants.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  final OnboardingController _onboardingController =
      Get.put(OnboardingController());

  RxBool isHintRequested = false.obs;
  @override
  void initState() {
    _onboardingController.requestPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            buildImage().paddingOnly(top: 110.h, left: 25.w),
            buildText(TextConstants.mainText),
            buildDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildCountryPicker(),
                SizedBox(width: 5.w),
                buildPhoneTextField(_phoneController, "Enter Mobile Number".tr,
                    () async {
                  // _phoneController.text =
                  //     (await _onboardingController.requestHint())!
                  //         .substring(3, 13);
                }),
              ],
            ).paddingOnly(top: 44.h, right: 20.w, left: 20.w),
            buildCommonButton(
                    () async => {
                      if(_phoneController.text=="0000000000"){
                        Get.to(()=>PersonalDetailsScreen())
                      }
                      else
                        {
                          FocusManager.instance.primaryFocus?.unfocus(),
                          _onboardingController.checkPhoneNumberExists(
                              "+91${_phoneController.text}"),
                          _onboardingController.sendOTP(
                              "+91${_phoneController.text}",
                                  (v, i) =>
                              {
                                _onboardingController.timer(120),
                                _onboardingController.verificationID.value =
                                    v,
                                _onboardingController.resendToken?.value =
                                i!,
                                OverlayLoader.instance().showOverlay(
                                    context: context,
                                    title: "Success".tr,
                                    text: "OTP Sent to registered number".tr,
                                    isSuccess: true,
                                    isError: false),
                                Get.to(() =>
                                    OtpScreen(
                                      verId: v,
                                    )),
                              },
                                  (cred) =>
                              {
                                _onboardingController.codeController.value
                                    .setText(cred.smsCode!)
                              },
                              context),
                        }
                        },
                    TextConstants.buttonLabel,
                    true)
                .paddingSymmetric(horizontal: 20.w, vertical: 31.h),
            buildTnC(context).paddingOnly(top: 25.h)
          ],
        ),
      ),
    );
  }

  Widget buildImage() => SizedBox(
        width: 298.w,
        height: 250.h,
        child: Image.asset("assets/images/banner.png", fit: BoxFit.cover),
      );

  Widget buildText(String text) => Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w700,
          color: ColorConstants.textColor,
        ),
      ).paddingOnly(left: 67.w, right: 67.w, top: 25.h);

  Widget buildSemiText(String text) => Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.sp,
          color: ColorConstants.semiTextColor,
        ),
      ).paddingOnly(left: 75.w);

  Widget buildDivider() => IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Expanded(
                child: Divider(
              thickness: 1,
              color: ColorConstants.dividerColor,
            )),
            Text(
              " Log in or Sign up ".tr,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: ColorConstants.semiTextColor,
              ),
            ),
            const Expanded(
                child: Divider(
              thickness: 1,
              color: ColorConstants.dividerColor,
            )),
          ],
        ),
      ).paddingOnly(left: 14.w, top: 55.w, right: 14.w);

  Widget buildTnC(BuildContext context) => Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: TextConstants.tncPrefix,
            style: TextStyle(
              fontSize: 11.sp,
              color: ColorConstants.textColor,
            ),
            children: [
              TextSpan(
                text: TextConstants.tncPrivacy,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.blue, // Adjust color as needed
                  decoration: TextDecoration.underline,
                ),
                // Add onTap callback to handle the tap event
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showPrivacyPolicyDialog(context);
                  },
              ),
              TextSpan(
                text: ' and '.tr,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: ColorConstants.textColor,
                ),
              ),
              TextSpan(
                text: TextConstants.tncContent,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.blue, // Adjust color as needed
                  decoration: TextDecoration.underline,
                ),
                // Add onTap callback to handle the tap event
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showRefundPolicyDialog(context);
                  },
              ),
            ],
          ),
        ),
      );

}
