import 'package:bhaada/sections/homescreen/controllers/home_screen_controller.dart';
import 'package:bhaada/sections/homescreen/views/order_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../Constants/color_constants.dart';
import '../../Onboarding/utils/utils.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
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
                  buildOnlineWidget(homeScreenController.isOnline.value)
                      .paddingOnly(right: 16.w, top: 45.h),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildText("Orders history".tr).paddingOnly(left: 31.w),
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
                ),
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
            Expanded(
              child: StreamBuilder(
                  stream: homeScreenController.orderStream.value,
                  builder: (c, s) {
                    if (s.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (s.hasError) {
                      return Text('Error: ${s.error}'.tr);
                    }
                    if (s.hasData &&
                        s.data != null &&
                        s.data!.docs.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 20.h),
                        itemBuilder: (c, i) {
                          return Column(
                            children: [
                              buildOrderListContainer(
                                  s.data!.docs[i].get("locationData")[0]
                                      ["latLng"],
                                  s.data!.docs[i].get("timeOfUpload"),
                                  s.data!.docs[i].get("fare").toDouble(),
                                  s.data!.docs[i].get("modeOfPayment"),
                                  true),
                              SizedBox(
                                  width: 296.w,
                                  child: const Divider(
                                    color: ColorConstants.lightGreyColor,
                                  ))
                            ],
                          );
                        },
                        itemCount: s.data!.docs.length,
                      );
                    } else {
                      return buildText("No Data to Show".tr)
                          .paddingOnly(top: 50.h);
                    }
                  }),
            ),
          ],
        ),
        StreamBuilder(
            stream: homeScreenController.orderStream1.value,
            builder: (c, s) {
              if (s.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (s.hasError) {
                return Text('Error: ${s.error}'.tr);
              }
              if (s.hasData && s.data != null && s.data!.docs.isNotEmpty) {
                return Positioned(
                    left: 16.w,
                    right: 16.w,
                    top: 95.h,
                    child: buildOrderContainer(
                        true,
                        false,
                        "UPI",
                        s.data!.docs[0].get("locationData")[0]["latLng"],
                        s.data!.docs[0].get("locationData")[0]["latLng"],
                        1.0,
                        s.data!.docs[0].id,
                        s.data!.docs[0].get("fare")));
              } else {
                return Positioned(
                    left: 16.w,
                    right: 16.w,
                    top: 95.h,
                    child: buildOrderContainer(
                        false,
                        true,
                        "UPI",
                        const GeoPoint(0, 0),
                        const GeoPoint(0, 0),
                        1.0,
                        "",
                        0.0));
              }
            }),
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
  Widget buildSortMenu() {
    return Padding(
      padding: EdgeInsets.only(top: 17.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRowWithAnimatedContainer([
            _buildAnimatedContainer(
                "By 1 Month".tr, 102.w, initialContainerHeight.value,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                )),
            _buildAnimatedContainer(
                "By 3 Month".tr, 102.w, initialContainerHeight.value),
            _buildAnimatedContainer(
                "By Date".tr, 102.w, initialContainerHeight.value,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                )),
          ], horizontalPadding: 21.w),
          SizedBox(height: 5.h), // Adjust vertical spacing
          _buildRowWithAnimatedContainer([
            _buildAnimatedContainer("From".tr, 155.w, initialContainerHeight.value,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                )),
            _buildAnimatedContainer("To".tr, 155.w, initialContainerHeight.value,
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

  Widget _buildAnimatedContainer(String text, double width, double height,
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
      child: Center(
          child: Text(
        text,
        style: TextStyle(color: ColorConstants.fontLightColor, fontSize: 12.sp),
      )),
    );
  }

  Widget buildOrderContainer(
          bool isData,
          bool isRideOngoing,
          String methodOfPayment,
          GeoPoint from,
          GeoPoint to,
          double progressPercentage,
          String orderID,
          double amount) =>
      Container(
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(color: ColorConstants.lightGreyColor, spreadRadius: 1)
            ],
            color: ColorConstants.bgColor,
            borderRadius: BorderRadius.circular(11)),
        child: !isData
            ? Center(
                child: Text(
                  "No Data to show".tr,
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: ColorConstants.textColor,
                      fontWeight: FontWeight.w500),
                ),
              ).paddingOnly(top: 130.h, bottom: 130.h)
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 18.w, top: 9.h, bottom: 9.h, right: 16.w),
                    decoration: const BoxDecoration(
                        color: ColorConstants.walletColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(11),
                            topRight: Radius.circular(11))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/images/ongoing.png",
                          fit: BoxFit.cover,
                          width: 23.w,
                          height: 23.h,
                        ).paddingOnly(right: 5.w),
                        Text(
                          isRideOngoing ? "Ongoing Ride".tr : "Previous Ride".tr,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: ColorConstants.textColor,
                              fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        buildProgressWidget(!isRideOngoing, methodOfPayment)
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isRideOngoing ? "Ongoing Ride".tr : "Previous Ride".tr,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorConstants.vehicleLightColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Trip Fare".tr,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorConstants.vehicleLightColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ).paddingOnly(top: 12.h, right: 16.w, left: 16.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        orderID,
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorConstants.blackColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "₹${amount.floor()}",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorConstants.blackColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ).paddingOnly(right: 16.w, left: 16.w),
                  const Divider(
                    color: ColorConstants.lightGreyColor,
                    thickness: 2,
                  ).paddingOnly(right: 16.w, left: 16.w),
                  CustomProgressTimeline(
                    progress: progressPercentage,
                  ).paddingOnly(top: 23.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "From".tr,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorConstants.vehicleLightColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "To".tr,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorConstants.vehicleLightColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ).paddingOnly(top: 10.h, right: 16.w, left: 16.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: FutureBuilder<String>(
                          future:
                          homeScreenController.getAddressFromGeopoint(from),
                          builder: (c, s) {
                            if (s.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (s.hasError) {
                              return Text('Error: ${s.error}'.tr);
                            }
                            if (!s.hasData || s.data == null) {
                              return Text(
                                'No Address Available'.tr,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    overflow: TextOverflow.ellipsis,
                                    color: ColorConstants.blackColor,
                                    fontWeight: FontWeight.w500),
                                maxLines: 2,
                              );
                            }

                            return Text(
                              s.data!,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  overflow: TextOverflow.ellipsis,
                                  color: ColorConstants.blackColor,
                                  fontWeight: FontWeight.w500),
                              maxLines: 2,
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        flex: 2,
                        child: FutureBuilder<String>(
                          future:
                              homeScreenController.getAddressFromGeopoint(to),
                          builder: (c, s) {
                            if (s.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (s.hasError) {
                              return Text('Error: ${s.error}'.tr);
                            }
                            if (!s.hasData || s.data == null) {
                              return Text(
                                'No Address Available'.tr,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    overflow: TextOverflow.ellipsis,
                                    color: ColorConstants.blackColor,
                                    fontWeight: FontWeight.w500),
                                maxLines: 2,
                              );
                            }

                            return Text(
                              s.data!,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  overflow: TextOverflow.ellipsis,
                                  color: ColorConstants.blackColor,
                                  fontWeight: FontWeight.w500),
                              maxLines: 2,
                            );
                          },
                        ),
                      )
                    ],
                  ).paddingOnly(right: 16.w, left: 16.w),
                  const Divider(
                    color: ColorConstants.lightGreyColor,
                    thickness: 2,
                  ).paddingOnly(right: 16.w, left: 16.w, top: 12.h),
                  GestureDetector(
                    onTap: () {
                      Get.to(const OrderDetailsScreen());
                    },
                    child: Text(
                      "View Details".tr,
                      style: TextStyle(
                          fontSize: 12.sp,
                          decoration: TextDecoration.underline,
                          decorationColor: ColorConstants.timeLineColor,
                          color: ColorConstants.timeLineColor,
                          fontWeight: FontWeight.w600),
                    ).paddingOnly(bottom: 15.h, top: 9.h),
                  ),
                ],
              ),
      );

  Widget buildOrderListContainer(GeoPoint address, Timestamp timeStamp,
      double amount, String method, bool incoming) {
    return FutureBuilder<String>(
      future: homeScreenController.getAddressFromGeopoint(address),
      builder: (c, s) {
        if (s.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (s.hasError) {
          return Text('Error: ${s.error}'.tr);
        }
        if (!s.hasData || s.data == null) {
          return  Text('No Address Available'.tr);
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.data!.substring(0, s.data!.length - 5),
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    homeScreenController.formatTimestamp(timeStamp),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.fontLightColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${formatNumber(amount.toInt())}",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    method,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.fontLightColor,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8.6.w),
              incoming
                  ? const Icon(
                      Icons.check,
                      color: ColorConstants.greenColor,
                    )
                  : const Icon(
                      Icons.close,
                      color: ColorConstants.redColor,
                    )
            ],
          ),
        );
      },
    );
  }
}

Widget buildProgressWidget(bool isCompleted, String methodOfPayment) =>
    Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 3.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17.r),
          color: isCompleted
              ? ColorConstants.greenColor
              : ColorConstants.redColor),
      child: Text(
        isCompleted ? "Completed".tr : methodOfPayment,
        style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstants.bgColor),
      ),
    );

class CustomProgressTimeline extends StatelessWidget {
  final double progress;
  const CustomProgressTimeline({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(280.w, 16.h),
          painter: ProgressTimelinePainter(progress),
        ),
      ],
    );
  }
}

class ProgressTimelinePainter extends CustomPainter {
  final double progress;

  ProgressTimelinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = ColorConstants.timeLineColor
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final paintProgress = Paint()
      ..color = ColorConstants.timeLineColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;

    final paintGray = Paint()
      ..color = ColorConstants.dividerColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill;

    canvas.drawLine(Offset(0, size.height / 2),
        Offset(size.width, size.height / 2), paintGray);

    // Draw the progress line (light blue)
    canvas.drawLine(Offset(0, size.height / 2),
        Offset(size.width * progress, size.height / 2), paintProgress);

    // Draw the circles
    final double radius = 7.0;
    final double centerY = size.height / 2;

    // Start Circle (Filled Light Blue)
    canvas.drawCircle(Offset(0, centerY), radius, paintProgress);

    // Progress Circle (Filled Light Blue)
    canvas.drawCircle(
        Offset(size.width * progress, centerY), radius, paintProgress);

    // End Circle (Hollow Gray)
    canvas.drawCircle(Offset(size.width, centerY), radius, paintGray);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint whenever the progress changes
  }
}
