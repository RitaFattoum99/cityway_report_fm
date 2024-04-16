// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../homepage/allreport_model.dart';
import '/core/config/service_config.dart';
import 'package:http/http.dart' as http;

class EditReportService {
  var message = '';
  Future<bool> editReports(
      List<ReportJobDescription> reportJobDescription,
      String token,
      int reportId,
      String workOrder,
      int isDraft,
      File? responsibleSignatureFile,
      int responsibleSatisfaction,
      String responsibleNote) async {
    try {
      var url = Uri.parse(
          '${ServiceConfig.domainNameServer}${ServiceConfig.edit}/$reportId');
      final request = http.MultipartRequest('POST', url)
        ..fields['draft'] = isDraft.toString()
        ..fields['client_notes'] = responsibleNote;
      request.fields['client_satisfaction'] =
          responsibleSatisfaction.toString();

      // // Only add the file if it's not null
      // if (responsibleSignatureFile != null) {
      //   request.files.add(http.MultipartFile(
      //     'client_signature',
      //     responsibleSignatureFile.readAsBytes().asStream(),
      //     responsibleSignatureFile.lengthSync(),
      //     filename: 'توقيع المسؤول.png',
      //     contentType: MediaType('image', 'png'),
      //   ));
      // }
// Assuming responsibleSignatureFile is a File object
      if (responsibleSignatureFile != null) {
        // Check if the file exists at the given path
        if (await responsibleSignatureFile.exists()) {
          try {
            // Add the file to the request
            request.files.add(http.MultipartFile(
              'client_signature',
              responsibleSignatureFile.readAsBytes().asStream(),
              await responsibleSignatureFile.length(),
              filename: 'توقيع المسؤول.png',
              contentType: MediaType('image', 'png'),
            ));
          } catch (e) {
            // Handle errors (e.g., file read errors) gracefully
            print('Error adding file to the request: $e');
          }
        } else {
          // File does not exist at the provided path
          print(
              'File does not exist at path: ${responsibleSignatureFile.path}');
        }
      } else {
        // responsibleSignatureFile is null
        print('No file selected');
      }

      // Prepare for parallel image processing
      List<Future<void>> imageFutures = [];

      for (int i = 0; i < reportJobDescription.length; i++) {
        var jobDesc = reportJobDescription[i];

        if (jobDesc.jobDescriptionId != null) {
          request.fields['report_job_description[$i][job_description_id]'] =
              jobDesc.jobDescriptionId.toString();
        }

        request.fields['report_job_description[$i][description]'] =
            jobDesc.jobDescription!.description!;

        if (jobDesc.price != null) {
          request.fields['report_job_description[$i][price]'] =
              jobDesc.price.toString();
        }
        if (jobDesc.quantity != null) {
          request.fields['report_job_description[$i][quantity]'] =
              jobDesc.quantity.toString();
        }
        if (jobDesc.totalPrice != null) {
          request.fields['report_job_description[$i][total_price]'] =
              jobDesc.totalPrice.toString();
        }
        request.fields['report_job_description[$i][unit]'] =
            jobDesc.jobDescription!.unit.toString();

        request.fields['report_job_description[$i][note]'] =
            jobDesc.note.toString();

        // Prepare image processing in parallel
        if (jobDesc.desImg != null) {
          imageFutures.add(_processAndAddImage(
              jobDesc.desImg!, 'report_job_description[$i][des_img]', request));
        }
        if (jobDesc.afterDesImg != null) {
          imageFutures.add(_processAndAddImage(jobDesc.afterDesImg!,
              'report_job_description[$i][after_des_img]', request));
        }
      }
      // Wait for all image processing to complete
      await Future.wait(imageFutures);
      // Print the entire request just before sending
      print('Final Request: ${request.fields}');
      print('Files: ${request.files}');
      print(request.fields);
      print("reportId: $reportId");
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

  Future<bool> rating(
      List<ReportJobDescription> reportJobDescription,
      String token,
      int reportId,
      int isDraft,
      File? responsibleSignatureFile,
      int responsibleSatisfaction,
      String responsibleNote) async {
    try {
      var url = Uri.parse(
          '${ServiceConfig.domainNameServer}${ServiceConfig.edit}/$reportId');
      final request = http.MultipartRequest('POST', url)
        ..fields['draft'] = isDraft.toString()
        ..fields['client_notes'] = responsibleNote
        ..fields['client_satisfaction'] = responsibleSatisfaction.toString()
        ..files.add(http.MultipartFile(
          'client_signatureure',
          responsibleSignatureFile!.readAsBytes().asStream(),
          responsibleSignatureFile.lengthSync(),
          filename: 'توقيع المسؤول.png',
          contentType: MediaType('image', 'png'),
        ));

      print('Final Request: ${request.fields}');
      print('Files: ${request.files}');
      print(request.fields);
      print("reportId: $reportId");
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Connection': 'keep-alive',
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        message = jsonResponse['message'] ?? "";
        print("Response: $jsonResponse");
        print("Status Code: ${response.statusCode}");
        print("message: ${jsonEncode(message)}");
        return true;
      } else {
        print("Response: $jsonResponse");
        print("Status Code: ${response.statusCode}");
        print("message: ${jsonEncode(message)}");
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

  Future<void> _processAndAddImage(
      String imagePath, String fieldName, http.MultipartRequest request) async {
    File imageFile = await processImage(imagePath);
    var stream = http.ByteStream(imageFile.openRead())..cast<List<int>>();
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile(fieldName, stream, length,
        filename: basename(imageFile.path));
    request.files.add(multipartFile);
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

  Future<bool> accceptance(
      int approval, int reportId, String token, String note) async {
    var url = Uri.parse(
        '${ServiceConfig.domainNameServer}${ServiceConfig.adminApproval}/$reportId?admin_revision=$approval&admin_notes=$note');
    print('url: $url');
    print("accceptance");
    print("note: $note");
    print("admin_revision: $approval");

    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'User-Agent': 'PostmanRuntime/7.37.0',
      'Connection': 'keep-alive'
    });

    print(response.statusCode);
    print(response.body);
    var jsonresponse = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonresponse = jsonDecode(response.body);
      message = jsonresponse['message'];
      print(message);
      return true;
    } else if (response.statusCode == 422 || response.statusCode == 500) {
      message = jsonresponse['message'];
      print(message);
      return false;
    } else {
      message = jsonresponse['message'];
      print(message);
      return false;
    }
  }
}
