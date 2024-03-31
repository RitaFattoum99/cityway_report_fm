import 'package:cityway_report_fm/edit_report_fm/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../final report/report_details.dart';
import '/core/config/information.dart';
import '/core/native_service/secure_storage.dart';
import '/core/resource/color_manager.dart';
import '/homepage/allreport_model.dart';
import 'reoport_list_controller.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/services.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

class DynamicTabBarWithReports extends StatefulWidget {
  DynamicTabBarWithReports({Key? key}) : super(key: key);

  @override
  State<DynamicTabBarWithReports> createState() =>
      _DynamicTabBarWithReportsState();
}

class _DynamicTabBarWithReportsState extends State<DynamicTabBarWithReports> {
  final ReportListController controller = Get.put(ReportListController());

  late SecureStorage secureStorage = SecureStorage();

  String userName = "";

  String email = "";

  @override
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Fixed list of report statuses
      var statusList = [
        'Urgent',
        'Done',
        'Pending',
        'In-Progress',
        'Complete',
        'Rejected'
      ];

      // Generating tabs with report status and count
      var tabs = statusList
          .map((status) => Tab(
              text:
                  '${_getStatusValue(status)} (${_getReportCountByStatus(status)})'))
          .toList();

      return DefaultTabController(
        length: statusList.length, // Set the number of tabs
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'التقاريـر',
              style: TextStyle(color: AppColorManager.white),
            ),
            bottom: TabBar(
              isScrollable: true, // Enable scrolling for tabs
              labelColor:
                  AppColorManager.babyGreyAppColor, // Selected tab label color
              unselectedLabelColor:
                  AppColorManager.white, // Unselected tab label color
              tabs: tabs, // List of tabs
            ),
            backgroundColor:
                AppColorManager.mainAppColor, // AppBar background color
          ),
          body: TabBarView(
            // Generate a tab for each report status
            children: statusList
                .map((status) => _buildReportList(status: status))
                .toList(),
          ),
          drawer: _buildDrawer(context, userName, email), // Drawer widget
          floatingActionButton:
              _buildAddReportButton(context), // Floating action button
        ),
      );
    });
  }

  int _getReportCountByStatus(String status) {
    return controller.reportList
        .where((report) => report.statusClient == status)
        .length;
  }

  // AppBar _buildAppBar(BuildContext context, List<Widget> tabs) {
  Drawer _buildDrawer(BuildContext context, String userName, String email) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
                backgroundColor: AppColorManager.white,
                child: Image.asset("assets/images/logo.png")),
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

  Widget _buildReportList({required String status}) {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    } else {
      var reports = controller.reportList
          .where((report) => report.statusClient == status)
          .toList();

      if (reports.isEmpty) {
        return _buildEmptyListAnimation();
      } else {
        return RefreshIndicator(
          onRefresh: () async {
            controller.fetchReports();
          },
          child: ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Get.to(() => ReportDetailsScreen(report: reports[index]));
                },
                child: _buildReportItem(reports[index])),
          ),
        );
      }
    }
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

  @override
  void initState() {
    super.initState();
    // Fetch user name on widget initialization
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    secureStorage = SecureStorage();
    String? name = await secureStorage.read("username");
    String? myEmail = await secureStorage.read("email");
    print('username : $name');
    print('myEmail : $myEmail');
    // Fetch user name using the key
    if (name != null) {
      setState(() {
        userName = name; // Set the user name if found
        print("username in drawer: $userName");
      });
    }
    if (myEmail != null) {
      setState(() {
        email = myEmail; // Set the user name if found
        print("email in drawer: $email");
      });
    }
  }
}
