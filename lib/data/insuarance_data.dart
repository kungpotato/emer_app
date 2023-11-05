class InsuranceData {
  InsuranceData({required this.id, required this.name});

  factory InsuranceData.fromJson(Map<String, dynamic> json) {
    return InsuranceData(
      id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      // img: json['img'].toString(),
    );
  }

  final int id;
  final String name;

  // final String img;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      // 'img': img,
    };
  }
}
