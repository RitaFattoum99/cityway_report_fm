import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../edit_report_fm/edit_screen.dart';
import '/core/resource/color_manager.dart';
import '/homepage/allreport_model.dart'; // Assuming the model fits the draft reports as well
import 'draft_controller.dart';

class DraftReportsScreen extends StatelessWidget {
  const DraftReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the draft list controller
    final DreftListController controller = Get.put(DreftListController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'التقاريـر المحفوظة',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColorManager.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColorManager.mainAppColor, // Use your color theme
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.draftList.isEmpty) {
          return const AnimatedOpacity(
            opacity: 1.0, // Fully visible
            duration: Duration(seconds: 2), // Duration of the animation
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.report_problem, size: 80, color: Colors.grey),
                  Text('ما من مسودات محفوظة..',
                      style: TextStyle(fontSize: 24, color: Colors.grey)),
                ],
              ),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: controller.draftList.length,
            itemBuilder: (context, index) {
              DataAllReport report = controller.draftList[index];
              Color statusColor = _getStatusColor(report.statusAdmin);
              String statusValue = _getStatusValue(report.statusAdmin);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: _itemDecoration(statusColor),
                      child: ListTile(
                        title: _buildTitle(report),
                        subtitle: Text("حالة المشروع: $statusValue",
                            style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w500)),
                        leading:
                            Icon(Icons.drafts, color: statusColor, size: 25),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.green),
                          onPressed: () {
                            // Navigate to the edit report screen
                            Get.to(() => EditReportScreen(report: report));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      }),
    );
  }

  BoxDecoration _itemDecoration(Color statusColor) {
    return BoxDecoration(
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
    );
  }

  Column _buildTitle(DataAllReport report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(report.project,
            style: const TextStyle(
                color: AppColorManager.secondaryAppColor,
                fontWeight: FontWeight.bold)),
        Text("موقع المشروع: ${report.location}",
            style: const TextStyle(color: AppColorManager.secondaryAppColor)),
      ],
    );
  }

  String _getStatusValue(String status) {
    switch (status) {
      case 'Urgent':
        return 'عاجل';
      case 'New-Report':
        return 'بلاغ جديد';
      case 'Awaiting Approval':
        return 'بانتظار الموافقة';
      case 'Approved':
        return 'تمت الموافقة';
      case 'Declined':
        return 'مرفوض';
      case 'Work Has Started':
        return 'تم بدء العمل';
      case 'Work is finished':
        return 'تم إنهاء العمل';
      case 'Rejected by admin':
        return 'تم الرفض';
      case 'Done':
        return 'منتهي';
      default:
        return '';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Urgent':
        return Colors.red;
      case 'New-Report':
        return Colors.grey;
      case 'Awaiting Approval':
        return Colors.deepOrange;
      case 'Approved':
        return Colors.pink;
      case 'Declined':
        return Colors.indigo;
      case 'Work Has Started':
        return Colors.purple;
      case 'Work is finished':
        return Colors.yellow[700]!;
      case 'Rejected by admin':
        return Colors.blue;
      case 'Done':
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
