class Category {
  final String? id;
  final String? name;
  final String? shortCode;
  final String? type;

  Category({
    this.id,
    this.name,
    this.shortCode,
    this.type,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      shortCode: json['short_code'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
