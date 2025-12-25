class Evolution {
  final String num;
  final String name;

  Evolution({required this.num, required this.name});

  factory Evolution.fromJson(Map<String, dynamic> json) {
    return Evolution(num: json['num'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'num': num, 'name': name};
  }
}
