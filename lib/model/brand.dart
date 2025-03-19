class Brand {
  final String? id;
  final String? name;

  Brand({this.id, this.name});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
    );
  }
}
