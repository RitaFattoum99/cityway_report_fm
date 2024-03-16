import 'package:get/get.dart';
import '/core/native_service/secure_storage.dart';
import '/homepage/allreport_model.dart';
import '/homepage/report_list_service.dart';

class ReportListController extends GetxController {
  var isLoading = true.obs;
  var reportList = <DataAllReport>[].obs; // Use RxList for reactivity
  final ReportListService _service = ReportListService();
  late SecureStorage secureStorage;

  @override
  void onInit() {
    super.onInit();
    secureStorage = SecureStorage();
    fetchReports(); // Fetch reports asynchronously
  }

  void fetchReports() async {
    isLoading.value = true;
    String? token = await secureStorage.read("token");
    if (token != null) {
      var fetchedReports = await _service.getReportList(token);
      reportList.assignAll(fetchedReports); // This will automatically update any listeners
    }
    isLoading.value = false;
  }
}
