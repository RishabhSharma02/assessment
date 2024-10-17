import 'dart:ui';

import 'package:bhaada/Constants/color_constants.dart';
import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:bhaada/sections/homescreen/controllers/home_screen_controller.dart';
import 'package:bhaada/sections/homescreen/views/add_vehicles.dart';
import 'package:bhaada/sections/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class YourVehicles extends StatelessWidget {
  YourVehicles({super.key});
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());
  final ProfileController _profileController=Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:buildCommonButton((){
        Get.to(()=>AddVehicles());
      },"Add Vehicles".tr,true).paddingOnly(left: 24.w, right: 24.w, bottom: 49.h, top: 10.h),
      appBar: buildCommonAppbar('Your Vehicles'.tr, true, true,context),
      backgroundColor: ColorConstants.bgColor,
      body: GetBuilder<HomeScreenController>(
          builder: (ctrl) => ListView.builder(
              itemCount: ctrl.userVehicles.length,
              itemBuilder: (ctx, idx) {
                return GestureDetector(
                  onTap:(ctrl.userVehicles[idx].vehicleType=="2-Wheeler"||ctrl.userVehicles[idx].vehicleType=="3-Wheeler")&&!_profileController.isInterCity.value?(){
                    customdialogBuilder1(context, "Vehicle not available due to location preferences".tr, "To use this vehicle change your preferences in the settings of the app.".tr,(){
                      Navigator.of(context).pop();
                    },(){    Navigator.of(context).pop();});
                  }: (){
                    customdialogBuilder1(context, "Want to switch vehicles ?", "Tap Confirm to Switch , Cancel to cancel".tr, (){
                      ctrl.myVehicle.vehicleName=ctrl.userVehicles[idx].vehicleName;
                      ctrl.myVehicle.vehicleType=ctrl.userVehicles[idx].vehicleType;
                      ctrl.myVehicle.rc=ctrl.userVehicles[idx].rc;
                      ctrl.myVehicle.imgLink=ctrl.userVehicles[idx].imgLink;
                      ctrl.myVehicle.loadCapacity=ctrl.userVehicles[idx].loadCapacity;
                      ctrl.update();
                      Navigator.pop(context);

                    }, (){

                      Navigator.pop(context);
                    });


                  },
                  child:

                  buildMyVehicleContainer(
                      ctrl.userVehicles[idx].imgLink,
                      ctrl.userVehicles[idx].vehicleType,
                      ctrl.myVehicle.rc==ctrl.userVehicles[idx].rc,
                      ctrl.userVehicles[idx].loadCapacity,
                      ctrl.userVehicles[idx].rc,(ctrl.userVehicles[idx].vehicleType=="2-Wheeler"||ctrl.userVehicles[idx].vehicleType=="3-Wheeler")&&!_profileController.isInterCity.value)
                );
              })),
    );
  }

  Widget buildMyVehicleContainer(String imgLnk, String type, bool status,
      String loadCapacity, String dlNumber, bool isBlurred) {
    return Opacity(
      opacity: isBlurred ? 0.5 : 1.0, // Adjust the opacity if needed
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: status ? ColorConstants.vehiclBorderColor : ColorConstants.lightGreyColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        color: ColorConstants.textColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      status ? "- ACTIVE".tr : "- INACTIVE".tr,
                      style: TextStyle(
                        color: status ? ColorConstants.greenColor : ColorConstants.redColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Load Capacity: $loadCapacity".tr,
                  style: TextStyle(
                    color: ColorConstants.vehicleLightColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ).paddingOnly(top: 12.h),
                Text(
                  "Plate number: $dlNumber".tr
                  ,
                  style: TextStyle(
                    color: ColorConstants.vehicleLightColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Image.network(
              imgLnk,
              height: 71.h,
              width: 96.w,
            ),
          ],
        ),
      ),
    );
  }

}
