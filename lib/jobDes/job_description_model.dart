// To parse this JSON data, do
//
//     final alljobDescription = alljobDescriptionFromJson(jsonString);

import 'dart:convert';

AlljobDescription alljobDescriptionFromJson(String str) => AlljobDescription.fromJson(json.decode(str));

String alljobDescriptionToJson(AlljobDescription data) => json.encode(data.toJson());

class AlljobDescription {
    int status;
    List<DataAllDes> data;
    String message;

    AlljobDescription({
        required this.status,
        required this.data,
        required this.message,
    });

    factory AlljobDescription.fromJson(Map<String, dynamic> json) => AlljobDescription(
        status: json["status"],
        data: List<DataAllDes>.from(json["data"].map((x) => DataAllDes.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
    };
}

class DataAllDes {
    int id;
    String description;
    int price;
    String unit;
    dynamic createdAt;
    dynamic updatedAt;

    DataAllDes({
        required this.id,
        required this.description,
        required this.price,
        required this.unit,
    });

    factory DataAllDes.fromJson(Map<String, dynamic> json) => DataAllDes(
        id: json["id"],
        description: json["description"],
        price: json["price"],
        unit: json["unit"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "price": price,
        "unit": unit,
    };
}
