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
        "data": data.map((x) => x.toJson()).toList(),
        "message": message,
      };
}

class DataMaterial {
  int id;
  String name;
  int price;
  String unit;
  dynamic createdAt;
  dynamic updatedAt;

  DataMaterial({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    this.createdAt,
    this.updatedAt,
  });

  factory DataMaterial.fromJson(Map<String, dynamic> json) => DataMaterial(
        id: json["id"],
        name: json["name"],
        price: int.tryParse(json["price"]) ?? 0,
        unit: json["unit"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "unit": unit,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
