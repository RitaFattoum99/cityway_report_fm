// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, unnecessary_null_comparison
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import '../core/config/service_config.dart';
import '../core/native_service/secure_storage.dart';
import '../create_report/report_controller.dart';
import '../homepage/reoport_list_controller.dart';
import '../jobDes/job_description_model.dart';
import '/core/resource/color_manager.dart';
import '../core/resource/size_manager.dart';
import '/edit_report_fm/edit_report_controller.dart';
import '/homepage/allreport_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class EditReportScreen extends StatefulWidget {
  final DataAllReport report;

  const EditReportScreen({Key? key, required this.report}) : super(key: key);

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  final EditReportController editController = Get.put(EditReportController());
  final ReportController reportController = Get.put(ReportController());
  final List<TextEditingController> controllers = [];
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  File? _selectedFile;

  late List<Map<String, dynamic>> jobCards = [
    {
      'description': TextEditingController(),
      'price': TextEditingController(),
      'quantity': TextEditingController(),
      'note': TextEditingController(),
      'image': null,
      'imageafter': null,
      'unit': TextEditingController(),
      'jobDescriptionId': null,
    }
  ];

  late SecureStorage secureStorage = SecureStorage();
  String userRole = '';

  Future<void> initRoles() async {
    final String? role = await secureStorage.read("role");
    if (role != null) {
      setState(() {
        userRole = role;
      });
    }
  }

  Future<String> downloadPDF(String url, String filename) async {
    final response = await http.get(Uri.parse(url));
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  @override
  void initState() {
    super.initState();
    initRoles();
    print("userRole: $userRole");
    editController.reportId = widget.report.id;
    editController.workOrder = widget.report.workOrder;
    if (widget.report.workOrder != null) {
      _selectedFile = File(widget.report.workOrder);
    }
    print('file: ${widget.report.workOrder}');

    // initializing jobCards with existing report data
    jobCards = widget.report.reportJobDescription.map((repjobDescription) {
      dynamic image;
      final imagePath = repjobDescription.desImg;
      if (imagePath != null) {
        final isImageUrl =
            imagePath.startsWith('http://') || imagePath.startsWith('https://');
        image = isImageUrl ? imagePath : File(imagePath);
      } else {
        image = null;
      }
      dynamic imageafter;

      final imagePathafter = repjobDescription.afterDesImg;
      if (imagePathafter != null) {
        final isImageUrlafter = imagePathafter.startsWith('http://') ||
            imagePathafter.startsWith('https://');
        imageafter = isImageUrlafter ? imagePathafter : File(imagePathafter);
      } else {
        // Here, you might want to assign a default value or handle the null case
        // For example, imageafter could be set to a placeholder image or remain null
        // and later handled accordingly when being used.
        imageafter = null; // Or your placeholder logic here
      }

      return {
        'description': TextEditingController(
            text: repjobDescription.jobDescription?.description ?? ''),
        'price':
            TextEditingController(text: repjobDescription.price.toString()),
        'quantity':
            TextEditingController(text: repjobDescription.quantity.toString()),
        'note': TextEditingController(text: repjobDescription.note),
        'image': image,
        'imageafter':
            imageafter, // This now correctly refers to the declared variable
        'unit': TextEditingController(
            text: repjobDescription.jobDescription?.unit ?? ''),
        'jobDescriptionId': repjobDescription.jobDescriptionId,
      };
    }).toList();
  }

  void _onAutocompleteSelected(
      DataAllDes selection, Map<String, dynamic> cardData) {
    setState(() {
      // Update the text in the 'description' TextEditingController
      cardData['description'].text = selection.description;

      // Assuming 'price' and 'unit' are also part of your data model,
      // and you have TextEditingControllers for them as well.
      cardData['price'].text = selection.price.toString();
      cardData['unit'].text = selection.unit;

      // Update any other relevant part of your data model here
      cardData['jobDescriptionId'] = selection.id;
    });
  }

  @override
  void dispose() {
    // Dispose of the controllers
    for (var card in jobCards) {
      card['description'].dispose();
      card['price'].dispose();
      card['quantity'].dispose();
      card['note'].dispose();
      card['unit'].dispose();
    }
    super.dispose();
  }

  void _addJobCard() {
    setState(() {
      jobCards.add({
        'description': TextEditingController(),
        'price': TextEditingController(),
        'quantity': TextEditingController(),
        'note': TextEditingController(),
        'image': null,
        'imageafter': null,
        'unit': TextEditingController(),
        'jobDescriptionId': null,
      });
      TextEditingController controller = TextEditingController();
      controllers.add(controller);
    });
  }

  void _removeJobCard(int index) {
    setState(() {
      if (jobCards.isNotEmpty && index >= 0 && index < jobCards.length) {
        jobCards.removeAt(index);
        if (index < controllers.length) {
          controllers.removeAt(index);
        }
      }
    });
  }

  Future<void> _pickImage(int index, {required bool isAfterImage}) async {
    final option = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر مصدر الصورة',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorManager.mainAppColor,
              ),
              child: const Text('الكاميرا',
                  style: TextStyle(color: AppColorManager.white)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorManager.mainAppColor,
              ),
              child: const Text('المعرض',
                  style: TextStyle(color: AppColorManager.white)),
            ),
          ],
        ),
      ),
    );

    if (option == null) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: option);

    if (image != null) {
      setState(() {
        String imagePath = image.path;
        if (isAfterImage) {
          // Update after-image data
          if (index < jobCards.length) {
            jobCards[index]['imageafter'] = File(imagePath);
          }
          if (index < editController.reportJobDescription.length) {
            editController.reportJobDescription[index].afterDesImg = imagePath;
          }
        } else {
          // Update before-image data
          if (index < jobCards.length) {
            jobCards[index]['image'] = File(imagePath);
          }
          if (index < editController.reportJobDescription.length) {
            editController.reportJobDescription[index].desImg = imagePath;
          }
        }
      });
    }
  }

  Future<File?> selectPDFFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      return File(result.files.single.path!);
    } else {
      // User canceled the picker
      return null;
    }
  }

  String? getJobDescriptionAt(int index) {
    // Check if the index is within the bounds of the list
    if (index >= 0 && index < widget.report.reportJobDescription.length) {
      return widget
              .report.reportJobDescription[index].jobDescription?.description ??
          '';
    }
    // Return a default value if the index is out of bounds
    return '';
  }

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إضافة وصف الأعمال',
          style: TextStyle(color: AppColorManager.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColorManager.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColorManager.mainAppColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          right: AppPaddingManager.p18,
          left: AppPaddingManager.p18,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
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
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.stacked_bar_chart,
                    color: AppColorManager.secondaryAppColor,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'الحالة: ${widget.report.location}',
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
                                      color: AppColorManager.secondaryAppColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'المسؤول: ${widget.report.contactInfo[index].name}',
                                      style: const TextStyle(
                                        color:
                                            AppColorManager.secondaryAppColor,
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
                                      color: AppColorManager.secondaryAppColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'المنصب: ${widget.report.contactInfo[index].position}',
                                      style: const TextStyle(
                                        color:
                                            AppColorManager.secondaryAppColor,
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
                                      color: AppColorManager.secondaryAppColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'الرقم: ${widget.report.contactInfo[index].phone}',
                                      style: const TextStyle(
                                        color:
                                            AppColorManager.secondaryAppColor,
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
              const SizedBox(height: 5),
              const Divider(
                color: AppColorManager.babyGreyAppColor,
                endIndent: 10,
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
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
                            SizedBox(width: 20),
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
                                          : widget
                                              .report
                                              .reportDescription[index]
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
                                  style: TextStyle(
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
                                          Object error,
                                          StackTrace? stackTrace) {
                                        return Center(
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
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "وصف الأعمال:",
                      style: TextStyle(
                        color: AppColorManager.mainAppColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: jobCards.length,
                        itemBuilder: (context, index) {
                          final data = jobCards[index];
                          return Card(
                            elevation: 4.0,
                            margin: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // Display and edit fields here, similar to JobCard's build method
                                  Autocomplete<DataAllDes>(
                                    displayStringForOption:
                                        (DataAllDes option) =>
                                            option.description,
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<
                                            DataAllDes>.empty();
                                      }
                                      return reportController.desList
                                          .where((DataAllDes item) {
                                        return item.description
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    optionsViewBuilder: (BuildContext context,
                                        AutocompleteOnSelected<DataAllDes>
                                            onSelected,
                                        Iterable<DataAllDes> options) {
                                      return Align(
                                        alignment: Alignment.topLeft,
                                        child: Material(
                                          child: SizedBox(
                                            width: 300,
                                            child: ListView.builder(
                                              itemCount: options.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final DataAllDes option =
                                                    options.elementAt(index);
                                                return GestureDetector(
                                                  onTap: () {
                                                    onSelected(option);
                                                  },
                                                  child: ListTile(
                                                    title: Text(
                                                        option.description),
                                                    subtitle: Text(
                                                        "السعر: ${option.price}, الوحدة: ${option.unit}"),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    onSelected: (DataAllDes selection) =>
                                        _onAutocompleteSelected(
                                            selection, data),
                                    fieldViewBuilder: (
                                      BuildContext context,
                                      TextEditingController
                                          fieldTextEditingController,
                                      FocusNode fieldFocusNode,
                                      VoidCallback onFieldSubmitted,
                                    ) {
                                      // Safely obtain the initial value using the function
                                      String? initialValue =
                                          getJobDescriptionAt(index);

                                      // Set the initial value only if the controller's text is empty
                                      if (fieldTextEditingController
                                              .text.isEmpty &&
                                          initialValue!.isNotEmpty) {
                                        fieldTextEditingController.text =
                                            initialValue;
                                      }
                                      return TextFormField(
                                        controller: fieldTextEditingController,
                                        focusNode: fieldFocusNode,
                                        decoration: const InputDecoration(
                                            labelText: 'الوصف'),
                                        // onChanged is not needed if the text is directly bound to the state,
                                        // but consider providing a way to update the state if the text changes
                                        onChanged: (value) => setState(() =>
                                            data['description'].text = value),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'ادخل الوصف';
                                          }
                                          return null;
                                        },
                                      );
                                    },
                                  ),
                                  userRole == 'estimation' ||
                                          userRole == 'admin'
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                // readOnly:
                                                //     userRole == 'fme' ? true : false,
                                                controller: data['unit'],
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: 'الوحدة'),
                                                onChanged: (value) => setState(
                                                    () => data['unit'].text =
                                                        value),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'ادخل الوحدة';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                // readOnly:
                                                //     userRole == 'fme' ? true : false,
                                                controller: data['price'],
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: 'السعر'),
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (value) {
                                                  setState(() {
                                                    data['price'].text = value;
                                                  });
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'إدخال السعر';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                // readOnly:
                                                //     userRole == 'fme' ? true : false,
                                                controller: data['quantity'],
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: 'الكمية'),
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (value) {
                                                  setState(() {
                                                    data['quantity'].text =
                                                        value;
                                                  });
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'ادخل الكمية';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      : TextFormField(
                                          // readOnly:
                                          //     userRole == 'fme' ? true : false,
                                          controller: data['unit'],
                                          decoration: const InputDecoration(
                                              labelText: 'الوحدة'),
                                          onChanged: (value) => setState(
                                              () => data['unit'].text = value),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'ادخل الوحدة';
                                            }
                                            return null;
                                          },
                                        ),

                                  TextFormField(
                                    controller: data['note'],
                                    decoration: const InputDecoration(
                                        labelText: 'ملاحظات'),
                                    onChanged: (value) {
                                      setState(() {
                                        // Make sure to convert the int to String before assigning
                                        data['note'].text = value; // Corrected
                                      });
                                    },
                                  ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Column(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         SizedBox(height: 10),
                                  //         Text(
                                  //           'صورة قبل:',
                                  //           style: TextStyle(
                                  //               color: AppColorManager
                                  //                   .secondaryAppColor,
                                  //               fontWeight: FontWeight.w600),
                                  //         ),
                                  //         GestureDetector(
                                  //           onTap: () async => await _pickImage(
                                  //               index,
                                  //               isAfterImage: false),
                                  //           child: Padding(
                                  //             padding:
                                  //                 const EdgeInsets.symmetric(
                                  //                     vertical: 8),
                                  //             child: jobCards[index]['image'] ==
                                  //                     null
                                  //                 ? const Icon(
                                  //                     Icons.add_a_photo)
                                  //                 : jobCards[index]['image']
                                  //                         is File
                                  //                     ? Image.file(
                                  //                         jobCards[index]
                                  //                             ['image'] as File,
                                  //                         width: 150,
                                  //                         height: 150,
                                  //                         fit: BoxFit.cover,
                                  //                       )
                                  //                     : Image.network(
                                  //                         jobCards[index]
                                  //                                 ['image']
                                  //                             as String,
                                  //                         width: 150,
                                  //                         height: 150,
                                  //                         fit: BoxFit.cover,
                                  //                         loadingBuilder:
                                  //                             (BuildContext
                                  //                                     context,
                                  //                                 Widget child,
                                  //                                 ImageChunkEvent?
                                  //                                     loadingProgress) {
                                  //                           if (loadingProgress ==
                                  //                               null) {
                                  //                             return child;
                                  //                           }
                                  //                           return Center(
                                  //                             child:
                                  //                                 CircularProgressIndicator(
                                  //                               value: loadingProgress
                                  //                                           .expectedTotalBytes !=
                                  //                                       null
                                  //                                   ? loadingProgress
                                  //                                           .cumulativeBytesLoaded /
                                  //                                       loadingProgress
                                  //                                           .expectedTotalBytes!
                                  //                                   : null,
                                  //                             ),
                                  //                           );
                                  //                         },
                                  //                       ),
                                  //           ),
                                  //         ),
                                  //         SizedBox(height: 10),
                                  //         Text(
                                  //           'صورة بعد:',
                                  //           style: TextStyle(
                                  //               color: AppColorManager
                                  //                   .secondaryAppColor,
                                  //               fontWeight: FontWeight.w600),
                                  //         ),
                                  //         GestureDetector(
                                  //           onTap: () async => await _pickImage(
                                  //               index,
                                  //               isAfterImage: true),
                                  //           child: Padding(
                                  //             padding:
                                  //                 const EdgeInsets.symmetric(
                                  //                     vertical: 8),
                                  //             child: jobCards[index]
                                  //                         ['imageafter'] ==
                                  //                     null
                                  //                 ? const Icon(
                                  //                     Icons.add_a_photo)
                                  //                 : jobCards[index]
                                  //                         ['imageafter'] is File
                                  //                     ? Image.file(
                                  //                         jobCards[index]
                                  //                                 ['imageafter']
                                  //                             as File,
                                  //                         width: 150,
                                  //                         height: 150,
                                  //                         fit: BoxFit.cover,
                                  //                       )
                                  //                     : Image.network(
                                  //                         jobCards[index]
                                  //                                 ['imageafter']
                                  //                             as String,
                                  //                         width: 150,
                                  //                         height: 150,
                                  //                         fit: BoxFit.cover,
                                  //                       ),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     _removeJobCard(index);
                                  //   },
                                  //   child: Container(
                                  //     height: 35,
                                  //     width: 35,
                                  //     decoration: const BoxDecoration(
                                  //       shape: BoxShape.circle,
                                  //       color: Colors.red,
                                  //     ),
                                  //     child: const Icon(
                                  //       Icons.remove,
                                  //       color: AppColorManager.white,
                                  //     ),
                                  //   ),
                                  // ),
                                  //   ],
                                  // ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10),
                                          Text(
                                            'صورة قبل:',
                                            style: TextStyle(
                                                color: AppColorManager
                                                    .secondaryAppColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          GestureDetector(
                                            onTap: () async => await _pickImage(
                                                index,
                                                isAfterImage: false),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: _buildImageDisplay(
                                                  jobCards[index]['image'],
                                                  150,
                                                  150),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'صورة بعد:',
                                            style: TextStyle(
                                                color: AppColorManager
                                                    .secondaryAppColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          GestureDetector(
                                            onTap: () async => await _pickImage(
                                                index,
                                                isAfterImage: true),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: _buildImageDisplay(
                                                  jobCards[index]['imageafter'],
                                                  150,
                                                  150),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _removeJobCard(index);
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red,
                                              ),
                                              child: const Icon(
                                                Icons.remove,
                                                color: AppColorManager.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  // InkWell(
                  // onTap: () async {
                  //   // Open the PDF file in a new full-screen page
                  //   if (File(widget.report.workOrder) != null) {
                  //     EasyLoading.show(
                  //         status: 'يتم التحميل...', dismissOnTap: true);
                  //     String url = widget.report.workOrder;
                  //     String filename = url.split('/').last;
                  //     String filePath = await downloadPDF(url, filename);
                  //     EasyLoading.dismiss();
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) =>
                  //           PdfViewPage(file: File(filePath)),
                  //     ));
                  //   } else if (_selectedFile != null) {
                  //     print("_selectedFile:$_selectedFile");
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (context) =>
                  //             PdfViewPage(file: _selectedFile!),
                  //       ),
                  //     );
                  //   } else {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(
                  //         content: Text("رجاءً اختر ملف أولاً."),
                  //       ),
                  //     );
                  //   }
                  // },
                  // child:
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedFile != null
                                ? _selectedFile!.path.split('/').last
                                : widget.report.workOrder.split('/').last,
                            style: const TextStyle(
                                color: AppColorManager.secondaryAppColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Icon(Icons.picture_as_pdf, size: 30),
                      ],
                    ),
                  ),
                  // ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorManager.mainAppColor,
                    ),
                    onPressed: () async {
                      File? file = await selectPDFFile();
                      if (file != null) {
                        setState(() {
                          _selectedFile =
                              file; // Update the UI to show selected file
                        });
                        editController.upload(file);
                      }
                    },
                    child: const Text(
                      'ملف بدء العمل',
                      style: TextStyle(
                          color: AppColorManager.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              // Column(
              //   children: [
              //     InkWell(
              //       onTap: () async {
              //         if (widget.report.workOrder != null &&
              //             (Uri.tryParse(widget.report.workOrder!)
              //                     ?.hasAbsolutePath ??
              //                 false)) {
              //           // Assuming widget.report.workOrder is a valid URL
              //           EasyLoading.show(
              //               status: 'يتم التحميل...', dismissOnTap: true);
              //           try {
              //             String url = widget.report.workOrder;
              //             String filename = url.split('/').last;
              //             String filePath = await downloadPDF(url, filename);
              //             EasyLoading.dismiss();
              //             Navigator.of(context).push(
              //               MaterialPageRoute(
              //                 builder: (context) =>
              //                     PdfViewPage(file: File(filePath)),
              //               ),
              //             );
              //           } catch (e) {
              //             EasyLoading.dismiss();
              //             ScaffoldMessenger.of(context).showSnackBar(
              //               SnackBar(
              //                   content: Text('حدث خطأ أثناء تحميل الملف.')),
              //             );
              //           }
              //         } else if (_selectedFile != null) {
              //           print("_selectedFile:$_selectedFile");
              //           Navigator.of(context).push(
              //             MaterialPageRoute(
              //               builder: (context) =>
              //                   PdfViewPage(file: _selectedFile!),
              //             ),
              //           );
              //         } else {
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             SnackBar(
              //               content: Text("رجاءً اختر ملف أولاً."),
              //             ),
              //           );
              //         }
              //       },
              //       child: Container(
              //         padding: EdgeInsets.all(8.0),
              //         child: Row(
              //           children: [
              //             Expanded(
              //               child: Text(
              //                 _selectedFile != null
              //                     ? _selectedFile!.path.split('/').last
              //                     : widget.report.workOrder?.split('/').last ??
              //                         "No file selected",
              //                 style: const TextStyle(
              //                     color: AppColorManager.secondaryAppColor,
              //                     fontWeight: FontWeight.bold),
              //               ),
              //             ),
              //             Icon(Icons.picture_as_pdf, size: 30),
              //           ],
              //         ),
              //       ),
              //     ),
              //     ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: AppColorManager.mainAppColor,
              //       ),
              //       onPressed: () async {
              //         File? file = await selectPDFFile();
              //         if (file != null) {
              //           setState(() {
              //             _selectedFile =
              //                 file; // Update the UI to show selected file
              //           });
              //           editController.upload(file);
              //         }
              //       },
              //       child: const Text(
              //         'ملف بدء العمل',
              //         style: TextStyle(
              //             color: AppColorManager.white,
              //             fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //   ],
              // ),

              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _addJobCard,
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: AppColorManager.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        print("تعديل");
                        var updatedJobDescriptions = jobCards.map((card) {
                          String? imagePath;
                          if (card['image'] is File) {
                            imagePath = (card['image'] as File).path;
                          } else if (card['image'] is String) {
                            imagePath = card['image'];
                          }
                          String? afterImagePath;
                          if (card['imageafter'] is File) {
                            afterImagePath = (card['imageafter'] as File).path;
                          } else if (card['imageafter'] is String) {
                            afterImagePath = card['imageafter'];
                          }
                          return ReportJobDescription(
                            jobDescription: JobDescription(
                                description: card['description'].text,
                                unit: card['unit'].text),
                            note: card['note'].text,
                            price: int.tryParse(card['price'].text),
                            quantity: int.tryParse(card['quantity'].text),
                            desImg: imagePath,
                            afterDesImg: afterImagePath,
                            jobDescriptionId: card['jobDescriptionId'],
                          );
                        }).toList();
                        print(
                            "updatedJobDescriptions: $updatedJobDescriptions");
                        // Now, update editController with the new list
                        editController.updateReportJobDescriptions(
                            updatedJobDescriptions);
                        EasyLoading.show(
                            status: 'يتم التحميل...', dismissOnTap: true);
                        await editController.edit(updatedJobDescriptions);
                        if (editController.editStatus) {
                          print("editStatus: ${editController.editStatus}");
                          EasyLoading.showSuccess(editController.message,
                              duration: const Duration(seconds: 3));
                          print(editController.message);

                          final reportListController =
                              Get.find<ReportListController>();
                          reportListController.fetchReports();
                          Get.offNamed('home');
                        } else {
                          EasyLoading.showError(editController.message,
                              duration: const Duration(seconds: 3));
                          print(editController.message);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorManager.mainAppColor,
                    ),
                    child: const Text(
                      'إرسال',
                      style: TextStyle(
                          color: AppColorManager.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  // ElevatedButton(
                  //   onPressed: () async {
                  //     if (_formKey.currentState!.validate()) {
                  //       print("تعديل");
                  //       var updatedJobDescriptions = jobCards.map((card) {
                  //         String? imagePath = card['image'] is File
                  //             ? (card['image'] as File).path
                  //             : card['image'];
                  //         String? afterImagePath = card['imageafter'] is File
                  //             ? (card['imageafter'] as File).path
                  //             : card['imageafter'];

                  //         int? price = int.tryParse(card['price'].text);
                  //         int? quantity = int.tryParse(card['quantity'].text);

                  //         // Check if both price and quantity are provided
                  //         bool isPriceAndQuantityProvided =
                  //             price != null && quantity != null;

                  //         return ReportJobDescription(
                  //           jobDescription: JobDescription(
                  //             description: card['description'].text,
                  //             unit: card['unit'].text,
                  //           ),
                  //           note: card['note'].text,
                  //           price: isPriceAndQuantityProvided ? price : null,
                  //           quantity:
                  //               isPriceAndQuantityProvided ? quantity : null,
                  //           desImg: imagePath,
                  //           afterDesImg: afterImagePath,
                  //           jobDescriptionId: card['jobDescriptionId'],
                  //         );
                  //       }).toList();
                  //       print(
                  //           "updatedJobDescriptions: $updatedJobDescriptions");
                  //       // Now, update editController with the new list
                  //       editController.updateReportJobDescriptions(
                  //           updatedJobDescriptions);

                  //       EasyLoading.show(
                  //           status: 'يتم التحميل...', dismissOnTap: true);
                  //       await editController.edit(updatedJobDescriptions);
                  //       if (editController.editStatus) {
                  //         print("editStatus: ${editController.editStatus}");
                  //         EasyLoading.showSuccess(editController.message,
                  //             duration: const Duration(seconds: 3));
                  //         print(editController.message);

                  //         final reportListController =
                  //             Get.find<ReportListController>();
                  //         reportListController.fetchReports();
                  //         Get.offNamed('home');
                  //       } else {
                  //         EasyLoading.showError(editController.message,
                  //             duration: const Duration(seconds: 3));
                  //         print(editController.message);
                  //       }
                  //     }
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: AppColorManager.mainAppColor,
                  //   ),
                  //   child: const Text(
                  //     'إرسال',
                  //     style: TextStyle(
                  //       color: AppColorManager.white,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget displayImage(dynamic image) {
  if (image is String &&
      (image.startsWith('http://') || image.startsWith('https://'))) {
    // It's a URL
    return Image.network(
      image,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
            child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null));
      },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return Center(child: Icon(Icons.error));
      },
    );
  } else if (image is File) {
    // It's a local file
    return Image.file(
      image,
      fit: BoxFit.cover,
    );
  } else {
    // Placeholder in case of null or unsupported type
    return Icon(Icons.broken_image);
  }
}

// class PdfViewPage extends StatelessWidget {
//   final File file;
//   const PdfViewPage({super.key, required this.file});

//   @override
//   Widget build(BuildContext context) {
//     return PDFView(
//       filePath: file.path,
//       enableSwipe: true,
//       // swipeHorizontal: true,
//       autoSpacing: false,
//       pageFling: false,
//       pageSnap: false,
//       defaultPage: 0,
//       fitPolicy: FitPolicy.BOTH,
//       preventLinkNavigation: false,
//     );
//   }
// }

Widget _buildImageDisplay(dynamic image, double width, double height) {
  if (image == null) {
    return const Icon(Icons.add_a_photo);
  } else if (image is File) {
    return Image.file(image, width: width, height: height, fit: BoxFit.cover);
  } else {
    return Image.network(
      image as String,
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }
}
