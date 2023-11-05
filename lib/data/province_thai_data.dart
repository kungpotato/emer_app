class ProvinceThaiData {
  ProvinceThaiData({
    required this.tambonID,
    required this.tambonThai,
    required this.tambonEng,
    required this.tambonThaiShort,
    required this.tambonEngShort,
    required this.districtID,
    required this.districtThai,
    required this.districtEng,
    required this.districtThaiShort,
    required this.districtEngShort,
    required this.provinceID,
    required this.provinceThai,
    required this.provinceEng,
    required this.officialRegion,
    required this.fourRegions,
    required this.tourismRegionOfThailand,
    required this.bangkokAndMetropolitan,
    required this.postCodeMain,
    required this.postCodeAll,
  });

  factory ProvinceThaiData.fromJson(Map<String, dynamic> json) {
    return ProvinceThaiData(
      tambonID: json['TambonID'].toString(),
      tambonThai: json['TambonThai'].toString(),
      tambonEng: json['TambonEng'].toString(),
      tambonThaiShort: json['TambonThaiShort'].toString(),
      tambonEngShort: json['TambonEngShort'].toString(),
      districtID: json['DistrictID'].toString(),
      districtThai: json['DistrictThai'].toString(),
      districtEng: json['DistrictEng'].toString(),
      districtThaiShort: json['DistrictThaiShort'].toString(),
      districtEngShort: json['DistrictEngShort'].toString(),
      provinceID: json['ProvinceID'].toString(),
      provinceThai: json['ProvinceThai'].toString(),
      provinceEng: json['ProvinceEng'].toString(),
      officialRegion: json['ภูมิภาคอย่างเป็นทางการ'].toString(),
      fourRegions: json['ภูมิภาคแบบสี่ภูมิภาค'].toString(),
      tourismRegionOfThailand:
          json['ภูมิภาคการท่องเที่ยวแห่งประเทศไทย'].toString(),
      bangkokAndMetropolitan: json['กรุงเทพปริมณฑลต่างจังหวัด'].toString(),
      postCodeMain: json['PostCodeMain'].toString(),
      postCodeAll: json['PostCodeAll'].toString(),
    );
  }

  final String tambonID;
  final String tambonThai;
  final String tambonEng;
  final String tambonThaiShort;
  final String tambonEngShort;
  final String districtID;
  final String districtThai;
  final String districtEng;
  final String districtThaiShort;
  final String districtEngShort;
  final String provinceID;
  final String provinceThai;
  final String provinceEng;
  final String officialRegion;
  final String fourRegions;
  final String tourismRegionOfThailand;
  final String bangkokAndMetropolitan;
  final String postCodeMain;
  final String postCodeAll;
}
