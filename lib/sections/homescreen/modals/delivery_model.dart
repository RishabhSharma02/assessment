// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';
//
// void subscribeToDatabaseChanges(BuildContext context) {
//   GeoFirePoint center = geo.point(
//       latitude: _currentPosition!.latitude,
//       longitude: _currentPosition!.longitude);
//   var collectionReference = databaseInstance.collection('locations');
//
//   double radius = 10;
//   String field = 'position';
//
//   Stream<List<DocumentSnapshot>> stream = geo
//       .collection(collectionRef: collectionReference)
//       .within(center: center, radius: radius, field: field);
//
//   stream.listen((List<DocumentSnapshot> documentList) {
//     for (var doc in documentList) {
//       try {
//         DeliveryModel deliveryModel = DeliveryModel.fromFirestore(doc);
//         print(deliveryModel.deliveryLocations);
//       } catch (e) {
//         print('Error decoding deliveryLocations: $e');
//       }
//     }
//   });
// }
//
// class DeliveryModel {
//   List<DeliveryLocation> deliveryLocations;
//   String orderId;
//   bool isAccepted;
//   double cashAlloted;
//   double totalDistance;
//
//   DeliveryModel({
//     required this.deliveryLocations,
//     required this.orderId,
//     required this.isAccepted,
//     required this.cashAlloted,
//     required this.totalDistance,
//   });
//
//   factory DeliveryModel.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return DeliveryModel(
//       deliveryLocations: (data['deliveryLocations'] as List)
//           .map((item) => DeliveryLocation.fromMap(item))
//           .toList(),
//       orderId: data['orderId'],
//       isAccepted: data['isAccepted'],
//       cashAlloted: data['cashAlloted'],
//       totalDistance: data['totalDistance'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'deliveryLocations': deliveryLocations.map((e) => e.toMap()).toList(),
//       'orderId': orderId,
//       'isAccepted': isAccepted,
//       'cashAlloted': cashAlloted,
//       'totalDistance': totalDistance,
//     };
//   }
// }
//
// class DeliveryLocation {
//   Location endPoint;
//   Location startPoint;
//   String name;
//   DeliveryPosition position;
//
//   DeliveryLocation({
//     required this.endPoint,
//     required this.startPoint,
//     required this.name,
//     required this.position,
//   });
//
//   factory DeliveryLocation.fromMap(Map<String, dynamic> data) {
//     return DeliveryLocation(
//       endPoint: Location.fromMap(data['endPoint']),
//       startPoint: Location.fromMap(data['startPoint']),
//       name: data['name'],
//       position: DeliveryPosition.fromMap(data['position']),
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'endPoint': endPoint.toMap(),
//       'startPoint': startPoint.toMap(),
//       'name': name,
//       'position': position.toMap(),
//     };
//   }
// }
//
// class Location {
//   GeoPoint location;
//   String phoneNumber;
//
//   Location({
//     required this.location,
//     required this.phoneNumber,
//   });
//
//   factory Location.fromMap(Map<String, dynamic> data) {
//     return Location(
//       location: data['location'],
//       phoneNumber: data['phoneNumber'] ?? data['phoneNo'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'location': location,
//       'phoneNumber': phoneNumber,
//     };
//   }
// }
//
// class DeliveryPosition {
//   String geohash;
//   GeoPoint geopoint;
//
//   DeliveryPosition({
//     required this.geohash,
//     required this.geopoint,
//   });
//
//   factory DeliveryPosition.fromMap(Map<String, dynamic> data) {
//     return DeliveryPosition(
//       geohash: data['geohash'],
//       geopoint: data['geopoint'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'geohash': geohash,
//       'geopoint': geopoint,
//     };
//   }
// }
