// ignore_for_file: avoid_print

import 'dart:convert';
import '/core/config/service_config.dart';
import '/homepage/allreport_model.dart';
import 'package:http/http.dart' as http;

class DraftListService {
  var url =
      Uri.parse(ServiceConfig.domainNameServer + ServiceConfig.getListDraft);

  Future<List<DataAllReport>> getDraftList(String token) async {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    });

    print("draft statusCode: ${response.statusCode}");
    print("draft response body: ${response.body}");

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var draftList = Allreports.fromJson(jsonResponse);

      var reports = draftList.data;
      for (var report in reports) {
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
}
