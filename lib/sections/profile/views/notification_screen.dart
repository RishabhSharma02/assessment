import 'package:bhaada/sections/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Constants/color_constants.dart';
import '../../common widgets/common_widgets.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});
  final ProfileController profileController =Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Scaffold(
        backgroundColor: ColorConstants.bgColor,
        appBar: buildInAppAppbar("Notifications".tr, true, true, homeScreenController.isOnline.value,context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText("Gen notifications about all of your preferred choices below".tr).paddingOnly(left: 27.w, right: 27.w, top: 31.h),
            buildNotifications("Trip notifications", "Get instant alerts for shipping orders".tr, profileController.isTripUpdatesEnabled.value, (val){
              profileController.setTripUpd(val!);
            }).paddingOnly(left: 27.w, right: 27.w, top: 31.h),
            const Divider(color: ColorConstants.lightGreyColor,).paddingOnly(left: 27.w, right: 27.w, top: 10.h),
            buildNotifications("Transaction updates".tr, "Get notifications for credited and debited activities of your wallet".tr, profileController.isTransactionUpdatesEnabled.value, (val){
              profileController.setTransUpd(val!);
            }).paddingOnly(left: 27.w, right: 27.w, top: 11.h),
            const Divider(color: ColorConstants.lightGreyColor,).paddingOnly(left: 27.w, right: 27.w, top: 10.h ),
            buildNotifications("Promotional Updates".tr, "Get instant updates for offers".tr, profileController.isOffersNotificationEnabled.value, (val){
              profileController.setOfferUpd(val!);
            }).paddingOnly(left: 27.w, right: 27.w, top: 11.h),
            const Divider(color: ColorConstants.lightGreyColor,).paddingOnly(left: 27.w, right: 27.w, top: 10.h),
          ],
        ),
      ),
    );
  }

  Widget buildNotifications(String title, String subtitle, bool value,
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
