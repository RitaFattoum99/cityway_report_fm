// ignore_for_file: avoid_print

import 'dart:convert';
import '/core/config/service_config.dart';
import '/homepage/allreport_model.dart';
import 'package:http/http.dart' as http;

class ReportListService {
  var message = '';
  var url =
      Uri.parse(ServiceConfig.domainNameServer + ServiceConfig.getListReport);

  Future<List<DataAllReport>> getReportList(String token) async {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var reportList = Allreports.fromJson(jsonResponse);

      // Access the list of reports
      var reports = reportList.data;
      for (var report in reports) {
        // Print the 'id' property of each report
        print(report.id);
      }

      return reports;
    } else {
      print("token $token");
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load list');
    }
  }

  Future<bool> deleteReport(int reportId, String token) async {
    var url = Uri.parse(
        '${ServiceConfig.domainNameServer}${ServiceConfig.deleteReport}/$reportId');
    var response = await http.delete(url, headers: {
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
