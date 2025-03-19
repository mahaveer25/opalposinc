// ignore_for_file: non_constant_identifier_names

class PricingGroup {
  String? id;
  String? name;
  String? selected_flag;

  PricingGroup({this.id, this.name, this.selected_flag});

  factory PricingGroup.fromJson(Map<String, dynamic> json) {
    return PricingGroup(
      id: json['id'],
      name: json['name'],
      selected_flag: json['selection_flag'],
    );
  }
}
