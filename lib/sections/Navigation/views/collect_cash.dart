import 'package:bhaada/Constants/color_constants.dart';
import 'package:bhaada/main.dart';
import 'package:bhaada/sections/Navigation/controllers/ride_controller.dart';
import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:bhaada/sections/homescreen/controllers/home_screen_controller.dart';
import 'package:bhaada/sections/homescreen/views/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CollectCash extends StatelessWidget {
  CollectCash({super.key});
  final RideController _rideController = Get.put(RideController());
  final HomeScreenController _homeScreenController=Get.put(HomeScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildCommonButton(() {
        _rideController.updateFirstDocumentValue(_rideController.cashToCollect,context);

        _homeScreenController.isRideStarted.value=false;



      }, "Complete Ride".tr, true)
          .paddingOnly(left: 24.w, right: 24.w, bottom: 49.h, top: 10.h),
      backgroundColor: ColorConstants.bgColor,
      appBar: buildCommonAppbar("Collect Cash".tr, true, true,context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "This Order is Cash on delivery".tr,
            style: TextStyle(color: ColorConstants.redColor, fontSize: 16.sp),
          ).paddingOnly(left: 25.w, top: 10.h),
          Container(
            margin: EdgeInsets.only(left: 25.w, top: 15.h, right: 25.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorConstants.btnColor),
            ),
            padding: const EdgeInsets.all(17),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Cash to Collect".tr,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.btnColor,
                  ),
                ),
                Text(
                  "₹ ${_rideController.cashToCollect}",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.btnColor,
                  ),
                ).paddingOnly(left: 63.w),
              ],
            ),
          )
        ],
      ),
    );
  }
}
