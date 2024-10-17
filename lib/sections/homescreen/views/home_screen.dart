import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bhaada/Constants/color_constants.dart';
import 'package:bhaada/sections/Onboarding/controllers/onboarding_controller.dart';
import 'package:bhaada/sections/Onboarding/utils/utils.dart';
import 'package:bhaada/sections/homescreen/shimmers/homescreen_shimmers.dart';
import 'package:bhaada/sections/homescreen/views/your_vehicles.dart';
import 'package:bhaada/sections/profile/views/delivery_locations.dart';
import 'package:bhaada/sections/profile/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../common widgets/common_widgets.dart';
import '../controllers/home_screen_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeScreenController _homeScreenController =
      Get.put(HomeScreenController());
  final RxBool isTapped = false.obs;
  final RxInt idx = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => !_homeScreenController.userAlreadyExists.value
          ? Container(
              color: Colors.white,
            )
          : Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _homeScreenController.dataLoading.value
                              ? buildNameShimmer().paddingOnly(
                                  top: 10.h, left: 16.w, right: 16.w)
                              : buildProfileSection(
                                      _homeScreenController.userName.value,
                                      _homeScreenController
                                          .myLocationString.value,
                                      _homeScreenController.imageUrl.value)
                                  .paddingOnly(top: 10.h),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildText("Your Vehicles".tr)
                                .paddingOnly(top: 225.h, left: 31.w),
                            InkWell(
                              onTap: () {
                                Get.to(() => YourVehicles());
                              },
                              child: Text("See All".tr,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: ColorConstants.blackColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500))
                                  .paddingOnly(top: 225.h, right: 31.w),
                            )
                          ],
                        ),
                        GetBuilder<HomeScreenController>(
                            builder: (ctrl) => buildMyVehicleContainer(
                                ctrl.myVehicle.imgLink,
                                ctrl.myVehicle.vehicleName,
                                true,
                                ctrl.myVehicle.loadCapacity,
                                ctrl.myVehicle.rc)),
                        buildLightText(_homeScreenController.isOnline.value
                                ? "Slide again to go OFFLINE".tr
                                : "Slide again to go ONLINE".tr)
                            .paddingOnly(top: 7.h, left: 26.w),
                        CustomSliderButton(
                          width: 317.w,
                          height: 51.h,
                          onCompleted: () {
                            AwesomeNotifications().createNotification(
                                content: NotificationContent(
                              id: 10,
                              channelKey: 'call_channel',
                              actionType: ActionType.Default,
                              title: 'Listening for Orders!'.tr,
                              body: 'Slide back button to stop listening'.tr,
                            ));

                            _homeScreenController
                                .startListeningForOrders(context);
                            _homeScreenController.isOnline.value = true;
                          },
                          onReset: () {
                            _homeScreenController.stopListeningForOrders();
                            _homeScreenController.isOnline.value = false;
                          },
                          state: _homeScreenController.isOnline.value,
                        ).paddingOnly(top: 9.h),
                      ],
                    ),
                  ),
                ],
              ),
              StreamBuilder(
                  stream: _homeScreenController.notificationStream.value,
                  builder: (c, s) {
                    if (s.connectionState == ConnectionState.waiting) {
                      return Positioned(
                          top: 136.h,
                          left: 16.w,
                          right: 16.w,
                          child: buildPerformanceShimmer());
                    }
                    if (s.hasError) {
                      return Text('Error: ${s.error}'.tr);
                    }
                    if (s.hasData && s.data != null) {
                      final data = s.data;
                      int tasksDone = data?.docs.first.get("tasksDone");
                      int loginHours = data?.docs.first.get("loginHours");
                      int trips = data?.docs.first.get("trips");
                      double earnings =
                          data?.docs.first.get("earnings").toDouble();
                      int orders = data?.docs.first.get("orders");
                      return Positioned(
                          top: 136.h,
                          left: 16.w,
                          right: 16.w,
                          child: buildPerformanceSection(
                              tasksDone.toInt(),
                              earnings.toInt(),
                              trips.toInt(),
                              loginHours.toInt(),
                              orders.toInt(),
                              earnings.toInt()));
                    } else {
                      return Positioned(
                          top: 136.h,
                          left: 16.w,
                          right: 16.w,
                          child: buildPerformanceShimmer());
                    }
                  }),
            ]),
    );
  }

  void _showWelcomeDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Planning to deliver in different city?".tr,
            style: TextStyle(fontSize: 22.sp),
          ),
          content: SizedBox(
            height: 220.h, // Increased height
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Explore Intracity and Intercity modes in settings. "
                  "Distances greater than 400 km are considered intracity. "
                  "These modes allow you to seamlessly manage deliveries across cities. "
                  "Whether you're delivering within the city limits or across state lines, "
                  "you can adjust your delivery preferences to suit your needs.".tr,
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Explore later'.tr,
                style:
                    TextStyle(color: ColorConstants.btnColor, fontSize: 14.sp),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Take me there'.tr,
                style:
                    TextStyle(color: ColorConstants.btnColor, fontSize: 14.sp),
              ),
              onPressed: () {
                Get.to(() => DeliveryLocationsScreen());
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildMyVehicleContainer(String imgLnk, String type, bool status,
          String loadCapacity, String dlNumber) =>
      Stack(children: [
        Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border.all(color: ColorConstants.vehiclBorderColor),
              borderRadius: BorderRadius.circular(8)),
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
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        status == true ? "- ACTIVE".tr : "- INACTIVE".tr,
                        style: TextStyle(
                            color: status == true
                                ? ColorConstants.greenColor
                                : ColorConstants.redColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Text(
                    "Load Capacity: $loadCapacity".tr,
                    style: TextStyle(
                        color: ColorConstants.vehicleLightColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500),
                  ).paddingOnly(top: 12.h),
                  Text(
                    "Plate number: $dlNumber".tr,
                    style: TextStyle(
                        color: ColorConstants.vehicleLightColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Image.network(
                imgLnk,
                height: 71.h,
                width: 96.w,
              )
            ],
          ),
        ),
      ]);

  Widget buildText(String text) => Text(
        text,
        style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorConstants.blackColor),
        textAlign: TextAlign.left,
      );

  Widget buildLightText(String text) => Text(
        text,
        style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: ColorConstants.fontLightColor),
        textAlign: TextAlign.left,
      );

  Widget buildPerformanceSection(int taskCnt, int earningCnt, int trpCnt,
          int lgnCnt, int odrCnt, int ernAmt) =>
      Obx(
        () => Container(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
              color: ColorConstants.bgColor,
              borderRadius: BorderRadius.circular(11),
              boxShadow: const [
                BoxShadow(color: ColorConstants.lightGreyColor, spreadRadius: 2)
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Today’s Performance".tr,
                  style: TextStyle(
                      color: ColorConstants.btnColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500)),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildTopContainers(taskCnt, "Tasks done".tr, false)
                        .paddingOnly(top: 13.h),
                    VerticalDivider(
                      width: 2,
                      endIndent: 5.h,
                      indent: 15.h,
                      color: ColorConstants.lightGreyColor,
                    ),
                    buildTopContainers(earningCnt, "Earnings".tr, true)
                        .paddingOnly(top: 13.h)
                  ],
                ),
              ),
              const Divider(
                color: ColorConstants.lightGreyColor,
              ).paddingOnly(top: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Performance this month".tr,
                          style: TextStyle(
                              color: ColorConstants.blackColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500))
                      .paddingOnly(top: 15.h),
                  GestureDetector(
                    onTap: () {
                      isTapped.value = !isTapped.value;
                    },
                    child: Text(isTapped.value ? "₹$ernAmt" : "₹ xx,xxx",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: ColorConstants.blackColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500))
                        .paddingOnly(top: 15.h),
                  )
                ],
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildPContainers(trpCnt, "Trips".tr)
                        .paddingOnly(right: 20.5.w),
                    const VerticalDivider(
                      width: 2,
                      color: ColorConstants.lightGreyColor,
                    ),
                    buildPContainers(lgnCnt, "Login hours".tr)
                        .paddingOnly(left: 20.5.w, right: 20.5.w),
                    const VerticalDivider(
                      width: 2,
                      color: ColorConstants.lightGreyColor,
                    ),
                    buildPContainers(odrCnt, "Orders".tr)
                        .paddingOnly(left: 20.5.w),
                  ],
                ).paddingOnly(top: 21.h),
              )
            ],
          ),
        ),
      );

  Widget buildTopContainers(int taskCnt, String name, bool isCurrency) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCurrency ? "₹${formatNumber(taskCnt)}" : formatNumber(taskCnt),
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 28.sp,
                color: ColorConstants.blackColor),
          ),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp),
          )
        ],
      );

  Widget buildPContainers(int cnt, String type) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: ColorConstants.lightGreyColor,
                borderRadius: BorderRadius.circular(29)),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
            child: Text(formatNumber(cnt),
                style: TextStyle(
                    color: ColorConstants.blackColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500)),
          ),
          Text(
            type,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp),
          ).paddingOnly(top: 13.h)
        ],
      );

  Widget buildProfileSection(String name, String address, String imgUrl) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Hi, ${name.length > 7 ? name.substring(0, 7) : name}".tr,
                style: TextStyle(
                    color: ColorConstants.bgColor,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "assets/images/Vector.png",
                    width: 11.34.w,
                    height: 11.34.h,
                  ).paddingOnly(right: 5.w),
                  Text(
                      "${address.length > 30 ? address.substring(0, 30) : address}...",
                      style: TextStyle(
                          color: ColorConstants.bgColor,
                          overflow: TextOverflow.fade,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500)),
                ],
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.to(ProfileScreen());
            },
            child: Container(
              width: 54.w,
              height: 54.w,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imgUrl), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                  color: Colors.white,
                  shape: BoxShape.circle),
            ),
          )
        ],
      ).paddingSymmetric(horizontal: 32.w);
}
