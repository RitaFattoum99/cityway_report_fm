// ignore_for_file: avoid_print

import '../jobDes/job_description_model.dart';
import '/create_report/complaint_party_model.dart';
import '/create_report/report_model.dart';
import '/create_report/report_service.dart';
import '/core/native_service/secure_storage.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  var id = 0;
  var userId = 0;
  var project = '';
  var location = '';
  int? complaintPartyId = 0;
  var complaintNumber = '';
  var contactName = '';
  var contactPosition = '';
  var contactNumber = '';
  var typeOfWork = '';
  var urgent = 0;
  var budget = 0;
  final List<ReportDescription> reportDescription = [];
  final List<ReportJobDescription> reportJobDescription = [];
  final List<ContactInfo> contactInfo = [];
  var createStatus = false;
  var message = '';

  ReportService service = ReportService();
  late SecureStorage secureStorage = SecureStorage();

  var isLoading = true.obs;
  List<DataComplaintParty> complaintPartyList = [];
  var selected = RxString('');
  var desList = <DataAllDes>[].obs; // Use RxList for reactivity
  @override
  void onInit() async {
    secureStorage = SecureStorage();
    String? token = await secureStorage.read("token");
    complaintPartyList = await service.getComplaintList(token!);
    selected.value =
        complaintPartyList.isNotEmpty ? complaintPartyList[0].username : '';
    super.onInit();
    fetchDes(); // Fetch reports asynchronously
    print("onInit");
  }

  @override
  void onReady() async {
    super.onReady();
    secureStorage = SecureStorage();
    String? token = await secureStorage.read("token");
    complaintPartyList = await service.getComplaintList(token!);
    selected.value =
        complaintPartyList.isNotEmpty ? complaintPartyList[0].username : '';
    print("onReady");
  }

  void setSelectedcomplaintPatry(String newValue) {
    selected.value = newValue;
  }

  Future<void> create() async {
    secureStorage = SecureStorage();
    complaintPartyId = await secureStorage.readInt("id");

    Data report = Data(
      id: id,
      project: project,
      location: location,
      complaintPartyId: complaintPartyId,
      typeOfWork: typeOfWork,
      urgent: urgent,
      budget: budget,
      contactInfo: contactInfo,
      complaintNumber: complaintNumber,
      reportDescription: reportDescription,
      reportJobDescription: reportJobDescription
    );
    String? token = await secureStorage.read("token");
    createStatus = await service.create(report, token!);
    message = service.message;
  }

  void fetchDes() async {
    isLoading.value = true;
    String? token = await secureStorage.read("token");
    if (token != null) {
      var fetchedDes = await service.getDesList(token);
      desList.assignAll(
          fetchedDes); // This will automatically update any listeners
    }
    isLoading.value = false;
  }
}