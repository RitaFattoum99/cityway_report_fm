import '/core/resource/color_manager.dart';
import 'core/resource/size_manager.dart';
import '/homepage/allreport_model.dart';
import 'package:flutter/material.dart';

class ReportDetailsScreen extends StatefulWidget {
  final DataAllReport report;

  const ReportDetailsScreen({Key? key, required this.report}) : super(key: key);

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  final List<String> imageList = [
    'assets/images/des1.jpg',
    'assets/images/des2.jpg',
    //'assets/images/des1.jpg',
  ];
  final List<String> imageList2 = [
    'assets/images/used.jpg',
    'assets/images/used2.jpg',
    //'assets/images/used3.jpg',
  ];

  final List<String> desList = [
    'جدار متشقق بحاجة ترميم وإكساء',
    ' التكييف مخرب في غرفة 2',
    // 'الإنارة مقطوعة في غرفة 1',
  ];
  final List<String> materialList = [
    'سكك حديدية',
    'فاحص التوتر',
    // 'المادة المستخدمة الثالثة',
  ];

  final List<String> num = [
    '10', '1',
    //'3'
  ];
  final List<String> price = [
    '800', '200',
    // '45'
  ];
  Color _acceptedColor = Colors.grey;
  Color _confirmColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: AppPaddingManager.p50,
          right: AppPaddingManager.p18,
          left: AppPaddingManager.p18,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  height: size.height * 0.1,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Text(
                ' رقم البلاغ: ${widget.report.complaintNumber}',
                style: const TextStyle(
                  color: AppColorManager.mainAppColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'اسم المشروع : ${widget.report.project}',
                style: const TextStyle(
                  color: AppColorManager.secondaryAppColor,
                  fontSize: 16,
                ),
              ),
              Text(
                'الحالة: ${widget.report.location}',
                style: const TextStyle(
                  color: AppColorManager.secondaryAppColor,
                  fontSize: 16,
                ),
              ),
              /*const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "وصف الأعمال:",
                    style: TextStyle(
                        color: AppColorManager.mainAppColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: desList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding:
                              EdgeInsets.only(bottom: size.height * 0.0001),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                desList[index],
                                style: const TextStyle(
                                  color: AppColorManager.secondaryAppColor,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Image.asset(
                                imageList[index],
                                fit: BoxFit.cover,
                                height: 150,
                                width: 150,
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: size.width * 0.05,
                        );
                      },
                    ),
                  ),
                ],
              ),
              */
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "وصف الأعمال:",
                          style: TextStyle(
                              color: AppColorManager.mainAppColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 300,
                          child: Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: materialList.length,
                              itemBuilder: (BuildContext context, int index) {
                                int numValue = int.parse(
                                    num[index]); // Convert num[index] to an int
                                int priceValue = int.parse(price[
                                    index]); // Convert price[index] to an int

                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: size.height * 0.0001),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        desList[index],
                                        style: const TextStyle(
                                          color:
                                              AppColorManager.secondaryAppColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text("العدد: $numValue"),
                                      Text("السعر: $priceValue"),
                                      Text(
                                          "السعر الكلي: ${(numValue * priceValue).toString()}"), // Updated line
                                      const SizedBox(height: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColorManager.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Image.asset(
                                          imageList2[index],
                                          fit: BoxFit.cover,
                                          height: 150,
                                          width: 150,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  width: size.width * 0.05,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _acceptedColor = Colors.green;
                              _confirmColor = Colors.grey;
                            });
                          },
                          child: Container(
                            width: size.width * 0.3,
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.01,
                              bottom: MediaQuery.of(context).size.width * 0.01,
                              left: MediaQuery.of(context).size.width * 0.01,
                              right: MediaQuery.of(context).size.width * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: _acceptedColor,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: const Center(
                              child: Text(
                                'تأكيد',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _acceptedColor = Colors.grey;
                              _confirmColor = Colors.red;
                            });
                          },
                          child: Container(
                            width: size.width * 0.3,
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.01,
                              bottom: MediaQuery.of(context).size.width * 0.01,
                              left: MediaQuery.of(context).size.width * 0.01,
                              right: MediaQuery.of(context).size.width * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: _confirmColor,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: const Center(
                              child: Text(
                                'رفض',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
