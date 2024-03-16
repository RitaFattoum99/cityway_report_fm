// ignore_for_file: avoid_print
import 'dart:io';

import '/core/resource/color_manager.dart';
import '/core/resource/size_manger.dart';
import '/core/utils/text_form_field.dart';
import '/create_report/complaint_party_model.dart';
import '/create_report/report_controller.dart';
import '/create_report/report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateReport extends StatefulWidget {
  const CreateReport({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateReportState createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  // bool isVerticalMode = true;
  // String selectedValue = 'أبو علي';
  // List<String> options = ['أبو سيف', 'أبو محمد', 'أبو أحمد', 'أبو علي'];
  // //String _selectedValue = 'أبو علي';
  // List<String> listOfValue = ['أبو سيف', 'أبو محمد', 'أبو أحمد', 'أبو علي'];

    final ReportController reportController = Get.put(ReportController());

  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _reportnumController = TextEditingController();
  final TextEditingController _administratorController =
      TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  List<String>? selectedWorkTypes = [];
  final List<TextEditingController> controllers = [];
  List<Map<String, dynamic>> data = [
    {
      'description': TextEditingController(),
      'descriptionImage': null,
    },
  ];

  Future<void> _pickImage(int rowIndex) async {
    final option = await showDialog<ImageSource>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('اختر مصدر الصورة',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorManger.mainAppColor,
                ),
                onPressed: () => Navigator.pop(context, ImageSource.camera),
                child: const Text(
                  'الكاميرا',
                  style: TextStyle(color: AppColorManger.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorManger.mainAppColor,
                ),
                onPressed: () => Navigator.pop(context, ImageSource.gallery),
                child: const Text('المعرض',
                    style: TextStyle(color: AppColorManger.white)),
              ),
            ],
          ),
        );
      },
    );

    if (option == null) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: option);

    if (image != null) {
      setState(() {
        if (rowIndex < data.length) {
          data[rowIndex]['descriptionImage'] = File(image.path);
          print(data[rowIndex]['descriptionImage']);
        }
        if (rowIndex < reportController.jobDescription.length) {
          reportController.jobDescription[rowIndex].desImg = File(image.path);
        } else {
          // Ensure that the jobDescription list is long enough to add a new item
          for (int i = reportController.jobDescription.length;
              i <= rowIndex;
              i++) {
            reportController.jobDescription
                .add(JobDescription(description: ''));
          }
          reportController.jobDescription[rowIndex].desImg = File(image.path);
        }
        print(
            "img in controller in _pickImage function: ${reportController.jobDescription[rowIndex].desImg}");
      });
    }
  }

  void addRow() {
    setState(() {
      data.add({
        'description': TextEditingController(),
        'descriptionImage': null,
      });
      TextEditingController controller = TextEditingController();
      controllers.add(controller);
    });
  }

  void removeRow(int index) {
    setState(() {
      print("remove");
      if (data.isNotEmpty && index >= 0 && index < data.length) {
        data.removeAt(index);
        if (index < controllers.length) {
          controllers.removeAt(index);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: AppPaddingManger.p60,
              left: AppPaddingManger.p12,
              right: AppPaddingManger.p12,
              bottom: AppPaddingManger.p12),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: size.height * 0.1,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormFieldWidget(
                  icon: Icons.file_copy,
                  controller: _projectController,
                  label: 'اسم المشروع',
                  hintText: ' ادخل اسم المشروع',
                  onChanged: (value) {
                    reportController.project = value!;
                  },
                  valedate: 'اسم المشروع مطلوب',
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormFieldWidget(
                        icon: Icons.location_on,
                        controller: _locationController,
                        label: 'موقع المشروع',
                        hintText: ' ادخل موقع المشروع',
                        onChanged: (value) {
                          reportController.location = value!;
                        },
                        valedate: 'موقع المشروع مطلوب',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormFieldWidget(
                        icon: Icons.numbers,
                        controller: _reportnumController,
                        label: 'رقم البلاغ',
                        hintText: ' ادخل رقم البلاغ',
                        onChanged: (value) {
                          reportController.reportNumber = value!;
                        },
                        valedate: 'رقم البلاغ مطلوب',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "مقدم البلاغ:",
                      style: TextStyle(
                          color: AppColorManger.greyAppColor,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    /*  Obx(() {
                      if (reportController.isLoading.value) {
                        return CircularProgressIndicator(); // Show loading indicator while loading data
                      } else {
                        if (reportController.complaintPartyList.isNotEmpty) {
                          // Map complaintPartyList to DropdownMenuItem<String>
                          List<DropdownMenuItem<String>> dropdownItems =
                              reportController.complaintPartyList
                                  .map((complaintParty) {
                            return DropdownMenuItem<String>(
                              value: complaintParty.name,
                              child: Text(complaintParty.name),
                            );
                          }).toList();

                          // Return the DropdownButton with the dropdownItems
                          return DropdownButton<String>(
                            value: reportController.selected.value,
                            onChanged: (String? newValue) {
                              reportController.selected.value = newValue!;
                            },
                            items: dropdownItems,
                          );
                        } else {
                          // Return a placeholder widget if complaintPartyList is empty
                          return Text('No items available');
                        }
                      }
                    }),
*/

                    Obx(() {
                      if (reportController.isLoading.value) {
                        return const CircularProgressIndicator(); // Show loading indicator while loading data
                      } else {
                        if (reportController.complaintPartyList.isNotEmpty) {
                          // Map complaintPartyList to DropdownMenuItem<String>
                          List<DropdownMenuItem<String>> dropdownItems =
                              reportController.complaintPartyList
                                  .map((complaintParty) {
                            return DropdownMenuItem<String>(
                              value: complaintParty.name,
                              child: Text(complaintParty.name),
                            );
                          }).toList();

                          // Return the DropdownButton with the dropdownItems
                          return DropdownButton<String>(
                            value: reportController.selected.value,
                            onChanged: (String? newValue) {
                              // Find the selected complaint party by name
                              DataComplaintParty selectedComplaintParty =
                                  reportController.complaintPartyList
                                      .firstWhere(
                                (complaintParty) =>
                                    complaintParty.name == newValue,
                              );

                              // Save the selected complaint party ID to the controller
                              reportController.complaintPartyId =
                                  selectedComplaintParty.id;
                              // Update the selected value in the controller
                              reportController.selected.value = newValue!;
                              print(
                                  'onchange:  ${reportController.complaintPartyId}');
                            },
                            items: dropdownItems,
                          );
                        } else {
                          // Return a placeholder widget if complaintPartyList is empty
                          return const Text('No items available');
                        }
                      }
                    }),

                    /* Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: AppColorManger.greyAppColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 4, right: 4, top: 2),
                          child: DropdownButtonFormField(
                            decoration:
                                const InputDecoration.collapsed(hintText: ''),
                            value: _selectedValue,
                            isExpanded: true,
                            onChanged: (value) {
                              setState(() {
                                _selectedValue = value!;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                _selectedValue = value!;
                              });
                            },
                            items: listOfValue.map((String val) {
                              return DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  */
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormFieldWidget(
                        icon: Icons.person_2_sharp,
                        controller: _administratorController,
                        label: 'الشخص المسؤول',
                        hintText: 'ادخل اسم الشخص المسؤول',
                        onChanged: (value) {
                          reportController.contactName = value!;
                        },
                        valedate: 'اسم  الشخص المسؤول مطلوب',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormFieldWidget(
                        icon: Icons.person_2_sharp,
                        controller: _positionController,
                        label: 'منصبه',
                        hintText: 'ادخل منصب الشخص المسؤول',
                        onChanged: (value) {
                          reportController.contactPosition = value!;
                        },
                        valedate: 'منصب الشخص المسؤول مطلوب',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormFieldWidget(
                  icon: Icons.phone,
                  controller: _numberController,
                  label: 'رقم الشخص المسؤول',
                  hintText: 'ادخل رقمك',
                  onChanged: (value) {
                    reportController.contactNumber = value!;
                  },
                  valedate: 'الرقم مطلوب',
                ),
                FormBuilderCheckboxGroup(
                  onChanged: (List<String>? selectedValues) {
                    setState(() {
                      selectedWorkTypes =
                          selectedValues!.cast<String>().toList();
                      reportController.typeOfWork =
                          selectedWorkTypes!.join(', ');
                      print(selectedWorkTypes);
                      print(reportController.typeOfWork);
                    });
                  },
                  //decoration: const InputDecoration(border: InputBorder.none),
                  wrapCrossAxisAlignment: WrapCrossAlignment.start,
                  // wrapDirection: Axis.horizontal,
                  name: 'workType',
                  options: const [
                    FormBuilderFieldOption(
                        value: 'میكانیـك', child: Text('میكانیـك')),
                    FormBuilderFieldOption(
                        value: 'تھویة وتبرید', child: Text('تھویة وتبرید')),
                    FormBuilderFieldOption(
                        value: 'أعمال مدنیـة', child: Text('أعمال مدنیـة')),
                    FormBuilderFieldOption(
                        value: 'كھرباء', child: Text('كھرباء')),
                    FormBuilderFieldOption(
                        value: 'تمدیدات صحية ', child: Text('تمدیدات صحیة')),
                    FormBuilderFieldOption(
                        value: 'أعمال أخرى', child: Text('أعمال أخرى')),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                onChanged: (value) {
                                  data[index]['description'] = value;
                                  if (index <
                                      reportController.jobDescription.length) {
                                    reportController.jobDescription[index]
                                        .description = value;
                                  } else {
                                    reportController.jobDescription.add(
                                        JobDescription(description: value));
                                  }
                                },
                                decoration: const InputDecoration(
                                  labelText: 'الوصف',
                                  labelStyle: TextStyle(
                                    color: AppColorManger.greyAppColor,
                                    fontSize: 12,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () async => await _pickImage(index),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: data[index]['descriptionImage'] ==
                                              null
                                          ? const Icon(Icons.add_a_photo)
                                          : Image.file(
                                              data[index]['descriptionImage'],
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove,
                                      color: AppColorManger.mainAppColor,
                                      size: 30,
                                    ),
                                    onPressed: () => removeRow(index),
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
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: addRow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColorManger.white,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: () async {
                        print("إرسال");

                        for (int i = 0; i < data.length; i++) {
                          print(
                              "description in data: ${data[i]['description']}");
                          reportController.jobDescription[i].description =
                              data[i]['description'];
                          print(
                              "description: ${reportController.jobDescription[i].description}");
                        }
                        await reportController.create();
                        if (reportController.createStatus) {
                          Get.offNamed('home');
                        } else {
                          print("bad request");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorManger.mainAppColor,
                      ),
                      child: const Text(
                        'إرسال',
                        style: TextStyle(
                            color: AppColorManger.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
