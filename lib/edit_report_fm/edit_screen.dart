// ignore_for_file: prefer_const_constructors, avoid_print
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import '../core/config/service_config.dart';
import '../create_report/report_controller.dart';
import '../homepage/reoport_list_controller.dart';
import '../jobDes/job_description_model.dart';
import '/core/resource/color_manager.dart';
import '../core/resource/size_manager.dart';
import '/edit_report_fm/edit_report_controller.dart';
import '/homepage/allreport_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  final _formKey = GlobalKey<FormState>();

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

  @override
  void initState() {
    super.initState();
    editController.reportId = widget.report.id;

    // initializing jobCards with existing report data
    jobCards = widget.report.reportJobDescription.map((repjobDescription) {
      final imagePath = repjobDescription.desImg!;
      final isImageUrl =
          imagePath.startsWith('http://') || imagePath.startsWith('https://');
      final image = isImageUrl ? imagePath : File(imagePath);

      final imagePathafter = repjobDescription.afterDesImg!;
      final isImageUrlafter = imagePathafter.startsWith('http://') ||
          imagePathafter.startsWith('https://');
      final imageafter =
          isImageUrlafter ? imagePathafter : File(imagePathafter);
      return {
        'description': TextEditingController(
            text: repjobDescription.jobDescription?.description ?? ''),
        'price':
            TextEditingController(text: repjobDescription.price.toString()),
        'quantity':
            TextEditingController(text: repjobDescription.quantity.toString()),
        'note': TextEditingController(text: repjobDescription.note),
        'image': image,
        'imageafter': imageafter,
        'unit':
            TextEditingController(text: repjobDescription.jobDescription!.unit),
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
            jobCards[index]['imagefter'] = File(imagePath);
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
                  Icon(
                    Icons.numbers,
                    color: AppColorManager.mainAppColor,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.report.complaintNumber,
                    style: const TextStyle(
                      color: AppColorManager.mainAppColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.file_copy,
                    color: AppColorManager.secondaryAppColor,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.report.project,
                    style: const TextStyle(
                      color: AppColorManager.secondaryAppColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColorManager.secondaryAppColor,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.report.location,
                    style: const TextStyle(
                      color: AppColorManager.secondaryAppColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.person_2_rounded,
                    color: AppColorManager.secondaryAppColor,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.report.complaintParty,
                    style: const TextStyle(
                      color: AppColorManager.secondaryAppColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'المسؤولين:',
                style: const TextStyle(
                    color: AppColorManager.mainAppColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.report.contactInfo.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColorManager.secondaryAppColor
                                  .withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_2_rounded,
                                    color: AppColorManager.secondaryAppColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    widget.report.contactInfo[index].name,
                                    style: const TextStyle(
                                      color: AppColorManager.secondaryAppColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.work_rounded,
                                    color: AppColorManager.secondaryAppColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    widget.report.contactInfo[index].position,
                                    style: const TextStyle(
                                      color: AppColorManager.secondaryAppColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: AppColorManager.secondaryAppColor,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    widget.report.contactInfo[index].phone,
                                    style: const TextStyle(
                                      color: AppColorManager.secondaryAppColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "وصف البلاغ:",
                      style: TextStyle(
                        color: AppColorManager.mainAppColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
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
                                  isExpanded ? "عرض أقل" : "عرض المزيد",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 16),
                                ),
                              ),
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
                    // Expanded(
                    // height: 400,
                    // child:
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
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
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: data['price'],
                                          decoration: const InputDecoration(
                                              labelText: 'السعر'),
                                          keyboardType: TextInputType.number,
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
                                          controller: data['quantity'],
                                          decoration: const InputDecoration(
                                              labelText: 'الكمية'),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            setState(() {
                                              data['quantity'].text = value;
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
                                              child: jobCards[index]['image'] ==
                                                      null
                                                  ? const Icon(
                                                      Icons.add_a_photo)
                                                  : jobCards[index]['image']
                                                          is File
                                                      ? Image.file(
                                                          jobCards[index]
                                                              ['image'] as File,
                                                          width: 150,
                                                          height: 150,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.network(
                                                          jobCards[index]
                                                                  ['image']
                                                              as String,
                                                          width: 150,
                                                          height: 150,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Widget child,
                                                                  ImageChunkEvent?
                                                                      loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) {
                                                              return child;
                                                            }
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(
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
                                                        ),
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
                                              child: jobCards[index]
                                                          ['imageafter'] ==
                                                      null
                                                  ? const Icon(
                                                      Icons.add_a_photo)
                                                  : jobCards[index]
                                                          ['imageafter'] is File
                                                      ? Image.file(
                                                          jobCards[index]
                                                                  ['imageafter']
                                                              as File,
                                                          width: 150,
                                                          height: 150,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.network(
                                                          jobCards[index]
                                                                  ['imageafter']
                                                              as String,
                                                          width: 150,
                                                          height: 150,
                                                          fit: BoxFit.cover,
                                                        ),
                                            ),
                                          ),
                                        ],
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
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // ),
                  ],
                ),
              ),
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
                            price: int.tryParse(card['price'].text) ?? 0,
                            quantity: int.tryParse(card['quantity'].text) ?? 0,
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
                            status: 'loading...', dismissOnTap: true);
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
