class RegisterDetails {
  RegisterDetails({
    String? openTime,
    String? closedAt,
    String? userId,
    String? closingNote,
    String? locationId,
    String? denominations,
    String? cashInHand,
    String? totalSale,
    String? totalExpense,
    String? totalCash,
    String? totalCashExpense,
    String? totalCheque,
    String? totalChequeExpense,
    String? totalCard,
    String? totalCardExpense,
    String? totalBankTransfer,
    String? totalBankTransferExpense,
    String? totalOther,
    String? totalOtherExpense,
    String? totalAdvance,
    String? totalAdvanceExpense,
    String? totalRefund,
    String? totalCashRefund,
    String? totalChequeRefund,
    String? totalCardRefund,
    String? totalBankTransferRefund,
    String? totalOtherRefund,
    String? totalAdvanceRefund,
    String? totalCheques,
    String? totalCardSlips,
    String? userName,
    String? email,
    String? locationName,
  }) {
    _openTime = openTime;
    _closedAt = closedAt;
    _userId = userId;
    _closingNote = closingNote;
    _locationId = locationId;
    _denominations = denominations;
    _cashInHand = cashInHand;
    _totalSale = totalSale;
    _totalExpense = totalExpense;
    _totalCash = totalCash;
    _totalCashExpense = totalCashExpense;
    _totalCheque = totalCheque;
    _totalChequeExpense = totalChequeExpense;
    _totalCard = totalCard;
    _totalCardExpense = totalCardExpense;
    _totalBankTransfer = totalBankTransfer;
    _totalBankTransferExpense = totalBankTransferExpense;
    _totalOther = totalOther;
    _totalOtherExpense = totalOtherExpense;
    _totalAdvance = totalAdvance;
    _totalAdvanceExpense = totalAdvanceExpense;
    _totalRefund = totalRefund;
    _totalCashRefund = totalCashRefund;
    _totalChequeRefund = totalChequeRefund;
    _totalCardRefund = totalCardRefund;
    _totalBankTransferRefund = totalBankTransferRefund;
    _totalOtherRefund = totalOtherRefund;
    _totalAdvanceRefund = totalAdvanceRefund;
    _totalCheques = totalCheques;
    _totalCardSlips = totalCardSlips;
    _userName = userName;
    _email = email;
    _locationName = locationName;
  }

  RegisterDetails.fromJson(dynamic json) {
    _openTime = json['open_time'];
    _closedAt = json['closed_at'];
    _userId = json['user_id'];
    _closingNote = json['closing_note'];
    _locationId = json['location_id'];
    _denominations = json['denominations'];
    _cashInHand = json['cash_in_hand'];
    _totalSale = json['total_sale'];
    _totalExpense = json['total_expense'];
    _totalCash = json['total_cash'];
    _totalCashExpense = json['total_cash_expense'];
    _totalCheque = json['total_cheque'];
    _totalChequeExpense = json['total_cheque_expense'];
    _totalCard = json['total_card'];
    _totalCardExpense = json['total_card_expense'];
    _totalBankTransfer = json['total_bank_transfer'];
    _totalBankTransferExpense = json['total_bank_transfer_expense'];
    _totalOther = json['total_other'];
    _totalOtherExpense = json['total_other_expense'];
    _totalAdvance = json['total_advance'];
    _totalAdvanceExpense = json['total_advance_expense'];
    _totalRefund = json['total_sell_return_inc_tax'];
    _totalCashRefund = json['total_cash_refund'];
    _totalChequeRefund = json['total_cheque_refund'];
    _totalCardRefund = json['total_card_refund'];
    _totalBankTransferRefund = json['total_bank_transfer_refund'];
    _totalOtherRefund = json['total_other_refund'];
    _totalAdvanceRefund = json['total_advance_refund'];
    _totalCheques = json['total_cheques'];
    _totalCardSlips = json['total_card_slips'];
    _userName = json['user_name'];
    _email = json['email'];
    _locationName = json['location_name'];
  }
  String? _openTime;
  dynamic _closedAt;
  String? _userId;
  dynamic _closingNote;
  String? _locationId;
  dynamic _denominations;
  String? _cashInHand;
  String? _totalSale;
  String? _totalExpense;
  String? _totalCash;
  String? _totalCashExpense;
  String? _totalCheque;
  String? _totalChequeExpense;
  String? _totalCard;
  String? _totalCardExpense;
  String? _totalBankTransfer;
  String? _totalBankTransferExpense;
  String? _totalOther;
  String? _totalOtherExpense;
  String? _totalAdvance;
  String? _totalAdvanceExpense;
  String? _totalRefund;
  String? _totalCashRefund;
  String? _totalChequeRefund;
  String? _totalCardRefund;
  String? _totalBankTransferRefund;
  String? _totalOtherRefund;
  String? _totalAdvanceRefund;
  String? _totalCheques;
  String? _totalCardSlips;
  String? _userName;
  String? _email;
  String? _locationName;
  RegisterDetails copyWith({
    String? openTime,
    dynamic closedAt,
    String? userId,
    dynamic closingNote,
    String? locationId,
    dynamic denominations,
    String? cashInHand,
    String? totalSale,
    String? totalExpense,
    String? totalCash,
    String? totalCashExpense,
    String? totalCheque,
    String? totalChequeExpense,
    String? totalCard,
    String? totalCardExpense,
    String? totalBankTransfer,
    String? totalBankTransferExpense,
    String? totalOther,
    String? totalOtherExpense,
    String? totalAdvance,
    String? totalAdvanceExpense,
    String? totalRefund,
    String? totalCashRefund,
    String? totalChequeRefund,
    String? totalCardRefund,
    String? totalBankTransferRefund,
    String? totalOtherRefund,
    String? totalAdvanceRefund,
    String? totalCheques,
    String? totalCardSlips,
    String? userName,
    String? email,
    String? locationName,
  }) =>
      RegisterDetails(
        openTime: openTime ?? _openTime,
        closedAt: closedAt ?? _closedAt,
        userId: userId ?? _userId,
        closingNote: closingNote ?? _closingNote,
        locationId: locationId ?? _locationId,
        denominations: denominations ?? _denominations,
        cashInHand: cashInHand ?? _cashInHand,
        totalSale: totalSale ?? _totalSale,
        totalExpense: totalExpense ?? _totalExpense,
        totalCash: totalCash ?? _totalCash,
        totalCashExpense: totalCashExpense ?? _totalCashExpense,
        totalCheque: totalCheque ?? _totalCheque,
        totalChequeExpense: totalChequeExpense ?? _totalChequeExpense,
        totalCard: totalCard ?? _totalCard,
        totalCardExpense: totalCardExpense ?? _totalCardExpense,
        totalBankTransfer: totalBankTransfer ?? _totalBankTransfer,
        totalBankTransferExpense:
            totalBankTransferExpense ?? _totalBankTransferExpense,
        totalOther: totalOther ?? _totalOther,
        totalOtherExpense: totalOtherExpense ?? _totalOtherExpense,
        totalAdvance: totalAdvance ?? _totalAdvance,
        totalAdvanceExpense: totalAdvanceExpense ?? _totalAdvanceExpense,
        totalRefund: totalRefund ?? _totalRefund,
        totalCashRefund: totalCashRefund ?? _totalCashRefund,
        totalChequeRefund: totalChequeRefund ?? _totalChequeRefund,
        totalCardRefund: totalCardRefund ?? _totalCardRefund,
        totalBankTransferRefund:
            totalBankTransferRefund ?? _totalBankTransferRefund,
        totalOtherRefund: totalOtherRefund ?? _totalOtherRefund,
        totalAdvanceRefund: totalAdvanceRefund ?? _totalAdvanceRefund,
        totalCheques: totalCheques ?? _totalCheques,
        totalCardSlips: totalCardSlips ?? _totalCardSlips,
        userName: userName ?? _userName,
        email: email ?? _email,
        locationName: locationName ?? _locationName,
      );
  String? get openTime => _openTime;
  dynamic get closedAt => _closedAt;
  String? get userId => _userId;
  dynamic get closingNote => _closingNote;
  String? get locationId => _locationId;
  dynamic get denominations => _denominations;
  String? get cashInHand => _cashInHand;
  String? get totalSale => _totalSale;
  String? get totalExpense => _totalExpense;
  String? get totalCash => _totalCash;
  String? get totalCashExpense => _totalCashExpense;
  String? get totalCheque => _totalCheque;
  String? get totalChequeExpense => _totalChequeExpense;
  String? get totalCard => _totalCard;
  String? get totalCardExpense => _totalCardExpense;
  String? get totalBankTransfer => _totalBankTransfer;
  String? get totalBankTransferExpense => _totalBankTransferExpense;
  String? get totalOther => _totalOther;
  String? get totalOtherExpense => _totalOtherExpense;
  String? get totalAdvance => _totalAdvance;
  String? get totalAdvanceExpense => _totalAdvanceExpense;
  String? get totalRefund => _totalRefund;
  String? get totalCashRefund => _totalCashRefund;
  String? get totalChequeRefund => _totalChequeRefund;
  String? get totalCardRefund => _totalCardRefund;
  String? get totalBankTransferRefund => _totalBankTransferRefund;
  String? get totalOtherRefund => _totalOtherRefund;
  String? get totalAdvanceRefund => _totalAdvanceRefund;
  String? get totalCheques => _totalCheques;
  String? get totalCardSlips => _totalCardSlips;
  String? get userName => _userName;
  String? get email => _email;
  String? get locationName => _locationName;

  Map<String?, dynamic> toJson() {
    final map = <String?, dynamic>{};
    map['open_time'] = _openTime;
    map['closed_at'] = _closedAt;
    map['user_id'] = _userId;
    map['closing_note'] = _closingNote;
    map['location_id'] = _locationId;
    map['denominations'] = _denominations;
    map['cash_in_hand'] = _cashInHand;
    map['total_sale'] = _totalSale;
    map['total_expense'] = _totalExpense;
    map['total_cash'] = _totalCash;
    map['total_cash_expense'] = _totalCashExpense;
    map['total_cheque'] = _totalCheque;
    map['total_cheque_expense'] = _totalChequeExpense;
    map['total_card'] = _totalCard;
    map['total_card_expense'] = _totalCardExpense;
    map['total_bank_transfer'] = _totalBankTransfer;
    map['total_bank_transfer_expense'] = _totalBankTransferExpense;
    map['total_other'] = _totalOther;
    map['total_other_expense'] = _totalOtherExpense;
    map['total_advance'] = _totalAdvance;
    map['total_advance_expense'] = _totalAdvanceExpense;
    map['total_sell_return_inc_tax'] = _totalRefund;
    map['total_cash_refund'] = _totalCashRefund;
    map['total_cheque_refund'] = _totalChequeRefund;
    map['total_card_refund'] = _totalCardRefund;
    map['total_bank_transfer_refund'] = _totalBankTransferRefund;
    map['total_other_refund'] = _totalOtherRefund;
    map['total_advance_refund'] = _totalAdvanceRefund;
    map['total_cheques'] = _totalCheques;
    map['total_card_slips'] = _totalCardSlips;
    map['user_name'] = _userName;
    map['email'] = _email;
    map['location_name'] = _locationName;
    return map;
  }
}
