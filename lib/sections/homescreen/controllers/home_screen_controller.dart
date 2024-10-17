import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bhaada/sections/Navigation/controllers/ride_controller.dart';
import 'package:bhaada/sections/Onboarding/models/vehicle_model.dart';
import 'package:bhaada/sections/Onboarding/views/login_screen.dart';
import 'package:bhaada/sections/Onboarding/views/new_details_screen.dart';
import 'package:bhaada/sections/common%20widgets/common_widgets.dart';
import 'package:bhaada/sections/Navigation/views/map_view.dart';
import 'package:bhaada/sections/homescreen/modals/vehicle_model.dart';
import 'package:bhaada/sections/profile/controllers/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../Constants/color_constants.dart';

class HomeScreenController extends GetxController {
  VehicleDB myVehicle = VehicleDB(
    imgLink: '',
    loadCapacity: '',
    rc: '',
    vehicleName: '',
    vehicleType: '',
  );
  RxList<VehicleDB> userVehicles = <VehicleDB>[].obs;
  final RideController _rideController = Get.put(RideController());
  final ProfileController profileController = Get.put(ProfileController());
  List<String> ls = [];
  List<String> associatedNumberPlates = [];
  late OverlayEntry copyOverlay;
  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  RxInt tval = 0.obs;
  RxBool userAlreadyExists = false.obs;
  RxDouble cashAlloted = 0.0.obs;
  RxDouble minsToReach = 0.0.obs;
  RxDouble distance = 0.0.obs;
  RxDouble userRating = 0.0.obs;
  RxString phoneNumber = "".obs;
  RxBool isOnline = false.obs;
  RxDouble cashInHand = 0.0.obs;
  RxString userName = "".obs;
  RxString imageUrl = "".obs;
  RxDouble wallet = 0.0.obs;
  Position? _currentPosition;
  RxBool dataLoading = false.obs;
  final geo = GeoFlutterFire();
  AudioPlayer player = AudioPlayer();
  String alarmAudioPath = "tones/notification.mp3";
  RxString myLocationString = "Searching...".obs;
  final databaseInstance = FirebaseFirestore.instance;
  RxBool isRideStarted = false.obs;
  GeoFirePoint? myLocation;
  RxString mapTheme = "".obs;
  Rx<TextEditingController> profileNameController = TextEditingController().obs;
  Rx<TextEditingController> profileNumberController =
      TextEditingController().obs;
  StreamSubscription<QuerySnapshot>? _orderSubscription;
  Rx<Stream<QuerySnapshot>?> orderStream = Rx<Stream<QuerySnapshot>?>(null);
  Rx<Stream<QuerySnapshot>?> orderStream1 = Rx<Stream<QuerySnapshot>?>(null);
  Rx<Stream<QuerySnapshot>?> earningStream = Rx<Stream<QuerySnapshot>?>(null);
  Rx<Stream<QuerySnapshot>?> notificationStream =
      Rx<Stream<QuerySnapshot>?>(null);
  void onRefresh() {
    getData();
    requestPermissions();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
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

  Future<void> requestPermissions() async {
    if (await Permission.location.request().isGranted) {
      //Get.showSnackbar(const GetSnackBar(message: "Permission Granted",duration: Duration(seconds: 2),backgroundColor: ColorConstants.greenColor,));
    } else {
      // Get.showSnackbar(const GetSnackBar(message: "Please allow location permission manually",duration: Duration(seconds: 2),backgroundColor: ColorConstants.redColor,));
    }

    // Request camera permission
    if (await Permission.camera.request().isGranted) {
      // Camera permission granted
    } else {
      // Get.showSnackbar(const GetSnackBar(message: "Please allow camera  permission ",duration: Duration(seconds: 2),backgroundColor: ColorConstants.redColor,));
    }

    // Request phone call permission
    if (await Permission.phone.request().isGranted) {
      //Get.showSnackbar(const GetSnackBar(message: "Please allow phone call permission ",duration: Duration(seconds: 2),backgroundColor: ColorConstants.redColor));
    } else {}

    // Request notification permission
    if (await Permission.notification.request().isGranted) {
      // Notification permission granted
    } else {
      //Get.showSnackbar(const GetSnackBar(message: "Please allow notification permission ",duration: Duration(seconds: 2),backgroundColor: ColorConstants.redColor));
    }
  }

  @override
  void onInit() {
    getData();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    super.onInit();
  }

  Future<bool> isRatingVisible() async {
    var data = await databaseInstance
        .collection("drivers")
        .doc(auth.currentUser!.phoneNumber.toString())
        .collection("orders")
        .get();
    return data.docs.isNotEmpty;
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(dateTime); // Adjust format as needed
  }

  Future<bool> isAssociatedNumberPlate(String numberPlate) async {
    var data = await databaseInstance
        .collection("registeredNumberPlates")
        .where("regCertificate", isEqualTo: numberPlate)
        .get();
    return data.docs.isEmpty;
  }

  void getData() {
    checkPhoneNumberExists(auth.currentUser!.phoneNumber.toString());
    String id = FirebaseAuth.instance.currentUser!.phoneNumber!;
    dataLoading.value = true;

    databaseInstance.collection("drivers").doc(id).get().then((data) {
      if (data.exists) {
        phoneNumber.value = id;
        try {
          userName.value = data.get("name");
          imageUrl.value = data.get("imageUrl") ?? "";
          wallet.value = data.get("wallet").toDouble();
          cashInHand.value = data.get("cashInHand").toDouble();
          userRating.value = data.get("rating").toDouble();
        } catch (e) {
          _showErrorDialog(
              "One or more fields are missing in the driver document.");
        }
      } else {
        _showErrorDialog("Driver data does not exist.");
      }
    }).then((val) {
      orderStream1.value = FirebaseFirestore.instance
          .collection('drivers')
          .doc(id)
          .collection('orders')
          .snapshots();
      orderStream.value = FirebaseFirestore.instance
          .collection('drivers')
          .doc(id)
          .collection('orders')
          .snapshots();
      earningStream.value = FirebaseFirestore.instance
          .collection('drivers')
          .doc(id)
          .collection('transactions')
          .snapshots();
      notificationStream.value = FirebaseFirestore.instance
          .collection('drivers')
          .doc(id)
          .collection('today')
          .snapshots();
    }).then((v) {
      databaseInstance
          .collection("drivers")
          .doc(id)
          .collection("vehicles")
          .get()
          .then((data) {
        userVehicles.clear();
        try {
          for (var i in data.docs) {
            userVehicles.add(VehicleDB(
              imgLink: i.get("imageLink"),
              loadCapacity: i.get("loadCapacity"),
              rc: i.get("regCertificate"),
              vehicleName: i.get("vehicleName"),
              vehicleType: i.get("vehicleType"),
            ));
          }
          if (userVehicles.isNotEmpty) {
            myVehicle.rc = userVehicles[0].rc;
            myVehicle.imgLink = userVehicles[0].imgLink;
            myVehicle.vehicleName = userVehicles[0].vehicleName;
            myVehicle.vehicleType = userVehicles[0].vehicleType;
            myVehicle.loadCapacity = userVehicles[0].loadCapacity;
          }
        } catch (e) {
          dataLoading.value = true;
          _showErrorDialog(
              "One or more fields are missing in the vehicle documents.");
        }
        _getLocation();
        dataLoading.value = false;
      });
    });
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        content: SizedBox(
          width: 250.w,
          height: 280.h,
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
                "Please complete your profile to proceed further".tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ).paddingOnly(top: 20),
            ],
          ),
        ),
        backgroundColor: ColorConstants.bgColor,
        actions: [
          TextButton(
              onPressed: () {
                Get.to(() => PersonalDetailsScreen());
              },
              child: Text("Complete Profile".tr,
                  style: TextStyle(
                      fontSize: 14.sp, color: ColorConstants.btnColor))),
          TextButton(
              onPressed: () {
                auth.signOut();
                Get.to(() => LoginScreen());
              },
              child: Text("Logout".tr,
                  style: TextStyle(
                      fontSize: 14.sp, color: ColorConstants.btnColor))),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void getPayment() {
    Razorpay razorpay = Razorpay();
    var options = {
      'key': 'rzp_live_ILgsfZCZoFIKMb',
      'amount': 100,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    //showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    // showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    //  showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }
  void _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return;
    }
    Geolocator.getPositionStream().listen(
      (Position position) async {
        try {
          _currentPosition = position;
          myLocation = geo.point(
            latitude: _currentPosition!.latitude,
            longitude: _currentPosition!.longitude,
          );

          if (_currentPosition != null) {
            List<Placemark> placemarks = await placemarkFromCoordinates(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            );

            if (placemarks.isNotEmpty) {
              Placemark place = placemarks[0];
              myLocationString.value =
                  '${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}';
            } else {
              myLocationString.value = "Unidentified location";
            }
          }
        } catch (e) {
          myLocationString.value = "Unidentified location";
        }
      },
    );
  }

  void initialiseGoogleMap(BuildContext context) {
    DefaultAssetBundle.of(context)
        .loadString("assets/map_themes/map_theme.json")
        .then((val) {
      mapTheme.value = val;
    });
  }

  Future<String> getAddressFromGeopoint(GeoPoint geopoint) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        geopoint.latitude,
        geopoint.longitude,
      );
      Placemark place = placemarks[0];
      return "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    } catch (e) {
      return "Unknown location".tr;
    }
  }

  void showOverlayForDocument(BuildContext context, List<dynamic> detailsMap,
      double cashAlloted, double distance, double minsToReach) async {
    OverlayEntry overlayEntry = await _createOverlayEntry(
        detailsMap, cashAlloted, distance, minsToReach, () {
      copyOverlay.remove();
    });
    Overlay.of(context).insert(overlayEntry);
    copyOverlay = overlayEntry;
    player.play(AssetSource(alarmAudioPath));
    startIncrementer(15);
    if (profileController.isTripUpdatesEnabled.value) {
      AwesomeNotifications().createNotification(
          actionButtons: [
            NotificationActionButton(key: "GO TO APP", label: "GO TO APP")
          ],
          content: NotificationContent(
            id: 10,
            channelKey: 'call_channel',
            actionType: ActionType.Default,
            title: 'New Ride!'.tr,
            body:
                'Click on \'Accept\' to accept ride , \'Decline\' to reject. '.tr,
          ));
    }

    Future.delayed(const Duration(seconds: 15), () {
      overlayEntry.remove();
    });
    tval.value = 0;
  }

  void startIncrementer(int dur) {
    Timer.periodic(const Duration(milliseconds: 50), (val) {
      tval.value += 50;
      if (tval.value == dur * 1000) {
        val.cancel();
      }
    });
  }

  Future<OverlayEntry> _createOverlayEntry(
      List<dynamic> detailsMap,
      double cashAlloted,
      double distance,
      double minsToReach,
      VoidCallback onDecline) async {
    // Collect all the addresses asynchronously
    List<Future<TimelineEntryData>> timelineEntriesFutures =
        detailsMap.map((entry) async {
      String getAddress = await getAddressFromGeopoint(entry["latLng"]);
      String name = entry["name"];
      String title = entry["type"];
      String phoneNumber = entry["phoneNumber"];
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
                        buildProgressBar((tval.value / 10000)),
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
                            buildOverlayButton(
                                    onDecline, "Decline".tr, false, false)
                                .paddingOnly(right: 16.w),
                            buildOverlayButton(() {
                              _rideController.places.value = detailsMap;
                              _rideController.cashToCollect = cashAlloted;
                              isRideStarted.value = true;
                              Navigator.pop(context);
                              Get.to(() => MapView());
                            }, "Accept".tr, true, true),
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

  void uploadImage(String filePath, BuildContext context) async {
    OverlayLoader.instance().showOverlay(
      title: "Upload Started".tr,
      context: context,
      text: "Please wait while we upload your profile picture.".tr,
    );

    Reference ref = storage.ref().child('images/${DateTime.now().toString()}');
    UploadTask task = ref.putFile(File(filePath));
    TaskSnapshot snap = await task;
    String url = await snap.ref.getDownloadURL();
    databaseInstance
        .collection("drivers")
        .doc(auth.currentUser!.phoneNumber.toString())
        .update({"imageUrl": url})
        .then((value) => {
              OverlayLoader.instance().showOverlay(
                  title: "Upload Completed".tr,
                  context: context,
                  text: "Successfully updated profile picture".tr,
                  isSuccess: true),
              LoadingScreen.instance().hide(),
              Navigator.pop(context)
            })
        .then((value) => {getData()});
  }

  pickImage(ImageSource source, BuildContext context) async {
    final ImagePicker imgpck = ImagePicker();
    XFile? file = await imgpck.pickImage(source: source);
    if (file != null) {
      uploadImage(file.path, context);
    } else {
      OverlayLoader.instance().showOverlay(
          title: "Error".tr,
          context: context,
          text: "Please select an image!".tr,
          isSuccess: false,
          isError: true);
    }
  }

  void removeProfilePicture(BuildContext context) {
    databaseInstance
        .collection("drivers")
        .doc(auth.currentUser!.phoneNumber.toString())
        .update({"imageUrl": ""})
        .then((value) => Navigator.pop(context))
        .then((value) => {
              OverlayLoader.instance().showOverlay(
                  title: "Success".tr,
                  context: context,
                  text: "Profile photo removed!".tr,
                  isSuccess: true),
              getData()
            });
  }

  Future<bool> isVehiclePresent(String numberPlate) async {
    try {
      final data = await databaseInstance
          .collection("drivers")
          .doc(auth.currentUser!.phoneNumber.toString())
          .collection("vehicles")
          .where("regCertificate", isEqualTo: numberPlate)
          .limit(1)
          .get();

      return data.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> addVehicle(
      Map<String, String> data, BuildContext context) async {
    try {
      await databaseInstance
          .collection("drivers")
          .doc(auth.currentUser!.phoneNumber.toString())
          .collection("vehicles")
          .add(data);
      await databaseInstance.collection("registeredNumberPlates").add(data);
      onRefresh();
      OverlayLoader.instance().showOverlay(
          title: "Success!".tr,
          context: context,
          text: "Added Vehicle Successfully!".tr,
          isSuccess: true,
          isError: false);
    } on Exception {
      OverlayLoader.instance().showOverlay(
          title: "Error!".tr,
          context: context,
          text: "Cannot add vehicle".tr,
          isSuccess: false,
          isError: true);
    }
  }

  // Start listening for new orders
  void startListeningForOrders(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    _orderSubscription =
        firestore.collection('orders').snapshots().listen((snapshot) async {
      try {
        // Get the current location
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        double currentLat = position.latitude;
        double currentLon = position.longitude;

        double radius = 100.0;
        List<Map<String, dynamic>> nearbyOrders = [];

        for (var doc in snapshot.docs) {
          if (OrderTracker.seenOrders.contains(doc.id)) {
            continue; // Skip orders that have already been seen
          }

          GeoPoint location = doc['location']; // Accessing the GeoPoint
          double orderLat = location.latitude;
          double orderLon = location.longitude;
          double distance = Geolocator.distanceBetween(
              currentLat, currentLon, orderLat, orderLon);

          if (distance <= radius * 1000) {
            // Convert radius to meters
            nearbyOrders.add({
              'id': doc.id,
              'latitude': orderLat,
              'longitude': orderLon,
              'orderDetails': doc['orderDetails'],
              'cashAlloted': doc['cashAlloted'],
              'distance': doc['distance'],
            });
          }
        }
        if (nearbyOrders.isEmpty) {
          print('No new orders within 10 km radius');
        } else {
          for (var i = 0; i < nearbyOrders.length; i++) {
            var order = nearbyOrders[i];

            OverlayEntry overlayEntry = OverlayEntry(
              builder: (context) => RideOverlay(
                ls: order['orderDetails'],
                mins: 12.toDouble(),
                cashAlloted: order['cashAlloted'].toDouble(),
                distance: order['distance'].toDouble(),
              ),
            );
            Overlay.of(context)!.insert(overlayEntry);
            // xwxx

            OrderTracker.seenOrders.add(order['id']);
          }
        }
      } catch (e) {
        print('Error: $e');
      }
    });
  }

  // Stop listening to new orders
  void stopListeningForOrders() {
    _orderSubscription?.cancel();
    print('Stopped listening to Firestore orders.');
  }
}

class OrderTracker {
  static Set<String> seenOrders =
      {}; // A set to keep track of seen orders locally
}
