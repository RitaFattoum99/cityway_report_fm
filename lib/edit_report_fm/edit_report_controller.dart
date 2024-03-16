// ignore_for_file: avoid_print

import '/core/native_service/secure_storage.dart';
import '/edit_report_fm/edit_report_service.dart';
import '/homepage/allreport_model.dart';
import '/material_model.dart';
import 'package:get/get.dart';

class EditReportController extends GetxController {
  final List<String> unit = [];
  final List<int> quantity = [];
  final List<int> price = [];
  final List<int> total = [];

  // Add a field to store the report ID
  late int reportId;

  // Add a method to set the report ID
  void setReportId(int id) {
    reportId = id;
  }

  var createStatus = false;
  var message = '';

  EditReportService service = EditReportService();
  late SecureStorage secureStorage = SecureStorage();

  var isLoading = true.obs;
  List<DataMaterial> materialList = [];
  var selected = RxString('');

  @override
  void onInit() async {
    secureStorage = SecureStorage();
    String? token = await secureStorage.read("token");
    print('token in check controller: $token');
    super.onInit();
    print("onInit");
    materialList = await service.getMaterialList(token!);
    selected.value = materialList.isNotEmpty ? materialList[0].name : '';
    print("name in controller: $materialList");
  }

  @override
  void onReady() async {
    secureStorage = SecureStorage();
    String? token = await secureStorage.read("token");
    materialList = await service.getMaterialList(token!);
    selected.value = materialList.isNotEmpty ? materialList[0].name : '';
    print("name in controller: $materialList");
    isLoading(false);
    super.onReady();
    print("onReady");
  }

  void setSelectedMateial(String newValue) {
    selected.value = newValue;
  }

  Future<void> edit(List<JobDescription> jobDescriptions) async {
    try {
      isLoading(true);
      String? token = await secureStorage.read("token");
      if (token != null) {
        
        await service.editReports(jobDescriptions, token, reportId);
      }
    } finally {
      isLoading(false);
    }
  }
}
