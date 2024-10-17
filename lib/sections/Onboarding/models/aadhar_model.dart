class AadharModel {
  Status? status;
  Response? response;

  AadharModel({this.status, this.response});

  AadharModel.fromJson(Map<String, dynamic> json) {
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
  String? requestId;
  Result? result;
  int? statusCode;

  Response({this.requestId, this.result, this.statusCode});

  Response.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class Result {
  String? message;

  Result({this.message});

  Result.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
