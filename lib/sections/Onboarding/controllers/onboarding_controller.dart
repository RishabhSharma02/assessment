import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bhaada/Constants/color_constants.dart';
import 'package:bhaada/sections/Onboarding/models/addhar_response_model.dart';
import 'package:bhaada/sections/Onboarding/models/dl_response_model.dart';
import 'package:bhaada/sections/Onboarding/models/driver_model.dart';
import 'package:bhaada/sections/Onboarding/models/pan_response_model.dart';
import 'package:bhaada/sections/Onboarding/utils/utils.dart';
import 'package:bhaada/sections/homescreen/views/nav_screen.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:smart_auth/smart_auth.dart';

import '../../common widgets/common_widgets.dart';
import '../../profile/views/delivery_locations.dart';
import '../models/aadhar_model.dart';
import '../models/rc_model.dart';
import '../models/vehicle_model.dart';
import '../views/new_details_screen.dart';

class OnboardingController extends GetxController {
  @override
  void onClose() {
    // Dispose controllers
    aadhaarController.value.dispose();
    nameController.value.dispose();
    dateController.value.dispose();
    emailController.value.dispose();
    whatsAppController.value.dispose();
    codeController.value.dispose();

    // Dispose Razorpay instance
    razorpay.clear();

    super.onClose();
  }

  final dioInstance = Dio();
  RxString imageUrl = "".obs;
  var razorpay = Razorpay();
  RxList<bool> verifiedKycs = [false, false, false, false].obs;
  RxList<bool> verifiedVehicleKycs = [false, false, false].obs;
  RxBool userAlreadyExists = false.obs;
  RxInt? resendToken = 0.obs;
  Rx<XFile> imageFile = XFile("").obs;
  final smartAuth = SmartAuth();
  final _db = FirebaseFirestore.instance;
  bool _hintRequested = false;
  RxString phoneNr = "".obs;
  RxString numberPlateValue = "".obs;
  RxString requestId = "".obs;
  RxString aadhaarNumber = "".obs;
  RxString panNumber = "".obs;
  RxString dlNumber = "".obs;
  Rx<DriverModel> currDriver = DriverModel(
          gender: "",
          email: "",
          driverName: "",
          driverPhone: "",
          driverDob: "",
          vehicles: [],
          isVerified: false,
          imageUrl: "")
      .obs;
  Rx<Vehicle> selectedVehicle =
      Vehicle(vehicleName: "", vehicleType: "", loadCapacity: "", imgLink: "")
          .obs;
  RxString verificationID = "".obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  Rx<TextEditingController> aadhaarController = TextEditingController().obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> dateController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> whatsAppController = TextEditingController().obs;
  Rx<TextEditingController> codeController = TextEditingController().obs;
  RxInt tc = 0.obs;
  List<Vehicle> lv = [];
  RxList<bool> selectedVehicles = <bool>[].obs;
  void getAppSignature() async {
    final res = await smartAuth.getAppSignature();
    debugPrint('Signature: $res');
  }

  @override
  void onInit() async {
    getAppSignature();
    getVehicles();
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: 'call_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white)
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'basic_channel_group',
              channelGroupName: 'Basic group')
        ],
        debug: true
    );

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.onInit();
  }

  Future<bool> isProfilePresent(String phoneNumber) async {
    var data = await _db
        .collection("drivers")
        .where("id", isEqualTo: phoneNumber)
        .get();
    return data.docs.isEmpty;
  }

  Future<void> sendOtpAadhaar(
      String aadhaar, Function() onSuccess, Function() onFailure) async {
    var postData = {"aadhaarNo": aadhaar, "task": "getOtp"};
    var postHeaders = {
      'Content-Type': 'application/json',
      'x-api-key': 'd48h23jffeta5ej0v5y94ayk4jy7xbx3l',
    };
    try {
      var httpResponse = await dioInstance.post(
          "https://api.kyckart.com/api/aadhaar/aadhaarOfflineOtpV5",
          data: postData,
          options: Options(headers: postHeaders));
      final aadhaarModel = AadharModel.fromJson(httpResponse.data);
      if (httpResponse.statusCode == 200) {
        if (aadhaarModel.response!.statusCode == 2) {
          onFailure();
        } else {
          requestId.value = aadhaarModel.response!.requestId!;
          onSuccess();
        }
      } else {
        onFailure();
      }
    } catch (e) {
      onFailure();
    }
  }

  Future<void> verifyOtpAadhaar(
      String otp, Function() onSuccess, Function() onFailure) async {
    var postData = {
      "aadhaarNo": aadhaarController.value.text,
      "task": "getFile",
      "otp": otp,
      "requestId": requestId.value
    };
    var postHeaders = {
      'Content-Type': 'application/json',
      'x-api-key': 'd48h23jffeta5ej0v5y94ayk4jy7xbx3l',
    };
    try {
      var httpResponse = await dioInstance.post(
          "https://api.kyckart.com/api/aadhaar/aadhaarOfflineOtpV5",
          data: postData,
          options: Options(headers: postHeaders));
      final aadhaarModel = AadharResponseModel.fromJson(httpResponse.data);
      if (aadhaarModel.status?.statusCode == 200) {
        aadhaarNumber.value = aadhaarModel.status!.input!.aadhaarNo!;
        onSuccess();
      } else {
        onFailure();
      }
    } catch (e) {
      onFailure();
    }
  }

  Future<void> verifyDL(String dlNo, String dateOfBirth, Function() onSuccess,
      Function() onFailure, Function onNotVerified) async {
    var postData = {"cardNumber": dlNo, "dob": dateOfBirth};
    var postHeaders = {
      'Content-Type': 'application/json',
      'x-api-key': 'd48h23jffeta5ej0v5y94ayk4jy7xbx3l',
    };
    try {
      var httpResponse = await dioInstance.post(
          "https://api.kyckart.com/api/dl/shortDetail",
          data: postData,
          options: Options(headers: postHeaders));
      final dlModel = DlResponseModel.fromJson(httpResponse.data);

      if (httpResponse.statusCode == 200) {
        if (dlModel.response!.code == 200 &&
            dlModel.response!.details!.status == "ACTIVE") {
          dlNumber.value = dlNo;
          onSuccess();
        } else {
          onNotVerified();
        }
      } else {
        onFailure();
      }
    } catch (e) {
      onFailure();
    }
  }

  Future<void> verifyPan(String panNo, Function() onSuccess,
      Function() onFailure, Function onNotVerified) async {
    var postData = {"panNumber": panNo};
    var postHeaders = {
      'Content-Type': 'application/json',
      'x-api-key': 'd48h23jffeta5ej0v5y94ayk4jy7xbx3l',
    };
    try {
      var httpResponse = await dioInstance.post(
          "https://api.kyckart.com/api/panCard/search",
          data: postData,
          options: Options(headers: postHeaders));
      final panModel = PanResponseModel.fromJson(httpResponse.data);

      if (httpResponse.statusCode == 200) {
        if (panModel.response!.code == 200 &&
            panModel.response!.panStatus == "VALID") {
          panNumber.value = panNo;
          onSuccess();
        } else {
          onNotVerified();
        }
      } else {
        onFailure();
      }
    } catch (e) {
      onFailure();
    }
  }

  Future<void> verifyRc(String numberPlate, Function() onSuccess,
      Function() onFailure, Function onNotVerified) async {
    var postData = {"vehicleNumber": numberPlate};
    var postHeaders = {
      'Content-Type': 'application/json',
      'x-api-key': 'd48h23jffeta5ej0v5y94ayk4jy7xbx3l',
    };
    try {
      var httpResponse = await dioInstance.post(
          "https://api.kyckart.com/api/vehicle-registration/searchV4",
          data: postData,
          options: Options(headers: postHeaders));
      bool result = validateResponse(httpResponse.data);
      numberPlateValue.value = numberPlate;
      if (httpResponse.statusCode == 200) {
        if (result) {
          onSuccess();
        } else {
          onNotVerified();
        }
      } else {
        onFailure();
      }
    } catch (e) {
      onFailure();
    }
  }

  Future<void> uploadImageFile(BuildContext context) async {
    LoadingScreen.instance()
        .show(context: context, desc: "Saving,Please Wait.");
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');
      UploadTask task = ref.putFile(File(imageFile.value.path));
      TaskSnapshot snap = await task;
      imageUrl.value = await snap.ref.getDownloadURL();
      LoadingScreen.instance().hide();
      OverlayLoader.instance().showOverlay(
          context: context,
          title: "Success".tr,
          text: "Image upload successful".tr,
          isSuccess: true,
          isError: false);
    } catch (e) {
      LoadingScreen.instance().hide();
      OverlayLoader.instance().showOverlay(
          context: context,
          title: "Error!".tr,
          text: e.toString(),
          isSuccess: false,
          isError: true);
    }
  }

  Future<void> requestPermissions() async {
    // Request location permission
    if (await Permission.location.request().isGranted) {
      // Get.showSnackbar(const GetSnackBar(
      //   message: "Location Permission Granted",
      //   duration: Duration(seconds: 2),
      //   backgroundColor: ColorConstants.greenColor,
      // ));
    } else {
      Get.showSnackbar( GetSnackBar(
        message: "Please allow location permission manually".tr,
        duration: Duration(seconds: 2),
        backgroundColor: ColorConstants.redColor,
      ));
    }

    // Request camera permission
    if (await Permission.camera.request().isGranted) {
      // Get.showSnackbar(const GetSnackBar(
      //   message: "Camera Permission Granted",
      //   duration: Duration(seconds: 2),
      //   backgroundColor: ColorConstants.greenColor,
      // ));
      // Camera permission granted
    } else {
      Get.showSnackbar( GetSnackBar(
        message: "Please allow camera  permission ".tr,
        duration: Duration(seconds: 2),
        backgroundColor: ColorConstants.redColor,
      ));
    }

    // Request phone call permission
    if (await Permission.phone.request().isGranted) {
      // Get.showSnackbar(const GetSnackBar(
      //   message: "Phone Permission Granted",
      //   duration: Duration(seconds: 2),
      //   backgroundColor: ColorConstants.greenColor,
      // ));

    } else {}

    // Request notification permission
    if (await Permission.notification.request().isGranted) {
      // Get.showSnackbar(const GetSnackBar(
      //   message: "Notification Permission Granted",
      //   duration: Duration(seconds: 2),
      //   backgroundColor: ColorConstants.greenColor,
      // ));
      // Notification permission granted
    } else {
      Get.showSnackbar( GetSnackBar(
          message: "Please allow notification permission ".tr,
          duration: Duration(seconds: 2),
          backgroundColor: ColorConstants.redColor));
    }
  }

  Future<void> checkPhoneNumberExists(String phoneNumber) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
          .instance
          .collection('drivers')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();
      userAlreadyExists.value = result.docs.isNotEmpty;
    } catch (e) {
      userAlreadyExists.value = false;
    }
  }

  void getVehicles() async {
    try {
      await _db
          .collection("vehicles")
          .orderBy("order", descending: false)
          .get()
          .then((data) {
        for (var i in data.docs) {
          lv.add(Vehicle(
              vehicleName: i.get("name"),
              vehicleType: i.get("type"),
              loadCapacity: i.get("loadCapacity"),
              imgLink: i.get("imgUrl")));
        }
        selectedVehicle.value.imgLink = lv[0].imgLink;
        selectedVehicle.value.loadCapacity = lv[0].loadCapacity;
        selectedVehicle.value.vehicleType = lv[0].vehicleType;
        selectedVehicle.value.vehicleName = lv[0].vehicleName;
      });
      selectedVehicles.value =
          List<bool>.generate(7, (int idx) => false, growable: false);
    } catch (e) {
      Get.showSnackbar( GetSnackBar(
          message: "Database Sync Error".tr, duration: Duration(seconds: 2)));
    }
  }

  void timer(int duration) {
    tc.value = duration;
    Timer.periodic(const Duration(seconds: 1), (val) {
      if (tc.value <= 0) {
        tc.value = 0;
        val.cancel();
      } else {
        tc.value--;
      }
    });
  }

  void getSmsCode() async {
    final res = await smartAuth.getSmsCode(useUserConsentApi: true);
    if (res.succeed) {
      codeController.value.text = res.code!;
      debugPrint('SMS: ${res.code}'.tr);
    } else {
      debugPrint('SMS Failure:');
    }
  }

  Future<String?> requestHint() async {
    if (_hintRequested) {
      return null; // Return null or handle accordingly if the function has already been called.
    }

    _hintRequested = true;

    final res = await smartAuth.requestHint(
      isPhoneNumberIdentifierSupported: true,
      isEmailAddressIdentifierSupported: false,
      showCancelButton: true,
    );

    return res?.id;
  }

  void sendOTP(String phoneNumber, Function(String, int?) onSuccess,
      Function(PhoneAuthCredential cred) autofill, BuildContext context) async {
    if (phoneNumber.isEmpty || phoneNumber.length < 13) {
      OverlayLoader.instance().showOverlay(
          context: context,
          title: "Error!".tr,
          text: "Please enter a valid phone number!".tr,
          isSuccess: false,
          isError: true);
      return; // Exit function early if phone number is invalid
    }

    phoneNr.value = phoneNumber;
    LoadingScreen.instance().show(context: context, desc: "Please Wait".tr);
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: resendToken?.value,
      verificationCompleted: autofill,
      timeout: const Duration(seconds: 120),
      verificationFailed: (FirebaseAuthException e) {
        LoadingScreen.instance().hide();
        OverlayLoader.instance().showOverlay(
            context: context,
            title: "Error!".tr,
            text: e.code,
            isSuccess: false,
            isError: true);
      },
      codeSent: onSuccess,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    Timer(const Duration(seconds: 4), () {
      LoadingScreen.instance().hide();
    });
  }

  void signInPhone(String phoneNumber, String code, Function() onSuccess,
      BuildContext context) async {
    if (code.isEmpty || code.length < 6) {
      OverlayLoader.instance().showOverlay(
          context: context,
          title: "Error!".tr,
          text: "Enter Valid code".tr,
          isSuccess: false,
          isError: true);
      return; // Exit function early if phone number is invalid
    }
    try {
      LoadingScreen.instance().show(context: context, desc: "Please Wait".tr);
      String smsCode = code;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationID.value, smsCode: smsCode);
      await auth.signInWithCredential(credential);
      onSuccess();
      whatsAppController.value.text = auth.currentUser!.phoneNumber.toString();
      // Call the onSuccess callback function when authentication succeeds
      LoadingScreen.instance().hide();
    } catch (error) {
      OverlayLoader.instance().showOverlay(
          context: context,
          title: "Error!".tr,
          text: error.toString(),
          isSuccess: false,
          isError: true);
    }
    LoadingScreen.instance().hide();
  }

  void createProfileHelper(BuildContext context) async {
    OverlayLoader.instance().showOverlay(
        title: "Creating Profile".tr, context: context, text: "Please wait..".tr);
    await _db
        .collection("drivers")
        .doc(auth.currentUser!.phoneNumber.toString()??"0000000000")
        .set({
      "name": currDriver.value.driverName,
      "phoneNumber": auth.currentUser!.phoneNumber.toString(),
      "dateOfBirth": currDriver.value.driverDob,
      "isVerified": currDriver.value.isVerified,
      "gender": currDriver.value.gender,
      "aadhaarNumber": aadhaarNumber.value,
      "panCard": panNumber.value,
      "dlNumber": dlNumber.value,
      "numberPlate": numberPlateValue.value,
      "imageUrl": imageUrl.value, //TODO:add image url here
      "whatsAppPhone": currDriver.value.driverWhatsAppPhone,
      "email": currDriver.value.email,
      "wallet": 0,
      "cashInHand": 0,
      "rating": 0.0
    }).then((val) async {
      _db
          .collection("drivers")
          .doc(auth.currentUser!.phoneNumber.toString())
          .collection("vehicles")
          .add({
        "regCertificate": numberPlateValue.value,
        "vehicleName": selectedVehicle.value.vehicleName,
        "vehicleType": selectedVehicle.value.vehicleType,
        "imageLink": selectedVehicle.value.imgLink,
        "loadCapacity": selectedVehicle.value.loadCapacity,
      });
      _db
          .collection("drivers")
          .doc(auth.currentUser!.phoneNumber.toString())
          .collection("today")
          .add({
        "tasksDone": 0,
        "earnings": 0,
        "trips": 0,
        "loginHours": 0,
        "orders": 0,
      });
    }).then((val) {
      verifiedVehicleKycs[0] = false;
      verifiedVehicleKycs[1] = false;
      verifiedVehicleKycs[2] = false;
      OverlayLoader.instance().showOverlay(
          context: context,
          title: "Success".tr,
          text: "Successfully created profile".tr,
          isSuccess: true,
          isError: false);
    });
    onClose();
    Get.offAll(() => NavScreen(), transition: Transition.cupertino);
  }




  bool validateResponse(Map<String, dynamic> data) {

    if (data['response']['code'] != 200) {
      return false;
    }
    if(selectedVehicle.value.vehicleType!="2-Wheeler"){
      if(data["isCommercial"]=="false"){
        return false;
      }else{
        if (data['response']['insurance'] == null) {
          return false;
        }
        DateTime today = DateTime.now();
        DateTime insuranceValidTill =
        parseDate(data['response']['insurance']['validTill']);

        if (insuranceValidTill.isBefore(today)) {
          return false;
        }
        return true;

      }
    }
    else{
      if (data['response']['insurance'] == null) {
        return false;
      }
      DateTime today = DateTime.now();
      DateTime insuranceValidTill =
      parseDate(data['response']['insurance']['validTill']);

      if (insuranceValidTill.isBefore(today)) {
        return false;
      }
      return true;
    }
  }

  // Helper function to parse date in DD/MM/YYYY format to DateTime object
  DateTime parseDate(String dateString) {
    List<String> parts = dateString.split('/');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }
}
