import 'package:bhaada/Constants/color_constants.dart';
import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../homescreen/controllers/home_screen_controller.dart';

class PersonalInformationScreen extends StatelessWidget {
  PersonalInformationScreen({super.key});
  bool isNameEditing = false;
  bool isNumberEditing = false;
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    LoadingScreen.instance().hide();
    return Obx(
      () => Scaffold(
        backgroundColor: ColorConstants.bgColor,
        appBar: buildInAppAppbar(
            "Your Profile".tr, true, true, homeScreenController.isOnline.value,context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildProfilePicture(homeScreenController.imageUrl.value, context)
                .paddingOnly(top: 44.h),
            buildProfileItem(
                    'Name'.tr,
                    homeScreenController.profileNameController.value,
                    isNameEditing,
                    () {})
                .paddingOnly(top: 44.h, right: 25.w, left: 25.w),
            buildProfileItem(
                'Mobile number'.tr,
                homeScreenController.profileNumberController.value,
                isNumberEditing, () {
              OverlayLoader.instance().showOverlay(
                  title: "Not Allowed".tr,
                  context: context,
                  text:
                      "Editing phone number is not allowed. Please contact administrator".tr,
                  isError: true);
            }).paddingOnly(top: 20.h, right: 25.w, left: 25.w),
          ],
        ),
      ),
    );
  }

  Widget buildProfilePicture(String imgUrl, BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 120.w,
          height: 120.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(imgUrl),
              fit: BoxFit.cover,
            ),
            border: Border.all(
              color: ColorConstants.blackColor,
              width: 1,
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: InkWell(
            onTap: () {
              imageDialog(
                  context,
                  "Change Profile Picture".tr,
                  "Select \"No Image\" to remove profile picture or select one from gallery.".tr,
                  () {homeScreenController.pickImage(ImageSource.gallery,context);},
                  () {homeScreenController.removeProfilePicture(context);});
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: ColorConstants.btnColor),
              child: const Icon(
                Icons.edit,
                color: ColorConstants.bgColor,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProfileItem(String title, TextEditingController controller,
      bool isEditing, VoidCallback onEditPressed) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.blackColor,
                    ),
                  ),
                  isEditing
                      ? TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        )
                      : Text(
                          controller.text,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorConstants.vehicleLightColor,
                          ),
                        ),
                ],
              ),
            ),
            TextButton(
              onPressed: onEditPressed,
              child: Text(
                isEditing ? "Save".tr : "Edit".tr,
                style: TextStyle(
                  fontSize: 15.sp,
                  decoration: TextDecoration.underline,
                  color: ColorConstants.btnColor,
                ),
              ),
            ),
          ],
        ),
        const Divider(color: ColorConstants.lightGreyColor),
      ],
    );
  }
}
