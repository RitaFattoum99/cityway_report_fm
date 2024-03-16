import '/edit_report_fm/edit_report_controller.dart';
import 'package:get/get.dart';

class EditReportBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<EditReportController>(EditReportController());
  }
}
