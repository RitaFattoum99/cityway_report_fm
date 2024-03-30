import 'package:cityway_report_fm/edit_report_fm/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../final report/report_details.dart';
import '/core/config/information.dart';
import '/core/native_service/secure_storage.dart';
import '/core/resource/color_manager.dart';
import '/homepage/allreport_model.dart';
import 'reoport_list_controller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DynamicTabBarWithReports extends StatelessWidget {
  DynamicTabBarWithReports({Key? key}) : super(key: key);

  final ReportListController controller = Get.put(ReportListController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      // Generating tabs based on report statuses and their counts
      final tabs = controller.reportStatuses.entries.map((entry) {
        return Tab(text: '${_getStatusValue(entry.key)} (${entry.value})');
      }).toList();

      return DefaultTabController(
        length: tabs.length, // Dynamic number of tabs
        child: Scaffold(
          appBar: _buildAppBar(context, tabs),
          drawer: _buildDrawer(context),
          body: TabBarView(
            children: controller.reportStatuses.keys.map((status) {
              // For each status, build a report list
              return _buildReportList(status);
            }).toList(),
          ),
          floatingActionButton: _buildAddReportButton(context),
        ),
      );
    });
  }

  AppBar _buildAppBar(BuildContext context, List<Widget> tabs) {
    return AppBar(
      title: const Text('التقاريـر',
          style: TextStyle(color: AppColorManager.white)),
      bottom: TabBar(
        isScrollable: true, // Enable scrolling if too many tabs
        labelColor: AppColorManager.babyGreyAppColor,
        unselectedLabelColor: AppColorManager.white,
        tabs: tabs,
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

  Widget _buildReportList(String status) {
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh logic here
        controller.fetchReports();
      },
      child: ListView.builder(
        itemCount: controller.filteredReports(status).length,
        itemBuilder: (context, index) {
          final report = controller.filteredReports(status)[index];
          return _buildReportItem(context, report);
        },
      ),
    );
  }

  Widget _buildReportItem(BuildContext context, DataAllReport report) {
    Color statusColor = _getStatusColor(report.statusClient);
    return Padding(
      padding: const EdgeInsets.all(10),
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
          onTap: () => Get.to(() => ReportDetailsScreen(report: report)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(report.project,
                  style: const TextStyle(
                      color: AppColorManager.secondaryAppColor,
                      fontWeight: FontWeight.bold)),
              Text("موقع المشروع: ${report.location}",
                  style: const TextStyle(
                      color: AppColorManager.secondaryAppColor)),
            ],
          ),
          subtitle: Text(
              "حالة المشروع: ${_getStatusValue(report.statusClient)}",
              style:
                  TextStyle(color: statusColor, fontWeight: FontWeight.w500)),
          leading: Icon(Icons.stacked_bar_chart, color: statusColor, size: 25),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.green,
                ),
                onPressed: () => Get.to(() => EditReportScreen(report: report)),
              ),
              IconButton(
                icon: const Icon(
                  Icons.picture_as_pdf,
                  color: AppColorManager.pdfIconColor,
                ),
                onPressed: () async {
                  // Logic to export the report
                  // Assuming ReportDetailsScreen has a method to generate and save PDF
                  _generateAndSavePDF(report);
                },
              ),
            ],
          ),
        ),
      ),
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

  Future<Uint8List> fetchImage(String url) async {
    final response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  Future<pw.Font> loadCustomFont() async {
    final fontData = await rootBundle.load("assets/font/Amiri-Regular.ttf");
    final font = pw.Font.ttf(fontData);
    return font;
  }

  Future<void> _generateAndSavePDF(DataAllReport report) async {
    final pdf = pw.Document();

// This list will hold both text and images as widgets.
    final contentWidgets = <pw.Widget>[];
    // Load your custom font
    final customFont = await loadCustomFont();

    final textDetails = [
      pw.Text('رقم البلاغ: ${report.complaintNumber}',
          style: pw.TextStyle(font: customFont)),
      pw.Text('مقدم البلاغ: ${report.complaintParty}',
          style: pw.TextStyle(font: customFont)),
      pw.Text('اسم المشروع: ${report.project}',
          style: pw.TextStyle(font: customFont)),
      pw.Text('موقع المشروع: ${report.location}',
          style: pw.TextStyle(font: customFont)),
      pw.Text('الحالة: ${report.statusClient}',
          style: pw.TextStyle(font: customFont)),
    ];
    contentWidgets.addAll(textDetails);

// Iterate over contactInfo and add details to the PDF
    for (final contact in report.contactInfo) {
      contentWidgets.add(
        pw.Text(
          "الاسم: ${contact.name}, المنصب: ${contact.position}, الرقم: ${contact.phone}",
          style: pw.TextStyle(fontSize: 12, font: customFont),
        ),
      );
    }

    // Prepare to add images from ReportDescription
    for (final description in report.reportDescription) {
      if (description.description != null) {
        contentWidgets.add(pw.Text("وصف البلاغ: ${description.description!}",
            style: pw.TextStyle(font: customFont)));
      }
      if (description.desImg != null && description.desImg!.isNotEmpty) {
        final imageBytes = await fetchImage(description.desImg!);
        final image = pw.MemoryImage(imageBytes);

        contentWidgets.add(pw.Image(image,height: 50,width: 50));
      }
    }
    for (final jobDesc in report.reportJobDescription) {
      // Include job description text
      if (jobDesc.jobDescription != null &&
          jobDesc.jobDescription!.description != null) {
        contentWidgets.add(pw.Text(
            "وصف الأعمال: ${jobDesc.jobDescription!.description}",
            style: pw.TextStyle(font: customFont)));
      }
      // Include job description image (if exists)
      if (jobDesc.desImg != null && jobDesc.desImg!.isNotEmpty) {
        final jobImageBytes = await fetchImage(jobDesc.desImg!);
        final jobImage = pw.MemoryImage(jobImageBytes);
        contentWidgets.add(pw.Image(jobImage,height: 50,width: 50));
      }
    }

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Container(
            alignment: pw.Alignment.topRight, // Align text to the right
            child: pw.Column(
              children: contentWidgets,
            ),
          );
        },
      ),
    );
    // pdf.addPage(
    //   pw.Page(
    //     build: (pw.Context context) => pw.Column(
    //       children: contentWidgets,
    //     ),
    //   ),
    // );
    // Save the document
    await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'تقرير إنجاز الأعمال ${report.complaintNumber}.pdf');
  }
}
