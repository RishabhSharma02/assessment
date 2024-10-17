import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bhaada/Constants/color_constants.dart';
import 'package:bhaada/sections/Navigation/controllers/ride_controller.dart';
import 'package:bhaada/sections/homescreen/controllers/home_screen_controller.dart';
import 'package:bhaada/sections/Navigation/views/map_view.dart';
import 'package:bhaada/sections/profile/views/support_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../Onboarding/utils/utils.dart';

HomeScreenController homeScreenController = Get.put(HomeScreenController());
RideController rideController = Get.put(RideController());
Widget buildPhoneTextField(
    TextEditingController phoneController, String hintText, Function() onTap) {
  return TextField(
    onTap: onTap,
    style: TextStyle(fontSize: 14.sp),
    cursorColor: ColorConstants.btnColor,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.only(left: 10.48.w),
      constraints: BoxConstraints(maxHeight: 42.h, maxWidth: 215.w),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorConstants.borderColor),
        borderRadius: BorderRadius.circular(11),
      ),
      hintText: hintText,
      hintStyle: TextStyle(color: ColorConstants.hintColor, fontSize: 14.sp),
      enabled: true,
      counterText: '',
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorConstants.borderColor),
        borderRadius: BorderRadius.circular(11),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ColorConstants.btnColor),
        borderRadius: BorderRadius.circular(11),
      ),
    ),
    maxLength: 10,
    keyboardType: TextInputType.phone,
    controller: phoneController,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    ],
    enableInteractiveSelection: false,
  );
}
RxBool isReadOnly = true.obs;
Widget buildOtpPhoneTextfield(
        TextEditingController phoneController, String hintText) =>
    Obx(
      () => TextField(
        readOnly: isReadOnly.value,
        cursorColor: ColorConstants.btnColor,
        // onTap: onSuffixTap,
        style: TextStyle(fontSize: 14.sp),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: ColorConstants.btnColor,
              ),
              borderRadius: BorderRadius.circular(11)),
          contentPadding: const EdgeInsets.all(10),
          constraints: BoxConstraints(maxHeight: 42.h, maxWidth: 312.w),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.borderColor),
              borderRadius: BorderRadius.circular(11)),
          hintText: hintText,
          hintStyle:
              TextStyle(color: ColorConstants.hintColor, fontSize: 14.sp),
          enabled: true,
          counterText: '',
          suffixIcon: GestureDetector(
            onTap: () {
              isReadOnly.value = false;
            },
            child:  Text(
              "Change".tr,
              style: TextStyle(
                  color: ColorConstants.btnColor,
                  decoration: TextDecoration.underline,
                  decorationColor: ColorConstants.btnColor),
            ).paddingAll(10),
          ),
          prefixIcon: Image.asset(
            "assets/images/whatsapp_icn.png",
            width: 17.w,
            height: 17.h,
            fit: BoxFit.cover,
          ).paddingOnly(left: 14.w, right: 12.w),
          prefixIconConstraints:
              BoxConstraints(maxHeight: 26.h, maxWidth: 50.w),
          border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: ColorConstants.borderColor,
              ),
              borderRadius: BorderRadius.circular(11)),
        ),
        maxLength: 13,
        keyboardType: TextInputType.phone,
        controller: phoneController,
      ),
    );

Widget buildCountryPicker() => Container(
      height: 42.h,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          border: Border.all(color: ColorConstants.borderColor),
          borderRadius: BorderRadius.circular(11)),
      child: CountryCodePicker(
        showDropDownButton: false,
        padding: EdgeInsets.zero,
        hideMainText: false,
        initialSelection: 'IN',
        // Initial country selection (India in this case)
        showFlag: true,
        enabled: true,
        boxDecoration: BoxDecoration(
            border: Border.all(color: ColorConstants.borderColor),
            borderRadius: BorderRadius.circular(11)),
      ),
    );
Widget buildWalletButton(Function() onPressed, String btnText, bool isActive) =>
    MaterialButton(
      elevation: 0,
      onPressed: onPressed,
      height: 40.h,
      minWidth: 138.w,
      color: isActive ? ColorConstants.btnColor : ColorConstants.bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: isActive
              ? BorderSide.none
              : const BorderSide(color: ColorConstants.textColor)),
      child: Text(
        btnText,
        style: TextStyle(
            color: isActive ? ColorConstants.bgColor : ColorConstants.textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500),
      ),
    );

Widget buildOverlayButton(Function() onPressed, String btnText, bool isActive,
        bool isAcceptEnabled) =>
    MaterialButton(
      elevation: 0,
      onPressed: isAcceptEnabled ? onPressed : () {},
      height: 40.h,
      minWidth: 138.w,
      shape: RoundedRectangleBorder(
          side: !isActive
              ? BorderSide(color: ColorConstants.textColor)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(5)),
      color: isActive
          ? isAcceptEnabled
              ? ColorConstants.btnColor
              : ColorConstants.unselectedColor
          : ColorConstants.bgColor,
      child: Text(
        btnText,
        style: TextStyle(
            color: isActive ? ColorConstants.bgColor : ColorConstants.textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500),
      ),
    );
Widget buildPreviewButton(
        Function() onPressed, String btnText, bool isActive) =>
    MaterialButton(
      elevation: 0,
      onPressed: onPressed,
      height: 40.h,
      minWidth: 138.w,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color:
          isActive ? ColorConstants.btnColor : ColorConstants.unselectedColor,
      child: Text(
        btnText,
        style: TextStyle(
            color: ColorConstants.bgColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500),
      ),
    );
Widget buildCommonButton(Function() onPressed, String btnText, bool isActive) =>
    MaterialButton(
      elevation: 0,
      onPressed: isActive ? onPressed : () {},
      height: 50.h,
      minWidth: 312.w,
      color: isActive ? ColorConstants.btnColor : ColorConstants.greyColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      child: Text(
        btnText,
        style: TextStyle(
            color: isActive
                ? ColorConstants.bgColor
                : ColorConstants.semiTextColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500),
      ),
    );

Widget buildDynamicButton(Function() onPressed, String btnText, Color btnColor,
        bool isBorder, Color bdrColor, Color txtColor) =>
    MaterialButton(
      onPressed: onPressed,
      height: 50.h,
      minWidth: 311.87.w,
      elevation: 0,
      color: btnColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(11),
        side: isBorder ? BorderSide(color: bdrColor) : BorderSide.none,
      ),
      child: Text(
        btnText,
        style: TextStyle(
            color: isBorder ? txtColor : ColorConstants.bgColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500),
      ),
    );

Widget progressIndicator(int idx) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50.w,
          height: 3.h,
          decoration: BoxDecoration(
              color: ColorConstants.btnColor,
              borderRadius: BorderRadius.circular(17)),
        ).paddingOnly(right: 5),
        Container(
            width: 50.w,
            height: 3.h,
            decoration: BoxDecoration(
                color:
                    idx == 1 ? ColorConstants.btnColor : ColorConstants.bgColor,
                borderRadius: BorderRadius.circular(17)))
      ],
    );
bool validateEmail(String email) {
  if (email.isEmpty) {
    return true;
  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
    return false;
  }
  return true;
}
Widget buildEmailTextfield(
        TextEditingController textController, String hintText) =>
    TextField(
      style: TextStyle(fontSize: 14.sp),
      onChanged: (val) {
        textController.text = val;
      },
      cursorColor: ColorConstants.btnColor,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.btnColor,
            ),
            borderRadius: BorderRadius.circular(11)),
        prefixIcon: const Icon(
          Icons.email,
          color: ColorConstants.hintColor,
        ),
        contentPadding: const EdgeInsets.all(10),
        constraints: BoxConstraints(maxHeight: 42.h, maxWidth: 312.w),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstants.borderColor),
            borderRadius: BorderRadius.circular(11)),
        hintText: hintText,
        hintStyle: TextStyle(color: ColorConstants.hintColor, fontSize: 14.sp),
        enabled: true,
        border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.borderColor,
            ),
            borderRadius: BorderRadius.circular(11)),
      ),
      keyboardType: TextInputType.emailAddress,
    );

Widget buildTextfield(TextEditingController textController, String hintText) =>
    TextField(
      style: TextStyle(fontSize: 14.sp),
      onChanged: (val) {
        textController.text = val;
      },
      cursorColor: ColorConstants.btnColor,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.person,
          color: ColorConstants.hintColor,
        ),
        contentPadding: const EdgeInsets.all(10),
        constraints: BoxConstraints(maxHeight: 42.h, maxWidth: 312.w),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstants.borderColor),
            borderRadius: BorderRadius.circular(11)),
        hintText: hintText,
        hintStyle: TextStyle(color: ColorConstants.hintColor, fontSize: 14.sp),
        enabled: true,
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.btnColor,
            ),
            borderRadius: BorderRadius.circular(11)),
        border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.borderColor,
            ),
            borderRadius: BorderRadius.circular(11)),
      ),
      keyboardType: TextInputType.text,
    );

Widget buildAdhharTextfield(
        TextEditingController textController, String hintText) =>
    TextField(
      style: TextStyle(fontSize: 16.sp),
      maxLength: 12,
      decoration: InputDecoration(
        suffixIcon: Image.asset("assets/images/adh_logo.png"),
        counterText: '',
        contentPadding: const EdgeInsets.all(10),
        constraints: BoxConstraints(maxHeight: 39.h, maxWidth: 312.w),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstants.borderColor),
            borderRadius: BorderRadius.circular(11)),
        hintText: hintText,
        hintStyle: TextStyle(color: ColorConstants.hintColor, fontSize: 16.sp),
        enabled: true,
        border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.borderColor,
            ),
            borderRadius: BorderRadius.circular(11)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.btnColor,
            ),
            borderRadius: BorderRadius.circular(11)),
      ),
      keyboardType: TextInputType.phone,
      controller: textController,
    );

Widget buildPanTextfield(
        TextEditingController textController, String hintText) =>
    TextField(
      style: TextStyle(fontSize: 16.sp),
      maxLength: 10,
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.all(10),
        constraints: BoxConstraints(maxHeight: 39.h, maxWidth: 312.w),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstants.borderColor),
            borderRadius: BorderRadius.circular(11)),
        hintText: hintText,
        hintStyle: TextStyle(color: ColorConstants.hintColor, fontSize: 16.sp),
        enabled: true,
        border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.borderColor,
            ),
            borderRadius: BorderRadius.circular(11)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.btnColor,
            ),
            borderRadius: BorderRadius.circular(11)),
      ),
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
      controller: textController,
    );

Widget buildDlTextfield(
        TextEditingController textController, String hintText) =>
    TextField(
      style: TextStyle(fontSize: 16.sp),
      maxLength: 16,
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.all(10),
        constraints: BoxConstraints(maxHeight: 39.h, maxWidth: 312.w),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstants.borderColor),
            borderRadius: BorderRadius.circular(11)),
        hintText: hintText,
        hintStyle: TextStyle(color: ColorConstants.hintColor, fontSize: 16.sp),
        enabled: true,
        border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.borderColor,
            ),
            borderRadius: BorderRadius.circular(11)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.btnColor,
            ),
            borderRadius: BorderRadius.circular(11)),
      ),
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
      controller: textController,
    );
Widget buildRcTextfield(
        TextEditingController textController, String hintText) =>
    TextField(
      style: TextStyle(fontSize: 16.sp),
      maxLength: 12,
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.all(10),
        constraints: BoxConstraints(maxHeight: 39.h, maxWidth: 312.w),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ColorConstants.borderColor),
            borderRadius: BorderRadius.circular(11)),
        hintText: hintText,
        hintStyle: TextStyle(color: ColorConstants.hintColor, fontSize: 16.sp),
        enabled: true,
        border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.borderColor,
            ),
            borderRadius: BorderRadius.circular(11)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ColorConstants.btnColor,
            ),
            borderRadius: BorderRadius.circular(11)),
      ),
      keyboardType: TextInputType.text,
      controller: textController,
    );

Widget buildDatePicker(
    TextEditingController textController, BuildContext context) {
  return TextField(
    controller: textController,
    readOnly: true, // Ensure the user cannot directly edit the text field
    onTap: () async {
      final selectedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: DateTime.now().subtract(
            Duration(days: 18 * 365)), // 18 years ago from current date
        lastDate:
            DateTime.now().subtract(Duration(days: 18 * 365)), // Current date
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: ColorConstants
                    .btnColor, // Customize the color of the selection button
              ),
            ),
            child: child!,
          );
        },
      );

      if (selectedDate != null) {
        // Format the selected date as per your requirement
        final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);

        // Update the text field with the selected date
        textController.text = formattedDate;
      }
    },
    cursorColor: ColorConstants.btnColor,
    decoration: InputDecoration(
      prefixIcon: const Icon(
        Icons.calendar_month_rounded,
        color: ColorConstants.hintColor,
      ),
      border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorConstants.borderColor,
          ),
          borderRadius: BorderRadius.circular(11)),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: ColorConstants.btnColor,
          ),
          borderRadius: BorderRadius.circular(11)),
      contentPadding: const EdgeInsets.all(10),
      hintText: "Date of Birth".tr,
      constraints: BoxConstraints(maxHeight: 42.h, maxWidth: 312.w),
      hintStyle: TextStyle(color: ColorConstants.hintColor, fontSize: 14.sp),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorConstants.borderColor),
          borderRadius: BorderRadius.circular(11)),
    ),
  );
}

Widget vehicleContainer(String name, String cap, bool isSelected,
        Function() onPressed, String imgLink) =>
    GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected
                  ? ColorConstants.btnColor
                  : ColorConstants.unselectedColor,
              width: isSelected ? 3 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20.5.w, vertical: 10.h),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: ColorConstants.textColor,
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  children: [
                    Text(
                      "Load Capacity : ".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: ColorConstants.textColor,
                      ),
                    ),
                    Text(
                      cap,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: ColorConstants.hintColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Image.network(
              imgLink,
              width: 60.w,
              height: 60.h,
            )
          ],
        ),
      ),
    );

Widget kycContainer(
        String name, String icnPath, bool isDone, Function() onTap) =>
    GestureDetector(
      onTap: isDone ? () {} : onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ColorConstants.textColor, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 25.5.w, vertical: 15),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(icnPath,
                    width: 18.w, height: 15.h, fit: BoxFit.fill),
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: ColorConstants.textColor,
                  ),
                ).paddingOnly(left: 9.w),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Text(
                  "Status: ".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: isDone
                        ? ColorConstants.greenColor
                        : ColorConstants.redColor,
                  ),
                ),
                Flexible(
                  child: Text(
                    isDone ? "Approved".tr : "Pending".tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: isDone
                          ? ColorConstants.greenColor
                          : ColorConstants.redColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

PreferredSizeWidget buildCommonAppbar(String title, bool isHelp, bool isBack,BuildContext context) =>
    AppBar(
      centerTitle: false,
      backgroundColor: ColorConstants.bgColor,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
          color: ColorConstants.textColor,
        ),
      ),
      titleSpacing: 0,
      leading: isBack
          ? GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: ColorConstants.blackColor,
              ))
          : null,
      actions: [
        isHelp
            ?
              GestureDetector(
                onTap: (){
                  Get.to(()=>SupportScreen());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(129),
                      border: Border.all(
                          color: ColorConstants
                              .borderColor)), // Adjust padding as needed
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.help_outline,
                        color: ColorConstants.btnColor,
                      ),
                      const SizedBox(
                          width: 5), // Add some space between icon and text
                      Text(
                        "Help".tr,
                        style: TextStyle(
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ).paddingOnly(right: 24.w),
              ):SizedBox()
            ]
          ,
    );

PreferredSizeWidget buildInAppAppbar(
        String title, bool isHelp, bool isBack, bool isOnline,BuildContext context) =>
    AppBar(
      centerTitle: false,
      backgroundColor: ColorConstants.bgColor,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
          color: ColorConstants.blackColor,
        ),
      ),
      titleSpacing: 0,
      leading: isBack
          ? GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: ColorConstants.blackColor,
              ))
          : null,
      actions: isHelp ? [buildOnlineWidget(isOnline).paddingAll(10)] : null,
    );
Widget buildOnlineWidget(bool isOnline) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
            color: isOnline
                ? ColorConstants.btnColor
                : ColorConstants.unselectedColor),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      child: Text(
        isOnline ? "ONLINE".tr : "OFFLINE".tr,
        style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: isOnline
                ? ColorConstants.btnColor
                : ColorConstants.unselectedColor),
      ),
    );
typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close; // to closs our dialog
  final UpdateLoadingScreen
      update; // to update anytext with in our dialog if needed

  const LoadingScreenController({
    required this.close,
    required this.update,
  });
}

class LoadingScreen {
  LoadingScreen._shareInstance();

  static final LoadingScreen _shared = LoadingScreen._shareInstance();

  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? _controller;

  void show({
    required BuildContext context,
    required String desc,
  }) {
    if (_controller?.update(desc) ?? false) {
      return;
    } else {
      _controller = showOverlay(context: context, text: desc);
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController? showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final textController = StreamController<String>();
    textController.add(text);
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * .8,
                maxHeight: size.width * .8,
                minWidth: size.width * .8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: ColorConstants.btnColor,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Verifying....".tr,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: ColorConstants.blackColor),
                        ),
                        // Use a Flexible widget to prevent overflow
                        Flexible(
                          child: SingleChildScrollView(
                            child: StreamBuilder(
                              stream: textController.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.requireData,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ColorConstants.textColor),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ).paddingOnly(left: 17.w),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        textController.close();
        overlay.remove();
        return true;
      },
      update: (String text) {
        textController.add(text);
        return true;
      },
    );
  }
}

class OverlayLoaderController {
  final Function() close;
  final Function(String text, {bool isSuccess, bool isError}) update;

  OverlayLoaderController({
    required this.close,
    required this.update,
  });
}

class OverlayLoader {
  OverlayLoader._shareInstance();

  static final OverlayLoader _shared = OverlayLoader._shareInstance();

  factory OverlayLoader.instance() => _shared;

  OverlayLoaderController? showOverlay({
    required String title,
    required BuildContext context,
    required String text,
    bool isSuccess = false,
    bool isError = false,
  }) {
    final textController = StreamController<String>();
    textController.add(text);
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * .8,
                maxHeight: size.width * .8,
                minWidth: size.width * .8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSuccess)
                      Icon(Icons.check_circle,
                          color: Colors.green, size: 24.sp),
                    if (isError)
                      Icon(Icons.error, color: Colors.red, size: 24.sp),
                    if (!isSuccess && !isError)
                      const CircularProgressIndicator(
                          color: ColorConstants.btnColor),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: ColorConstants.blackColor),
                          ),
                          StreamBuilder(
                            stream: textController.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.requireData,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: ColorConstants.textColor),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ],
                      ).paddingOnly(left: 17.w),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    // Hide after 2 seconds
    Timer(const Duration(seconds: 3), () {
      textController.close();
      overlay.remove();
    });

    return null; // No controller is returned
  }
}

Widget buildNavbar(Function(int) onBtnPress, int idx) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BottomNavigationBar(
            currentIndex: idx,
            selectedFontSize: 11.sp,
            backgroundColor: ColorConstants.bgColor,
            showUnselectedLabels: true,
            selectedItemColor: ColorConstants.btnColor,
            onTap: onBtnPress,
            items: [
              BottomNavigationBarItem(
                  icon: SizedBox(
                          width: 26.w,
                          height: 26.h,
                          child: Image.asset("assets/images/home_unfilled.png"))
                      .paddingOnly(bottom: 6.h, top: 8.h),
                  activeIcon: SizedBox(
                          width: 26.w,
                          height: 26.h,
                          child: Image.asset("assets/images/home_filled.png"))
                      .paddingOnly(bottom: 6.h, top: 8.h),
                  label: "Home".tr),
              BottomNavigationBarItem(
                  icon: SizedBox(
                          width: 26.w,
                          height: 26.h,
                          child:
                              Image.asset("assets/images/orders_unfilled.png"))
                      .paddingOnly(bottom: 6.h, top: 8.h),
                  activeIcon: SizedBox(
                          width: 26.w,
                          height: 26.h,
                          child: Image.asset("assets/images/orders_filled.png"))
                      .paddingOnly(bottom: 6.h, top: 8.h),
                  label: "Orders".tr),
              BottomNavigationBarItem(
                  icon: SizedBox(
                          width: 26.w,
                          height: 26.h,
                          child:
                              Image.asset("assets/images/wallet_unfilled.png"))
                      .paddingOnly(bottom: 6.h, top: 8.h),
                  activeIcon: SizedBox(
                          width: 26.w,
                          height: 26.h,
                          child: Image.asset("assets/images/wallet_filled.png"))
                      .paddingOnly(bottom: 6.h, top: 8.h),
                  label: "Wallet".tr)
            ]),
        Container(
          color: ColorConstants.bgColor,
          height: 3.h,
        )
      ],
    );

class CustomSliderButton extends StatefulWidget {
  final bool state;
  final double width;
  final double height;
  final VoidCallback onCompleted;
  final VoidCallback onReset;
  const CustomSliderButton({
    super.key,
    required this.width,
    required this.height,
    required this.onCompleted,
    required this.onReset,
    required this.state,
  });

  @override
  _CustomSliderButtonState createState() => _CustomSliderButtonState();
}

class _CustomSliderButtonState extends State<CustomSliderButton>
    with SingleTickerProviderStateMixin {
  double _value = 0.0;
  bool _isSlideCompleted = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    if (widget.state == true) {
      _isSlideCompleted = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateValue(double newValue) {
    setState(() {
      _value = newValue.clamp(0.0, 1.0);
      if (_value == 1) {
        widget.onCompleted();
        _isSlideCompleted = true;
        _controller.forward();
      } else {
        widget.onReset();
        _isSlideCompleted = false;
        _controller.reset();
      }
    });

    if (_isSlideCompleted) {
      Timer(const Duration(milliseconds: 15), () async {
        widget.onCompleted();
      });
    }
  }

  void _onTapDown(TapDownDetails details) {
    _updateValue(details.localPosition.dx / widget.width);
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _updateValue(details.localPosition.dx / widget.width);
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (!_isSlideCompleted) {
      _updateValue(0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTapDown: _onTapDown,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.height / 6),
            color: ColorConstants.lightGreyColor,
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _value < 0.1
                    ? _value * widget.width
                    : (_value + 0.05) * widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.height / 6),
                  color: ColorConstants.btnColor,
                ),
              ),
              if (!_isSlideCompleted)
                Positioned(
                  top: widget.height * 0.1,
                  left: _value * (widget.width - widget.height) +
                      widget.height * 0.1,
                  child: Container(
                    width: widget.height * 0.8,
                    height: widget.height * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.height / 6),
                      // shape: BoxShape.circle,
                      color: ColorConstants.btnColor,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              if (!_isSlideCompleted)
                Positioned(
                  top: widget.height * 0.25,
                  right: _value * (widget.width - widget.height) +
                      widget.height * 0.1,
                  child: Container(
                    width: widget.width - widget.height,
                    height: widget.height * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.height / 6),
                      color: Colors.transparent,
                    ),
                    child: Text(
                      "Swipe to go online".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorConstants.textColor,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              if (_isSlideCompleted)
                Positioned(
                  top: 0,
                  left: 0,
                  child: FadeTransition(
                    opacity: _animation,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.height / 6),
                        color: ColorConstants.btnColor,
                      ),
                      width: widget.width,
                      height: widget.height,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 40.w,
                          ),
                          Text(
                            "You are Online!".tr,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: widget.height * 0.8,
                            height: widget.height * 0.8,
                            decoration: BoxDecoration(
                                color: ColorConstants.bgColor,
                                borderRadius:
                                    BorderRadius.circular(widget.height / 6)),
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.arrow_back,
                              color: ColorConstants.btnColor,
                              size: 18.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildTransactionContainer(String prefixAssetPath, String title,
    Timestamp timeStamp, double amount, bool incoming) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44.w,
          height: 44.h,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: ColorConstants.lightGreyColor,
          ),
          child: Image.asset(
            prefixAssetPath,
            width: 16.w,
            height: 20.h,
          ),
        ),
        SizedBox(width: 16.w), // Adjusted spacing between image and text
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(
                height: 8.h), // Adjusted spacing between title and timestamp
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
        Spacer(), // Pushes the amount text and icon to the right
        Text(
          "₹${formatNumber(amount.toInt())}",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 8.6.w), // Adjusted spacing between amount and icon
        Image.asset(
          incoming
              ? "assets/images/incoming.png"
              : "assets/images/outgoing.png",
          width: 12.w,
          height: 14.h,
        ),
      ],
    ),
  );
}

class RideOverlay extends StatefulWidget {
  final List<dynamic> ls;
  final double mins;
  final double cashAlloted;
  final double distance;
  const RideOverlay({
    super.key,
    required this.ls,
    required this.mins,
    required this.cashAlloted,
    required this.distance,
  });

  @override
  State<RideOverlay> createState() => _RideOverlayState();
}

class _RideOverlayState extends State<RideOverlay> {
  RxInt tval = 0.obs;
  OverlayEntry? _overlayEntry;
  ScrollController _scrollController = ScrollController();
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    AudioPlayer player = AudioPlayer();
    const alarmAudioPath = "tones/notification.mp3";
    player.play(AssetSource(alarmAudioPath));
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: 'call_channel',
      actionType: ActionType.Default,
      title: 'New Order!'.tr,
      body: 'Click \'Accept\' to accept order and \'Reject\' to reject it.',
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _overlayEntry = await _createOverlayEntry(
        widget.ls,
        widget.cashAlloted,
        widget.distance,
        widget.mins,
      );

      Overlay.of(context)!.insert(_overlayEntry!);
      startIncrementer(15);
      //_closeOverlayAfterDelay();
    });
  }

  void startIncrementer(int dur) {
    Timer.periodic(const Duration(milliseconds: 50), (val) {
      tval.value += 50;
      if (tval.value >= dur * 1000) {
        val.cancel();
        setState(() {
          isActive = true;
        });
      }
    });
  }

  Future<OverlayEntry> _createOverlayEntry(
    List<dynamic> detailsMap,
    double cashAlloted,
    double distance,
    double minsToReach,
  ) async {
    // Collect all the addresses asynchronously
    List<Future<TimelineEntryData>> timelineEntriesFutures =
        detailsMap.map((entry) async {
      String getAddress =
          await homeScreenController.getAddressFromGeopoint(entry["latLng"]);
      String title = entry["type"];
      String phoneNumber = entry["phoneNumber"];
      String name=entry["name"];
      return TimelineEntryData(
        name: name,
        icon: Icons.radio_button_checked,
        phoneNumber: phoneNumber,
        iconColor: ColorConstants.unselectedColor,
        title: title,
        description: getAddress,
        isDashed: false,
      );
    }).toList();

    // Wait for all futures to complete
    List<TimelineEntryData> timelineEntries =
        await Future.wait(timelineEntriesFutures);

    // Creating the OverlayEntry
    return OverlayEntry(
      builder: (context) => Obx(
        () => Stack(
          children: [
            Material(
              color: Colors.black.withAlpha(150),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: ColorConstants.bgColor,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildProgressBar(tval.value / 10000),
                        buildTopSection(
                                distance, cashAlloted, minsToReach.toInt())
                            .paddingOnly(top: 20.h),
                        const Divider(
                          height: 2,
                          color: ColorConstants.lightGreyColor,
                        ).paddingOnly(top: 20.h),
                        Expanded(
                          child: VerticalTimeline(
                            entries: timelineEntries,
                          ),
                        ),
                        const Divider(
                          height: 2,
                          color: ColorConstants.lightGreyColor,
                        ).paddingOnly(top: 6.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildOverlayButton(() {
                              _closeOverlay();
                            }, "Decline".tr, false, true)
                                .paddingOnly(right: 16.w),
                            buildOverlayButton(() {
                              rideController.places.value = detailsMap;
                              rideController.cashToCollect = cashAlloted;
                              homeScreenController.isRideStarted.value = true;
                              _closeOverlay();
                              Get.to(() => MapView());
                            }, "Accept".tr, true, isActive),
                          ],
                        ).paddingOnly(top: 20.h),
                      ],
                    ),
                  ).paddingOnly(top: 328.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _closeOverlay() {
    _overlayEntry?.remove();
  }

  void _closeOverlayAfterDelay() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          isActive = true;
        });
        _closeOverlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox
        .shrink(); // Return an empty widget because no UI is needed here
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }
}

Widget buildTopSection(double distance, double cash, int minsToReach) => Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Distance".tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.textColor),
            ),
            Text(
              "${distance}kms".tr,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.blackColor),
            ).paddingOnly(top: 9.h)
          ],
        ),
        Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Cash".tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.greenColor),
            ),
            Text(
              "₹${cash}",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.blackColor),
            ).paddingOnly(top: 9.h)
          ],
        ),
        Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Pickup Point".tr,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.textColor),
            ),
            Text(
              "${minsToReach} mins".tr,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.blackColor),
            ).paddingOnly(top: 9.h)
          ],
        )
      ],
    );
Widget buildProgressBar(double perComp) {
  return LinearProgressIndicator(
    value: perComp,
    backgroundColor: ColorConstants.lightGreyColor,
    minHeight: 7.h,
    borderRadius: BorderRadius.circular(8),
    valueColor: const AlwaysStoppedAnimation<Color>(ColorConstants.btnColor),
  );
}

class VerticalTimeline extends StatelessWidget {
  final List<TimelineEntryData> entries;

  VerticalTimeline({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return TimelineEntry(
            name: entry.name,
            phoneNumber: entry.phoneNumber,
            icon: entry.icon,
            iconColor: entry.iconColor,
            title: entry.title,
            description: entry.description,
            isLast: index == entries.length - 1,
            isDashed: entry.isDashed,
          );
        },
      ),
    );
  }
}

class TimelineEntry extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final bool isLast;
  final bool isDashed;

  const TimelineEntry({super.key,
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    this.isLast = false,
    this.isDashed = false,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              icon,
              color: ColorConstants.btnColor,
              size: 15.sp,
            ),
            if (!isLast)
              isDashed ? DashedLine(height: 50.h) : SolidLine(height: 85.h),
          ],
        ),
        const SizedBox(width: 8.0),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color:  ColorConstants.textColor,
                ),
              ),
              Text(
                getAddressType(title) ,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color:  getAddressType(title)  =="DROP-OFF".tr?ColorConstants.redColor:ColorConstants.greenColor,
                ),
              ),

              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: title == 'Your location'.tr ? Colors.grey : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String getAddressType(String data) {
  if (data == "startPoint") {
    return "PICK-UP";
  } else if (data == "pickUp") {
    return "PICK-UP";
  } else {
    return "DROP-OFF";
  }
}

class VerticalTimelineMap extends StatelessWidget {
  final List<TimelineEntryData> entries;

  VerticalTimelineMap({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: entries
            .asMap()
            .entries
            .map((entry) => TimelineEntryMap(
                  name: entry.value.name,
                  icon: entry.value.icon,
                  iconColor: entry.value.iconColor,
                  title: entry.value.title,
                  description: entry.value.description,
                  isLast: entry.key == entries.length - 1,
                  isDashed: entry.value.isDashed,
                ))
            .toList(),
      ),
    );
  }
}

class TimelineEntryMap extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final bool isLast;
  final bool isDashed;

  const TimelineEntryMap({super.key,
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    this.isLast = false,
    this.isDashed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 20.h,
            ),
            if (!isLast)
              isDashed ? DashedLine(height: 70.h) : SolidLine(height: 70.h),
          ],
        ),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.textColor,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: title == 'Your location'.tr ? Colors.grey : Colors.black,
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ],
    );
  }
}

class TimelineEntryData {
  final String name;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final bool isDashed;
  final String phoneNumber;

  TimelineEntryData({
    required this.name,
    required this.phoneNumber,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    this.isDashed = false,
  });
}

class DashedLine extends StatelessWidget {
  final double height;

  DashedLine({required this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate((height / 1.5).round(), (index) {
        return Container(
          width: 2.0,
          height: 2.0,
          color: index % 2 == 0 ? Colors.grey : Colors.transparent,
        );
      }),
    );
  }
}

class SolidLine extends StatelessWidget {
  final double height;

  SolidLine({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2.0,
      height: height,
      color: ColorConstants.btnColor,
    );
  }
}

void showRefundPolicyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text('Refund Policy'.tr),
        content:  SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Thank you for choosing our transportation and logistics services. We are committed to providing high-quality services to all of our customers. Please read our refund policy carefully before booking our services.\n\n'
                  'Once you have booked our services, you are not eligible for a refund on cancellation. We understand that circumstances can change, and you may need to cancel your booking. However, we do not provide refunds for cancelled bookings. Our services are based on a committed schedule, and cancellations can have an impact on our operations.\n\n'
                  'We encourage you to consider the booking carefully before confirming the transaction. If you have any doubts or questions, please contact our customer support team before booking the services. We will be happy to provide any additional information or assistance.\n\n'
                  'In case of any issues or concerns with the services provided, please contact our customer support team immediately. We will do our best to resolve the issue and ensure your satisfaction.\n\n'
                  'We reserve the right to make changes to our refund policy at any time without prior notice. The current refund policy will be posted on our website.\n\n'
                  'Thank you for your understanding and cooperation in this matter. If you have any questions or concerns, please contact our customer support team.'.tr),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child:  Text('Close'.tr),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showPrivacyPolicyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Privacy Policy'.tr),
        content:  SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'We take your privacy seriously and are committed to protecting your personal information. This privacy policy explains how we collect, use, and protect your personal information when you use our mobile application and avail of our services.\n\n'
                  'Information Collection: We collect personal information such as your name, precise & coarse location, contact details, and payment information when you book our services through our mobile applications (namely:Bhaada -move cargo easily, "BHAADA-move cargo easily"– Driver App””). We may also collect information about your use of our mobile application through cookies and other tracking technologies.\n\n'
                  'Background Location: In our “BHAADA-move cargo easily"– Driver App” we may request for your background location permissions in order to allow all the features of the app to work properly. We capture the Driver App’s background location so that the customers who are booking a service (Logistic Delivery) from the app can track the delivery of their goods and the driver location in real-time even if the driver has switched between other application or turned of the screen. This allows us to provide clear transparency between Driver and Customer. We will only use the background location in the “bhaada-move cargo easily" driver app only when the Driver is in an active booking. We take our user’s privacy very seriously and are committed to protecting your personal information. We do not share any personal information including background location information with any third-parties.\n\n'
                  'Use of Information: We use your personal information to process your bookings, provide our services, and communicate with you about your bookings and our services. We may also use your personal information to improve our services and for marketing purposes. We will not share your personal information with any third party except as required by law or to provide our services.\n\n'
                  'Cookies: We use cookies and other tracking technologies to collect information about your use of our mobile application. This information is used to improve our mobile application and provide a better user experience. You can control the use of cookies through your mobile device settings.\n\n'
                  'Data Security: We have implemented appropriate technical and organizational measures to protect your personal information from unauthorized access, disclosure, or loss. We regularly review and update our security measures to ensure the protection of your personal information.\n\n'
                  'Data Retention: We will retain your personal information for as long as necessary to provide our services and as required by law. After the retention period, we will securely dispose of your personal information.\n\n'
                  'Your Rights: You have the right to access, correct, and delete your personal information. You can exercise these rights by contacting us through our customer support team.\n\n'
                  'Children’s Privacy: Our services are not intended for children under the age of 13. We do not knowingly collect personal information from children under the age of 13.\n\n'
                  'Third-Party Links: Our mobile application may contain links to third-party websites. We are not responsible for the privacy practices of these websites. We recommend that you review the privacy policies of these websites before using their services.\n\n'
                  'Advertising: Our mobile application does not contain advertisements from third-party advertisers.\n\n'
                  'Amendments: We reserve the right to amend this privacy policy at any time without prior notice. Your continued use of our mobile application and services after any such amendments shall constitute your acceptance of the amended privacy policy.\n\n'
                  'If you have any questions or concerns regarding our privacy policy, including our use of background location permissions, please contact our customer support team.'.tr),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'.tr),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> imageDialog(
    BuildContext context,
    String dialogContentPrimary,
    String dialogContentSecondary,
    VoidCallback onConfirm,
    VoidCallback onCancel) {
  var screenWidth = MediaQuery.sizeOf(context).width;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
            backgroundColor: ColorConstants.bgColor,
            actions: [
              TextButton(
                  onPressed: onCancel,
                  child:  Text(
                    "No Image".tr,
                    style: TextStyle(color: ColorConstants.btnColor),
                  )),
              TextButton(
                  onPressed: onConfirm,
                  child:  Text(
                    "Select Image".tr,
                    style: TextStyle(color: ColorConstants.btnColor),
                  ))
            ],
            content: SizedBox(
              width: screenWidth * 0.9,
              height: 200.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info,
                    color: ColorConstants.btnColor,
                    size: 100,
                  ).paddingOnly(top: 20),
                  Text(
                    dialogContentPrimary,
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ).paddingOnly(top: 10.h),
                  Text(
                    dialogContentSecondary,
                    style: TextStyle(fontSize: 14.sp),
                    maxLines: 18,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )),
      );
    },
  );
}

class LocationTimeline extends StatelessWidget {
  final bool isPickup;
  final bool isStart;
  final bool isFuture;
  final String phoneNumber;
  final String address;
  final bool isLast;
  final bool showMap;
  final VoidCallback onPressed;

  const LocationTimeline({
    super.key,
    required this.isStart,
    required this.isFuture,
    required this.phoneNumber,
    required this.address,
    required this.isLast,
    required this.isPickup,
    required this.onPressed,
    required this.showMap,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      indicatorStyle: IndicatorStyle(
        width: 15.w,
        height: 15.w,
        color: isFuture
            ? (isPickup ? ColorConstants.greenColor : ColorConstants.redColor)
            : ColorConstants.greyColor, // Use a neutral color if not future
      ),
      isFirst: isStart,
      beforeLineStyle: LineStyle(
        color:
            !isFuture ? ColorConstants.lightGreyColor : ColorConstants.btnColor,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color:
            !isFuture ? ColorConstants.lightGreyColor : ColorConstants.btnColor,
        thickness: 2,
      ),
      isLast: isLast,
      lineXY: 0.1,
      alignment: TimelineAlign.manual,
      endChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isPickup ? "PICKUP".tr : "DROP-OFF".tr,
            style: TextStyle(
              fontSize: 14.sp,
              color: isPickup
                  ? ColorConstants.greenColor
                  : ColorConstants.redColor,
            ),
          ).paddingOnly(left: 10.w, top: 30.h),
          Text(
            address,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ).paddingOnly(left: 10.w),
          Row(
            children: [
              showMap
                  ? GestureDetector(
                      onTap: () async {
                        bool? res = await FlutterPhoneDirectCaller.callNumber(
                            phoneNumber);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: ColorConstants.btnColor),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.phone,
                                    color: ColorConstants.btnColor)
                                .paddingOnly(right: 10.w),
                            Text(
                              phoneNumber,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.btnColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
              showMap
                  ? GestureDetector(
                      onTap: onPressed,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: ColorConstants.btnColor),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.map_sharp,
                                    color: ColorConstants.btnColor)
                                .paddingOnly(right: 10.w),
                            Text(
                              "Open Maps".tr,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.btnColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          )
        ],
      ),
    );
  }
}

class CurrentLocation extends StatelessWidget {
  final bool isPickup;
  final bool isStart;
  final bool isFuture;
  final String phoneNumber;
  final String address;
  final bool isLast;
  final bool showMap;
  final VoidCallback onPressed;

  const CurrentLocation({
    super.key,
    required this.isStart,
    required this.isFuture,
    required this.phoneNumber,
    required this.address,
    required this.isLast,
    required this.isPickup,
    required this.onPressed,
    required this.showMap,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      indicatorStyle: IndicatorStyle(
        width: 15.w,
        height: 15.w,
        color: isFuture
            ? (isPickup ? ColorConstants.greenColor : ColorConstants.redColor)
            : ColorConstants.greyColor, // Use a neutral color if not future
      ),
      isFirst: isStart,
      beforeLineStyle: LineStyle(
        color:
            !isFuture ? ColorConstants.lightGreyColor : ColorConstants.btnColor,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color:
            !isFuture ? ColorConstants.lightGreyColor : ColorConstants.btnColor,
        thickness: 2,
      ),
      isLast: isLast,
      lineXY: 0.1,
      alignment: TimelineAlign.manual,
      endChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "YOUR LOCATION".tr,
            style: TextStyle(
              fontSize: 14.sp,
              color: isPickup
                  ? ColorConstants.greenColor
                  : ColorConstants.redColor,
            ),
          ).paddingOnly(left: 10.w, top: 30.h),
          Text(
            address,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ).paddingOnly(left: 10.w),
        ],
      ),
    );
  }
}

Future<void> customdialogBuilder1(
    BuildContext context,
    String dialogContentPrimary,
    String dialogContentSecondary,
    VoidCallback onConfirm,
    VoidCallback onCancel) {
  var screenWidth = MediaQuery.sizeOf(context).width;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
            backgroundColor: ColorConstants.bgColor,
            actions: [
              TextButton(
                  onPressed: onCancel,
                  child: Text("Cancel".tr,
                      style: TextStyle(
                          fontSize: 14.sp, color: ColorConstants.btnColor))),
              TextButton(
                  onPressed: onConfirm,
                  child: Text("Confirm".tr,
                      style: TextStyle(
                          fontSize: 14.sp, color: ColorConstants.btnColor)))
            ],
            content: SizedBox(
              width: screenWidth * 0.9,
              height: 310.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info,
                    color: ColorConstants.btnColor,
                    size: 100,
                  ).paddingOnly(top: 20),
                  Text(
                    dialogContentPrimary,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ).paddingOnly(top: 20),
                  Text(
                    dialogContentSecondary,
                    style: const TextStyle(
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ).paddingOnly(top: 20),
                ],
              ),
            )),
      );
    },
  );
}
Future<void> profileDialog(
    BuildContext context,
    String dialogContentPrimary,
    String dialogContentSecondary,
    VoidCallback onConfirm,
    VoidCallback onCancel) {
  var screenWidth = MediaQuery.sizeOf(context).width;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
            backgroundColor: ColorConstants.bgColor,
            actions: [
              TextButton(
                  onPressed: onCancel,
                  child: Text("Complete Profile".tr,
                      style: TextStyle(
                          fontSize: 14.sp, color: ColorConstants.btnColor))),
              TextButton(
                  onPressed: onConfirm,
                  child: Text("Logout".tr,
                      style: TextStyle(
                          fontSize: 14.sp, color: ColorConstants.btnColor)))
            ],
            content: SizedBox(
              width: screenWidth * 0.9,
              height: 210.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info,
                    color: ColorConstants.btnColor,
                    size: 100,
                  ).paddingOnly(top: 20),
                  Text(
                    dialogContentPrimary,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ).paddingOnly(top: 20),
                  Text(
                    dialogContentSecondary,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ).paddingOnly(top: 20),
                ],
              ),
            )),
      );
    },
  );
}
