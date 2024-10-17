import 'package:bhaada/constants/color_constants.dart';
import 'package:bhaada/sections/Onboarding/views/login_screen.dart';
import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:bhaada/sections/homescreen/controllers/home_screen_controller.dart';
import 'package:bhaada/sections/profile/views/coupons_screen.dart';
import 'package:bhaada/sections/profile/views/delivery_locations.dart';
import 'package:bhaada/sections/profile/views/languages_screen.dart';
import 'package:bhaada/sections/profile/views/notification_screen.dart';
import 'package:bhaada/sections/profile/views/personal_info.dart';
import 'package:bhaada/sections/profile/views/support_screen.dart';
import 'package:clipboard/clipboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final HomeScreenController homeScreenController=Get.put(HomeScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            leading: GestureDetector(
                onTap: () => {
                  Navigator.pop(context)
                },
                child: const Icon(Icons.arrow_back_ios)),
            pinned: true,
            title: Text(
              "Your Profile".tr,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
                color: ColorConstants.blackColor,
              ),
            ),
            actions: [buildOnlineWidget(homeScreenController.isOnline.value).paddingAll(10)],
            backgroundColor: ColorConstants.bgColor,
            expandedHeight: 170.h,
            // Adjust this value based on your profile container height
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return buildProfileContainer(
                        homeScreenController.imageUrl.value, homeScreenController.userName.value.split(" ")[0], homeScreenController.phoneNumber.value, homeScreenController.userRating.value)
                    .paddingOnly(top: 100.h);
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                buildSubsection("Settings and Preferences".tr)
                    .paddingOnly(left: 21.w, top: 37.h, bottom: 29.h),
                GestureDetector(
                  onTap: () {
                    homeScreenController.profileNameController.value.setText(homeScreenController.userName.value);
                    homeScreenController.profileNumberController.value.setText(homeScreenController.phoneNumber.value);
                    Get.to(() => PersonalInformationScreen());
                  },
                  child: buildMenu("assets/images/pi.png",
                      "Personal Information".tr, "Name, Phone number".tr),
                ),
                const Divider(
                  color: ColorConstants.lightGreyColor,
                ).paddingSymmetric(horizontal: 27.w),
                GestureDetector(
                  onTap: () {
                    Get.to(() => LanguagesScreen());
                  },
                  child: buildMenu("assets/images/lang_chg.png", "Languages",
                      "Chosen language: English"),
                ),
                const Divider(
                  color: ColorConstants.lightGreyColor,
                ).paddingSymmetric(horizontal: 27.w),
                GestureDetector(
                  onTap: () {
                    Get.to(() =>  NotificationScreen());
                  },
                  child: buildMenu("assets/images/noti.png", "Notifications".tr,
                      "Receive trip alters and promotions: ON".tr),
                ),
                const Divider(
                  color: ColorConstants.lightGreyColor,
                ).paddingSymmetric(horizontal: 27.w),
                GestureDetector(
                  onTap: () {
                    Get.to(() => DeliveryLocationsScreen());
                  },
                  child: buildMenu("assets/images/address.png",
                      "Delivery Locations".tr, "Choose your preferred zone ".tr),
                ),
                buildSubsection("Additional")
                    .paddingOnly(left: 21.w, top: 37.h, bottom: 29.h),
                GestureDetector(
                  onTap: (){
                    Get.to(const CouponsScreen());
                  },
                  child: buildMenu("assets/images/offrs.png", "Offers and coupons ".tr,
                      "Get exclusive offers and save more".tr),
                ),
                const Divider(
                  color: ColorConstants.lightGreyColor,
                ).paddingSymmetric(horizontal: 27.w),
                GestureDetector(
                  onTap: (){
                    FlutterClipboard.copy('28AUG10').then(( value ){
                      OverlayLoader.instance().showOverlay(
                          title: "Success!".tr,
                          context: context,
                          text: "Copied Code to Clipboard!".tr,
                          isSuccess: true);
                    });
                  },
                  child: buildMenu("assets/images/refer.png", "Refer your friends".tr,
                      "Share your code ".tr),
                ),
                const Divider(
                  color: ColorConstants.lightGreyColor,
                ).paddingSymmetric(horizontal: 27.w),
                GestureDetector(
                  onTap: (){
                  // Get.to(()=>SupportScreen());
                  },
                  child: buildMenu("assets/images/support.png", "Get support".tr,
                      "Connect with our support team".tr),
                ),
                buildSubsection("Account Management".tr)
                    .paddingOnly(left: 21.w, top: 37.h, bottom: 29.h),
                GestureDetector(
                  onTap: (){
                    customdialogBuilder1(
                      context,
                      "Are you sure want to Logout ?".tr,
                      "Confirm to logout,Cancel to Cancel the process ".tr,
                          () {
                            FirebaseAuth.instance.signOut();
                            Get.offAll(()=>LoginScreen());
                      },
                          () {
                       Navigator.pop(context);
                      },
                    );

                  },
                  child: buildLogout("assets/images/logout.png", "Log Out".tr,
                      "Temporarily sign out from device".tr),
                ),
                const Divider(
                  color: ColorConstants.lightGreyColor,
                ).paddingSymmetric(horizontal: 27.w),
                GestureDetector(
                  onTap: (){
                    OverlayLoader.instance().showOverlay(
                        title: "Info".tr,
                        context: context,
                        text:
                        "To delete account please reach us at +91 77540 90709".tr,
                        isSuccess: true,
                        isError: false);
                  },
                  child: buildDeleteAccount("assets/images/delete_act.png",
                      "Delete Account".tr, "Permanently delete your account".tr),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeleteAccount(String imagePath, String title, String subtitle) =>
      ListTile(
        leading: Image.asset(
          imagePath,
          width: 25.w,
          fit: BoxFit.contain,
          height: 25.h,
        ).paddingOnly(bottom: 16.h),
        contentPadding: EdgeInsets.symmetric(horizontal: 27.w, vertical: 0),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 15.sp,
              color: ColorConstants.redColor,
              fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              fontSize: 12.sp,
              color: ColorConstants.vehicleLightColor,
              fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: ColorConstants.blackColor,
        ),
      );

  Widget buildLogout(String imagePath, String title, String subtitle) =>
      ListTile(
        leading: Image.asset(
          imagePath,
          width: 25.w,
          fit: BoxFit.contain,
          height: 25.h,
        ).paddingOnly(bottom: 16.h),
        contentPadding: EdgeInsets.symmetric(horizontal: 27.w, vertical: 0),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 15.sp,
              color: ColorConstants.btnColor,
              fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              fontSize: 12.sp,
              color: ColorConstants.vehicleLightColor,
              fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: ColorConstants.blackColor,
        ),
      );

  Widget buildMenu(String imagePath, String title, String subtitle) => ListTile(
        leading: Image.asset(
          imagePath,
          width: 25.w,
          fit: BoxFit.contain,
          height: 25.h,
        ).paddingOnly(bottom: 16.h),
        contentPadding: EdgeInsets.symmetric(horizontal: 27.w, vertical: 0),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 15.sp,
              color: ColorConstants.blackColor,
              fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
              fontSize: 12.sp,
              color: ColorConstants.vehicleLightColor,
              fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: ColorConstants.textColor,
        ),
      );

  Widget buildSubsection(String text) => Text(
        text,
        style: TextStyle(
            fontSize: 12.sp,
            color: ColorConstants.blackColor,
            fontWeight: FontWeight.w500),
      );

  Widget buildBankContainer() => Image.asset(
        "assets/images/bank.png",
        width: 150.w,
        height: 90.h,
      );

  Widget buildProfileContainer(
      String imageLnk, String name, String phoneNr, double starCnt) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerHeight =
            constraints.maxHeight * 5; // Adjust this as needed
        return Container(
          height: containerHeight,
          padding: EdgeInsets.only(
              left: 21.w, top: 10.h, bottom: containerHeight / 100),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                ColorConstants.homeBgColorStart,
                ColorConstants.homeBgColorEnd
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: containerHeight * 0.1,
                // Adjust as needed
                width: containerHeight * 0.1,
                // Keep the aspect ratio consistent
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        imageLnk
                       ), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                  color: ColorConstants.bgColor,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: containerHeight / 30,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.bgColor,
                    ),
                  ),
                  Text(
                    phoneNr,
                    style: TextStyle(
                      fontSize: containerHeight / 40,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.bgColor,
                    ),
                  ),
                ],
              ).paddingOnly(left: 20.w),
              FutureBuilder(
                future: homeScreenController.isRatingVisible(),
                builder: (ctx, val) {
                  if (val.connectionState == ConnectionState.waiting) {
                    return SizedBox(width: 100.w);
                  } else if (val.hasData && val.data == true) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(23),
                        color: ColorConstants.bgColor,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: containerHeight / 100),
                      margin: EdgeInsets.only(
                        top: 8.h,
                        bottom: 8.h,
                        left: 21.w,
                        right: 11.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$starCnt/5",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.blackColor,
                            ),
                          ),
                          Icon(
                            Icons.star,
                            size: containerHeight / 28,
                            color: ColorConstants.starColor,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox(width: 100.w);
                  }
                },
              )


            ],
          ),
        );
      },
    );
  }
}
