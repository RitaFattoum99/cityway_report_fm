
// ignore_for_file: avoid_print

import 'dart:convert';
import '/core/config/service_config.dart';
import '/homepage/allreport_model.dart';
import 'package:http/http.dart' as http;

class ReportListService {
  var url =
      Uri.parse(ServiceConfig.domainNameServer + ServiceConfig.getListReport);

  Future<List<DataAllReport>> getReportList(String token) async {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    });
    if (response.statusCode == 200) {
      print('response.statusCode: ${response.statusCode} report list');
      print("response.body: ${response.body}");
      print("token $token");
      var jsonResponse = jsonDecode(response.body);
      var reportList = Allreports.fromJson(jsonResponse);

      // Access the list of reports
      var reports = reportList.data;
      for (var report in reports) {
        print(report.id); // Print the 'id' property of each report
      }

      return reports;
    } else {
      print("token $token");
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load order list');
    }
  }
}
