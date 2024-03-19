import 'package:cityway_report_fm/core/config/information.dart';
import 'package:cityway_report_fm/core/native_service/secure_storage.dart';

import '/core/resource/color_manager.dart';
import '/edit_report_fm/edit_screen.dart';
import '/homepage/reoport_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/homepage/allreport_model.dart';

class TabBarWithListView extends StatefulWidget {
  const TabBarWithListView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TabBarWithListViewState createState() => _TabBarWithListViewState();
}

class _TabBarWithListViewState extends State<TabBarWithListView> {
  ReportListController controller = Get.put(ReportListController());
  Future<void> _showLogoutConfirmationDialog() async {
    final confirmLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تسجيل خروج'),
          content: Text('هل أنت متأكد؟'),
          actions: <Widget>[
            TextButton(
              child: Text('إلغاء'),
              onPressed: () => Navigator.of(context)
                  .pop(false), // Dismiss the dialog and return false
            ),
            TextButton(
              child: Text('تأكيد'),
              onPressed: () => Navigator.of(context)
                  .pop(true), // Dismiss the dialog and return true
            ),
          ],
        );
      },
    );

    // If the user confirmed logout, proceed with the logout logic
    if (confirmLogout == true) {
      _logout();
    }
  }

  void _logout() async {
    // Assuming 'token' is the key for storing token in SecureStorage
    final secureStorage = SecureStorage();
    await secureStorage.delete('token'); // Delete the token
    Information.TOKEN = ''; // Clear token from the Information class if needed

    // Navigate to login page, assuming 'login' is the route name for your login screen
    Get.offAllNamed('/signin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('التقاريـر'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed:
                  _showLogoutConfirmationDialog, // Show confirmation dialog
            ),
          ],
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: controller.reportList.length,
                  itemBuilder: (BuildContext context, int index) {
                    DataAllReport report = controller.reportList[index];
                    Color statusColor = _getStatusColor(report.statusClient!);
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                            left: 10,
                            right: 10,
                            bottom: 10,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => EditReportScreen(report: report));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: statusColor.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "اسم المشروع: ${report.project}",
                                      style: const TextStyle(
                                        color: AppColorManger.secondaryAppColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "موقع المشروع: ${report.location}",
                                      style: const TextStyle(
                                        color: AppColorManger.secondaryAppColor,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  "حالة المشروع: ${report.statusClient}",
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                leading: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Icon(
                                    Icons.stacked_bar_chart,
                                    color: statusColor,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed('create');
          },
          backgroundColor: AppColorManger.mainAppColor,
          child: const Icon(
            Icons.add,
            color: AppColorManger.white,
          ),
        ));
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Complete':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'In-Progress':
        return Colors.blue;
      case 'Pending':
        return Colors.grey;
      case 'Done':
        return Colors.yellow[700]!;
      default:
        return Colors.purple;
    }
  }
}
