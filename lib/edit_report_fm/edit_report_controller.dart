// ignore_for_file: avoid_print

import 'dart:io';

import '/core/native_service/secure_storage.dart';
import '/edit_report_fm/edit_report_service.dart';
import '/homepage/allreport_model.dart';
import 'package:get/get.dart';

class EditReportController extends GetxController {
  int reportId = -1;
  // ignore: prefer_typing_uninitialized_variables
  var workOrder;
  void setReportId(int id) {
    reportId = id;
  }

  int get getReportId => reportId;
  var editStatus = false;
  var message = '';

  EditReportService service = EditReportService();
  late SecureStorage secureStorage = SecureStorage();

  var isLoading = true.obs;

  Future<void> edit(List<ReportJobDescription> reportJobDescription) async {
    print("work order: $workOrder");
    isLoading(true);

    try {
      String? token = await secureStorage.read("token");
      if (token != null) {
        editStatus = await service.editReports(
            reportJobDescription, token, reportId, workOrder);
        message = service.message;

        isLoading(true);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> upload(File file) async {
    String? token = await secureStorage.read("token");
    if (token == null) {
      print("Authorization token is missing");
      return;
    }
    int reportId = getReportId;
    await service.uploadPDFFile(file, token, reportId);
  }

  var reportJobDescription = <ReportJobDescription>[].obs;

  // Initialize with existing report data
  void initialize(DataAllReport report) {
    reportJobDescription.assignAll(report.reportJobDescription);
  }

  // Update job descriptions
  void updateReportJobDescriptions(List<ReportJobDescription> updatedList) {
    reportJobDescription.assignAll(updatedList);
  }
}
