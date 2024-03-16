// ignore_for_file: avoid_print, library_prefixes, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';
import '/core/config/service_config.dart';
import '/create_report/complaint_party_model.dart'
    as ComplaintPartyModel;
import '/create_report/report_model.dart';
import 'package:http/http.dart' as http;

class ReportService {
  var message;
  var url = Uri.parse(ServiceConfig.domainNameServer + ServiceConfig.create);
  Future<bool> create(Data report, String token) async {
    print("create");
    final request = http.MultipartRequest('POST', url)
      ..fields['project'] = report.project
      ..fields['location'] = report.location
      ..fields['report_number'] = report.reportNumber
      ..fields['complaint_party_id'] = report.complaintPartyId.toString()
      ..fields['contact_name'] = report.contactName
      ..fields['contact_position'] = report.contactPosition
      ..fields['contact_number'] = report.contactNumber
      ..fields['type_of_work'] = report.typeOfWork;

    final List<String?> jobDescriptions =
        report.jobDescription.map((jobDesc) => jobDesc.description).toList();

    for (int i = 0; i < jobDescriptions.length; i++) {
      final jobDesc = report.jobDescription[i];
      request.fields['job_descriptions[$i][description]'] =
          jobDesc.description.toString();

      if (jobDesc.desImg != null) {
        if (jobDesc.desImg != null) {
          // Convert image to base64
          final bytes = await File(jobDesc.desImg!.path).readAsBytes();
          String imageName = File(jobDesc.desImg!.path).path.split("/").last;

          // Add base64-encoded image to the request
          request.fields['job_descriptions[$i][des_img]'] = imageName;

          // Add image as a file to the request
          request.files.add(http.MultipartFile.fromBytes(
            'job_descriptions[$i][des_img]',
            bytes,
            filename: imageName,
          ));
        }
      }
    }
    // Print the entire request just before sending
    print('Final Request: ${request.fields}');
    print('Files: ${request.files}');
    print(request.fields);

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Connection': 'keep-alive',
      'Accept-Encoding': 'gzip, deflate, br',
      'User-Agent': 'PostmanRuntime/7.36.3',
    });
    print("request.fields");

    final response = await request.send();

    final Map<String, dynamic> jsonResponse =
        json.decode(await response.stream.bytesToString());
    print("Raw Response: $jsonResponse");
    print("Status Code: ${response.statusCode}");
    print("message: ${jsonEncode(message)}");
    if (jsonResponse.containsKey('message')) {
      message = jsonResponse['message'];
      print(message);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.statusCode);
        return true;
      } else {
        print(message);
      }
      print(response.statusCode);
      print(message);
      return true;
    } else if (response.statusCode == 422) {
      print(response.statusCode);
      print(message);
      return false;
    } else if (response.statusCode == 500) {
      print(response.statusCode);
      print(message);
      return false;
    } else {
      print(response.statusCode);
      print(message);
      return false;
    }
  }

  var urlget =
      Uri.parse(ServiceConfig.domainNameServer + ServiceConfig.complaintParty);
  Future<List<ComplaintPartyModel.DataComplaintParty>> getComplaintList(
      String token) async {
    final response = await http.get(urlget, headers: {
      'Authorization': 'Bearer $token',
    });

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var complaintList =
          ComplaintPartyModel.ComplaintParty.fromJson(jsonResponse);
      return complaintList.data;
    } else {
      print("Failed to load ComplaintParty list");
      throw Exception('Failed to load ComplaintParty list');
    }
  }


}
