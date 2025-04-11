class RegisterDetails {
  String? openTime;
  String? currentTime;
  String? closedAt;
  String? userId;
  String? closingNote;
  String? locationId;
  String? denominations;
  String? cashInHand;
  String? totalSale;
  String? totalExpense;
  String? totalCash;
  String? totalCashExpense;
  String? totalCheque;
  String? totalChequeExpense;
  String? totalCard;
  String? totalCardExpense;
  String? totalBankTransfer;
  String? totalBankTransferExpense;
  String? totalOther;
  String? totalOtherExpense;
  String? totalAdvance;
  String? totalAdvanceExpense;
  String? totalRefund;
  String? totalCashRefund;
  String? totalChequeRefund;
  String? totalCardRefund;
  String? totalBankTransferRefund;
  String? totalOtherRefund;
  String? totalAdvanceRefund;
  String? totalCheques;
  String? totalCardSlips;
  String? totalPayment; // ✅ New field added here
  String? userName;
  String? email;
  String? locationName;

  RegisterDetails({
    this.openTime,
    this.currentTime,
    this.closedAt,
    this.userId,
    this.closingNote,
    this.locationId,
    this.denominations,
    this.cashInHand,
    this.totalSale,
    this.totalExpense,
    this.totalCash,
    this.totalCashExpense,
    this.totalCheque,
    this.totalChequeExpense,
    this.totalCard,
    this.totalCardExpense,
    this.totalBankTransfer,
    this.totalBankTransferExpense,
    this.totalOther,
    this.totalOtherExpense,
    this.totalAdvance,
    this.totalAdvanceExpense,
    this.totalRefund,
    this.totalCashRefund,
    this.totalChequeRefund,
    this.totalCardRefund,
    this.totalBankTransferRefund,
    this.totalOtherRefund,
    this.totalAdvanceRefund,
    this.totalCheques,
    this.totalCardSlips,
    this.totalPayment, // ✅ Include it in the constructor
    this.userName,
    this.email,
    this.locationName,
  });

  factory RegisterDetails.fromJson(Map<String, dynamic> json) {
    return RegisterDetails(
      openTime: json['open_time'],
      currentTime: json['current_time'],
      closedAt: json['closed_at'] ?? '',
      userId: json['user_id'],
      closingNote: json['closing_note'] ?? '',
      locationId: json['location_id'],
      denominations: json['denominations'] ?? '',
      cashInHand: formatFloat(json['cash_in_hand']),
      totalSale: formatFloat(json['total_sale']),
      totalExpense: formatFloat(json['total_expense']),
      totalCash: formatFloat(json['total_cash']),
      totalCashExpense: formatFloat(json['total_cash_expense']),
      totalCheque: formatFloat(json['total_cheque']),
      totalChequeExpense: formatFloat(json['total_cheque_expense']),
      totalCard: formatFloat(json['total_card']),
      totalCardExpense: formatFloat(json['total_card_expense']),
      totalBankTransfer: formatFloat(json['total_bank_transfer']),
      totalBankTransferExpense: formatFloat(json['total_bank_transfer_expense']),
      totalOther: formatFloat(json['total_other']),
      totalOtherExpense: formatFloat(json['total_other_expense']),
      totalAdvance: formatFloat(json['total_advance']),
      totalAdvanceExpense: formatFloat(json['total_advance_expense']),
      totalRefund: formatFloat(json['total_sell_return_inc_tax']),
      totalCashRefund: formatFloat(json['total_cash_refund']),
      totalChequeRefund: formatFloat(json['total_cheque_refund']),
      totalCardRefund: formatFloat(json['total_card_refund']),
      totalBankTransferRefund: formatFloat(json['total_bank_transfer_refund']),
      totalOtherRefund: formatFloat(json['total_other_refund']),
      totalAdvanceRefund: formatFloat(json['total_advance_refund']),
      totalCheques: formatFloat(json['total_cheques']),
      totalCardSlips: formatFloat(json['total_card_slips']),
      totalPayment: formatFloat(json['total_payment']), // ✅ Parse new field
      userName: json['user_name'],
      email: json['email'],
      locationName: json['location_name'],
    );
  }

  static String? formatFloat(dynamic value) {
    if (value is double) {
      return value.toStringAsFixed(2);
    } else if (value is String) {
      double? floatValue = double.tryParse(value);
      if (floatValue != null) {
        return floatValue.toStringAsFixed(2);
      }
    }
    return value?.toString();
  }

  Map<String?, dynamic> toJson() {
    final map = <String?, dynamic>{};
    map['open_time'] = openTime;
    map['current_time'] = currentTime;
    map['closed_at'] = closedAt;
    map['user_id'] = userId;
    map['closing_note'] = closingNote;
    map['location_id'] = locationId;
    map['denominations'] = denominations;
    map['cash_in_hand'] = cashInHand;
    map['total_sale'] = totalSale;
    map['total_expense'] = totalExpense;
    map['total_cash'] = totalCash;
    map['total_cash_expense'] = totalCashExpense;
    map['total_cheque'] = totalCheque;
    map['total_cheque_expense'] = totalChequeExpense;
    map['total_card'] = totalCard;
    map['total_card_expense'] = totalCardExpense;
    map['total_bank_transfer'] = totalBankTransfer;
    map['total_bank_transfer_expense'] = totalBankTransferExpense;
    map['total_other'] = totalOther;
    map['total_other_expense'] = totalOtherExpense;
    map['total_advance'] = totalAdvance;
    map['total_advance_expense'] = totalAdvanceExpense;
    map['total_sell_return_inc_tax'] = totalRefund;
    map['total_cash_refund'] = totalCashRefund;
    map['total_cheque_refund'] = totalChequeRefund;
    map['total_card_refund'] = totalCardRefund;
    map['total_bank_transfer_refund'] = totalBankTransferRefund;
    map['total_other_refund'] = totalOtherRefund;
    map['total_advance_refund'] = totalAdvanceRefund;
    map['total_cheques'] = totalCheques;
    map['total_card_slips'] = totalCardSlips;
    map['total_payment'] = totalPayment; // ✅ Include in toJson
    map['user_name'] = userName;
    map['email'] = email;
    map['location_name'] = locationName;
    return map;
  }
}
