// ignore_for_file: avoid_print,
import 'dart:convert';
import 'dart:io';
import '/core/config/service_config.dart';
// ignore: library_prefixes
import '/create_report/complaint_party_model.dart' as ComplaintPartyModel;
import '/create_report/report_model.dart';
import 'package:http/http.dart' as http;

class ReportService {
  // ignore: prefer_typing_uninitialized_variables
  var message;
  Uri url =
      Uri.parse('${ServiceConfig.domainNameServer}${ServiceConfig.create}');

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

    for (int i = 0; i < report.jobDescription.length; i++) {
      final jobDesc = report.jobDescription[i];
      request.fields['job_descriptions[$i][description]'] =
          jobDesc.description ?? '';

      if (jobDesc.desImg != null) {
        final bytes = await File(jobDesc.desImg!.path).readAsBytes();
        String imageName = File(jobDesc.desImg!.path).path.split("/").last;
        request.fields['job_descriptions[$i][des_img]'] = imageName;
        request.files.add(http.MultipartFile.fromBytes(
          'job_descriptions[$i][des_img]',
          bytes,
          filename: imageName,
        ));
      }
    }

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Connection': 'keep-alive',
      'Accept-Encoding': 'gzip, deflate, br',
      'User-Agent': 'PostmanRuntime/7.36.3',
    });

    final response = await request.send();

    // Enhanced error handling
    if (response.statusCode != 200 && response.statusCode != 201) {
      String responseBody = await response.stream.bytesToString();
      if (responseBody.startsWith('<html>')) {
        print("Received HTML response: $responseBody");
        throw Exception(
            'Received HTML response. Possible server issue or wrong URL.');
      }
      // Handling JSON response
      try {
        final Map<String, dynamic> jsonResponse = json.decode(responseBody);
        print("Raw Response: $jsonResponse");
        message = jsonResponse['message'] ?? 'Unknown error occurred.';
      } catch (e) {
        throw FormatException(
            'Failed to decode response: $responseBody', e.toString());
      }
      return false;
    }

    final Map<String, dynamic> jsonResponse =
        json.decode(await response.stream.bytesToString());
    message = jsonResponse['message'];
    return true;
  }

  Uri urlget = Uri.parse(
      '${ServiceConfig.domainNameServer}${ServiceConfig.complaintParty}');

  Future<List<ComplaintPartyModel.DataComplaintParty>> getComplaintList(
      String token) async {
    final response = await http.get(urlget, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        final complaintList =
            ComplaintPartyModel.ComplaintParty.fromJson(jsonResponse);
        return complaintList.data;
      } catch (e) {
        throw FormatException(
            'Failed to decode response: ${response.body}', e.toString());
      }
    } else {
      print(
          "Failed to load ComplaintParty list with status code: ${response.statusCode}");
      throw Exception('Failed to load ComplaintParty list');
    }
  }
}
