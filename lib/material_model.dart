// To parse this JSON data, do
//
//     final material = materialFromJson(jsonString);

import 'dart:convert';

Material materialFromJson(String str) => Material.fromJson(json.decode(str));

String materialToJson(Material data) => json.encode(data.toJson());

class Material {
  int status;
  List<DataMaterial> data;
  String message;

  Material({
    required this.status,
    required this.data,
    required this.message,
  });

  factory Material.fromJson(Map<String, dynamic> json) => Material(
        status: json["status"],
        data: List<DataMaterial>.from(
            json["data"].map((x) => DataMaterial.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class DataMaterial {
  int id;
  String name;
  int price;
  Unit unit;
  dynamic createdAt;
  dynamic updatedAt;

  DataMaterial({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataMaterial.fromJson(Map<String, dynamic> json) => DataMaterial(
        id: json["id"],
        name: json["name"],
        price: int.tryParse(json["price"]) ?? 0,
        unit: unitValues.map[json["unit"]]!,
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "unit": unitValues.reverse[unit],
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

// ignore: constant_identifier_names
enum Unit { EMPTY }

final unitValues = EnumValues({"كيلو": Unit.EMPTY});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
