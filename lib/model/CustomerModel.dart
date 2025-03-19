class CustomerModel {
  CustomerModel({
    String? id,
    String? businessId,
    String? name,
    String? email,
    String? mobile,
    dynamic zipCode,
    String? contactId,
    dynamic assignedToUsers,
    String? rewardPoints,
    String? rewardPointsUsed,
  }) {
    _id = id ?? '';
    _businessId = businessId ?? '';
    _name = name ?? '';
    _email = email ?? '';
    _mobile = mobile ?? '';
    _zipCode = zipCode ?? '';
    _contactId = contactId ?? '';
    _assignedToUsers = assignedToUsers ?? '';
    _rewardPoints = rewardPoints ?? '';
    _rewardPointsUsed = rewardPointsUsed ?? '';
  }

  CustomerModel.fromJson(dynamic json) {
    _id = json['id'] ?? '';
    _businessId = json['business_id'] ?? '';
    _name = json['name'] ?? '';
    _email = json['email'] ?? '';
    _mobile = json['mobile'] ?? '';
    _zipCode = json['zip_code'] ?? '';
    _contactId = json['contact_id'] ?? '';
    _assignedToUsers = json['assigned_to_users'] ?? '';
    _rewardPoints = json['Reward_Point'] ?? '';
    _rewardPointsUsed = json['Reward_Point_used'] ?? '';
  }

  String? _id;
  String? _businessId;
  String? _name;
  String? _email;
  String? _mobile;
  dynamic _zipCode;
  String? _contactId;
  dynamic _assignedToUsers;
  String? _rewardPoints;
  String? _rewardPointsUsed;

  CustomerModel copyWith({
    String? id,
    String? businessId,
    String? name,
    String? email,
    String? mobile,
    dynamic zipCode,
    String? contactId,
    dynamic assignedToUsers,
    String? rewardPoints,
    String? rewardPointsUsed,
  }) =>
      CustomerModel(
        id: id ?? _id,
        businessId: businessId ?? _businessId,
        name: name ?? _name,
        email: email ?? _email,
        mobile: mobile ?? _mobile,
        zipCode: zipCode ?? _zipCode,
        contactId: contactId ?? _contactId,
        assignedToUsers: assignedToUsers ?? _assignedToUsers,
        rewardPoints: rewardPoints ?? _rewardPoints,
        rewardPointsUsed: rewardPointsUsed ?? _rewardPointsUsed,
      );

  String? get id => _id;
  String? get businessId => _businessId;
  String? get name => _name;
  String? get email => _email;
  String? get mobile => _mobile;
  dynamic get zipCode => _zipCode;
  String? get contactId => _contactId;
  String? get rewardPoints => _rewardPoints;
  String? get rewardPointsUsed => _rewardPointsUsed;
  dynamic get assignedToUsers => _assignedToUsers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id ?? '';
    map['business_id'] = _businessId ?? '';
    map['name'] = _name ?? '';
    map['email'] = _email ?? '';
    map['mobile'] = _mobile ?? '';
    map['zip_code'] = _zipCode ?? '';
    map['contact_id'] = _contactId ?? '';
    map['assigned_to_users'] = _assignedToUsers ?? '';
    map['Reward_Point'] = _rewardPoints ?? '';
    map['Reward_Point_used'] = _rewardPointsUsed ?? '';
    return map;
  }
}
