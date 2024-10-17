class PanResponseModel {
  Status? status;
  Response? response;

  PanResponseModel({this.status, this.response});

  PanResponseModel.fromJson(Map<String, dynamic> json) {
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Status {
  int? statusCode;
  String? statusMessage;
  String? transactionId;
  String? checkId;
  String? groupId;
  Input? input;
  String? timestamp;

  Status(
      {this.statusCode,
        this.statusMessage,
        this.transactionId,
        this.checkId,
        this.groupId,
        this.input,
        this.timestamp});

  Status.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    transactionId = json['transactionId'];
    checkId = json['checkId'];
    groupId = json['groupId'];
    input = json['input'] != null ? new Input.fromJson(json['input']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['statusMessage'] = this.statusMessage;
    data['transactionId'] = this.transactionId;
    data['checkId'] = this.checkId;
    data['groupId'] = this.groupId;
    if (this.input != null) {
      data['input'] = this.input!.toJson();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Input {
  String? panNumber;

  Input({this.panNumber});

  Input.fromJson(Map<String, dynamic> json) {
    panNumber = json['panNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['panNumber'] = this.panNumber;
    return data;
  }
}

class Response {
  int? code;
  String? number;
  String? name;
  String? typeOfHolder;
  bool? isIndividual;
  bool? isValid;
  String? firstName;
  String? middleName;
  String? lastName;
  String? title;
  String? panStatusCode;
  String? panStatus;
  String? aadhaarSeedingStatus;
  String? aadhaarSeedingStatusCode;
  String? lastUpdatedOn;

  Response(
      {this.code,
        this.number,
        this.name,
        this.typeOfHolder,
        this.isIndividual,
        this.isValid,
        this.firstName,
        this.middleName,
        this.lastName,
        this.title,
        this.panStatusCode,
        this.panStatus,
        this.aadhaarSeedingStatus,
        this.aadhaarSeedingStatusCode,
        this.lastUpdatedOn});

  Response.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    number = json['number'];
    name = json['name'];
    typeOfHolder = json['typeOfHolder'];
    isIndividual = json['isIndividual'];
    isValid = json['isValid'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    title = json['title'];
    panStatusCode = json['panStatusCode'];
    panStatus = json['panStatus'];
    aadhaarSeedingStatus = json['aadhaarSeedingStatus'];
    aadhaarSeedingStatusCode = json['aadhaarSeedingStatusCode'];
    lastUpdatedOn = json['lastUpdatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['number'] = this.number;
    data['name'] = this.name;
    data['typeOfHolder'] = this.typeOfHolder;
    data['isIndividual'] = this.isIndividual;
    data['isValid'] = this.isValid;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['title'] = this.title;
    data['panStatusCode'] = this.panStatusCode;
    data['panStatus'] = this.panStatus;
    data['aadhaarSeedingStatus'] = this.aadhaarSeedingStatus;
    data['aadhaarSeedingStatusCode'] = this.aadhaarSeedingStatusCode;
    data['lastUpdatedOn'] = this.lastUpdatedOn;
    return data;
  }
}
