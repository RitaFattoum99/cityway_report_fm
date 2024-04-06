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
      String token, int reportId, String workOrder) async {
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

        if (reportJobDescription[i].price != null) {
          request.fields['report_job_description[$i][price]'] =
              reportJobDescription[i].price.toString();
        }
        // request.fields['report_job_description[$i][quantity]'] =
        //     reportJobDescription[i].quantity.toString();
        if (reportJobDescription[i].quantity != null) {
          request.fields['report_job_description[$i][quantity]'] =
              reportJobDescription[i].quantity.toString();
        } else {}
        if (reportJobDescription[i].totalPrice != null) {
          request.fields['report_job_description[$i][total_price]'] =
              reportJobDescription[i].totalPrice.toString();
        }
        request.fields['report_job_description[$i][unit]'] =
            reportJobDescription[i].jobDescription!.unit.toString();

        request.fields['report_job_description[$i][note]'] =
            reportJobDescription[i].note.toString();

        if (reportJobDescription[i].desImg != null) {
          File imageFile = await processImage(reportJobDescription[i].desImg!);
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

        if (reportJobDescription[i].afterDesImg != null) {
          File imageFile =
              await processImage(reportJobDescription[i].afterDesImg!);
          var stream = http.ByteStream(imageFile.openRead())..cast<List<int>>();
          var length = await imageFile.length();
          var multipartFile = http.MultipartFile(
            'report_job_description[$i][after_des_img]',
            stream,
            length,
            filename: basename(imageFile.path),
          );
          request.files.add(multipartFile);
        }
      }
      // Print the entire request just before sending
      print('Final Request: ${request.fields}');
      print('Files: ${request.files}');
      print(request.fields);
      print("reportId: $reportId");
      print("work  order: $workOrder");
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Connection': 'keep-alive',
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        message = jsonResponse['message'] ?? "بانتظار موافقة مقدم البلاغ";
        print("Response: $jsonResponse");
        print("Status Code: ${response.statusCode}");
        print("message: ${jsonEncode(message)}");
        return true;
      } else {
        print("Response: $jsonResponse");
        print("Status Code: ${response.statusCode}");
        print("message: ${jsonEncode(message)}");
        // message = jsonResponse['message'] ?? "حدث خطـأ بالإرسال";
        if (jsonResponse['message'] is Map) {
          message = jsonEncode(jsonResponse['message']);
        } else {
          message = jsonResponse['message'] ?? "حدث خطـأ بالإرسال";
        }
        return false;
      }
    } catch (e) {
      message = 'Exception caught: $e';
      return false;
    }
  }

  Future<File> processImage(String imagePath) async {
    Uri imageUri = Uri.parse(imagePath);

    // Check if the URI is a file path or a network URL
    if (imageUri.scheme.contains('http')) {
      // It's a URL, download the image
      return await downloadImage(imageUri.toString());
    } else {
      // It's a local file path, no need to download
      return File(imagePath);
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

  // Future<void> uploadPDFFile(File file, String token, int reportId) async {
  //   Uri uri = Uri.parse(
  //       '${ServiceConfig.domainNameServer}${ServiceConfig.edit}/$reportId');
  //   http.MultipartRequest request = http.MultipartRequest('POST', uri)
  //     ..headers.addAll({
  //       "Authorization": "Bearer $token",
  //     })
  //     ..files.add(await http.MultipartFile.fromPath(
  //       'work_order',
  //       file.path,
  //     ));

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     print("File uploaded successfully");
  //   } else {
  //     print("Failed to upload file. Status code: ${response.statusCode}");
  //   }
  // }
  Future<void> uploadPDFFile(File file, String token, int reportId) async {
    // First, check if the file exists
    if (!file.existsSync()) {
      print("File does not exist at path: ${file.path}");
      return;
    }

    // Continue with the upload if the file exists
    Uri uri = Uri.parse(
        '${ServiceConfig.domainNameServer}${ServiceConfig.edit}/$reportId');
    http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        "Authorization": "Bearer $token",
      })
      ..files.add(await http.MultipartFile.fromPath(
        'work_order',
        file.path,
      ));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("File uploaded successfully");
    } else {
      print("Failed to upload file. Status code: ${response.statusCode}");
    }
  }
}
