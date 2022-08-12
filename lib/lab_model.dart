// To parse this JSON data, do
//
//     final labModel = labModelFromJson(jsonString);

import 'dart:convert';

LabModel labModelFromJson(String str) => LabModel.fromJson(json.decode(str));

String labModelToJson(LabModel data) => json.encode(data.toJson());

class LabModel {
  LabModel({
    required this.namaLab,
    this.lat,
    this.lon,
    this.alamat,
    this.kontakPhone,
    required this.provinsi,
  });

  String namaLab;
  String? lat;
  String? lon;
  String? alamat;
  String? kontakPhone;
  String? provinsi;

  factory LabModel.fromJson(Map<String, dynamic> json) => LabModel(
        namaLab: json["nama_lab"],
        lat: json["lat"],
        lon: json["lon"],
        alamat: json["alamat"],
        kontakPhone: json["kontak_phone"],
        provinsi: json["provinsi"],
      );

  Map<String, dynamic> toJson() => {
        "nama_lab": namaLab,
        "lat": lat,
        "lon": lon,
        "alamat": alamat,
        "kontak_phone": kontakPhone,
        "provinsi": provinsi,
      };
}
