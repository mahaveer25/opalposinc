class Location {
  final String? id;
  final String? businessId;
  final String? locationId;
  final String? name;
  final String? landmark;
  final String? country;
  final String? state;
  final String? city;
  final String? zipCode;
  final String? alternateNumber;
  const Location(
      {this.id,
      this.businessId,
      this.locationId,
      this.name,
      this.landmark,
      this.country,
      this.state,
      this.city,
      this.zipCode,
      this.alternateNumber});
  Location copyWith(
      {String? id,
      String? businessId,
      String? locationId,
      String? name,
      String? landmark,
      String? country,
      String? state,
      String? city,
      String? zipCode,
      String? alternateNumber}) {
    return Location(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        locationId: locationId ?? this.locationId,
        name: name ?? this.name,
        landmark: landmark ?? this.landmark,
        country: country ?? this.country,
        state: state ?? this.state,
        city: city ?? this.city,
        zipCode: zipCode ?? this.zipCode,
        alternateNumber: alternateNumber ?? this.alternateNumber);
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'business_id': businessId,
      'location_id': locationId,
      'name': name,
      'landmark': landmark,
      'country': country,
      'state': state,
      'city': city,
      'zip_code': zipCode,
      'alternate_number': alternateNumber
    };
  }

  static Location fromJson(Map<String, Object?> json) {
    return Location(
        id: json['id'] == null ? null : json['id'] as String,
        businessId:
            json['business_id'] == null ? null : json['business_id'] as String,
        locationId:
            json['location_id'] == null ? null : json['location_id'] as String,
        name: json['name'] == null ? null : json['name'] as String,
        landmark: json['landmark'] == null ? null : json['landmark'] as String,
        country: json['country'] == null ? null : json['country'] as String,
        state: json['state'] == null ? null : json['state'] as String,
        city: json['city'] == null ? null : json['city'] as String,
        zipCode: json['zip_code'] == null ? null : json['zip_code'] as String,
        alternateNumber: json['alternate_number'] == null
            ? null
            : json['alternate_number'] as String);
  }

  @override
  String toString() {
    return '''Location(
                id:$id,
businessId:$businessId,
locationId:$locationId,
name:$name,
landmark:$landmark,
country:$country,
state:$state,
city:$city,
zipCode:$zipCode,
alternateNumber:$alternateNumber
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Location &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.businessId == businessId &&
        other.locationId == locationId &&
        other.name == name &&
        other.landmark == landmark &&
        other.country == country &&
        other.state == state &&
        other.city == city &&
        other.zipCode == zipCode &&
        other.alternateNumber == alternateNumber;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, businessId, locationId, name, landmark,
        country, state, city, zipCode, alternateNumber);
  }
}
