import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Constants/color_constants.dart';
import '../../common widgets/common_widgets.dart';
import '../../homescreen/controllers/home_screen_controller.dart';

class LanguagesScreen extends StatelessWidget {
  LanguagesScreen({super.key});
  final HomeScreenController homeScreenController=Get.put(HomeScreenController());
  Locale currentLocale = Locale('en', 'US');

  void toggleLanguage() {
    if (currentLocale == Locale('en', 'US')) {
      currentLocale = Locale('hi', 'IN');
    } else {
      currentLocale = Locale('en', 'US');
    }
    Get.updateLocale(currentLocale);
  }
  @override
  Widget build(BuildContext context) {
    return Obx(()=>
        Scaffold(
        backgroundColor: ColorConstants.bgColor,
        appBar: buildInAppAppbar("Languages".tr, true, true, homeScreenController.isOnline.value,context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildText( "Choose your preferred language you want to use in Bhaada app".tr).paddingOnly(left: 27.w, right: 27.w, top: 31.h),
            buildLanguages('English',true,(val){toggleLanguage();}).paddingOnly(left: 27.w, right: 27.w,top: 26.h ),
            const Divider(color: ColorConstants.lightGreyColor,).paddingOnly(left: 27.w, right: 27.w, ),
            buildLanguages('Hindi'.tr,true,(val){toggleLanguage();}).paddingOnly(left: 27.w, right: 27.w,top: 22.h ),
            const Divider(color: ColorConstants.lightGreyColor,).paddingOnly(left: 27.w, right: 27.w, )
          ],
        ),
      ),
    );
  }
  Widget buildLanguages(String language,bool value,Function(bool?) onSelected)=>Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    language,
    textAlign: TextAlign.left,
    style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w600, color: ColorConstants.blackColor),
  ),
    Checkbox(value: value, onChanged: onSelected,fillColor:  WidgetStateProperty.all(ColorConstants.btnColor))
  ],);

  Widget buildText(String text) => Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 14.sp, color: ColorConstants.textColor),
      );
}
