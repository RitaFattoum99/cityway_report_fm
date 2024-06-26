// ignore_for_file: avoid_print

import '/core/native_service/secure_storage.dart';
import '/edit_report_fm/edit_report_service.dart';
import '/homepage/allreport_model.dart';
import 'package:get/get.dart';

class EditReportController extends GetxController {
  // final List<ReportJobDescription> reportJobDescription = [];
  // Add a field to store the report ID
  int reportId = -1;

  // Add a method to set the report ID
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
    isLoading(true);

    try {
      String? token = await secureStorage.read("token");
      if (token != null) {
        editStatus =
            await service.editReports(reportJobDescription, token, reportId);

        isLoading(true);
      }
    } finally {
      isLoading(false);
    }
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
