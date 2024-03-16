// ignore_for_file: avoid_print

import '/core/native_service/secure_storage.dart';
import '/homepage/allreport_model.dart';
import '/homepage/report_list_service.dart';
import 'package:get/get.dart';

class ReportListController extends GetxController {
  var isLoading = true.obs;
  List<DataAllReport> reportList = [];
  final ReportListService _service = ReportListService();
  late SecureStorage secureStorage;
  @override
  void onInit() async {
    secureStorage = SecureStorage();
    String? token = await secureStorage.read("token");
        reportList = await _service.getReportList(token!);

    super.onInit();
    print("onInit");
  }

  @override
  void onReady() async {
    secureStorage = SecureStorage();
    String? token = await secureStorage.read("token");
    reportList = await _service.getReportList(token!);
    isLoading(false);
    print("reportList controller");
    print(reportList);
    print("_service.getEmpList(token) controller");
    print(_service.getReportList(token));
    super.onReady();
    print("onReady");
  }
}
