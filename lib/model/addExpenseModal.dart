// ignore_for_file: file_names

import 'dart:convert';

class AddExpenseModal {
  String? businessId;
  String? categoryId;
  String? userId;
  String? userLocation;
  String? locationId;
  String? refNo;
  String? contactId;
  String? expenseFor;
  double? finalTotal;
  String? additionalNotes;

  List<dynamic>? paymentMethods;

  AddExpenseModal({
    this.businessId,
    this.categoryId,
    this.userId,
    this.userLocation,
    this.locationId,
    this.refNo,
    this.contactId,
    this.expenseFor,
    this.finalTotal,
    this.additionalNotes,
    this.paymentMethods,
  });

  Map<String, dynamic> toJson() => {
        'business_id': businessId.toString(),
        'category_id': categoryId.toString(),
        'user_id': userId.toString(),
        'user_location': userLocation.toString(),
        'location_id': locationId.toString(),
        'ref_no': refNo.toString(),
        'payment': jsonEncode(paymentMethods?.map((e) => e).toList()),
        'contact_id': contactId.toString(),
        'expense_for': expenseFor.toString(),
        'final_total': finalTotal.toString(),
        'additional_notes': additionalNotes.toString(),
      };

  factory AddExpenseModal.fromJson(Map<String, dynamic> json) {
    return AddExpenseModal(
      businessId: json['business_id'],
      categoryId: json['category_id'],
      userId: json['user_location'],
      userLocation: json['user_location'],
      locationId: json['location_id'],
      refNo: json['ref_no'],
      contactId: json['contact_id'],
      expenseFor: json['expense_for'],
      finalTotal:
          (json['final_total'] as num).toDouble(), // Ensuring double type
      additionalNotes: json['additional_notes'],
    );
  }
}
