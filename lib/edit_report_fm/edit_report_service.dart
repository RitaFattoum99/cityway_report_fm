// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../homepage/allreport_model.dart';
import '/core/config/service_config.dart';
import 'package:http/http.dart' as http;

class EditReportService {
  var message = '';

  Future<bool> editReports(List<ReportJobDescription> reportJobDescription,
      String token, int reportId) async {
    try {
      var url = Uri.parse(
          '${ServiceConfig.domainNameServer}${ServiceConfig.edit}/$reportId');
      final request = http.MultipartRequest('POST', url);

      // Adding fields from jobDescriptions
      for (int i = 0; i < reportJobDescription.length; i++) {
        if (reportJobDescription[i].jobDescriptionId != null) {
          request.fields['report_job_description[$i][job_description_id]'] =
              reportJobDescription[i].jobDescriptionId.toString();
        }

        request.fields['report_job_description[$i][description]'] =
            reportJobDescription[i].jobDescription!.description!;
        request.fields['report_job_description[$i][price]'] =
            reportJobDescription[i].price.toString();
        request.fields['report_job_description[$i][quantity]'] =
            reportJobDescription[i].quantity.toString();
        request.fields['report_job_description[$i][unit]'] =
            reportJobDescription[i].jobDescription!.unit.toString();

        request.fields['report_job_description[$i][note]'] =
            reportJobDescription[i].note.toString();

        if (reportJobDescription[i].desImg != null) {
          var imageFile = File(reportJobDescription[i].desImg!);
          var stream = http.ByteStream(imageFile.openRead())..cast<List<int>>();
          var length = await imageFile.length();
          var multipartFile = http.MultipartFile(
            'report_job_description[$i][des_img]',
            stream,
            length,
            filename: basename(imageFile.path),
          );
          request.files.add(multipartFile);
          print("multipartFile: $multipartFile");
        }
      }
      // Print the entire request just before sending
      print('Final Request: ${request.fields}');
      print('Files: ${request.files}');
      print(request.fields);
      print("reportId: $reportId");
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        message = jsonResponse['message'] ?? "Report Edited Successfully";
        print("Response: $jsonResponse");
        print("Status Code: ${response.statusCode}");
        print("message: ${jsonEncode(message)}");
        return true;
      } else {
        print("Response: $jsonResponse");
        print("Status Code: ${response.statusCode}");
        print("message: ${jsonEncode(message)}");
        message = jsonResponse['error'] ?? "Failed to edit report";
        return false;
      }
    } catch (e) {
      message = 'Exception caught: $e';
      return false;
    }
  }

  Future<File> downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final fileName = basename(url);
    final file = File('${documentDirectory.path}/$fileName');

    await file.writeAsBytes(response.bodyBytes);
    return file;
  }
}
