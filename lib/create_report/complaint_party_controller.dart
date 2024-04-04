// ignore_for_file: avoid_print

import '/create_report/complaint_party_model.dart';
import '/create_report/report_service.dart';
import '/core/native_service/secure_storage.dart';
import 'package:get/get.dart';

class ComplaintPartyController extends GetxController {
  var createStatus = false;
  var message = '';

  ReportService service = ReportService();
  late SecureStorage secureStorage = SecureStorage();

  var isLoading = true.obs;
  int? complaintPartyId = 0;

  List<DataComplaintParty> complaintPartyList = [];
  var selected = RxString('');

  @override
  void onInit() async {
    try {
      secureStorage = SecureStorage();
      String? token = await secureStorage.read("token");
      if (token != null) {
        complaintPartyList = await service.getComplaintList(token);
        if (complaintPartyList.isNotEmpty) {
          selected.value = complaintPartyList[0].username;
        }
      }
    } catch (e) {
      print("Error fetching complaint party list: $e");
      // Handle any errors here
    } finally {
      isLoading.value = false; // Ensure isLoading is set to false here
    }
    print('complaintPartyList: $complaintPartyList');
    print("onInit ComplaintPartyController");
    super.onInit();
    print("onInit ComplaintPartyController");
  }

  void setSelectedcomplaintPatry(String newValue) {
    selected.value = newValue;
  }
}
