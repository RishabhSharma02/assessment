import 'package:bhaada/sections/homescreen/controllers/home_screen_controller.dart';
import 'package:bhaada/sections/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Constants/color_constants.dart';
import '../../common widgets/common_widgets.dart';

class DeliveryLocationsScreen extends StatelessWidget {
  DeliveryLocationsScreen({super.key});
  final HomeScreenController homeScreenController=Get.put(HomeScreenController());
  ProfileController profileController=Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Obx(()=>
 Scaffold(
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
                    profileController.isIntraCity.value,
                    (val) {
                       profileController.setIntraUpd(val!);
                    })
                .paddingOnly(left: 27.w, right: 27.w, top: 31.h),
            const Divider(
              color: ColorConstants.lightGreyColor,
            ).paddingOnly(left: 27.w, right: 27.w, top: 10.h),
            buildLocations(
                    "Intercity".tr,
                    "You choose to deliver across the neghibouring cities of your current location.".tr,
                profileController.isInterCity.value,
                    (val) {
                      profileController.setInterUpd(val!);
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
