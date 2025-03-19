import 'dart:convert';
import 'dart:developer';

class LoggedInUser {
  LoggedInUser({
    this.id,
    this.password,
    this.surname,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.businessId,
    this.businessName,
    this.allowLogin,
    this.status,
    this.registerStatus,
    this.locations,
    this.locationList,
    this.color,
    this.business,
    this.paxDevices,
  });

  LoggedInUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
    surname = json['surname'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    email = json['email'];
    businessId = json['business_id'];
    businessName = json['business_name'];
    allowLogin = json['allow_login'];
    status = json['status'];
    if (json['pax_devices'] != null) {
      paxDevices = (json['pax_devices'] as List)
          .map((i) => PaxDevice.fromJson(i))
          .toList();
    }
    registerStatus = json['cash_register_status'];
    locations = json['locations'];
    color = json['color'];
    if (json['location_list'] != null) {
      locationList = (json['location_list'] as List)
          .map((i) => LocationList.fromJson(i))
          .toList();
    }
    business =
        json['business'] != null ? Business.fromJson(json['business']) : null;
  }

  String? id;
  String? password;
  String? surname;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? businessId;
  String? businessName;
  String? allowLogin;
  String? status;
  List<PaxDevice>? paxDevices;
  String? registerStatus;
  String? locations;
  List<LocationList>? locationList;

  String? color;
  Business? business;

  LoggedInUser copyWith({
    String? id,
    String? password,
    String? surname,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? businessId,
    String? businessName,
    String? allowLogin,
    String? status,
    List<PaxDevice>? paxDevices,
    String? registerStatus,
    String? locations,
    List<LocationList>? locationList,
    String? color,
    Business? business,
  }) =>
      LoggedInUser(
        id: id ?? this.id,
        password: password ?? this.password,
        surname: surname ?? this.surname,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        username: username ?? this.username,
        email: email ?? this.email,
        businessId: businessId ?? this.businessId,
        businessName: businessName ?? this.businessName,
        allowLogin: allowLogin ?? this.allowLogin,
        status: status ?? this.status,
        paxDevices: paxDevices ?? this.paxDevices,
        registerStatus: registerStatus ?? this.registerStatus,
        locations: locations ?? this.locations,
        locationList: locationList ?? this.locationList,
        color: color ?? this.color,
        business: business ?? this.business,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['password'] = password;
    map['surname'] = surname;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['username'] = username;
    map['email'] = email;
    map['business_id'] = businessId;
    map['business_name'] = businessName;
    map['allow_login'] = allowLogin;
    map['status'] = status;
    if (paxDevices != null) {
      map['pax_devices'] = paxDevices!.map((i) => i.toJson()).toList();
    }
    map['cash_register_status'] = registerStatus;
    map['locations'] = locations;
    map['color'] = color;
    if (locationList != null) {
      map['location_list'] = locationList!.map((i) => i.toJson()).toList();
    }
    if (business != null) {
      map['business'] = business!.toJson();
    }
    return map;
  }
}

class PaxDevice {
  PaxDevice({
    this.id,
    this.businessLocationId,
    this.deviceName,
    this.serialNumber,
    this.bridgePayUrl,
    this.bridgePayDetails,
  });

  PaxDevice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessLocationId = json['business_location_id'];
    deviceName = json['device_name'];
    serialNumber = json['serial_number'];
    bridgePayUrl = json['bridge_pay_url'];
    if (json['bridge_pay_details'] != null) {
      if (json['bridge_pay_details'] is String) {
        bridgePayDetails = BridgePayDetails.fromJson(
          jsonDecode(json['bridge_pay_details']),
        );
      } else if (json['bridge_pay_details'] is Map<String, dynamic>) {
        bridgePayDetails =
            BridgePayDetails.fromJson(json['bridge_pay_details']);
      }
    }
  }

  String? id;
  String? businessLocationId;
  String? deviceName;
  String? serialNumber;
  String? bridgePayUrl;
  BridgePayDetails? bridgePayDetails;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_location_id': businessLocationId,
      'device_name': deviceName,
      'serial_number': serialNumber,
      'bridge_pay_url': bridgePayUrl,
      'bridge_pay_details': bridgePayDetails?.toJson(),
    };
  }
}

class Business {
  Business({
    this.bridgePayUrl,
    this.bridgePayDetails,
  });

  Business.fromJson(Map<String, dynamic> json) {
    bridgePayUrl = json['bridge_pay_url'];
    if (json['bridge_pay_details'] != null) {
      if (json['bridge_pay_details'] is String) {
        log("Parsing bridge_pay_details as String");
        bridgePayDetails = BridgePayDetails.fromJson(
          jsonDecode(json['bridge_pay_details']),
        );
      } else if (json['bridge_pay_details'] is Map<String, dynamic>) {
        log("Parsing bridge_pay_details as Map<String, dynamic>");
        bridgePayDetails =
            BridgePayDetails.fromJson(json['bridge_pay_details']);
      }
    }
  }

  String? bridgePayUrl;
  BridgePayDetails? bridgePayDetails;

  Map<String, dynamic> toJson() {
    return {
      'bridge_pay_url': bridgePayUrl,
      'bridge_pay_details': bridgePayDetails?.toJson(),
    };
  }
}

class BridgePayDetails {
  BridgePayDetails({
    this.mode,
    this.password,
    this.username,
    this.terminalID,
    this.merchantCode,
    this.softwareVendor,
    this.partialApproval,
    this.merchantAccountCode,
  });

  BridgePayDetails.fromJson(Map<String, dynamic> json) {
    mode = json['mode'];
    password = json['password'];
    username = json['username'];
    terminalID = json['terminalID'];
    merchantCode = json['merchantCode'];
    softwareVendor = json['softwareVendor'];
    partialApproval = json['partialApproval'];
    merchantAccountCode = json['merchantAccountCode'];
  }

  String? mode;
  String? password;
  String? username;
  String? terminalID;
  String? merchantCode;
  String? softwareVendor;
  String? partialApproval;
  String? merchantAccountCode;

  Map<String, dynamic> toJson() {
    return {
      'mode': mode,
      'password': password,
      'username': username,
      'terminalID': terminalID,
      'merchantCode': merchantCode,
      'softwareVendor': softwareVendor,
      'partialApproval': partialApproval,
      'merchantAccountCode': merchantAccountCode,
    };
  }
}

class LocationList {
  LocationList({
    this.id,
    this.name,
  });

  LocationList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  String? id;
  String? name;

  LocationList copyWith({
    String? id,
    String? name,
  }) =>
      LocationList(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
