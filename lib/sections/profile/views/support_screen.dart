// import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:mailto/mailto.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../Constants/color_constants.dart';
// import '../../common widgets/common_widgets.dart';
// import '../../homescreen/controllers/home_screen_controller.dart';
//
// class SupportScreen extends StatelessWidget {
//    SupportScreen({super.key});
//   HomeScreenController homeScreenController =Get.put(HomeScreenController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorConstants.bgColor,
//       appBar: buildCommonAppbar("Support".tr, false, true,context),
//       // body: Column(
//       //   crossAxisAlignment: CrossAxisAlignment.start,
//       //   mainAxisAlignment: MainAxisAlignment.center,
//       //
//       //   children: [
//       //   GestureDetector(
//       //     onTap: () async{
//       //       final mailtoLink = Mailto(
//       //         to: ['help@bhaada.co.in'],
//       //         subject: 'I need help ',
//       //         body: 'Explain Issue',
//       //       );
//       //
//       //       await launch('$mailtoLink');
//       //     },
//       //     child: Container(
//       //       margin: EdgeInsets.only(top: 15.h,left: 45.h),
//       //       decoration: BoxDecoration(
//       //         borderRadius: BorderRadius.circular(10),
//       //         border: Border.all(color: ColorConstants.btnColor),
//       //       ),
//       //       padding: const EdgeInsets.all(17),
//       //       child: Row(
//       //         mainAxisSize: MainAxisSize.min,
//       //         children: [
//       //           const Icon(Icons.mail,color: ColorConstants.btnColor,size: 24,),
//       //           Text(
//       //             "Mail us at: ".tr,
//       //             style: TextStyle(
//       //               fontSize: 14.sp,
//       //               fontWeight: FontWeight.w600,
//       //               color: ColorConstants.btnColor,
//       //             ),
//       //           ).paddingOnly(left: 14.w),
//       //           Text(
//       //             "help@bhaada.co.in",
//       //             style: TextStyle(
//       //               fontSize: 14.sp,
//       //               fontWeight: FontWeight.w600,
//       //               color: ColorConstants.btnColor,
//       //             ),
//       //           ),
//       //         ],
//       //       ),
//       //     ),
//       //   ),
//       //   GestureDetector(
//       //     onTap: () async{
//       //       bool? res = await FlutterPhoneDirectCaller.callNumber("+91 77540 90709");
//       //     },
//       //     child: Container(
//       //       margin: EdgeInsets.only( top: 15.h,left: 60.h),
//       //       decoration: BoxDecoration(
//       //         borderRadius: BorderRadius.circular(10),
//       //         border: Border.all(color: ColorConstants.btnColor),
//       //       ),
//       //       padding: const EdgeInsets.all(17),
//       //       child: Row(
//       //         mainAxisSize: MainAxisSize.min,
//       //         children: [
//       //           const Icon(Icons.phone,color: ColorConstants.btnColor,size: 24,),
//       //           Text(
//       //             "Call us at: +91 77540 90709",
//       //             style: TextStyle(
//       //               fontSize: 14.sp,
//       //               fontWeight: FontWeight.w600,
//       //               color: ColorConstants.btnColor,
//       //             ),
//       //           ).paddingOnly(left: 14.w),
//
//           //    ],
//             //),
//         //  ),
//         )
//       ],),
//
//     );
//   }
// }
