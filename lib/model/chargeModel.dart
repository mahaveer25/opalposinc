class ChargeModel {
  final int? success;
  final String? message;
  final String? transactionId;
  final Response? response;
  const ChargeModel(
      {this.success, this.message, this.transactionId, this.response});
  ChargeModel copyWith(
      {int? success,
      String? message,
      String? transactionId,
      Response? response}) {
    return ChargeModel(
        success: success ?? this.success,
        message: message ?? this.message,
        transactionId: transactionId ?? this.transactionId,
        response: response ?? this.response);
  }

  Map<String, Object?> toJson() {
    return {
      'success': success,
      'message': message,
      'transaction_id': transactionId,
      'response': response?.toJson()
    };
  }

  static ChargeModel fromJson(Map<String, Object?> json) {
    return ChargeModel(
        success: json['success'] == null ? null : json['success'] as int,
        message: json['message'] == null ? null : json['message'] as String,
        transactionId: json['transaction_id'] == null
            ? null
            : json['transaction_id'] as String,
        response: json['response'] == null
            ? null
            : Response.fromJson(json['response'] as Map<String, Object?>));
  }

  @override
  String toString() {
    return '''ChargeModel(
                success:$success,
message:$message,
transactionId:$transactionId,
response:${response.toString()}
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is ChargeModel &&
        other.runtimeType == runtimeType &&
        other.success == success &&
        other.message == message &&
        other.transactionId == transactionId &&
        other.response == response;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, success, message, transactionId, response);
  }
}

class Response {
  final String? errorNo;
  final bool? successUrl;
  final String? errorCode;
  final String? amount;
  final String? tax;
  final String? customfee;
  final String? msg;
  final String? desc;
  final String? additionalInfo;
  final String? clerkId;
  final String? clerkName;
  final String? clerkLabel;
  final String? additionalKeyOne;
  final String? additionalKeyTwo;
  final String? additionalValueOne;
  final String? additionalValueTwo;
  final String? approvalCode;
  final String? rrn;
  final String? txnid;
  final int? tranNo;
  final int? stan;
  final int? isPartialApprove;
  final String? partialAmount;
  final String? pan;
  final String? cardType;
  final String? phoneNumber;
  final String? emailId;
  final String? zip;
  final String? cardHolderName;
  final String? expiryDate;
  final String? address;
  final String? epi;
  final String? channel;
  final String? token;
  final String? cardBrand;
  const Response(
      {this.errorNo,
      this.successUrl,
      this.errorCode,
      this.amount,
      this.tax,
      this.customfee,
      this.msg,
      this.desc,
      this.additionalInfo,
      this.clerkId,
      this.clerkName,
      this.clerkLabel,
      this.additionalKeyOne,
      this.additionalKeyTwo,
      this.additionalValueOne,
      this.additionalValueTwo,
      this.approvalCode,
      this.rrn,
      this.txnid,
      this.tranNo,
      this.stan,
      this.isPartialApprove,
      this.partialAmount,
      this.pan,
      this.cardType,
      this.phoneNumber,
      this.emailId,
      this.zip,
      this.cardHolderName,
      this.expiryDate,
      this.address,
      this.epi,
      this.channel,
      this.token,
      this.cardBrand});
  Response copyWith(
      {String? errorNo,
      bool? successUrl,
      String? errorCode,
      String? amount,
      String? tax,
      String? customfee,
      String? msg,
      String? desc,
      String? additionalInfo,
      String? clerkId,
      String? clerkName,
      String? clerkLabel,
      String? additionalKeyOne,
      String? additionalKeyTwo,
      String? additionalValueOne,
      String? additionalValueTwo,
      String? approvalCode,
      String? rrn,
      String? txnid,
      int? tranNo,
      int? stan,
      int? isPartialApprove,
      String? partialAmount,
      String? pan,
      String? cardType,
      String? phoneNumber,
      String? emailId,
      String? zip,
      String? cardHolderName,
      String? expiryDate,
      String? address,
      String? epi,
      String? channel,
      String? token,
      String? cardBrand}) {
    return Response(
        errorNo: errorNo ?? this.errorNo,
        successUrl: successUrl ?? this.successUrl,
        errorCode: errorCode ?? this.errorCode,
        amount: amount ?? this.amount,
        tax: tax ?? this.tax,
        customfee: customfee ?? this.customfee,
        msg: msg ?? this.msg,
        desc: desc ?? this.desc,
        additionalInfo: additionalInfo ?? this.additionalInfo,
        clerkId: clerkId ?? this.clerkId,
        clerkName: clerkName ?? this.clerkName,
        clerkLabel: clerkLabel ?? this.clerkLabel,
        additionalKeyOne: additionalKeyOne ?? this.additionalKeyOne,
        additionalKeyTwo: additionalKeyTwo ?? this.additionalKeyTwo,
        additionalValueOne: additionalValueOne ?? this.additionalValueOne,
        additionalValueTwo: additionalValueTwo ?? this.additionalValueTwo,
        approvalCode: approvalCode ?? this.approvalCode,
        rrn: rrn ?? this.rrn,
        txnid: txnid ?? this.txnid,
        tranNo: tranNo ?? this.tranNo,
        stan: stan ?? this.stan,
        isPartialApprove: isPartialApprove ?? this.isPartialApprove,
        partialAmount: partialAmount ?? this.partialAmount,
        pan: pan ?? this.pan,
        cardType: cardType ?? this.cardType,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        emailId: emailId ?? this.emailId,
        zip: zip ?? this.zip,
        cardHolderName: cardHolderName ?? this.cardHolderName,
        expiryDate: expiryDate ?? this.expiryDate,
        address: address ?? this.address,
        epi: epi ?? this.epi,
        channel: channel ?? this.channel,
        token: token ?? this.token,
        cardBrand: cardBrand ?? this.cardBrand);
  }

  Map<String, Object?> toJson() {
    return {
      'error_no': errorNo,
      'success_url': successUrl,
      'error_code': errorCode,
      'amount': amount,
      'tax': tax,
      'customfee': customfee,
      'msg': msg,
      'desc': desc,
      'additional_info': additionalInfo,
      'clerk_id': clerkId,
      'clerk_name': clerkName,
      'clerk_label': clerkLabel,
      'additionalKeyOne': additionalKeyOne,
      'additionalKeyTwo': additionalKeyTwo,
      'additionalValueOne': additionalValueOne,
      'additionalValueTwo': additionalValueTwo,
      'approval_code': approvalCode,
      'rrn': rrn,
      'txnid': txnid,
      'tran_no': tranNo,
      'stan': stan,
      'is_partial_approve': isPartialApprove,
      'partial_amount': partialAmount,
      'pan': pan,
      'card_type': cardType,
      'phone_number': phoneNumber,
      'email_id': emailId,
      'zip': zip,
      'card_holder_name': cardHolderName,
      'expiry_date': expiryDate,
      'address': address,
      'epi': epi,
      'channel': channel,
      'token': token,
      'card_brand': cardBrand
    };
  }

  static Response fromJson(Map<String, Object?> json) {
    return Response(
        errorNo: json['error_no'] == null ? null : json['error_no'] as String,
        successUrl:
            json['success_url'] == null ? null : json['success_url'] as bool,
        errorCode:
            json['error_code'] == null ? null : json['error_code'] as String,
        amount: json['amount'] == null ? null : json['amount'] as String,
        tax: json['tax'] == null ? null : json['tax'] as String,
        customfee:
            json['customfee'] == null ? null : json['customfee'] as String,
        msg: json['msg'] == null ? null : json['msg'] as String,
        desc: json['desc'] == null ? null : json['desc'] as String,
        additionalInfo: json['additional_info'] as String?,
        clerkId: json['clerk_id'] as String?,
        clerkName: json['clerk_name'] as String?,
        clerkLabel: json['clerk_label'] as String?,
        additionalKeyOne: json['additionalKeyOne'] as String?,
        additionalKeyTwo: json['additionalKeyTwo'] as String?,
        additionalValueOne: json['additionalValueOne'] as String?,
        additionalValueTwo: json['additionalValueTwo'] as String?,
        approvalCode: json['approval_code'] == null
            ? null
            : json['approval_code'] as String,
        rrn: json['rrn'] == null ? null : json['rrn'] as String,
        txnid: json['txnid'] == null ? null : json['txnid'] as String,
        tranNo: json['tran_no'] == null ? null : json['tran_no'] as int,
        stan: json['stan'] == null ? null : json['stan'] as int,
        isPartialApprove: json['is_partial_approve'] == null
            ? null
            : json['is_partial_approve'] as int,
        partialAmount: json['partial_amount'] == null
            ? null
            : json['partial_amount'] as String,
        pan: json['pan'] == null ? null : json['pan'] as String,
        cardType: json['card_type'] as String?,
        phoneNumber: json['phone_number'] == null
            ? null
            : json['phone_number'] as String,
        emailId: json['email_id'] == null ? null : json['email_id'] as String,
        zip: json['zip'] as String?,
        cardHolderName: json['card_holder_name'] == null
            ? null
            : json['card_holder_name'] as String,
        expiryDate:
            json['expiry_date'] == null ? null : json['expiry_date'] as String,
        address: json['address'] == null ? null : json['address'] as String,
        epi: json['epi'] == null ? null : json['epi'] as String,
        channel: json['channel'] == null ? null : json['channel'] as String,
        token: json['token'] == null ? null : json['token'] as String,
        cardBrand:
            json['card_brand'] == null ? null : json['card_brand'] as String);
  }

  @override
  String toString() {
    return '''Response(
                errorNo:$errorNo,
successUrl:$successUrl,
errorCode:$errorCode,
amount:$amount,
tax:$tax,
customfee:$customfee,
msg:$msg,
desc:$desc,
additionalInfo:$additionalInfo,
clerkId:$clerkId,
clerkName:$clerkName,
clerkLabel:$clerkLabel,
additionalKeyOne:$additionalKeyOne,
additionalKeyTwo:$additionalKeyTwo,
additionalValueOne:$additionalValueOne,
additionalValueTwo:$additionalValueTwo,
approvalCode:$approvalCode,
rrn:$rrn,
txnid:$txnid,
tranNo:$tranNo,
stan:$stan,
isPartialApprove:$isPartialApprove,
partialAmount:$partialAmount,
pan:$pan,
cardType:$cardType,
phoneNumber:$phoneNumber,
emailId:$emailId,
zip:$zip,
cardHolderName:$cardHolderName,
expiryDate:$expiryDate,
address:$address,
epi:$epi,
channel:$channel,
token:$token,
cardBrand:$cardBrand
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Response &&
        other.runtimeType == runtimeType &&
        other.errorNo == errorNo &&
        other.successUrl == successUrl &&
        other.errorCode == errorCode &&
        other.amount == amount &&
        other.tax == tax &&
        other.customfee == customfee &&
        other.msg == msg &&
        other.desc == desc &&
        other.additionalInfo == additionalInfo &&
        other.clerkId == clerkId &&
        other.clerkName == clerkName &&
        other.clerkLabel == clerkLabel &&
        other.additionalKeyOne == additionalKeyOne &&
        other.additionalKeyTwo == additionalKeyTwo &&
        other.additionalValueOne == additionalValueOne &&
        other.additionalValueTwo == additionalValueTwo &&
        other.approvalCode == approvalCode &&
        other.rrn == rrn &&
        other.txnid == txnid &&
        other.tranNo == tranNo &&
        other.stan == stan &&
        other.isPartialApprove == isPartialApprove &&
        other.partialAmount == partialAmount &&
        other.pan == pan &&
        other.cardType == cardType &&
        other.phoneNumber == phoneNumber &&
        other.emailId == emailId &&
        other.zip == zip &&
        other.cardHolderName == cardHolderName &&
        other.expiryDate == expiryDate &&
        other.address == address &&
        other.epi == epi &&
        other.channel == channel &&
        other.token == token &&
        other.cardBrand == cardBrand;
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        errorNo,
        successUrl,
        errorCode,
        amount,
        tax,
        customfee,
        msg,
        desc,
        additionalInfo,
        clerkId,
        clerkName,
        clerkLabel,
        additionalKeyOne,
        additionalKeyTwo,
        additionalValueOne,
        additionalValueTwo,
        approvalCode,
        rrn,
        txnid);
  }
}
