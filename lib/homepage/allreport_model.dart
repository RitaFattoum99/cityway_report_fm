// To parse this JSON data, do
//
//     final allreports = allreportsFromJson(jsonString);

import 'dart:convert';

import 'package:cityway_report_fm/material_model.dart';

Allreports allreportsFromJson(String str) =>
    Allreports.fromJson(json.decode(str));

String allreportsToJson(Allreports data) => json.encode(data.toJson());

class Allreports {
  int status;
  List<DataAllReport> data;
  String message;

  Allreports({
    required this.status,
    required this.data,
    required this.message,
  });

  factory Allreports.fromJson(Map<String, dynamic> json) => Allreports(
        status: json['status'],
        data: List<DataAllReport>.from(
            json["data"].map((x) => DataAllReport.fromJson(x))),
        message: json['message'],
      );
  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class DataAllReport {
  int? id;
  int? userId;
  String? qrCode;
  String? project;
  String? location;
  int? complaintPartyId;
  String? reportNumber;
  DateTime? reportDate;
  String? contactName;
  String? contactPosition;
  String? contactNumber;
  String? contactInfo;
  DateTime? complaintDate;
  String? typeOfWork;
  String? contractNumber;
  String? startingDateOfWork;
  DateTime? finishingDateOfWork;
  String? madeBy;
  String? revisedBy;
  int? fmeId;
  DateTime? fmeDate;
  int? estimationId;
  DateTime? estimationDate;
  String? acceptedBy;
  String? client;
  DateTime? clientDate;
  String? clientNotes;
  String? clientSignature;
  String? clientSatisfaction;
  String? notes;
  String? statusClient;
  String? statusAdmin;
  String? uuid;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fmeSignature;
  String? estimationSignature;
  List<JobDescription>? jobDescription;
  String? fmeEmployee;
  String? estimationEmployee;
  ComplaintParty? complaintParty;

  DataAllReport({
    this.id,
    this.userId,
    this.qrCode,
    this.project,
    this.location,
    this.complaintPartyId,
    this.reportNumber,
    this.reportDate,
    this.contactName,
    this.contactPosition,
    this.contactNumber,
    this.contactInfo,
    this.complaintDate,
    this.typeOfWork,
    this.contractNumber,
    this.startingDateOfWork,
    this.finishingDateOfWork,
    this.madeBy,
    this.revisedBy,
    this.fmeId,
    this.fmeDate,
    this.estimationId,
    this.estimationDate,
    this.acceptedBy,
    this.client,
    this.clientDate,
    this.clientNotes,
    this.clientSignature,
    this.clientSatisfaction,
    this.notes,
    this.statusClient,
    this.statusAdmin,
    this.uuid,
    this.createdAt,
    this.updatedAt,
    this.fmeSignature,
    this.estimationSignature,
    this.jobDescription,
    this.fmeEmployee,
    this.estimationEmployee,
    this.complaintParty,
  });

  factory DataAllReport.fromJson(Map<String, dynamic> json) => DataAllReport(
        id: json["id"],
        userId: int.tryParse(json["user_id"]) ?? 0,
        qrCode: json["qr_code"],
        project: json["project"],
        location: json["location"],
        complaintPartyId: int.tryParse(json["complaint_party_id"]) ?? 0,
        reportNumber: json["report_number"],
        reportDate: DateTime.parse(json["report_date"]),
        contactName: json["contact_name"],
        contactPosition: json["contact_position"],
        contactNumber: json["contact_number"],
        contactInfo: json["contact_info"],
        complaintDate:
            DateTime.parse(json["complaint_date"] ?? DateTime.now().toString()),
        typeOfWork: json["type_of_work"],
        contractNumber: json["contract_number"],
        startingDateOfWork: json["starting_date_of_work"],
        finishingDateOfWork: json["finishing_date_of_work"],
        madeBy: json["made_by"],
        revisedBy: json["revised_by"],
        fmeId: json["fme_id"] != null ? int.tryParse(json["fme_id"]) ?? 0 : 0,
        fmeDate: DateTime.parse(json["fme_date"] ?? DateTime.now().toString()),
        estimationId: json["estimation_id"] != null
            ? int.tryParse(json["estimation_id"]) ?? 0
            : 0,
        estimationDate: DateTime.parse(
            json["estimation_date"] ?? DateTime.now().toString()),
        acceptedBy: json["accepted_by"],
        client: json["client"],
        clientDate: json["client_date"],
        clientNotes: json["client_notes"],
        clientSignature: json["client_signature"],
        clientSatisfaction: json["client_satisfaction"],
        notes: json["notes"],
        statusClient: json["status_client"],
        statusAdmin: json["status_admin"],
        uuid: json["uuid"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        fmeSignature: json["fme_signature"],
        estimationSignature: json["estimation_signature"],
        jobDescription: List<JobDescription>.from(
            json["job_description"].map((x) => JobDescription.fromJson(x))),
        fmeEmployee: json["fme_employee"] is String ? json["fme_employee"] : '',
        estimationEmployee: json["estimation_employee"] is String
            ? json["estimation_employee"]
            : null,
        complaintParty: ComplaintParty.fromJson(json["complaint_party"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "qr_code": qrCode,
        "project": project,
        "location": location,
        "complaint_party_id": complaintPartyId,
        "report_number": reportNumber,
        "report_date":
            "${reportDate!.year.toString().padLeft(4, '0')}-${reportDate!.month.toString().padLeft(2, '0')}-${reportDate!.day.toString().padLeft(2, '0')}",
        "contact_name": contactName,
        "contact_position": contactPosition,
        "contact_number": contactNumber,
        "contact_info": contactInfo,
        "complaint_date": complaintDate,
        "type_of_work": typeOfWork,
        "contract_number": contractNumber,
        "starting_date_of_work": startingDateOfWork,
        "finishing_date_of_work": finishingDateOfWork,
        "made_by": madeBy,
        "revised_by": revisedBy,
        "fme_id": fmeId,
        "fme_date": fmeDate,
        "estimation_id": estimationId,
        "estimation_date": estimationDate,
        "accepted_by": acceptedBy,
        "client": client,
        "client_date": clientDate,
        "client_notes": clientNotes,
        "client_signature": clientSignature,
        "client_satisfaction": clientSatisfaction,
        "notes": notes,
        "status_client": statusClient,
        "status_admin": statusAdmin,
        "uuid": uuid,
        "fme_signature": fmeSignature,
        "estimation_signature": estimationSignature,
        "job_description":
            List<dynamic>.from(jobDescription!.map((x) => x.toJson())),
        "fme_employee": fmeEmployee,
        "estimation_employee": estimationEmployee,
        "complaint_party": complaintParty!.toJson(),
      };
}

class ComplaintParty {
  int id;
  String name;
  dynamic createdAt;
  dynamic updatedAt;

  ComplaintParty({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ComplaintParty.fromJson(Map<String, dynamic> json) => ComplaintParty(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class JobDescription {
  int? id;
  int? reportId;
  dynamic materialId;
  String description;
  String? desImg;
   bool isDefaultImage = true;
  String? afterDesImg;
  int price;
  int quantity;
  DataMaterial? material;

  JobDescription({
    this.id,
    this.reportId,
    required this.materialId,
    required this.description,
    this.desImg,
    this.isDefaultImage = true,
    this.afterDesImg,
    required this.price,
    required this.quantity,
    this.material,
  });

  factory JobDescription.fromJson(Map<String, dynamic> json) {
    return JobDescription(
      id: json['id'] is String ? int.tryParse(json['id']) : json['id'],
      reportId: json["report_id"] is String
          ? int.tryParse(json["report_id"])
          : json["report_id"],
      materialId: json[
          'material_id'], // Assuming this can be dynamic as originally intended
      description: json['description'] ?? '',
      desImg: json['des_img'],
      afterDesImg: json['after_des_img'],
      price:
          json["price"] is String ? int.tryParse(json["price"]) : json["price"],
      quantity: json["quantity"] is String
          ? int.tryParse(json["quantity"])
          : json["quantity"],
      material: json['material'] != null
          ? DataMaterial.fromJson(json['material'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'report_id': reportId,
      'material_id': materialId,
      'description': description,
      'des_img': desImg,
      'after_des_img': afterDesImg,
      'price': price,
      'quantity': quantity,
      'material': material?.toJson(),
    };
  }
}

// class JobDescription {
//   int? id;
//   int? reportId;
//   dynamic materialId;
//   String description;
//   String? desImg;
//   String? afterDesImg;
//   int price;
//   int quantity;
//   DataMaterial? material;

//   JobDescription({
//     this.id,
//     this.reportId,
//     required this.materialId,
//     required this.description,
//     this.desImg,
//     this.afterDesImg,
//     required this.price,
//     required this.quantity,
//     this.material,
//   });

//   factory JobDescription.fromJson(Map<String, dynamic> json) => JobDescription(
//         id: json["id"],
//         reportId: int.tryParse(json["report_id"]) ?? 0,
//         materialId: json["material_id"],
//         description: json["description"] ?? '',
//         desImg: json["des_img"],
//         afterDesImg: json["after_des_img"],
//         price: int.tryParse(json["price"]) ?? 0,
//         quantity: int.tryParse(json["quantity"]) ?? 0,
//         material: json["material"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "report_id": reportId,
//         "material_id": materialId,
//         "description": description,
//         "des_img": desImg,
//         "after_des_img": afterDesImg,
//         "price": price,
//         "quantity": quantity,
//         "material": material,
//       };
// }
