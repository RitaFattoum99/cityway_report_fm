// ignore_for_file: prefer_const_constructors, avoid_print

// import 'package:cityway_report_fm/homepage/reoport_list_controller.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

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

  late List<Map<String, dynamic>> jobCards = [
    {
      'description': TextEditingController(),
      'price': TextEditingController(),
      'quantity': TextEditingController(),
      'note': TextEditingController(),
      'image': null,
      'unit': TextEditingController(),
      'jobDescriptionId': null,
    }
  ];

  @override
  void initState() {
    super.initState();
    editController.reportId = widget.report.id;

    // Example of initializing jobCards with existing report data
    // This assumes `report` has a `jobDescriptions` list to iterate over
    // You need to adjust based on your actual data structure
    jobCards = widget.report.reportJobDescription.map((repjobDescription) {
      print("description:  ${repjobDescription.jobDescription!.description}");
      return {
        'description': TextEditingController(
            text: repjobDescription.jobDescription!.description.toString()),
        'price':
            TextEditingController(text: repjobDescription.price.toString()),
        'quantity':
            TextEditingController(text: repjobDescription.quantity.toString()),
        'note': TextEditingController(text: repjobDescription.note),
        'image': repjobDescription
            .desImg, // This assumes you have a way to convert saved image paths to File objects or similar
        'unit':
            TextEditingController(text: repjobDescription.jobDescription!.unit),
        'jobDescriptionId': repjobDescription.id,
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
        'unit': TextEditingController(),
        'jobDescriptionId': null,
      });
    });
  }

  void _removeJobCard(int index) {
    setState(() {
      jobCards.removeAt(index);
    });
  }

  Future<void> _pickImage(Map<String, dynamic> cardData) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        cardData['image'] = File(pickedFile.path);
      });
    }
  }

  bool isExpanded = false;
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
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  height: size.height * 0.1,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
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
                        physics: const NeverScrollableScrollPhysics(),
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
                                      : "${widget.report.reportDescription[index].description!.substring(0, 50)}...",
                                  style: const TextStyle(
                                    color: Colors
                                        .black, // Replace with your actual color
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
                                          .reportDescription[index].desImg),
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child; // Image is fully loaded
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
                                                : null, // Progress indicator
                                          ),
                                        );
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace) {
                                        // Optionally handle errors, e.g., display a placeholder image
                                        return Center(
                                          child: Icon(Icons
                                              .error), // Example error icon
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
                    SizedBox(
                      height: 600,
                      child: ListView.builder(
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
                                      return TextFormField(
                                        controller: fieldTextEditingController,
                                        focusNode: fieldFocusNode,
                                        decoration: const InputDecoration(
                                            labelText: 'الوصف'),
                                        onChanged: (value) {
                                          // Update the state based on manual entry
                                          setState(() =>
                                              data['description'].text = value);
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
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          onPressed: () => _pickImage(data),
                                          icon: Icon(Icons.camera_enhance)),
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
                                  // Display the selected image if available
                                  // if (data['image'] != null)
                                  //   Image.file(File(data[
                                  //       'image'])), // Wrap the string path with File()
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
              Row(
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
                  ElevatedButton(
                    onPressed: () async {
                      print("إرسال");
                      // Iterate through jobCards to update editController data
                      var updatedJobDescriptions = jobCards.map((card) {
                        return ReportJobDescription(
                          jobDescription: JobDescription(
                              description: card['description'].text,
                              unit: card['unit'].text),
                          note: card['note'].text,
                          price: int.tryParse(card['price'].text) ?? 0,
                          quantity: int.tryParse(card['quantity'].text) ?? 0,

                          desImg: card[
                              'image'], // Assuming you handle File to String conversion in the controller
                          jobDescriptionId: card['jobDescriptionId'],
                        );
                      }).toList();
                      print("updatedJobDescriptions: $updatedJobDescriptions");
                      // Now, update editController with the new list
                      editController
                          .updateReportJobDescriptions(updatedJobDescriptions);

                      EasyLoading.show(
                          status: 'loading...', dismissOnTap: true);
                      await editController.edit(updatedJobDescriptions);
                      if (editController.editStatus) {
                        print("editStatus: ${editController.editStatus}");
                        EasyLoading.showSuccess(editController.message,
                            duration: const Duration(seconds: 2));
                        final reportListController =
                            Get.find<ReportListController>();
                        reportListController.fetchReports();
                        Get.offNamed('home');
                      } else {
                        EasyLoading.showError(reportController.message);
                        print("error edit report");
                      }
                    },
                    child: Text('تعديـل'),
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
