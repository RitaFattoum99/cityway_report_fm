import 'package:cityway_report_fm/edit_report_fm/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/core/config/information.dart';
import '/core/native_service/secure_storage.dart';
import '/core/resource/color_manager.dart';
import '/homepage/allreport_model.dart';
import 'reoport_list_controller.dart';

class TabBarWithListView extends StatelessWidget {
  TabBarWithListView({Key? key}) : super(key: key);

  final ReportListController controller = Get.put(ReportListController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // Number of tabs
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(context),
        drawer: _buildDrawer(context), // Add the drawer here

        body: TabBarView(
          children: [
            _buildReportList(all: true),
            // Pass a flag to filter for urgent
            _buildReportList(all: false),
          ],
        ),
        floatingActionButton: _buildAddReportButton(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'التقاريـر',
        style: TextStyle(color: AppColorManager.white),
      ),
      bottom: const TabBar(
        labelColor: AppColorManager.babyGreyAppColor,
        unselectedLabelColor: AppColorManager.white,
        tabs: [
          Tab(
            text: 'كل التقاريـر',
          ),
          Tab(text: 'التقاريـر العاجلة'),
        ],
      ),
      backgroundColor: AppColorManager.mainAppColor,
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(Information.username),
            accountEmail: Text(Information.email),
            currentAccountPicture: CircleAvatar(
                backgroundColor: AppColorManager.white,
                child: Image.asset("assets/images/logo.png")
                // Text("U", style: TextStyle(fontSize: 40.0)),
                ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: AppColorManager.secondaryAppColor,
            ),
            title: const Text(
              'الصفحة الرئيسية',
              style: TextStyle(
                  color: AppColorManager.secondaryAppColor,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: AppColorManager.secondaryAppColor,
            ),
            title: const Text(
              'تسجيل خروج',
              style: TextStyle(
                  color: AppColorManager.secondaryAppColor,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () => _showLogoutConfirmationDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildReportList({required bool all}) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        List<DataAllReport> reports = all
            ? controller.reportList
            : controller.reportList
                .where((report) => report.statusClient == 'Urgent')
                .toList();

        if (reports.isEmpty) {
          return _buildEmptyListAnimation();
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              // Call your function to refresh the data here
              controller.fetchReports();
            },
            child: ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      Get.to(() => EditReportScreen(report: reports[index]));
                    },
                    child: _buildReportItem(reports[index]));
              },
            ),
          );
        }
      }
    });
  }

  Widget _buildEmptyListAnimation() {
    return const AnimatedOpacity(
      opacity: 1.0, // Fully visible
      duration: Duration(seconds: 2), // Duration of the animation
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.report_problem, size: 80, color: Colors.grey),
            Text('ما من بلاغات مقدمة بعد..',
                style: TextStyle(fontSize: 24, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(DataAllReport report) {
    Color statusColor = _getStatusColor(report.statusClient);
    String statusValue = _getStatusValue(report.statusClient);
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
                      color: statusColor, fontWeight: FontWeight.w500)),
              leading:
                  Icon(Icons.stacked_bar_chart, color: statusColor, size: 25),
            ),
          ),
        ),
      ],
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

  FloatingActionButton _buildAddReportButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        var result = await Get.toNamed('create');
        if (result == true) {
          controller.fetchReports();
        }
      },
      backgroundColor: AppColorManager.mainAppColor,
      child: const Icon(Icons.add, color: AppColorManager.white),
    );
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    final confirmLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تسجيل خروج',
          style: TextStyle(
              color: AppColorManager.secondaryAppColor,
              fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'هل أنت متأكد؟',
          style: TextStyle(
            color: AppColorManager.secondaryAppColor,
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('إلغاء'),
              onPressed: () => Navigator.of(context).pop(false)),
          TextButton(
              child: const Text('تأكيد'),
              onPressed: () => Navigator.of(context).pop(true)),
        ],
      ),
    );

    if (confirmLogout == true) {
      _logout();
    }
  }

  void _logout() async {
    final secureStorage = SecureStorage();
    await secureStorage.delete('token');
    Information.TOKEN = '';
    Get.offAllNamed('/signin');
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Urgent':
        return Colors.red;
      case 'Complete':
        return Colors.green;
      case 'Rejected':
        return Colors.pink;
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

  String _getStatusValue(String status) {
    switch (status) {
      case 'Urgent':
        return 'عاجل';
      case 'Complete':
        return 'مكتمل';
      case 'Rejected':
        return 'مرفوض';
      case 'In-Progress':
        return 'قيد التطوير';
      case 'Pending':
        return 'قيد الانتظار';
      case 'Done':
        return 'منتهي';
      default:
        return '';
    }
  }
}
