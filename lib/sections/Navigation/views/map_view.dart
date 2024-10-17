import 'package:bhaada/sections/Navigation/controllers/ride_controller.dart';
import 'package:bhaada/sections/Navigation/views/collect_cash.dart';
import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:bhaada/sections/homescreen/controllers/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pinput/pinput.dart';

import '../../../Constants/color_constants.dart';

class MapView extends StatefulWidget {
  MapView({super.key});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  RxBool isCancelRideVisible=true.obs;
  final HomeScreenController homeScreenController = Get.put(HomeScreenController());
  final RideController _rideController = Get.put(RideController());
  final RxInt currIdx = 0.obs;
  final TextEditingController otpController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
            canPop: false,
            onPopInvoked:(b){
              OverlayLoader.instance().showOverlay(
                context: context,
                title: "Error".tr,
                text: "Can't move back while ride in progress!".tr,
                isSuccess:false,
                isError: true
              );

            },
            child: Obx(()=>
              Scaffold(

                      backgroundColor: ColorConstants.bgColor,
                      body: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  SizedBox(
                    width: 360.w,
                    height: 381.h,
                    child: GoogleMap(
                      onTap: (val) {
                        // homeScreenController.testing(val.latitude, val.longitude);
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId("Currpos"),
                          position: LatLng(
                            homeScreenController.myLocation!.latitude,
                            homeScreenController.myLocation!.longitude,
                          ),
                          infoWindow:  InfoWindow(title: "Your Location".tr),
                        ),
                      },
                      style: homeScreenController.mapTheme.value,
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        zoom: 17,
                        target: LatLng(
                          homeScreenController.myLocation!.latitude,
                          homeScreenController.myLocation!.longitude,
                        ),
                      ),
                    ),
                  ),
                  CurrentLocation(
                    showMap: false,
                    onPressed: () {
                      // Handle location actions
                    },
                    isPickup: true,
                    isStart: true,
                    isFuture: true,
                    phoneNumber: "",
                    address: homeScreenController.myLocationString.value,
                    isLast: false,
                  ),
                  FutureBuilder<List<String>>(
                    future: Future.wait(
                      _rideController.places.map(
                            (place) async {
                          return await homeScreenController
                              .getAddressFromGeopoint(place["latLng"]);
                        },
                      ),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'.tr));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return  Center(child: Text('No data available'.tr));
                      }

                      final addresses = snapshot.data!;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                        }
                      });

                      return Column(
                        children: List.generate(
                          _rideController.places.length,
                              (i) => LocationTimeline(
                            showMap: currIdx.value == i,
                            onPressed: () {
                              _rideController.openMap(
                                  _rideController.places[i]["latLng"], context);
                            },
                            isPickup: _rideController.places[i]["type"] ==
                                "startPoint" ||
                                _rideController.places[i]["type"] == "pickUp",
                            isStart: false,
                            isFuture: i < currIdx.value,
                            phoneNumber: _rideController.places[i]["phoneNumber"],
                            address: addresses[i],
                            isLast: i == _rideController.places.length - 1,
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ColorConstants.dividerColor,
                  ).paddingOnly(left: 26.w, right: 26.w,top: 5.h),
                  FutureBuilder(
                    future: _rideController.calculateDistance(
                        _rideController.places[currIdx.value]["latLng"]),
                    builder: (c, s) {
                      return Text(
                        "ETA -- Mins  • ${s.data?.round()} m",
                        style: TextStyle(
                            color: ColorConstants.textColor, fontSize: 14.sp),
                      ).paddingOnly(top: 16.h);
                    },
                  ),
                  Column(
                    children: [
                      buildCommonButton(() {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Enter OTP'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16.sp),
                              ),
                              content: SizedBox(
                                height: 50.h,
                                child: Pinput(
                                  controller: otpController,
                                  length: 4,
                                  obscureText: false,
                                  animationDuration: const Duration(milliseconds: 200),
                                  defaultPinTheme: PinTheme(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: ColorConstants.borderColor),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    textStyle: TextStyle(
                                      fontSize: 18.sp,
                                      color: ColorConstants.textColor,
                                    ),
                                    width: 45.5.w,
                                    height: 48.h,
                                  ),
                                ),
                              ),
                              actions: [
                                MaterialButton(
                                  textColor: Colors.black,
                                  onPressed: () {
                                    otpController.clear();
                                    Navigator.pop(context);
                                  },
                                  child:  Text('CANCEL'.tr),
                                ),
                                MaterialButton(
                                  textColor: Colors.black,
                                  onPressed: () {
                                    if (otpController.text ==
                                        _rideController.places[currIdx.value]["otp"]) {
                                      otpController.clear();
                                      isCancelRideVisible.value=false;
                                      if (currIdx.value + 1 < _rideController.places.length) {
                                        currIdx.value++;
                                        isCancelRideVisible.value=false ;
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          if (_scrollController.hasClients) {
                                            _scrollController.animateTo(
                                              _scrollController.position.maxScrollExtent,
                                              duration: const Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        });
                                        OverlayLoader.instance().showOverlay(
                                          context: context,
                                          title: "Verified".tr,
                                          text: "Successfully Verified OTP".tr,
                                          isSuccess: true,
                                        );
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.push(context,MaterialPageRoute(builder: (c){
                                          return  CollectCash();
                                        }));
                                      }

                                    } else {
                                      otpController.clear();
                                      OverlayLoader.instance().showOverlay(
                                          context: context,
                                          title: "Error!".tr,
                                          text: "Please enter valid OTP".tr,
                                          isSuccess: false,
                                          isError: true);
                                    }
                                  },
                                  child: const Text('SUBMIT'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                          _rideController.places[currIdx.value]["type"] ==
                              "startPoint" ||
                              _rideController.places[currIdx.value]["type"] ==
                                  "pickUp"
                              ? "Pick-Up"
                              : "Drop-Off",
                          true)
                          .paddingOnly(left: 25.5.w, right: 25.5.w, top: 10.h,bottom: 20.h),
                     isCancelRideVisible.value?
                     buildCancelRide((){
                       customdialogBuilder1(context, "Are you sure to cancel ride ?".tr, "", (){
                         Navigator.pop(context);
                         Navigator.pop(context);
                       }, (){Navigator.pop(context);});

                     }, "Cancel Ride".tr, false)
                          .paddingOnly(

                          bottom: 23.h,
                          top: 5.h):const SizedBox(),
                    ],
                  ),
                ],
              ),
                      ),
                    ),
            ),
          );
  }
  Widget buildCancelRide(Function() onPressed, String btnText, bool isActive) =>
      MaterialButton(
        elevation: 0,
        onPressed: onPressed,
        height: 50.h,
        minWidth: 312.w,
        color: isActive ? ColorConstants.btnColor : ColorConstants.bgColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
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
}
