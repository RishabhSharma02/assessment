class DlResponseModel {
  Status? status;
  Response? response;

  DlResponseModel({this.status, this.response});

  DlResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? timestamp;

  Status(
      {this.statusCode,
        this.statusMessage,
        this.transactionId,
        this.checkId,
        this.groupId,
        this.timestamp});

  Status.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    statusMessage = json['statusMessage'];
    transactionId = json['transactionId'];
    checkId = json['checkId'];
    groupId = json['groupId'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['statusMessage'] = this.statusMessage;
    data['transactionId'] = this.transactionId;
    data['checkId'] = this.checkId;
    data['groupId'] = this.groupId;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Response {
  int? code;
  Validity? validity;
  Details? details;

  Response({this.code, this.validity, this.details});

  Response.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    validity = json['validity'] != null
        ? new Validity.fromJson(json['validity'])
        : null;
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.validity != null) {
      data['validity'] = this.validity!.toJson();
    }
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class Validity {
  NonTransport? nonTransport;
  NonTransport? transport;

  Validity({this.nonTransport, this.transport});

  Validity.fromJson(Map<String, dynamic> json) {
    nonTransport = json['Non-Transport'] != null
        ? new NonTransport.fromJson(json['Non-Transport'])
        : null;
    transport = json['Transport'] != null
        ? new NonTransport.fromJson(json['Transport'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.nonTransport != null) {
      data['Non-Transport'] = this.nonTransport!.toJson();
    }
    if (this.transport != null) {
      data['Transport'] = this.transport!.toJson();
    }
    return data;
  }
}

class NonTransport {
  String? from;
  String? to;

  NonTransport({this.from, this.to});

  NonTransport.fromJson(Map<String, dynamic> json) {
    from = json['From'];
    to = json['To'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['From'] = this.from;
    data['To'] = this.to;
    return data;
  }
}

class Details {
  String? status;
  String? name;
  List<CovDetails>? covDetails;

  Details({this.status, this.name, this.covDetails});

  Details.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    name = json['name'];
    if (json['covDetails'] != null) {
      covDetails = <CovDetails>[];
      json['covDetails'].forEach((v) {
        covDetails!.add(new CovDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['name'] = this.name;
    if (this.covDetails != null) {
      data['covDetails'] = this.covDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CovDetails {
  String? cOVCategory;
  String? cOVIssueDate;
  String? classOfVehicle;

  CovDetails({this.cOVCategory, this.cOVIssueDate, this.classOfVehicle});

  CovDetails.fromJson(Map<String, dynamic> json) {
    cOVCategory = json['COV Category'];
    cOVIssueDate = json['COV Issue Date'];
    classOfVehicle = json['Class Of Vehicle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['COV Category'] = this.cOVCategory;
    data['COV Issue Date'] = this.cOVIssueDate;
    data['Class Of Vehicle'] = this.classOfVehicle;
    return data;
  }
}
