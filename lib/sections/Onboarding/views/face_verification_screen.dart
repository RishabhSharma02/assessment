import 'package:bhaada/Constants/color_constants.dart';
import 'package:bhaada/sections/Onboarding/controllers/onboarding_controller.dart';
import 'package:bhaada/sections/Onboarding/views/image_preview.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common widgets/common_widgets.dart';

class FaceVerification extends StatefulWidget {
  const FaceVerification({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<FaceVerification> createState() => _FaceVerificationState();
}

class _FaceVerificationState extends State<FaceVerification> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller =
        CameraController(widget.cameras[1], ResolutionPreset.max, fps: 60);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  final OnboardingController _onboardingController=Get.put(OnboardingController());
  @override
  Widget build(BuildContext context) {

    if (!controller.value.isInitialized) {
      return Container();
    } else {
      return Scaffold(
        appBar: buildCommonAppbar("Your Selfie photo".tr, false, true,context),
        backgroundColor: ColorConstants.bgColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildCameraView().paddingOnly(top: 82.h),
            buildText(
                    "Make sure your face is clearly visible, and you are standing against a simple background in bright light".tr)
                .paddingOnly(top: 37.h, left: 24.w, right: 24.w),
            buildCameraButton(() async=> {
                  await controller.takePicture().then((val)=>{
                    _onboardingController.imageFile.value=val,
                    Get.to(()=>ImagePreview())
                  })

            }).paddingOnly(top: 80.h),
          ],
        ),
      );
    }
  }

  Widget buildCameraView() => ClipOval(
        child: SizedBox(
          width: 300,
          height: 300,
          child: CameraPreview(controller),
        ),
      );

  Widget buildText(String text) => Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 14.sp, color: ColorConstants.textColor),
      );

  Widget buildCameraButton(Function() onTap) => MaterialButton(
        onPressed: onTap,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(62),
            side: const BorderSide(
                width: 5, color: ColorConstants.clickButtonColor)),
        minWidth: 78,
        height: 78,
      );
}
