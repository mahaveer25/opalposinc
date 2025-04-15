class PaidProductModel {
  String? requestID;
  String? locationID;
  String? terminalID;
  String? approvedAmount;
  String? authCode;
  String? avsMessage;
  String? cardType;
  String? cardHolderName;
  String? cashBackAmt;
  String? entryMode;
  String? expirationDate;
  ExtData? extData;
  String? gatewayMessage;
  String? gatewayResult;
  String? hostCode;
  String? hostResponse;
  String? invNum;
  String? maskedAccountNumber;
  String? message;
  String? pnRefNum;
  String? rawResponse;
  String? refNum;
  String? remainingAmount;
  String? requestedAmount;
  String? resultCode;
  String? resultTxt;
  String? submittedAmount;
  String? timestamp;
  String? tipAmount;
  String? token;
  String? transactionCode;

  PaidProductModel({
    this.requestID,
    this.locationID,
    this.terminalID,
    this.approvedAmount,
    this.authCode,
    this.avsMessage,
    this.cardType,
    this.cardHolderName,
    this.cashBackAmt,
    this.entryMode,
    this.expirationDate,
    this.extData,
    this.gatewayMessage,
    this.gatewayResult,
    this.hostCode,
    this.hostResponse,
    this.invNum,
    this.maskedAccountNumber,
    this.message,
    this.pnRefNum,
    this.rawResponse,
    this.refNum,
    this.remainingAmount,
    this.requestedAmount,
    this.resultCode,
    this.resultTxt,
    this.submittedAmount,
    this.timestamp,
    this.tipAmount,
    this.token,
    this.transactionCode,
  });

  PaidProductModel.fromJson(Map<String, dynamic> json) {
    requestID = json['requestID'];
    locationID = json['locationID'];
    terminalID = json['terminalID'];
    approvedAmount = json['approvedAmount'];
    authCode = json['authCode'];
    avsMessage = json['avsMessage'];
    cardType = json['cardType'];
    cardHolderName = json['cardHolderName'];
    cashBackAmt = json['cashBackAmt'];
    entryMode = json['entryMode'];
    expirationDate = json['expirationDate'];
    extData = json['extData'] != null ? ExtData.fromJson(json['extData']) : null;
    gatewayMessage = json['gatewayMessage'];
    gatewayResult = json['gatewayResult'];
    hostCode = json['hostCode'];
    hostResponse = json['hostResponse'];
    invNum = json['invNum'];
    maskedAccountNumber = json['maskedAccountNumber'];
    message = json['message'];
    pnRefNum = json['pnRefNum'];
    rawResponse = json['rawResponse'];
    refNum = json['refNum'];
    remainingAmount = json['remainingAmount'];
    requestedAmount = json['requestedAmount'];
    resultCode = json['resultCode'];
    resultTxt = json['resultTxt'];
    submittedAmount = json['submittedAmount'];
    timestamp = json['timestamp'];
    tipAmount = json['tipAmount'];
    token = json['token'];
    transactionCode = json['transactionCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestID'] = requestID;
    data['locationID'] = locationID;
    data['terminalID'] = terminalID;
    data['approvedAmount'] = approvedAmount;
    data['authCode'] = authCode;
    data['avsMessage'] = avsMessage;
    data['cardType'] = cardType;
    data['cardHolderName'] = cardHolderName;
    data['cashBackAmt'] = cashBackAmt;
    data['entryMode'] = entryMode;
    data['expirationDate'] = expirationDate;
    if (extData != null) {
      data['extData'] = extData!.toJson();
    }
    data['gatewayMessage'] = gatewayMessage;
    data['gatewayResult'] = gatewayResult;
    data['hostCode'] = hostCode;
    data['hostResponse'] = hostResponse;
    data['invNum'] = invNum;
    data['maskedAccountNumber'] = maskedAccountNumber;
    data['message'] = message;
    data['pnRefNum'] = pnRefNum;
    data['rawResponse'] = rawResponse;
    data['refNum'] = refNum;
    data['remainingAmount'] = remainingAmount;
    data['requestedAmount'] = requestedAmount;
    data['resultCode'] = resultCode;
    data['resultTxt'] = resultTxt;
    data['submittedAmount'] = submittedAmount;
    data['timestamp'] = timestamp;
    data['tipAmount'] = tipAmount;
    data['token'] = token;
    data['transactionCode'] = transactionCode;
    return data;
  }
}

class ExtData {
  ReceiptTagData? receiptTagData;

  ExtData({this.receiptTagData});

  ExtData.fromJson(Map<String, dynamic> json) {
    receiptTagData = json['receiptTagData'] != null
        ? ReceiptTagData.fromJson(json['receiptTagData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (receiptTagData != null) {
      data['receiptTagData'] = receiptTagData!.toJson();
    }
    return data;
  }
}

class ReceiptTagData {
  String? maskedCard;
  String? chipCardAID;
  String? atc;
  String? invoice;
  String? authCode;
  String? entryMethod;
  String? totalAmount;
  String? appLabel;

  ReceiptTagData({
    this.maskedCard,
    this.chipCardAID,
    this.atc,
    this.invoice,
    this.authCode,
    this.entryMethod,
    this.totalAmount,
    this.appLabel,
  });

  ReceiptTagData.fromJson(Map<String, dynamic> json) {
    maskedCard = json['maskedCard'];
    chipCardAID = json['chipCardAID'];
    atc = json['atc'];
    invoice = json['invoice'];
    authCode = json['authCode'];
    entryMethod = json['entryMethod'];
    totalAmount = json['totalAmount'];
    appLabel = json['appLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maskedCard'] = maskedCard;
    data['chipCardAID'] = chipCardAID;
    data['atc'] = atc;
    data['invoice'] = invoice;
    data['authCode'] = authCode;
    data['entryMethod'] = entryMethod;
    data['totalAmount'] = totalAmount;
    data['appLabel'] = appLabel;
    return data;
  }
}
