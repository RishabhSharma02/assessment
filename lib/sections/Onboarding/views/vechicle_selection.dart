import 'package:bhaada/sections/Onboarding/controllers/onboarding_controller.dart';
import 'package:bhaada/sections/Onboarding/models/vehicle_model.dart';
import 'package:bhaada/sections/Onboarding/views/RC_verification_screen.dart';

import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:bhaada/sections/homescreen/views/nav_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';

import '../../../Constants/color_constants.dart';
import '../../../Constants/text_constants.dart';

class VehicleSelectionScreen extends StatelessWidget {
  VehicleSelectionScreen({super.key});
  final OnboardingController _onboardingController =
      Get.put(OnboardingController());
  PageController _pageController = PageController();
  RxInt selectedIdx=0.obs;
  Set<Vehicle> set={};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppbar("Vehicles".tr, true,false,context),
      backgroundColor: ColorConstants.bgColor,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),

        children: [
        buildVehicleSelectionScreen(),
        buildKycScreen(context)

      ],),
    );
  }
  Widget buildVehicleSelectionScreen()=>SafeArea(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        buildSemiText("Choose type of your service vehicle you want to drive on Bhaada".tr)
            .paddingOnly(left: 27.w, bottom: 12.h,top: 35.h,right: 27.w),
        Expanded(
          child: ListView.builder(
              itemBuilder: (c, i) {
                return Obx(
                      () => vehicleContainer(
                      "${_onboardingController.lv[i].vehicleName} (${_onboardingController.lv[i].vehicleType})",
                      _onboardingController.lv[i].loadCapacity,
                      selectedIdx.value==i, () {
                    selectedIdx.value=i;
                    _onboardingController
                        .selectedVehicle.value.vehicleName =
                        _onboardingController.lv[i].vehicleName;
                    _onboardingController
                        .selectedVehicle.value.vehicleType =
                        _onboardingController.lv[i].vehicleType;
                    _onboardingController
                        .selectedVehicle.value.loadCapacity =
                        _onboardingController.lv[i].loadCapacity;
                    _onboardingController.selectedVehicle.value.imgLink =
                        _onboardingController.lv[i].imgLink;
                    set.add(_onboardingController.selectedVehicle.value);
                  }, _onboardingController.lv[i].imgLink),
                );
              },
              itemCount: _onboardingController.lv.length),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "1/2",
              style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorConstants.textColor,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            buildCommonButton(() => {
              _onboardingController.currDriver.value.vehicles=set.toList(),
            _pageController.animateToPage(1,
            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut)
            }, "Continue".tr, true)
                .paddingOnly(left: 25.5.w, right: 25.5.w, bottom: 23.h, top: 23.h),
          ],
        ),
      ],
    ),
  );
  Widget buildKycScreen(BuildContext context) => SafeArea(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSemiText(
            "Upload document of vehicle which you will use on Bhaada".tr)
            .paddingOnly(left: 27.w, bottom: 12.h, top: 32.h),
        Expanded(
          child: GetBuilder<OnboardingController>(
            builder: (onboardingController) => ListView.builder(
              itemBuilder: (context, i) {
                return kycContainer(
                    TextConstants.vehicleKycHeads[i],
                    "assets/images/icon_doc.png",
                    onboardingController.verifiedVehicleKycs[i],
                        () async => {
                        Get.to(()=> RcVerificationScreen())
                    });

              },
              itemCount: TextConstants.vehicleKycHeads.length,
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
        ).paddingOnly( left: 167.w),
        GetBuilder<OnboardingController>(
          builder:(ctrl)=> buildCommonButton(() async => {

              ctrl.createProfileHelper(context),



          }, "Continue".tr, ctrl.verifiedVehicleKycs[0]==true&&
              ctrl.verifiedVehicleKycs[1]==true&&
              ctrl.verifiedVehicleKycs[2]==true)
              .paddingOnly(left: 25.5.w, right: 25.5.w, bottom: 23.h, top: 23.h),
        )
      ],
    ),
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
      fontSize: 12.sp,
      color: ColorConstants.textColor,
    ),
  );

  Widget returnScreens(int idx) {
    return RcVerificationScreen();
  }




}
