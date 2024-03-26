// ignore_for_file: library_private_types_in_public_api

import '/core/resource/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Report {
  final String reportNumber;
  final String reportParty;
  final String location;
  final String imageName;

  Report(
      {required this.reportNumber,
      required this.reportParty,
      required this.location,
      required this.imageName});
}

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  List<Report> notifications = [
    Report(
        reportNumber: '001',
        reportParty: 'ترميم مسجد',
        location: 'الموافقة على توصيف الأعمال',
        imageName: 'assets/images/des.jpg'),
    Report(
        reportNumber: '002',
        reportParty: 'تمديدات صحية',
        location: 'الموافقة على السعر الجديد',
        imageName: 'assets/images/des1.png'),
    Report(
        reportNumber: '003',
        reportParty: 'إنارة المسجد',
        location: 'الموافقة على توصيف الأعمال',
        imageName: 'assets/images/des2.png'),
    Report(
        reportNumber: '004',
        reportParty: 'الأرضيات',
        location: 'الموافقة على السعر الجديد',
        imageName: 'assets/images/des3.png'),
    Report(
        reportNumber: '005',
        reportParty: 'تمديدات المياه ',
        location: 'الموافقة على توصيف الأعمال',
        imageName: 'assets/images/des4.png'),
    Report(
        reportNumber: '006',
        reportParty: 'الكهرباء',
        location: 'الموافقة على توصيف الأعمال',
        imageName: 'assets/images/des.jpg'),
    Report(
        reportNumber: '007',
        reportParty: 'ترميم الأثاث',
        location: 'الموافقة على السعر الجديد',
        imageName: 'assets/images/des1.png'),
    Report(
        reportNumber: '008',
        reportParty: 'تمديدات صحية',
        location: 'الموافقة على السعر الجديد',
        imageName: 'assets/images/des2.png'),

    // Add more reports as needed
  ];
  List<Report> material = [
    Report(
        reportNumber: '002',
        reportParty: 'تمديدات صحية',
        location: 'الإمارات',
        imageName: 'assets/images/des1.png'),
    Report(
        reportNumber: '001',
        reportParty: 'صيانة المرفقات',
        location: 'دبي',
        imageName: 'assets/images/des.jpg'),
    Report(
        reportNumber: '004',
        reportParty: 'تمديدات صحية',
        location: 'أبو ظبي',
        imageName: 'assets/images/des3.png'),

    Report(
        reportNumber: '003',
        reportParty: 'إنارة المسجد',
        location: 'دبي',
        imageName: 'assets/images/des2.png'),
    Report(
        reportNumber: '006',
        reportParty: 'الكهرباء',
        location: 'الإمارات',
        imageName: 'assets/images/des.jpg'),

    Report(
        reportNumber: '007',
        reportParty: 'ترميم الأثاث',
        location: 'دبي',
        imageName: 'assets/images/des1.png'),
    Report(
        reportNumber: '008',
        reportParty: 'تمديدات صحية',
        location: 'أبو ظبي',
        imageName: 'assets/images/des2.png'),

    // Add more reports as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          color: AppColorManager.babyGreyAppColor,
          endIndent: 10,
        ),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColorManager.babyGreyAppColor,
              ),
              child: const Icon(
                Icons.notifications_active,
                color: AppColorManager.mainAppColor,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('البلاغ ${notifications[index].reportNumber}',
                    style: const TextStyle(
                        color: AppColorManager.mainAppColor,
                        fontWeight: FontWeight.bold)),
                Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                  style: const TextStyle(
                      color: AppColorManager.secondaryAppColor, fontSize: 10),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('اسم المشروع: ${notifications[index].reportParty}',
                    style: const TextStyle(
                        color: AppColorManager.secondaryAppColor,
                        fontWeight: FontWeight.w700)),
                Text('الحالة : ${notifications[index].location}',
                    style: const TextStyle(
                        color: AppColorManager.secondaryAppColor,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            onTap: () {
              if (index >= 0 && index < material.length) {
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportDetailsScreen(
                      report: notifications[index],
                    ),
                  ),
                );*/
              }
            },
          );
        },
      ),
    );
  }
}
