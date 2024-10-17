import 'package:bhaada/sections/homescreen/controllers/home_screen_controller.dart';
import 'package:bhaada/sections/homescreen/views/driving_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../Constants/color_constants.dart';
import '../../../Constants/text_constants.dart';
import '../../Onboarding/controllers/onboarding_controller.dart';
import '../../Onboarding/models/vehicle_model.dart';
import '../../Onboarding/views/RC_verification_screen.dart';
import '../../common widgets/common_widgets.dart';

class AddVehicles extends StatelessWidget {
  AddVehicles({super.key});
  final OnboardingController _onboardingController =
      Get.put(OnboardingController());
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());
  PageController _pageController = PageController();
  RxInt selectedIdx = 0.obs;
  Set<Vehicle> set = {};

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (c, t) {
        _onboardingController.verifiedVehicleKycs[0] = false;
        _onboardingController.verifiedVehicleKycs[1] = false;
        _onboardingController.verifiedVehicleKycs[2] = false;
      },
      child: Scaffold(
        appBar: buildCommonAppbar("Add Vehicles", true, true, context),
        backgroundColor: ColorConstants.bgColor,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [buildVehicleSelectionScreen(), buildKycScreen(context)],
        ),
      ),
    );
  }

  Widget buildVehicleSelectionScreen() => SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSemiText("Choose type of your service vehicle you want to drive on Bhaada".tr)
                .paddingOnly(left: 27.w, bottom: 12.h, top: 35.h, right: 27.w),
            Expanded(
              child: ListView.builder(
                  itemBuilder: (c, i) {
                    return Obx(
                      () => vehicleContainer(
                          "${_onboardingController.lv[i].vehicleName} (${_onboardingController.lv[i].vehicleType})",
                          _onboardingController.lv[i].loadCapacity,
                          selectedIdx.value == i, () {
                        selectedIdx.value = i;
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
                        _onboardingController.verifiedVehicleKycs[0] = false;
                        _onboardingController.verifiedVehicleKycs[1] = false;
                        _onboardingController.verifiedVehicleKycs[2] = false;
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
                buildCommonButton(
                        () => {
                              _onboardingController.currDriver.value.vehicles =
                                  set.toList(),
                              _pageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut)
                            },
                        "Continue".tr,
                        true)
                    .paddingOnly(
                        left: 25.5.w, right: 25.5.w, bottom: 23.h, top: 23.h),
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
                        () async => {Get.to(() => RcVerificationScreen())});
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
            ).paddingOnly(left: 167.w),
            buildCommonButton(
                    () async => {
                          if (_onboardingController
                                      .verifiedVehicleKycs[0] ==
                                  true &&
                              _onboardingController
                                      .verifiedVehicleKycs[1] ==
                                  true &&
                              _onboardingController.verifiedVehicleKycs[2] ==
                                  true &&
                              await homeScreenController.isVehiclePresent(
                                      _onboardingController
                                          .numberPlateValue.value) ==
                                  false &&
                              await homeScreenController
                                      .isAssociatedNumberPlate(
                                          _onboardingController
                                              .numberPlateValue.value) ==
                                  true)
                            {
                              if (_onboardingController
                                          .selectedVehicle.value.vehicleType ==
                                      "2-Wheeler" &&
                                  _onboardingController
                                          .selectedVehicle.value.vehicleType ==
                                      "3-Wheeler")
                                {
                                  homeScreenController.addVehicle({
                                    "regCertificate": _onboardingController
                                        .numberPlateValue.value,
                                    "vehicleName": _onboardingController
                                        .selectedVehicle.value.vehicleName,
                                    "vehicleType": _onboardingController
                                        .selectedVehicle.value.vehicleType,
                                    "imageLink": _onboardingController
                                        .selectedVehicle.value.imgLink,
                                    "loadCapacity": _onboardingController
                                        .selectedVehicle.value.loadCapacity,
                                    "isIntercity": true.toString(),
                                    "isIntracity": false.toString()
                                  }, context).then((c) {
                                    _onboardingController
                                        .verifiedVehicleKycs[0] = false;
                                    _onboardingController
                                        .verifiedVehicleKycs[1] = false;
                                    _onboardingController
                                        .verifiedVehicleKycs[2] = false;
                                  }).then((c) => {
                                        Navigator.pop(context),
                                        Navigator.pop(context),
                                      })
                                }
                              else
                                {Get.to(() => DrivingPreferences())}
                            }
                          else
                            {
                              OverlayLoader.instance().showOverlay(
                                  context: context,
                                  title: "Cannot Add Vehicle".tr,
                                  text:
                                      "Vehicle already registered or Verification error!".tr,
                                  isSuccess: false,
                                  isError: true),
                              _onboardingController.verifiedVehicleKycs[0] =
                                  false,
                              _onboardingController.verifiedVehicleKycs[1] =
                                  false,
                              _onboardingController.verifiedVehicleKycs[2] =
                                  false,
                              Navigator.pop(context),
                              Navigator.pop(context)
                            }
                        },
                    "Continue".tr,
                    true)
                .paddingOnly(
                    left: 25.5.w, right: 25.5.w, bottom: 23.h, top: 23.h)
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
