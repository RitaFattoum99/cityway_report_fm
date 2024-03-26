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
  String username;

  DataComplaintParty({
    required this.id,
    required this.username,
  });

  factory DataComplaintParty.fromJson(Map<String, dynamic> json) =>
      DataComplaintParty(
        id: json["id"],
        username: json["username"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
      };
}
