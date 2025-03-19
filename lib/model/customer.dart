class Customer {
  final String? contactType;
  final String? contactId;
  final String? customerGroupId;
  final String? supplierBusinessName;
  final String? prefix;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? mobile;
  final String? alternateContact;
  final String? landline;
  final String? email;
  final String? dob;
  final String? assignedToUsers;
  final String? taxNumber;
  final String? openingBalance;
  final String? payTermNumber;
  final String? payTermType;
  final String? creditLimit;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;
  final String? customField1;
  final String? customField2;
  final String? customField3;
  final String? customField4;
  final String? customField5;
  final String? customField6;
  final String? customField7;
  final String? customField8;
  final String? customField9;
  final String? customField10;
  final String? shippingAddress;
  final String? anniversaryDate;
  final String? discount;

  Customer({
     this.contactType,
     this.contactId,
     this.customerGroupId,
     this.supplierBusinessName,
     this.prefix,
     this.firstName,
     this.middleName,
     this.lastName,
     this.mobile,
     this.alternateContact,
     this.landline,
     this.email,
     this.dob,
     this.assignedToUsers,
     this.taxNumber,
     this.openingBalance,
     this.payTermNumber,
     this.payTermType,
     this.creditLimit,
     this.addressLine1,
     this.addressLine2,
     this.city,
     this.state,
     this.country,
     this.zipCode,
     this.customField1,
     this.customField2,
     this.customField3,
     this.customField4,
     this.customField5,
     this.customField6,
     this.customField7,
     this.customField8,
     this.customField9,
     this.customField10,
     this.shippingAddress,
     this.anniversaryDate,
     this.discount,
  });

  factory Customer.fromJson(Map<String?, dynamic> json) {
    return Customer(
      contactType: json['contact_type'] ?? '',
      contactId: json['contact_id'] ?? '',
      customerGroupId: json['customer_group_id'] ?? '',
      supplierBusinessName: json['supplier_business_name'] ?? '',
      prefix: json['prefix'] ?? '',
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? '',
      mobile: json['mobile'] ?? '',
      alternateContact: json['alternate_number'] ?? '',
      landline: json['landline'] ?? '',
      email: json['email'] ?? '',
      dob: json['dob'] ?? '',
      assignedToUsers: json['assigned_to_users'] ?? '',
      taxNumber: json['tax_number'] ?? '',
      openingBalance: json['opening_balance'] ?? '',
      payTermNumber: json['pay_term_number'] ?? '',
      payTermType: json['pay_term_type'] ?? '',
      creditLimit: json['credit_limit'] ?? '',
      addressLine1: json['address_line_1'] ?? '',
      addressLine2: json['address_line_2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      zipCode: json['zip_code'] ?? '',
      customField1: json['custom_field1'] ?? '',
      customField2: json['custom_field2'] ?? '',
      customField3: json['custom_field3'] ?? '',
      customField4: json['custom_field4'] ?? '',
      customField5: json['custom_field5'] ?? '',
      customField6: json['custom_field6'] ?? '',
      customField7: json['custom_field7'] ?? '',
      customField8: json['custom_field8'] ?? '',
      customField9: json['custom_field9'] ?? '',
      customField10: json['custom_field10'] ?? '',
      shippingAddress: json['shipping_address'] ?? '',
      anniversaryDate: json['anniversary_date'] ?? '',
      discount: json['discount'] ?? '',
    );
  }
}
