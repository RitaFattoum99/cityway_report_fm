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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('التقاريـر'),
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
      case 'Completed':
        return Colors.green;
      case 'Closed':
        return Colors.red;
      case 'In Progress':
        return Colors.blue;
      case 'Pending':
        return Colors.grey;
      case 'Open':
        return Colors.yellow[700]!;
      default:
        return Colors.purple;
    }
  }
}
