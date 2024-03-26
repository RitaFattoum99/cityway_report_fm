// To parse this JSON data, do
//
//     final report = reportFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

String reportToJson(Report data) => json.encode(data.toJson());

class Report {
  int status;
  Data data;
  String message;

  Report({
    required this.status,
    required this.data,
    required this.message,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  int? id;
  String? qrCode;
  String? project;
  String? location;
  String? googleMapLocation;
  int? complaintPartyId;
  String? complaintNumber;
  DateTime? complaintDate;
  DateTime? reportDate;
  String? typeOfWork;
  int? contractNumber;
  DateTime? startingDateOfWork;
  DateTime? finishingDateOfWork;
  String? statusClient;
  String? statusAdmin;
  int? urgent;
  int? budget;
  String? complaintParty;
  List<ContactInfo>? contactInfo;
  List<ReportJobDescription>? reportJobDescription;
  List<ReportDescription>? reportDescription;

  Data({
    this.id,
    this.qrCode,
    this.project,
    this.location,
    this.googleMapLocation,
    this.complaintPartyId,
    this.complaintNumber,
    this.complaintDate,
    this.reportDate,
    this.typeOfWork,
    this.contractNumber,
    this.startingDateOfWork,
    this.finishingDateOfWork,
    this.statusClient,
    this.statusAdmin,
    this.urgent,
    this.budget,
    this.complaintParty,
    this.contactInfo,
    this.reportJobDescription,
    this.reportDescription,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        qrCode: json["qr_code"],
        project: json["project"],
        location: json["location"],
        googleMapLocation: json["google_map_location"],
        complaintPartyId: json["complaint_party_id"],
        complaintNumber: json["complaint_number"],
        complaintDate: DateTime.parse(json["complaint_date"]),
        reportDate: DateTime.parse(json["report_date"]),
        typeOfWork: json["type_of_work"],
        contractNumber: json["contract_number"],
        startingDateOfWork: json["starting_date_of_work"],
        finishingDateOfWork: json["finishing_date_of_work"],
        statusClient: json["status_client"],
        statusAdmin: json["status_admin"],
        urgent: json["urgent"],
        budget: json["budget"],
        complaintParty: json["complaint_party"],
        contactInfo: List<ContactInfo>.from(
            json["contact_info"].map((x) => ContactInfo.fromJson(x))),
        reportJobDescription: List<ReportJobDescription>.from(
            json["report_job_description"].map((x) => x)),
        reportDescription: List<ReportDescription>.from(
            json["report_description"]
                .map((x) => ReportDescription.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "qr_code": qrCode,
        "project": project,
        "location": location,
        "google_map_location": googleMapLocation,
        "complaint_party_id": complaintPartyId,
        "complaint_number": complaintNumber,
        "complaint_date":
            "${complaintDate?.year.toString().padLeft(4, '0')}-${complaintDate?.month.toString().padLeft(2, '0')}-${complaintDate?.day.toString().padLeft(2, '0')}",
        "report_date":
            "${reportDate?.year.toString().padLeft(4, '0')}-${reportDate?.month.toString().padLeft(2, '0')}-${reportDate?.day.toString().padLeft(2, '0')}",
        "type_of_work": typeOfWork,
        "contract_number": contractNumber,
        "starting_date_of_work": startingDateOfWork,
        "finishing_date_of_work": finishingDateOfWork,
        "status_client": statusClient,
        "status_admin": statusAdmin,
        "urgent": urgent,
        "budget": budget,
        "complaint_party": complaintParty,
        "contact_info": List<dynamic>.from(contactInfo!.map((x) => x.toJson())),
        "report_job_description":
            List<dynamic>.from(reportJobDescription!.map((x) => x)),
        "report_description":
            List<dynamic>.from(reportDescription!.map((x) => x.toJson())),
      };
}

class ContactInfo {
  int? id;
  String? name;
  String? position;
  String? phone;
  String? financialNumber;
  Pivot? pivot;

  ContactInfo({
    this.id,
    this.name,
    this.position,
    this.phone,
    this.financialNumber,
    this.pivot,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) => ContactInfo(
        id: json["id"],
        name: json["name"],
        position: json["position"],
        phone: json["phone"],
        financialNumber: json["financial_number"],
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "position": position,
        "phone": phone,
        "financial_number": financialNumber,
        "pivot": pivot!.toJson(),
      };
}

class Pivot {
  int reportId;
  int contactInfoId;
  int id;

  Pivot({
    required this.reportId,
    required this.contactInfoId,
    required this.id,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        reportId: json["report_id"],
        contactInfoId: json["contact_info_id"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "report_id": reportId,
        "contact_info_id": contactInfoId,
        "id": id,
      };
}

class ReportDescription {
  int? id;
  int? reportId;
  String? description;
  String? note;
  File? desImg;

  ReportDescription({
    this.id,
    this.reportId,
    this.description,
    this.note,
    this.desImg,
  });

  factory ReportDescription.fromJson(Map<String, dynamic> json) =>
      ReportDescription(
        id: json["id"],
        reportId: json["report_id"],
        description: json["description"],
        note: json["note"],
        desImg: json["des_img"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "report_id": reportId,
        "description": description,
        "note": note,
        "des_img": desImg,
      };
}

class ReportJobDescription {
  int id;
  int reportId;
  int jobDescriptionId;
  String desImg;
  String afterDesImg;
  int price;
  int quantity;
  dynamic note;
  JobDescription jobDescription;

  ReportJobDescription({
    required this.id,
    required this.reportId,
    required this.jobDescriptionId,
    required this.desImg,
    required this.afterDesImg,
    required this.price,
    required this.quantity,
    required this.note,
    required this.jobDescription,
  });

  factory ReportJobDescription.fromJson(Map<String, dynamic> json) =>
      ReportJobDescription(
        id: json["id"],
        reportId: json["report_id"],
        jobDescriptionId: json["job_description_id"],
        desImg: json["des_img"],
        afterDesImg: json["after_des_img"],
        price: json["price"],
        quantity: json["quantity"],
        note: json["note"],
        jobDescription: JobDescription.fromJson(json["job_description"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "report_id": reportId,
        "job_description_id": jobDescriptionId,
        "des_img": desImg,
        "after_des_img": afterDesImg,
        "price": price,
        "quantity": quantity,
        "note": note,
        "job_description": jobDescription.toJson(),
      };
}

class JobDescription {
  int? id;
  String? description;
  int? price;
  String? unit;

  JobDescription({
    this.id,
    this.description,
    this.price,
    this.unit,
  });

  factory JobDescription.fromJson(Map<String, dynamic> json) => JobDescription(
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
