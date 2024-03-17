// ignore_for_file: avoid_print

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

  Future<bool> editReports(
      List<JobDescription> jobDescriptions, String token, int reportId) async {
    print("report id: $reportId");
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
        print(
            "material id in service: ${jobDescriptions[i].materialId.toString()}");
      }
      // Set headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',

      });

      // Send the request
      final response = await request.send();
      // Read the response
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      print("Raw response body: $responseBody");

      print("statusCode: ${response.statusCode}");
      print("body: $jsonResponse");

      if (response.statusCode == 200 || response.statusCode == 201) {
        message = "Report Edited Successfully";
        // Handle successful response
        return true;
      } else {
        // Handle other statuses
        print("Error: $responseBody");
        message = "Failed to edit report";
        return false;
      }
    } catch (error) {
      throw Exception('Failed to edit reports: $error');
    }
  }
}