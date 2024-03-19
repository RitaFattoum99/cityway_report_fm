// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '/core/config/service_config.dart';
import '/homepage/allreport_model.dart';
import '/material_model.dart';
import 'package:http/http.dart' as http;

class EditReportService {
  var message = '';
  var urlget =
      Uri.parse(ServiceConfig.domainNameServer + ServiceConfig.getListMaterial);
  Future<List<DataMaterial>> getMaterialList(String token) async {
    final response = await http.get(urlget, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var materialList = Material.fromJson(jsonResponse);
      print(materialList.data);
      return materialList.data;
    } else {
      print("Failed to load material list");
      throw Exception('Failed to load material list');
    }
  }

  /*Future<bool> editReports(
        List<JobDescription> jobDescriptions, String token, int reportId) async {
      try {
        var url = Uri.parse(
            '${ServiceConfig.domainNameServer}${ServiceConfig.edit}/$reportId');
        final request = http.MultipartRequest('POST', url);

        // Adding fields from jobDescriptions
        for (int i = 0; i < jobDescriptions.length; i++) {
          request.fields['job_descriptions[$i][id]'] =
              jobDescriptions[i].id.toString();
          request.fields['job_descriptions[$i][material_id]'] =
              jobDescriptions[i].materialId.toString();
          request.fields['job_descriptions[$i][description]'] =
              jobDescriptions[i].description;
          request.fields['job_descriptions[$i][price]'] =
              jobDescriptions[i].price.toString();
          request.fields['job_descriptions[$i][quantity]'] =
              jobDescriptions[i].quantity.toString();
        
          if (jobDescriptions[i].desImg != null) {
            var imageFile = File(jobDescriptions[i].desImg!);
            var stream = http.ByteStream(imageFile.openRead())..cast<List<int>>();
            var length = await imageFile.length();
            var multipartFile = http.MultipartFile(
              'job_descriptions[$i][des_img]',
              stream,
              length,
              filename: basename(imageFile.path),
            );
            request.files.add(multipartFile);
            print("multipartFile: $multipartFile");
          }
        }

        request.headers.addAll({
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);

        if (response.statusCode == 200 || response.statusCode == 201) {
          message = jsonResponse['message'] ?? "Report Edited Successfully";
          return true;
        } else {
          message = jsonResponse['error'] ?? "Failed to edit report";
          return false;
        }
      } catch (e) {
        message = 'Exception caught: $e';
        return false;
      }
    }
*/

  Future<File> downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final fileName = basename(url);
    final file = File('${documentDirectory.path}/$fileName');

    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<bool> editReports(
      List<JobDescription> jobDescriptions, String token, int reportId) async {
    try {
      var url = Uri.parse(
          '${ServiceConfig.domainNameServer}${ServiceConfig.edit}/$reportId');
      final request = http.MultipartRequest('POST', url);

      for (int i = 0; i < jobDescriptions.length; i++) {
        // Adding fields from jobDescriptions
        request.fields['job_descriptions[$i][id]'] =
            jobDescriptions[i].id.toString();
        request.fields['job_descriptions[$i][material_id]'] =
            jobDescriptions[i].materialId.toString();
        request.fields['job_descriptions[$i][description]'] =
            jobDescriptions[i].description;
        request.fields['job_descriptions[$i][price]'] =
            jobDescriptions[i].price.toString();
        request.fields['job_descriptions[$i][quantity]'] =
            jobDescriptions[i].quantity.toString();

        // Add non-image fields to the request as before
        request.fields['job_descriptions[$i][description]'] =
            jobDescriptions[i].description;

        if (jobDescriptions[i].desImg != null) {
          File imageFile;

          // Check if the image path is a remote URL
          if (jobDescriptions[i].desImg!.startsWith('http')) {
            // Download the image first
            imageFile = await downloadImage(jobDescriptions[i].desImg!);
          } else {
            // It's a local file path, use directly
            imageFile = File(jobDescriptions[i].desImg!);
          }

          var stream = http.ByteStream(imageFile.openRead())..cast<List<int>>();
          var length = await imageFile.length();

          var multipartFile = http.MultipartFile(
            'job_descriptions[$i][des_img]',
            stream,
            length,
            filename: basename(imageFile.path),
          );

          request.files.add(multipartFile);
        }
      }

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle success
        return true;
      } else {
        // Handle failure
        return false;
      }
    } catch (e) {
      // Handle exception
      return false;
    }
  }
}
