// ignore_for_file: avoid_print
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
  var complaintPartyId = 0;
  var reportNumber = '';
  var contactName = '';
  var contactPosition = '';
  var contactNumber = '';
  var typeOfWork = '';

  final List<JobDescription> jobDescription = [];
  var createStatus = false;
  var message = '';

  ReportService service = ReportService();
  late SecureStorage secureStorage = SecureStorage();

  var isLoading = true.obs;
  List<DataComplaintParty> complaintPartyList = [];
  var selected = RxString('');

  @override
  void onInit() async {
    secureStorage = SecureStorage();
    String? token = await secureStorage.read("token");
    print('token in check controller: $token');
    super.onInit();
    print("onInit");
    //if (token != null) {
      complaintPartyList = await service.getComplaintList(token!);
      selected.value =
          complaintPartyList.isNotEmpty ? complaintPartyList[0].name : '';
      print("name in controller: $complaintPartyList");
   // } 
    /*else {
      // Handle the case where token is null
      print("Token is null");
    }*/
  }

  @override
  void onReady() async {
    secureStorage = SecureStorage();
    String? token = await secureStorage.read("token");
   // if (token != null) {
      complaintPartyList = await service.getComplaintList(token!);
      selected.value =
          complaintPartyList.isNotEmpty ? complaintPartyList[0].name : '';
      print("name in controller: $complaintPartyList");
    //} else {
      // Handle the case where token is null
      //print("Token is null");
    //}
    isLoading(false);
    super.onReady();
    print("onReady");
  }

  void setSelectedcomplaintPatry(String newValue) {
    selected.value = newValue;
  }

  Future<void> create() async {
    Data report = Data(
      id: id,
      userId: userId,
      project: project,
      location: location,
      contactPosition: contactPosition,
      contactNumber: contactNumber,
      typeOfWork: typeOfWork,
      jobDescription: jobDescription,
      complaintPartyId: complaintPartyId,
      reportNumber: reportNumber,
      contactName: contactName,
    );
    for (int i = 0; i < jobDescription.length; i++) {
      print('image in controller ${jobDescription[i].desImg}');
    }
    String? token = await secureStorage.read("token");
    createStatus = await service.create(report, token!);
    //message = service.message;
  }
}
