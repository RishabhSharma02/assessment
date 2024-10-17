import 'package:bhaada/Constants/color_constants.dart';
import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:bhaada/sections/homescreen/controllers/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WithdrawlScreen extends StatelessWidget {
  WithdrawlScreen({super.key});
  HomeScreenController _homeScreenController=Get.put(HomeScreenController());
  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Scaffold(
          bottomNavigationBar: buildCommonButton(() => {}, "Withdraw".tr, true)
              .paddingOnly(left: 24.w, right: 24.w, bottom: 49.h, top: 10.h),
          backgroundColor: ColorConstants.bgColor,
          appBar: buildCommonAppbar("Withdrawal".tr, true, true,context),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                buildItems(
                    "Online earnings".tr,
                    "Bhaada’s commission is already deducted.".tr,
                    0,
                    true,
                    true,
                    false,
                    false),
                const Divider(
                  height: 2,
                  color: ColorConstants.lightGreyColor,
                ).paddingSymmetric(horizontal: 26.w, vertical: 18.h),
                buildItems(
                    "Cash in hand".tr,
                    "10% of cash payment commission will be deducted from your wallet.".tr,
                    _homeScreenController.cashInHand.value,
                    true,
                    true,
                    false,
                    false),
                const Divider(
                  height: 2,
                  color: ColorConstants.lightGreyColor,
                ).paddingSymmetric(horizontal: 26.w, vertical: 18.h),
                buildItems(
                    "Total Deductions".tr, "", _homeScreenController.cashInHand.value*0.1, true, false, false, false),
                const Divider(
                  height: 2,
                  color: ColorConstants.lightGreyColor,
                ).paddingSymmetric(horizontal: 26.w, vertical: 18.h),
                buildItems("Amount Withdrawn".tr, "", 0, true, false, true, true),
                const Divider(
                  height: 2,
                  color: ColorConstants.lightGreyColor,
                ).paddingSymmetric(horizontal: 26.w, vertical: 18.h),
                buildItems(
                    "Amount Deposited".tr, "", 0, true, false, true, false),
                const Divider(
                  height: 2,
                  color: ColorConstants.lightGreyColor,
                ).paddingSymmetric(horizontal: 26.w, vertical: 18.h),
                buildItems("Wallet Balance".tr, "",0, true, false, false, false),
                const Divider(
                  height: 2,
                  color: ColorConstants.lightGreyColor,
                ).paddingSymmetric(horizontal: 26.w, vertical: 18.h),
                buildItems(
                    "",
                    "Min balance required This amount will be credited with weekly payout".tr,
                    350,
                    false,
                    true,
                    false,
                    false),
                const Divider(
                  height: 2,
                  color: ColorConstants.lightGreyColor,
                ).paddingSymmetric(horizontal: 26.w, vertical: 18.h),
                buildItems(
                    "Withdrawable Amount".tr, "",_homeScreenController.cashInHand.value<350?0:_homeScreenController.cashInHand.value-350 , true, false, false, false),
              ],
            ).paddingOnly(top: 35.h),
          )),
    );
  }

  Widget buildItems(String title, String subtitle, double amount, bool isTitle,
          bool isSubtitle, bool isAmountColored, bool isRedColored) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: 26.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                      visible: isTitle,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.textColor),
                      )),
                  Visibility(
                      visible: isSubtitle,
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.left,
                        maxLines: 4,
                        style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: ColorConstants.semiTextColor),
                      ))
                ],
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            Text(
              "₹${amount.round()}",
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: isAmountColored
                      ? isRedColored
                          ? ColorConstants.redColor
                          : ColorConstants.greenColor
                      : ColorConstants.blackColor),
            )
          ],
        ),
      );
}
