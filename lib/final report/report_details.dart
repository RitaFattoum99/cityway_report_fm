import '/core/resource/color_manager.dart';
import '../core/config/service_config.dart';
import '../core/resource/size_manager.dart';
import '/homepage/allreport_model.dart';
import 'package:flutter/material.dart';

class ReportDetailsScreen extends StatefulWidget {
  final DataAllReport report;

  const ReportDetailsScreen({Key? key, required this.report}) : super(key: key);

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  bool isExpanded = false;
  bool isExpanded1 = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تقرير إنجاز الأعمال',
          style: TextStyle(color: AppColorManager.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColorManager.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColorManager.mainAppColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: AppPaddingManager.p20,
          right: AppPaddingManager.p18,
          left: AppPaddingManager.p18,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.numbers,
                    color: AppColorManager.mainAppColor,
                  ),
                  Text(
                    ' رقم البلاغ: ${widget.report.complaintNumber}',
                    style: const TextStyle(
                      color: AppColorManager.mainAppColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.person_2_rounded,
                    color: AppColorManager.secondaryAppColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    ' مقدم البلاغ: ${widget.report.complaintParty}',
                    style: const TextStyle(
                      color: AppColorManager.secondaryAppColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.file_copy,
                    color: AppColorManager.secondaryAppColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'اسم المشروع : ${widget.report.project}',
                    style: const TextStyle(
                      color: AppColorManager.secondaryAppColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColorManager.secondaryAppColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'موقع المشروع : ${widget.report.location}',
                    style: const TextStyle(
                      color: AppColorManager.secondaryAppColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.stacked_bar_chart,
                    color: AppColorManager.secondaryAppColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'الحالة: ${widget.report.location}',
                    style: const TextStyle(
                      color: AppColorManager.secondaryAppColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(
                color: AppColorManager.babyGreyAppColor,
                endIndent: 10,
              ),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.group,
                        color: AppColorManager.mainAppColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "المسـؤولين:",
                        style: TextStyle(
                            color: AppColorManager.mainAppColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100,
                    child: Stack(
                      children: [
                        ListView.builder(
                          controller:
                              _scrollController, // Use the ScrollController here
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.report.contactInfo.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(bottom: size.height * 0.0001),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 325,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.person_2_rounded,
                                          color:
                                              AppColorManager.secondaryAppColor,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'المسؤول: ${widget.report.contactInfo[index].name}',
                                          style: const TextStyle(
                                            color: AppColorManager
                                                .secondaryAppColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.work,
                                          color:
                                              AppColorManager.secondaryAppColor,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'المنصب: ${widget.report.contactInfo[index].position}',
                                          style: const TextStyle(
                                            color: AppColorManager
                                                .secondaryAppColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.phone,
                                          color:
                                              AppColorManager.secondaryAppColor,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'الرقم: ${widget.report.contactInfo[index].phone}',
                                          style: const TextStyle(
                                            color: AppColorManager
                                                .secondaryAppColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                // Calculate the scroll amount for one item here if necessary
                                _scrollController.animateTo(
                                  _scrollController.offset +
                                      325, // Adjust the scroll amount based on your item width
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: AppColorManager.mainAppColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(
                color: AppColorManager.babyGreyAppColor,
                endIndent: 10,
              ),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.description,
                        color: AppColorManager.mainAppColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "وصف البلاغ:",
                        style: TextStyle(
                            color: AppColorManager.mainAppColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 400,
                    width: 300,
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.report.reportDescription.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 300,
                              child: Text(
                                isExpanded
                                    ? widget.report.reportDescription[index]
                                        .description!
                                    : widget.report.reportDescription[index]
                                                .description!.length >
                                            50
                                        ? "${widget.report.reportDescription[index].description!.substring(0, 40)}..."
                                        : widget.report.reportDescription[index]
                                            .description!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Text(
                                isExpanded ? "عرض أقل" : "...عرض المزيد",
                                style: const TextStyle(
                                    color: AppColorManager.greyAppColor,
                                    fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.note_add,
                                  color: AppColorManager.secondaryAppColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "ملاحظة: ${widget.report.reportDescription[index].note!}",
                                  style: const TextStyle(
                                    color: AppColorManager.secondaryAppColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Container(
                                height: 200,
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    getFullImageUrl(widget.report
                                        .reportDescription[index].desImg!),
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        // Image is fully loaded
                                        return child;
                                      }
                                      // While the image is loading, return a loader widget
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.error),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(
                color: AppColorManager.babyGreyAppColor,
                endIndent: 10,
              ),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.description,
                        color: AppColorManager.mainAppColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "وصف الأعمال:",
                        style: TextStyle(
                            color: AppColorManager.mainAppColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 600,
                    width: 300,
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.report.reportJobDescription.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 300,
                              child: Text(
                                isExpanded1
                                    ? widget.report.reportJobDescription[index]
                                        .jobDescription!.description!
                                    : widget
                                                .report
                                                .reportJobDescription[index]
                                                .jobDescription!
                                                .description!
                                                .length >
                                            50
                                        ? "${widget.report.reportJobDescription[index].jobDescription!.description!.substring(0, 40)}..."
                                        : widget
                                            .report
                                            .reportJobDescription[index]
                                            .jobDescription!
                                            .description!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isExpanded1 = !isExpanded1;
                                });
                              },
                              child: Text(
                                isExpanded1 ? "عرض أقل" : "...عرض المزيد",
                                style: const TextStyle(
                                    color: AppColorManager.greyAppColor,
                                    fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  Icons.attach_money,
                                  color: AppColorManager.secondaryAppColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'السعر: ${widget.report.reportJobDescription[index].jobDescription!.price.toString()}',
                                  style: const TextStyle(
                                    color: AppColorManager.secondaryAppColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.note_add,
                                  color: AppColorManager.secondaryAppColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'ملاحظة: ${widget.report.reportJobDescription[index].note ?? ' '}',
                                  style: const TextStyle(
                                    color: AppColorManager.secondaryAppColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Expanded(
                              child: Container(
                                height: 200,
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    getFullImageUrl(widget.report
                                        .reportJobDescription[index].desImg!),
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        // Image is fully loaded
                                        return child;
                                      }
                                      // While the image is loading, return a loader widget
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.error),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Container(
                                height: 200,
                                width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    getFullImageUrl(widget
                                        .report
                                        .reportJobDescription[index]
                                        .afterDesImg!),
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        // Image is fully loaded
                                        return child;
                                      }
                                      // While the image is loading, return a loader widget
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.error),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
