import '/core/resource/color_manager.dart';
import 'package:flutter/material.dart';

class Report {
  final String reportNumber;
  final String projectName;
  final String location;
  final String status;

  Report({
    required this.status,
    required this.reportNumber,
    required this.projectName,
    required this.location,
  });
}

class TabBarWithListView extends StatefulWidget {
  const TabBarWithListView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TabBarWithListViewState createState() => _TabBarWithListViewState();
}

class _TabBarWithListViewState extends State<TabBarWithListView> {
  List<Report> reports = [
    Report(
      reportNumber: '001',
      projectName: 'ترميم مسجد',
      status: 'Closed',
      location: 'أبو ظبي',
    ),
    Report(
      reportNumber: '002',
      projectName: 'تمديدات كهربائية',
      status: 'Open',
      location: 'دبي',
    ),
    Report(
        reportNumber: '003',
        projectName: 'ترميم مسجد',
        location: 'أبو ظبي',
        status: 'In Progress'),
    Report(
        reportNumber: '004',
        projectName: 'تمديدات كهربائية',
        location: 'دبي',
        status: 'In Progress'),
    Report(
        reportNumber: '005',
        projectName: 'تمديدات كهربائية',
        location: 'دبي',
        status: 'Closed'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تقاريري'),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Open'),
                Tab(text: 'Closed'),
                Tab(text: 'In Progress'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildListViewByStatus('Open'),
                  _buildListViewByStatus('Closed'),
                  _buildListViewByStatus('In Progress'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListViewByStatus(String status) {
    List<Report> filteredReports =
        reports.where((report) => report.status == status).toList();

    return ListView.builder(
      itemCount: filteredReports.length,
      itemBuilder: (BuildContext context, int index) {
        Report report = filteredReports[index];
        Color statusColor = _getStatusColor(report.status);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, left: 10, right: 10, bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColorManager.white,
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "اسم المشروع: ${report.projectName}",
                        style: const TextStyle(
                            color: AppColorManager.secondaryAppColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "موقع المشروع: ${report.location}",
                        style: const TextStyle(
                          color: AppColorManager.secondaryAppColor,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    "حالة المشروع: ${report.status}",
                    style: const TextStyle(
                        color: AppColorManager.secondaryAppColor,
                        fontWeight: FontWeight.w500),
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
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'Open') {
      return Colors.green;
    } else if (status == 'Closed') {
      return Colors.red;
    } else if (status == 'In Progress') {
      return Colors.yellow;
    } else {
      return Colors.grey;
    }
  }
}










/*import 'package:city_way/homepage/allreport_model.dart';
import 'package:city_way/homepage/reoport_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabBarWithListView extends StatefulWidget {
  const TabBarWithListView({Key? key}) : super(key: key);

  @override
  _TabBarWithListViewState createState() => _TabBarWithListViewState();
}

class _TabBarWithListViewState extends State<TabBarWithListView> {
  String selectedStatus = 'All';
  ReportListController controller = Get.put(ReportListController());

  @override
  Widget build(BuildContext context) {
    List<DataAllReport> filteredReports = selectedStatus == 'All'
        ? controller.reportList
        : controller.reportList
            .where((report) => report.statusClient == selectedStatus)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('تقاريري'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedStatus,
              items: [
                'All',
                'Pending',
                'Closed',
                'In Progress',
              ].map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredReports.length,
              itemBuilder: (BuildContext context, int index) {
                // DataAllReport report = filteredReports[index];
                //Color statusColor = _getStatusColor(report.statusClient);

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 10,
                        right: 10,
                        bottom: 10,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              //color: statusColor.withOpacity(0.5),
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
                                "اسم المشروع: ${controller.reportList[index].project}",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "موقع المشروع: ${controller.reportList[index].location}",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            "حالة المشروع: ${controller.reportList[index].statusClient}",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          leading: SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.stacked_bar_chart,
                          //    color: statusColor,
                              size: 25,
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
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.green;
      case 'Closed':
        return Colors.red;
      case 'In Progress':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}
*/
