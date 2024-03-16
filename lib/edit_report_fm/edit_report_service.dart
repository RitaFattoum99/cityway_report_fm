import 'dart:convert';

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

  /*Future<void> editReports(
      List<JobDescription> jobDescriptions, String token, int reportId) async {
    try {
      final List<Map<String, dynamic>> requestBody = jobDescriptions
          .asMap()
          .entries
          .map((entry) => {
                'job_descriptions[${entry.key}][id]': entry.key.toString(),
                'job_descriptions[${entry.key}][material_id]':
                    entry.value.materialId,
                'job_descriptions[${entry.key}][description]':
                    entry.value.description,
                'job_descriptions[${entry.key}][price]': entry.value.price,
                'job_descriptions[${entry.key}][quantity]':
                    entry.value.quantity,
                //   'job_descriptions[${entry.key}][des_img]': entry.value.desImg,
              })
          .toList();
      final String jsonBody = jsonEncode(requestBody); // Convert to JSON string
      var url = Uri.parse(
          '${ServiceConfig.domainNameServer}${ServiceConfig.edit}/$reportId');
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonBody, // Use JSON string as request body
      );
      print("jsonBody: $jsonBody");
      if (response.statusCode == 200 || response.statusCode == 201) {
        message = "Report Edited Successfully";
        print(response.statusCode);
        print(response.body);
      } else if (response.statusCode == 422) {
        message = "please verify your information";
        print(response.statusCode);
        print(response.body);
      } else if (response.statusCode == 500) {
        message = "server error";
        print(response.statusCode);
      } else {
        message = "there is error..";
        print(response.statusCode);
      }
    } catch (error) {
      throw Exception('Failed to edit reports: $error');
    }
  }
*/
  /*Future<void> editReports(
      List<JobDescription> jobDescriptions, String token, int reportId) async {
    print(" report id : $reportId");
    try {
      final List<Map<String, dynamic>> requestBody = jobDescriptions
          .asMap()
          .entries
          .map((entry) => {
                'job_descriptions[${entry.key}][id]': entry.key.toString(),
                'job_descriptions[${entry.key}][material_id]':
                    entry.value.materialId,
                'job_descriptions[${entry.key}][description]':
                    entry.value.description,
                'job_descriptions[${entry.key}][price]': entry.value.price,
                'job_descriptions[${entry.key}][quantity]':
                    entry.value.quantity,
                // Uncomment and adjust as necessary
                // 'job_descriptions[${entry.key}][des_img]': entry.value.desImg,
              })
          .toList();
      final String jsonBody = jsonEncode(requestBody);
      var url = Uri.parse(
          '${ServiceConfig.domainNameServer}${ServiceConfig.edit}/$reportId');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
        body: jsonBody,
      );
      print("jsonBody: $jsonBody");
      print("statusCode: ${response.statusCode}");
      print("body: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        message = "Report Edited Successfully";
        // Handle successful response
      } else {
        // Handle other statuses
      }
    } catch (error) {
      throw Exception('Failed to edit reports: $error');
    }
  }
*/
Future<void> editReports(List<JobDescription> jobDescriptions, String token, int reportId) async {
  print("report id: $reportId");
  try {
    var url = Uri.parse('${ServiceConfig.domainNameServer}${ServiceConfig.edit}/$reportId');
    final request = http.MultipartRequest('POST', url);

    // Adding fields from jobDescriptions
    for (int i = 0; i < jobDescriptions.length; i++) {
      request.fields['job_descriptions[$i][id]'] = jobDescriptions[i].id.toString();
      request.fields['job_descriptions[$i][material_id]'] = jobDescriptions[i].materialId.toString();
      request.fields['job_descriptions[$i][description]'] = jobDescriptions[i].description;
      request.fields['job_descriptions[$i][price]'] = jobDescriptions[i].price.toString();
      request.fields['job_descriptions[$i][quantity]'] = jobDescriptions[i].quantity.toString();
      
      // Example for handling image upload, similar to the create function
      // Uncomment and adjust as necessary
      /*
      if (jobDescriptions[i].desImg != null) {
        final bytes = await File(jobDescriptions[i].desImg!.path).readAsBytes();
        String imageName = File(jobDescriptions[i].desImg!.path).path.split("/").last;

        // Add image as a file to the request
        request.files.add(http.MultipartFile.fromBytes(
          'job_descriptions[$i][des_img]',
          bytes,
          filename: imageName,
        ));
      }
      */
    }

    // Set headers
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    // Send the request
    final response = await request.send();
    
    // Read the response
    final responseBody = await response.stream.bytesToString();
    final jsonResponse = jsonDecode(responseBody);
    print("statusCode: ${response.statusCode}");
    print("body: $jsonResponse");

    if (response.statusCode == 200 || response.statusCode == 201) {
      message = "Report Edited Successfully";
      // Handle successful response
    } else {
      // Handle other statuses
      print("Error: $responseBody");
      message = "Failed to edit report";
    }
  } catch (error) {
    throw Exception('Failed to edit reports: $error');
  }
}

}
