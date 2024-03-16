// To parse this JSON data, do
//
//     final complaintParty = complaintPartyFromJson(jsonString);

import 'dart:convert';

ComplaintParty complaintPartyFromJson(String str) =>
    ComplaintParty.fromJson(json.decode(str));

String complaintPartyToJson(ComplaintParty data) => json.encode(data.toJson());

class ComplaintParty {
  int status;
  List<DataComplaintParty> data;
  String message;

  ComplaintParty({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ComplaintParty.fromJson(Map<String, dynamic> json) => ComplaintParty(
        status: json["status"],
        data: List<DataComplaintParty>.from(
            json["data"].map((x) => DataComplaintParty.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class DataComplaintParty {
  int id;
  String name;

  DataComplaintParty({
    required this.id,
    required this.name,
  });

  factory DataComplaintParty.fromJson(Map<String, dynamic> json) =>
      DataComplaintParty(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
