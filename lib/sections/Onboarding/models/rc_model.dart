// // To parse this JSON data, do
// //
// //     final rcResponseModel = rcResponseModelFromJson(jsonString);
//
// import 'dart:convert';
//
// RcResponseModel rcResponseModelFromJson(String str) => RcResponseModel.fromJson(json.decode(str));
//
// String rcResponseModelToJson(RcResponseModel data) => json.encode(data.toJson());
//
// class RcResponseModel {
//   Status status;
//   Response response;
//
//   RcResponseModel({
//     required this.status,
//     required this.response,
//   });
//
//   factory RcResponseModel.fromJson(Map<String, dynamic> json) => RcResponseModel(
//     status: Status.fromJson(json["status"]),
//     response: Response.fromJson(json["response"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status.toJson(),
//     "response": response.toJson(),
//   };
// }
//
// class Response {
//   int code;
//   String owner;
//   String ownerNumber;
//   String ownerFathersName;
//   String presentAddress;
//   String permanentAddress;
//   RegistrationDetail registrationDetail;
//   HypotecationDetail hypotecationDetail;
//   Vehicle vehicle;
//   Insurance insurance;
//   Pucc pucc;
//   String isCommercial;
//   dynamic permitDetails;
//   dynamic nonUseDetails;
//   String serviceCode;
//
//   Response({
//     required this.code,
//     required this.owner,
//     required this.ownerNumber,
//     required this.ownerFathersName,
//     required this.presentAddress,
//     required this.permanentAddress,
//     required this.registrationDetail,
//     required this.hypotecationDetail,
//     required this.vehicle,
//     required this.insurance,
//     required this.pucc,
//     required this.isCommercial,
//     required this.permitDetails,
//     required this.nonUseDetails,
//     required this.serviceCode,
//   });
//
//   factory Response.fromJson(Map<String, dynamic> json) => Response(
//     code: json["code"],
//     owner: json["owner"],
//     ownerNumber: json["ownerNumber"],
//     ownerFathersName: json["ownerFathersName"],
//     presentAddress: json["presentAddress"],
//     permanentAddress: json["permanentAddress"],
//     registrationDetail: RegistrationDetail.fromJson(json["registrationDetail"]),
//     hypotecationDetail: HypotecationDetail.fromJson(json["hypotecationDetail"]),
//     vehicle: Vehicle.fromJson(json["vehicle"]),
//     insurance: Insurance.fromJson(json["insurance"]),
//     pucc: Pucc.fromJson(json["pucc"]),
//     isCommercial: json["isCommercial"],
//     permitDetails: json["permitDetails"],
//     nonUseDetails: json["nonUseDetails"],
//     serviceCode: json["serviceCode"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "code": code,
//     "owner": owner,
//     "ownerNumber": ownerNumber,
//     "ownerFathersName": ownerFathersName,
//     "presentAddress": presentAddress,
//     "permanentAddress": permanentAddress,
//     "registrationDetail": registrationDetail.toJson(),
//     "hypotecationDetail": hypotecationDetail.toJson(),
//     "vehicle": vehicle.toJson(),
//     "insurance": insurance.toJson(),
//     "pucc": pucc.toJson(),
//     "isCommercial": isCommercial,
//     "permitDetails": permitDetails,
//     "nonUseDetails": nonUseDetails,
//     "serviceCode": serviceCode,
//   };
// }
//
// class HypotecationDetail {
//   bool isFinanced;
//   String financier;
//
//   HypotecationDetail({
//     required this.isFinanced,
//     required this.financier,
//   });
//
//   factory HypotecationDetail.fromJson(Map<String, dynamic> json) => HypotecationDetail(
//     isFinanced: json["isFinanced"],
//     financier: json["financier"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "isFinanced": isFinanced,
//     "financier": financier,
//   };
// }
//
// class Insurance {
//   String policyNumber;
//   String company;
//   String validTill;
//
//   Insurance({
//     required this.policyNumber,
//     required this.company,
//     required this.validTill,
//   });
//
//   factory Insurance.fromJson(Map<String, dynamic> json) => Insurance(
//     policyNumber: json["policyNumber"],
//     company: json["company"],
//     validTill: json["validTill"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "policyNumber": policyNumber,
//     "company": company,
//     "validTill": validTill,
//   };
// }
//
// class Pucc {
//   String number;
//   String upto;
//
//   Pucc({
//     required this.number,
//     required this.upto,
//   });
//
//   factory Pucc.fromJson(Map<String, dynamic> json) => Pucc(
//     number: json["number"],
//     upto: json["upto"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "number": number,
//     "upto": upto,
//   };
// }
//
// class RegistrationDetail {
//   dynamic blacklistStatus;
//   dynamic blacklistDetails;
//   String rcStatusAsOn;
//   String rcStatus;
//   String authority;
//   String date;
//   String expiryDate;
//   String number;
//   dynamic nocDetails;
//   String taxUpto;
//   String rtoCode;
//
//   RegistrationDetail({
//     required this.blacklistStatus,
//     required this.blacklistDetails,
//     required this.rcStatusAsOn,
//     required this.rcStatus,
//     required this.authority,
//     required this.date,
//     required this.expiryDate,
//     required this.number,
//     required this.nocDetails,
//     required this.taxUpto,
//     required this.rtoCode,
//   });
//
//   factory RegistrationDetail.fromJson(Map<String, dynamic> json) => RegistrationDetail(
//     blacklistStatus: json["blacklistStatus"],
//     blacklistDetails: json["blacklistDetails"],
//     rcStatusAsOn: json["rcStatusAsOn"],
//     rcStatus: json["rcStatus"],
//     authority: json["authority"],
//     date: json["date"],
//     expiryDate: json["expiryDate"],
//     number: json["number"],
//     nocDetails: json["nocDetails"],
//     taxUpto: json["taxUpto"],
//     rtoCode: json["RTOCode"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "blacklistStatus": blacklistStatus,
//     "blacklistDetails": blacklistDetails,
//     "rcStatusAsOn": rcStatusAsOn,
//     "rcStatus": rcStatus,
//     "authority": authority,
//     "date": date,
//     "expiryDate": expiryDate,
//     "number": number,
//     "nocDetails": nocDetails,
//     "taxUpto": taxUpto,
//     "RTOCode": rtoCode,
//   };
// }
//
// class Vehicle {
//   String number;
//   String fuelType;
//   String bodyType;
//   String normsDesc;
//   String vehicleMmv;
//   String companyName;
//   String modelName;
//   String category;
//   String color;
//   String chassis;
//   String engine;
//   String manufacturingDate;
//   String cubicCapacity;
//   String grossWeight;
//   String unladenWeight;
//   String noCyl;
//   String seatCap;
//   String rcStandardCap;
//   dynamic sleeperCapacity;
//   String standingCap;
//   String wheelBase;
//   String vehicleClass;
//
//   Vehicle({
//     required this.number,
//     required this.fuelType,
//     required this.bodyType,
//     required this.normsDesc,
//     required this.vehicleMmv,
//     required this.companyName,
//     required this.modelName,
//     required this.category,
//     required this.color,
//     required this.chassis,
//     required this.engine,
//     required this.manufacturingDate,
//     required this.cubicCapacity,
//     required this.grossWeight,
//     required this.unladenWeight,
//     required this.noCyl,
//     required this.seatCap,
//     required this.rcStandardCap,
//     required this.sleeperCapacity,
//     required this.standingCap,
//     required this.wheelBase,
//     required this.vehicleClass,
//   });
//
//   factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
//     number: json["number"],
//     fuelType: json["fuelType"],
//     bodyType: json["bodyType"],
//     normsDesc: json["normsDesc"],
//     vehicleMmv: json["vehicleMMV"],
//     companyName: json["companyName"],
//     modelName: json["modelName"],
//     category: json["category"],
//     color: json["color"],
//     chassis: json["chassis"],
//     engine: json["engine"],
//     manufacturingDate: json["manufacturingDate"],
//     cubicCapacity: json["cubicCapacity"],
//     grossWeight: json["grossWeight"],
//     unladenWeight: json["unladenWeight"],
//     noCyl: json["noCyl"],
//     seatCap: json["seatCap"],
//     rcStandardCap: json["rcStandardCap"],
//     sleeperCapacity: json["sleeperCapacity"],
//     standingCap: json["standingCap"],
//     wheelBase: json["wheelBase"],
//     vehicleClass: json["class"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "number": number,
//     "fuelType": fuelType,
//     "bodyType": bodyType,
//     "normsDesc": normsDesc,
//     "vehicleMMV": vehicleMmv,
//     "companyName": companyName,
//     "modelName": modelName,
//     "category": category,
//     "color": color,
//     "chassis": chassis,
//     "engine": engine,
//     "manufacturingDate": manufacturingDate,
//     "cubicCapacity": cubicCapacity,
//     "grossWeight": grossWeight,
//     "unladenWeight": unladenWeight,
//     "noCyl": noCyl,
//     "seatCap": seatCap,
//     "rcStandardCap": rcStandardCap,
//     "sleeperCapacity": sleeperCapacity,
//     "standingCap": standingCap,
//     "wheelBase": wheelBase,
//     "class": vehicleClass,
//   };
// }
//
// class Status {
//   int statusCode;
//   String statusMessage;
//   String transactionId;
//   String checkId;
//   String groupId;
//   Input input;
//   DateTime timestamp;
//
//   Status({
//     required this.statusCode,
//     required this.statusMessage,
//     required this.transactionId,
//     required this.checkId,
//     required this.groupId,
//     required this.input,
//     required this.timestamp,
//   });
//
//   factory Status.fromJson(Map<String, dynamic> json) => Status(
//     statusCode: json["statusCode"],
//     statusMessage: json["statusMessage"],
//     transactionId: json["transactionId"],
//     checkId: json["checkId"],
//     groupId: json["groupId"],
//     input: Input.fromJson(json["input"]),
//     timestamp: DateTime.parse(json["timestamp"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "statusCode": statusCode,
//     "statusMessage": statusMessage,
//     "transactionId": transactionId,
//     "checkId": checkId,
//     "groupId": groupId,
//     "input": input.toJson(),
//     "timestamp": timestamp.toIso8601String(),
//   };
// }
//
// class Input {
//   String vehicleNumber;
//
//   Input({
//     required this.vehicleNumber,
//   });
//
//   factory Input.fromJson(Map<String, dynamic> json) => Input(
//     vehicleNumber: json["vehicleNumber"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "vehicleNumber": vehicleNumber,
//   };
// }
