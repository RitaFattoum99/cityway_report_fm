import '/create_report/report_controller.dart';
import 'package:get/get.dart';

class ReportBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ReportController>(ReportController());
  }
}
