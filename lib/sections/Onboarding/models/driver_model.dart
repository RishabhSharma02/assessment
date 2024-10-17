import 'package:bhaada/sections/Onboarding/models/vehicle_model.dart';

class DriverModel {
  String driverName;
  String driverPhone;
  String gender;
  String? driverWhatsAppPhone;
  String driverDob;
  List<Vehicle> vehicles;
  bool isVerified;
  String imageUrl;
  String email;
  DriverModel(
      {required this.driverName,
        required this.driverPhone,
        required this.gender,
        required this.email,
        this.driverWhatsAppPhone,
        required this.driverDob,
        required this.vehicles,
        required this.isVerified,
        required this.imageUrl});
}


