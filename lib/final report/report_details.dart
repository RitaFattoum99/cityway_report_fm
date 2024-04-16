// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '/core/resource/color_manager.dart';
import '../core/config/service_config.dart';
import '../core/resource/size_manager.dart';
import '/homepage/allreport_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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

  Future<String> downloadPDF(String url, String filename) async {
    final response = await http.get(Uri.parse(url));
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  @override
  void initState() {
    print('file: ${widget.report.workOrder}');
    super.initState();
  }

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
                  Expanded(
                    child: Text(
                      ' رقم البلاغ: ${widget.report.complaintNumber}',
                      style: const TextStyle(
                        color: AppColorManager.mainAppColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                  Expanded(
                    child: Text(
                      ' مقدم البلاغ: ${widget.report.complaintParty}',
                      style: const TextStyle(
                        color: AppColorManager.secondaryAppColor,
                        fontSize: 16,
                      ),
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
                  Expanded(
                    child: Text(
                      'اسم المشروع : ${widget.report.project}',
                      style: const TextStyle(
                        color: AppColorManager.secondaryAppColor,
                        fontSize: 16,
                      ),
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
                  Expanded(
                    child: Text(
                      'موقع المشروع : ${widget.report.location}',
                      style: const TextStyle(
                        color: AppColorManager.secondaryAppColor,
                        fontSize: 16,
                      ),
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
                                  "ملاحظة: ${widget.report.reportDescription[index].note ?? ''}",
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
              widget.report.statusAdmin == 'Awaiting Approval' ||
                      widget.report.statusAdmin == 'Approved' ||
                      widget.report.statusAdmin == 'Declined' ||
                      widget.report.statusAdmin == 'Work Has Started' ||
                      widget.report.statusAdmin == 'Work is Finished' ||
                      widget.report.statusAdmin == 'Rejected By Admin' ||
                      widget.report.statusAdmin == 'Done'
                  ? Column(
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
                            itemCount:
                                widget.report.reportJobDescription.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      isExpanded1
                                          ? widget
                                              .report
                                              .reportJobDescription[index]
                                              .jobDescription!
                                              .description!
                                          : widget
                                                      .report
                                                      .reportJobDescription[
                                                          index]
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
                                  // Row(
                                  //   children: [
                                  //     const Icon(
                                  //       Icons.attach_money,
                                  //       color: AppColorManager.secondaryAppColor,
                                  //     ),
                                  //     const SizedBox(width: 6),
                                  //     Text(
                                  //       'السعر: ${widget.report.reportJobDescription[index].jobDescription!.price.toString()}',
                                  //       style: const TextStyle(
                                  //         color: AppColorManager.secondaryAppColor,
                                  //         fontSize: 16,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly, // This will distribute space evenly between the elements
                                    children: [
                                      const Icon(Icons.attach_money,
                                          color: AppColorManager
                                              .secondaryAppColor),
                                      const SizedBox(width: 6),
                                      Text(
                                        'السعر: ${widget.report.reportJobDescription[index].jobDescription!.price.toString()}',
                                        style: const TextStyle(
                                          color:
                                              AppColorManager.secondaryAppColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 10), // Added space
                                      const Icon(
                                          Icons.production_quantity_limits,
                                          color: AppColorManager
                                              .secondaryAppColor),
                                      const SizedBox(width: 6),
                                      Text(
                                        'الكمية: ${widget.report.reportJobDescription[index].quantity.toString()}',
                                        style: const TextStyle(
                                          color:
                                              AppColorManager.secondaryAppColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 10), // Added space
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(Icons.attach_money,
                                          color: AppColorManager
                                              .secondaryAppColor),
                                      const SizedBox(width: 6),
                                      Text(
                                        'الإجمالي: ${((widget.report.reportJobDescription[index].quantity ?? 0) * (widget.report.reportJobDescription[index].jobDescription!.price ?? 0)).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color:
                                              AppColorManager.secondaryAppColor,
                                          fontSize: 16,
                                        ),
                                      ), // Added some space before the note
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.note_add,
                                        color:
                                            AppColorManager.secondaryAppColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'ملاحظة: ${widget.report.reportJobDescription[index].note ?? ' '}',
                                        style: const TextStyle(
                                          color:
                                              AppColorManager.secondaryAppColor,
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
                                          widget
                                                      .report
                                                      .reportJobDescription[
                                                          index]
                                                      .desImg !=
                                                  null
                                              ? getFullImageUrl(widget
                                                  .report
                                                  .reportJobDescription[index]
                                                  .desImg!)
                                              : 'assets/images/default.png', // Provide a default image path

                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
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
                                              Object error,
                                              StackTrace? stackTrace) {
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
                                          widget
                                                      .report
                                                      .reportJobDescription[
                                                          index]
                                                      .afterDesImg !=
                                                  null
                                              ? getFullImageUrl(widget
                                                  .report
                                                  .reportJobDescription[index]
                                                  .afterDesImg!)
                                              : 'assets/images/default.png', // Provide a default image path
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
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
                                              Object error,
                                              StackTrace? stackTrace) {
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
                    )
                  : const SizedBox(),
              widget.report.statusAdmin == 'Work Has Started' ||
                      widget.report.statusAdmin == 'Work is Finished' ||
                      widget.report.statusAdmin == 'Rejected By Admin' ||
                      widget.report.statusAdmin == 'Done'
                  ? InkWell(
                      onTap: () async {
                        EasyLoading.show(
                            status: 'يتم التحميل...', dismissOnTap: true);
                        String url = widget.report.workOrder;
                        String filename = url.split('/').last;
                        String filePath = await downloadPDF(url, filename);
                        EasyLoading.dismiss();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              PdfViewPage(file: File(filePath)),
                        ));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.report.workOrder.split('/').last,
                                style: const TextStyle(
                                    color: AppColorManager.secondaryAppColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Icon(Icons.picture_as_pdf, size: 30),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 10),
              widget.report.statusAdmin == 'Work is Finished' ||
                      widget.report.statusAdmin == 'Rejected By Admin' ||
                      widget.report.statusAdmin == 'Done'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "توقيع المهندس:",
                          style: TextStyle(
                              color: AppColorManager.secondaryAppColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          child: _buildImage(widget.report.fmeSignature),
                        ),
                        const Text(
                          "ملاحظات المسؤول:",
                          style: TextStyle(
                              color: AppColorManager.secondaryAppColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.report.clientNotes,
                          style: const TextStyle(
                              color: AppColorManager.secondaryAppColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "توقيع المسؤول:",
                          style: TextStyle(
                              color: AppColorManager.secondaryAppColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          child: _buildImage(widget.report.clientSignature),
                        ),
                        const Text(
                          "ملاحظات الأدمن:",
                          style: TextStyle(
                              color: AppColorManager.secondaryAppColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.report.adminNotes,
                          style: const TextStyle(
                              color: AppColorManager.secondaryAppColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "توقيع الأدمن:",
                          style: TextStyle(
                              color: AppColorManager.secondaryAppColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          child: _buildImage(widget.report.adminSignature),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class PdfViewPage extends StatelessWidget {
  final File file;
  const PdfViewPage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: file.path,
      enableSwipe: true,
      autoSpacing: false,
      pageFling: false,
      pageSnap: false,
      defaultPage: 0,
      fitPolicy: FitPolicy.BOTH,
      preventLinkNavigation: false,
    );
  }
}

Widget _buildImage(String? imageUrl) {
  // Check if the URL is valid and is a network URL
  final isNetworkUrl = imageUrl?.startsWith('http') ?? false;

  if (!isNetworkUrl) {
    // Return an alternative widget or image if the URL is not valid
    return const Center(
        child: Text(
      'لم يتم التوقيع بعد',
      style: TextStyle(color: AppColorManager.mainAppColor),
    ));
  }

  // If the URL is valid, use Image.network with a loading builder
  return Image.network(
    imageUrl!,
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child; // Image is fully loaded
      // While the image is loading, show a progress indicator
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      );
    },
    errorBuilder:
        (BuildContext context, Object exception, StackTrace? stackTrace) {
      // If the image fails to load, show an alternative widget
      return const Center(child: Text('Failed to load image'));
    },
  );
}
