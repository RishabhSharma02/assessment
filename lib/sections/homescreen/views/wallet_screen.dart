import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:bhaada/sections/homescreen/controllers/home_screen_controller.dart';
import 'package:bhaada/sections/homescreen/views/withdrawl_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Constants/color_constants.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());
  RxDouble initialHeight = 0.h.obs;
  RxDouble initialContainerHeight = 0.h.obs;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: 396.w,
              height: 236.h,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    ColorConstants.homeBgColorStart,
                    ColorConstants.homeBgColorEnd
                  ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildOnlineWidget(homeScreenController.isOnline.value).paddingOnly(right: 16.w, top: 45.h),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildText("Your Earnings".tr).paddingOnly(left: 31.w),
                InkWell(
                  onTap: () {
                    initialHeight.value == 100.h
                        ? initialHeight.value = 0.h
                        : initialHeight.value = 100.h;
                    initialContainerHeight.value == 30.h
                        ? initialContainerHeight.value = 0.h
                        : initialContainerHeight.value = 30.h;
                  },
                  child: Text("Sort By".tr,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: ColorConstants.btnColor,
                              fontSize: 12.sp,
                              decorationColor: ColorConstants.btnColor,
                              fontWeight: FontWeight.w500))
                      .paddingOnly(right: 31.w),
                )
              ],
            ).paddingOnly(top: 170.h),
            const Divider(
              color: ColorConstants.lightGreyColor,
            ).paddingOnly(top: 17.h),
            Obx(() => AnimatedContainer(
                  curve: Curves.easeOut,
                  height: initialHeight.value,
                  duration: const Duration(milliseconds: 200),
                  child: buildSortMenu(),
                )),
            StreamBuilder(stream: homeScreenController.earningStream.value, builder: (c,s){

              if (s.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (s.hasError) {
                return Text('Error: ${s.error}'.tr);
              }
              if (s.hasData && s.data != null&&s.data!.docs.isNotEmpty) {

                return  Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 20.h),
                    itemBuilder: (c, i) {

                        return buildTransactionContainer("assets/images/trip.png",
                            "Cash Collected".tr, s.data!.docs[i].get("timeOfUpload"),s.data!.docs[i].get("fare") , true);
                      }
                    ,
                    itemCount: s.data!.docs.length,
                  ),
                );


              }
              else{
                return
                  buildText("No Data to Show".tr).paddingOnly(top: 50.h);

              }




            }),

          ],
        ),
        Positioned(
            left: 16.w,
            right: 16.w,
            top: 95.h,
            child: buildWalletContainer(
                homeScreenController.wallet.value.floor(),
                homeScreenController.cashInHand.value.floor(),
                0,
                () => {homeScreenController.getPayment()},
                () => {Get.to(() => WithdrawlScreen())}))
      ],
    );
  }

  Widget buildDateText(String date) => Text(
        date,
        style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstants.textColor),
      );
  Widget buildSortMenu() {
    return Padding(
      padding: EdgeInsets.only(top: 17.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRowWithAnimatedContainer([
            _buildAnimatedContainer("By 1 Month".tr,102.w, initialContainerHeight.value,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                )),
            _buildAnimatedContainer("By 3 Month".tr,102.w, initialContainerHeight.value),
            _buildAnimatedContainer("By Date".tr,102.w, initialContainerHeight.value,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                )),
          ], horizontalPadding: 21.w),
          SizedBox(height: 5.h), // Adjust vertical spacing
          _buildRowWithAnimatedContainer([
            _buildAnimatedContainer("From".tr,155.w, initialContainerHeight.value,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                )),
            _buildAnimatedContainer("To".tr,155.w, initialContainerHeight.value,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                )),
          ], horizontalPadding: 21.w, verticalPadding: 5.h),
        ],
      ),
    );
  }

  Widget _buildRowWithAnimatedContainer(List<Widget> children,
      {double horizontalPadding = 0, double verticalPadding = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }

  Widget _buildAnimatedContainer(String text,double width, double height,
      {BorderRadius borderRadius = BorderRadius.zero}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: ColorConstants.walletColor,
      ),
      child: Center(child: Text(text,style:  TextStyle(color: ColorConstants.fontLightColor,fontSize: 12.sp),)),
    );
  }

  Widget buildText(String text) => Text(
        text,
        style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstants.blackColor),
        textAlign: TextAlign.left,
      );
  Widget buildOnlineWidget(bool isOnline) => Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: isOnline
            ? ColorConstants.bgColor
            : ColorConstants.lightGreyColor),
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
    child: Text(
      isOnline ? "ONLINE".tr : "OFFLINE".tr,
      style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: isOnline
              ? ColorConstants.btnColor
              : ColorConstants.textColor),
    ),
  );
  Widget buildWalletContainer(int walBal, int cashInHnd, int whdBal,
          Function() onDeposit, Function() onWithdraw) =>
      Container(
        width: 328.w,
        decoration: BoxDecoration(
            color: ColorConstants.bgColor,
            boxShadow: const [
              BoxShadow(color: ColorConstants.lightGreyColor, spreadRadius: 1)
            ],
            borderRadius: BorderRadius.circular(11)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 18.w,
                top: 11.h,
                bottom: 11.h,
              ),
              decoration: const BoxDecoration(
                  color: ColorConstants.walletColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(11),
                      topRight: Radius.circular(11))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/wallet_unfilled.png",
                    width: 19.w,
                    height: 19.h,
                  ).paddingOnly(right: 10.w),
                  Text(
                    "${homeScreenController.userName.value.split(" ")[0]}'s Wallet",
                    style: TextStyle(
                        fontSize: 12.sp, color: ColorConstants.textColor),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Wallet Balance".tr,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstants.textColor,
                      fontWeight: FontWeight.w500),
                ).paddingOnly(left: 18.w),
                Text(
                  "₹$walBal",
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstants.blackColor,
                      fontWeight: FontWeight.w600),
                ).paddingOnly(right: 16.w),
              ],
            ).paddingOnly(top: 17.h),
            SizedBox(
              width: 296.w,
              height: 2.h,
              child: const Divider(
                color: ColorConstants.lightGreyColor,
              ),
            ).paddingOnly(top: 10.h, left: 18.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cash in hand".tr,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstants.textColor,
                      fontWeight: FontWeight.w500),
                ).paddingOnly(left: 18.w),
                Text(
                  "₹$cashInHnd",
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstants.blackColor,
                      fontWeight: FontWeight.w600),
                ).paddingOnly(right: 16.w),
              ],
            ).paddingOnly(top: 10.h),
            SizedBox(
              width: 296.w,
              height: 2.h,
              child: const Divider(
                color: ColorConstants.lightGreyColor,
              ),
            ).paddingOnly(top: 10.h, left: 18.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Withdrawable amount".tr,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstants.textColor,
                      fontWeight: FontWeight.w500),
                ).paddingOnly(left: 18.w),
                Text(
                  "₹$whdBal",
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstants.blackColor,
                      fontWeight: FontWeight.w600),
                ).paddingOnly(right: 16.w),
              ],
            ).paddingOnly(top: 10.h),
            Text(
              "Please maintain a ₹350 wallet balance for cash deliveries.".tr,
              style: TextStyle(
                decorationColor: ColorConstants.btnColor,
                decorationThickness: 1,
                decoration: TextDecoration.underline,
                height: 2,
                color: ColorConstants.btnColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ).paddingOnly(top: 39.h, left: 18.w, bottom: 10.h),
            Row(
              children: [
                buildWalletButton(onDeposit, "Deposit".tr, true)
                    .paddingOnly(left: 18.w, right: 16.w, bottom: 16.h),
                buildWalletButton(onWithdraw, "Withdraw".tr, false)
                    .paddingOnly(right: 18.w, bottom: 16.h),
              ],
            ),
          ],
        ),
      );
}
