// ignore_for_file: avoid_print

import 'package:cityway_report_fm/drafts/draft_service.dart';
import 'package:get/get.dart';
import '/core/native_service/secure_storage.dart';
import '/homepage/allreport_model.dart';

class DreftListController extends GetxController {
  var isLoading = true.obs;
  var draftList = <DataAllReport>[].obs;
  final DraftListService _service = DraftListService();
  late SecureStorage secureStorage;

  @override
  void onInit() {
    super.onInit();
    secureStorage = SecureStorage();
    fetchDrafts();
  }

  void fetchDrafts() async {
    isLoading.value = true;
    String? token = await secureStorage.read("token");
    if (token != null) {
      var fetchedDrafts = await _service.getDraftList(token);
      print(fetchedDrafts);
      // for (int i = 0; i <= fetchedDrafts.length; i++) {
      //   print("draft report $i: ${fetchedDrafts[i]}");
      // }
      draftList.assignAll(fetchedDrafts);
    }
    isLoading.value = false;
  }
}
