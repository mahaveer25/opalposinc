// ignore_for_file: non_constant_identifier_names

class ExpenseDrop {
  String? id;
  String? name;

  ExpenseDrop({
    this.id,
    this.name,
  });

  factory ExpenseDrop.fromJson(Map<String, dynamic> json) {
    return ExpenseDrop(
      id: json['id'],
      name: json['name'],
    );
  }
}
