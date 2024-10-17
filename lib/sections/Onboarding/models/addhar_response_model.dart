class AadharResponseModel {
  Status? status;
  Response? response;

  AadharResponseModel({this.status, this.response});

  AadharResponseModel.fromJson(Map<String, dynamic> json) {
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
  Input? input;
  String? timestamp;

  Status(
      {this.statusCode,
        this.statusMessage,
        this.transactionId,
        this.input,
        this.timestamp});

  Status.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    transactionId = json['transactionId'];
    input = json['input'] != null ? new Input.fromJson(json['input']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['statusMessage'] = this.statusMessage;
    data['transactionId'] = this.transactionId;
    if (this.input != null) {
      data['input'] = this.input!.toJson();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Input {
  String? aadhaarNo;
  String? task;

  Input({this.aadhaarNo, this.task});

  Input.fromJson(Map<String, dynamic> json) {
    aadhaarNo = json['aadhaarNo'];
    task = json['task'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aadhaarNo'] = this.aadhaarNo;
    data['task'] = this.task;
    return data;
  }
}

class Response {
  String? maskedAadhaarNumber;
  String? name;
  String? dob;
  String? gender;
  String? fatherName;
  String? careOf;
  String? address;
  SplitAddress? splitAddress;
  String? pincode;
  String? shareCode;
  String? generatedDateTime;
  String? image;
  String? file;
  String? fileXML;

  Response(
      {this.maskedAadhaarNumber,
        this.name,
        this.dob,
        this.gender,
        this.fatherName,
        this.careOf,
        this.address,
        this.splitAddress,
        this.pincode,
        this.shareCode,
        this.generatedDateTime,
        this.image,
        this.file,
        this.fileXML});

  Response.fromJson(Map<String, dynamic> json) {
    maskedAadhaarNumber = json['maskedAadhaarNumber'];
    name = json['name'];
    dob = json['dob'];
    gender = json['gender'];
    fatherName = json['fatherName'];
    careOf = json['careOf'];
    address = json['address'];
    splitAddress = json['splitAddress'] != null
        ? new SplitAddress.fromJson(json['splitAddress'])
        : null;
    pincode = json['pincode'];
    shareCode = json['shareCode'];
    generatedDateTime = json['generatedDateTime'];
    image = json['image'];
    file = json['file'];
    fileXML = json['fileXML'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maskedAadhaarNumber'] = this.maskedAadhaarNumber;
    data['name'] = this.name;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['fatherName'] = this.fatherName;
    data['careOf'] = this.careOf;
    data['address'] = this.address;
    if (this.splitAddress != null) {
      data['splitAddress'] = this.splitAddress!.toJson();
    }
    data['pincode'] = this.pincode;
    data['shareCode'] = this.shareCode;
    data['generatedDateTime'] = this.generatedDateTime;
    data['image'] = this.image;
    data['file'] = this.file;
    data['fileXML'] = this.fileXML;
    return data;
  }
}

class SplitAddress {
  String? country;
  String? dist;
  String? state;
  String? po;
  String? loc;
  String? vtc;
  String? subdist;
  String? street;
  String? house;
  String? landmark;

  SplitAddress(
      {this.country,
        this.dist,
        this.state,
        this.po,
        this.loc,
        this.vtc,
        this.subdist,
        this.street,
        this.house,
        this.landmark});

  SplitAddress.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    dist = json['dist'];
    state = json['state'];
    po = json['po'];
    loc = json['loc'];
    vtc = json['vtc'];
    subdist = json['subdist'];
    street = json['street'];
    house = json['house'];
    landmark = json['landmark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['dist'] = this.dist;
    data['state'] = this.state;
    data['po'] = this.po;
    data['loc'] = this.loc;
    data['vtc'] = this.vtc;
    data['subdist'] = this.subdist;
    data['street'] = this.street;
    data['house'] = this.house;
    data['landmark'] = this.landmark;
    return data;
  }
}
