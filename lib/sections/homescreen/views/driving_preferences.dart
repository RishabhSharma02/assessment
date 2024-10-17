import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Constants/color_constants.dart';
import '../../Onboarding/controllers/onboarding_controller.dart';
import '../../common widgets/common_widgets.dart';

class DrivingPreferences extends StatelessWidget {
  DrivingPreferences({super.key});
  final OnboardingController _onboardingController =
  Get.put(OnboardingController());
  RxBool isIntracity=false.obs;
  RxBool isIntercity=false.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Scaffold(
        bottomNavigationBar: buildCommonButton((){
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
            "isIntercity":isIntercity.value.toString(),
            "isIntracity":isIntracity.value.toString()
          }, context).then((c) {
            _onboardingController.verifiedVehicleKycs[0] =
            false;
            _onboardingController.verifiedVehicleKycs[1] =
            false;
            _onboardingController.verifiedVehicleKycs[2] =
            false;
          }).then((c) => {
            Navigator.pop(context),
            Navigator.pop(context),
            Navigator.pop(context),

          });
        }, "Add Vehicle".tr, true).paddingOnly(
            left: 25.5.w, right: 25.5.w, bottom: 23.h, top: 23.h),
        backgroundColor: ColorConstants.bgColor,
        appBar: buildInAppAppbar("Delivery locations".tr, true, true, homeScreenController.isOnline.value,context),
        body: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText(
                "Choose your zone in which you would like to work with us. You can also choose both.".tr)
                .paddingOnly(left: 27.w, right: 27.w, top: 31.h),
            buildLocations(
                "Intracity".tr,
                "You choose to deliver within the city your current location is.".tr,
                isIntracity.value,
                    (val) {
                      isIntracity.value=!isIntracity.value;
                  //profileController.setIntraUpd(val!);
                })
                .paddingOnly(left: 27.w, right: 27.w, top: 31.h),
            const Divider(
              color: ColorConstants.lightGreyColor,
            ).paddingOnly(left: 27.w, right: 27.w, top: 10.h),
            buildLocations(
                "Intercity".tr,
                "You choose to deliver across the neghibouring cities of your current location.".tr,
                isIntercity.value,
                    (val) {
                      isIntercity.value=!isIntercity.value;
                })
                .paddingOnly(left: 27.w, right: 27.w, top: 10.h),
            const Divider(
              color: ColorConstants.lightGreyColor,
            ).paddingOnly(left: 27.w, right: 27.w, top: 10.h),
          ],
        ),

      ),
    );
  }
  Widget buildLocations(String title, String subtitle, bool value,
      Function(bool?) onSelected) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.blackColor),
                ),
                Text(
                  subtitle,
                  maxLines: 3,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12.sp, color: ColorConstants.vehicleLightColor),
                ),
              ],
            ),
          ),
          Checkbox(
              value: value,
              onChanged: onSelected,
              fillColor:value? WidgetStateProperty.all(ColorConstants.btnColor):WidgetStateProperty.all(ColorConstants.bgColor))
        ],
      );
  Widget buildText(String text) => Text(
    text,
    textAlign: TextAlign.left,
    style: TextStyle(fontSize: 14.sp, color: ColorConstants.textColor),
  );
}
