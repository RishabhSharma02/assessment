import 'package:bhaada/Constants/color_constants.dart';
import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgColor,
      appBar: buildInAppAppbar("Order Details".tr, false, true, false,context),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildOrderText("MEXJ200820 "),
                buildProgressWidget(false)
              ],
            ).paddingOnly(left: 20.w, right: 20.w, top: 30.h),
            StarRating(rating: 3).paddingOnly(left: 20.w, top: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    width: 111.w,
                    child: const Divider(
                      color: ColorConstants.lightGreyColor,
                    )).paddingOnly(right: 7.w),
                buildDateText("12th Aug 2024"),
                SizedBox(
                    width: 111.w,
                    child: const Divider(
                      color: ColorConstants.lightGreyColor,
                    )).paddingOnly(left: 7.w),
              ],
            ).paddingOnly(left: 18.w, right: 18.w, top: 30.h),
            CustomTimeline(),
            buildOrderItem("Receiver".tr, "Kishan Lalwani")
                .paddingOnly(left: 18.w, right: 18.w, top: 30.h),
            const Divider(
              color: ColorConstants.lightGreyColor,
            ).paddingOnly(left: 18.w, right: 18.w, top: 11.h),
            buildOrderItem("Sender".tr, "Rishabh Sharma")
                .paddingOnly(left: 18.w, right: 18.w),
            const Divider(
              color: ColorConstants.lightGreyColor,
            ).paddingOnly(left: 18.w, right: 18.w, top: 11.h),
            buildOrderEbill("E-way bill".tr, "View Bill".tr, () {})
                .paddingOnly(left: 18.w, right: 18.w),
            buildTitleText("Bill Details".tr)
                .paddingOnly(left: 18.w, right: 18.w, top: 43.h),
            buildOrderItem("Trip Fare".tr, "₹668.72")
                .paddingOnly(left: 18.w, right: 18.w, top: 27.h),
            const Divider(
              color: ColorConstants.lightGreyColor,
            ).paddingOnly(left: 18.w, right: 18.w),
            buildOrderItem("Cash collected".tr, "₹0")
                .paddingOnly(left: 18.w, right: 18.w, top: 11.h),
            const Divider(
              color: ColorConstants.lightGreyColor,
            ).paddingOnly(left: 18.w, right: 18.w),
            buildOrderEarning("Bhaada’s deduction".tr, "-₹187.24", true)
                .paddingOnly(left: 18.w, right: 18.w, top: 11.h),
            const Divider(
              color: ColorConstants.lightGreyColor,
            ).paddingOnly(left: 18.w, right: 18.w),
            buildOrderEarning("Your Earnings".tr, "₹187.24", false)
                .paddingOnly(left: 18.w, right: 18.w, top: 11.h),
          ],
        ),
      ),
    );
  }

  Widget buildOrderEbill(
          String leftText, String rightText, Function() onTapped) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: ColorConstants.textColor),
          ),
          InkWell(
            onTap: onTapped,
            child: Text(
              rightText,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.btnColor,
                  decoration: TextDecoration.underline,
                  decorationColor: ColorConstants.btnColor),
            ),
          )
        ],
      );
  Widget buildOrderEarning(
          String leftText, String rightText, bool isDeduction) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: ColorConstants.textColor),
          ),
          Text(
            rightText,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDeduction
                    ? ColorConstants.redColor
                    : ColorConstants.greenColor),
          )
        ],
      );
  Widget buildOrderItem(String leftText, String rightText) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: ColorConstants.textColor),
          ),
          Text(
            rightText,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: ColorConstants.blackColor),
          )
        ],
      );
  Widget buildProgressWidget(bool isCompleted) => Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 3.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.r),
            color: ColorConstants.bgColor,
            border: Border.all(
                color: isCompleted
                    ? ColorConstants.greenColor
                    : ColorConstants.redColor)),
        child: Text(
          isCompleted ? "Completed".tr : "Cancelled".tr,
          style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isCompleted
                  ? ColorConstants.greenColor
                  : ColorConstants.redColor),
        ),
      );
  Widget buildDateText(String date) => Text(
        date,
        style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstants.textColor),
      );
  Widget buildOrderText(String orderId) => Text(
        "Order ID :$orderId".tr,
        style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstants.blackColor),
      );
}

Widget buildTitleText(String text) => Text(
      text,
      style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: ColorConstants.blackColor),
    );

class StarRating extends StatelessWidget {
  final double rating;

  const StarRating({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating - 0.5
              ? Icons.star
              : index < rating
                  ? Icons.star_half
                  : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }
}

class CustomTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTimelineTile(
          time: '9:30 AM',
          description:
              'Moti Nagar Metro Station, DLE Industrial Area, Kirti Nagar, Delhi',
          isFirst: true,
          isLast: false,
          indicatorColor: Colors.green,
        ),
        buildTimelineTile(
          time: '9:47 AM',
          description:
              '31, 32, 33, Central Market, 43, Rd Number 43, West Punjabi Bagh, Punjabi Bagh, New Delhi, Delhi 110026',
          isFirst: false,
          isLast: false,
          indicatorColor: Colors.green,
        ),
        buildTimelineTile(
          time: '10:05 AM',
          description:
              'FIITJEE, 31, 32, 33, Central Market, 43, Rd Number 43, West Punjabi Bagh, Punjabi Bagh, New Delhi, Delhi 110026',
          isFirst: false,
          isLast: true,
          indicatorColor: Colors.red,
        ),
      ],
    );
  }

  Widget buildTimelineTile({
    required String time,
    required String description,
    required bool isFirst,
    required bool isLast,
    required Color indicatorColor,
  }) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.3,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: indicatorColor,
        padding: EdgeInsets.all(6),
      ),
      beforeLineStyle: LineStyle(
        color: Colors.grey,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color: Colors.grey,
        thickness: 2,
      ),
      startChild: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.0),
        child: Text(time),
      ),
      endChild: Container(
        padding: EdgeInsets.all(16.0),
        child: Text(description),
      ),
    );
  }
}
