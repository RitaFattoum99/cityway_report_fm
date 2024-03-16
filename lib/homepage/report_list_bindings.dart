import '/homepage/reoport_list_controller.dart';
import 'package:get/get.dart';

class ReportListBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ReportListController>(ReportListController());
  }
}
