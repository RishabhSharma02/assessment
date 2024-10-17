import 'dart:convert';

import 'package:bhaada/sections/homescreen/controllers/home_screen_controller.dart';
import 'package:bhaada/sections/homescreen/views/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../common widgets/common_widgets.dart';
import '../../homescreen/views/nav_screen.dart';
class RideController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  final databaseInstance = FirebaseFirestore.instance;
  late Position currentPosition;
  double cashToCollect=0.0;
  RxList<dynamic> places = [].obs;
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
  Future<String> getETA(GeoPoint destination) async {
    currentPosition = await getCurrentPosition();
    double startLat = currentPosition.latitude;
    double startLng = currentPosition.longitude;
    const apiKey = 'AIzaSyA5IWnkQKUXaz_7vecOut8VVaXewrkw50A'; // Replace with your actual API key
    final response = await http.get(
        Uri.parse('https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=${destination.latitude},${destination.longitude}&key=$apiKey')
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var eta = data['routes'][0]['legs'][0]['duration']['text'];
      return eta;
    } else {
      return "--";
    }
  }

  Future<double> calculateDistance(GeoPoint destination) async {
    Position currentPosition = await getCurrentPosition();
    double startLat = currentPosition.latitude;
    double startLng = currentPosition.longitude;

    return Geolocator.distanceBetween(
        startLat, startLng,
        destination.latitude, destination.longitude
    );
  }
  Future<void> openMap(GeoPoint destination, BuildContext context) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${destination.latitude},${destination.longitude}';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
     // isRideStarted.value = true;
      await launchUrl(Uri.parse(googleUrl));
    } else {
      OverlayLoader.instance().showOverlay(
          title: "Error".tr,
          context: context,
          text: "Unable to open Google Maps".tr,
          isError: true);
      throw 'Could not open the map.';
    }
  }
  void updateFirstDocumentValue(double amount,BuildContext context) async {
    FirebaseFirestore databaseInstance = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String phoneNumber = auth.currentUser?.phoneNumber ?? '';
    DocumentReference<Map<String, dynamic>> collectionRefWallet = databaseInstance
        .collection("drivers")
        .doc(phoneNumber);

    CollectionReference collectionRef = databaseInstance
        .collection("drivers")
        .doc(phoneNumber)
        .collection("today");
    try {
      databaseInstance.collection("drivers").doc(phoneNumber).collection("orders").add({
        "locationData":places,
        "fare":amount,
        "modeOfPayment":"cash",
        "timeOfUpload":DateTime.now()
      });
      databaseInstance.collection("drivers").doc(phoneNumber).collection("transactions").add({
        "fare":amount,
        "modeOfPayment":"cash",
        "type":"incoming",
        "timeOfUpload":DateTime.now()
      });
      collectionRefWallet.get().then((data){
        if(data.exists){
          var value=data.get("cashInHand");
          collectionRefWallet.update({"cashInHand":value+amount});
        }
      });
      QuerySnapshot querySnapshot = await collectionRef.limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        String docId = docSnapshot.id;
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        double earnings= data['earnings'].toDouble() ?? 0;
        int orders=data['orders'] ?? 0;
        int tasksDone=data['tasksDone'] ?? 0;
        int trip=data['trips'] ?? 0;

        DocumentReference docRef = collectionRef.doc(docId);

        await docRef.update({
          'earnings': earnings + amount,
          'orders':orders+1,
          'tasksDone':tasksDone+1,
          'trips':trip+1,
        }).then((val){
          homeScreenController.isOnline.value=true;
          homeScreenController.getData();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){

            return NavScreen();
          }));

        });
      } else {
        print('No documents found in the collection');
      }
    } catch (e) {

    }
  }
}