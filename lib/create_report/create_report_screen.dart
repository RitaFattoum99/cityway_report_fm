// ignore_for_file: avoid_print
import 'dart:io';

import 'package:cityway_report_fm/create_report/report_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../core/native_service/secure_storage.dart';
import '../homepage/reoport_list_controller.dart';
import '/core/resource/color_manager.dart';
import '/core/resource/size_manager.dart';
import '/core/utils/text_form_field.dart';
import '/create_report/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'complaint_party_model.dart';

class CreateReport extends StatefulWidget {
  const CreateReport({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateReportState createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  final ReportController reportController = Get.put(ReportController());

  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _reportnumController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  bool _isBudgetFieldVisible = false;

  final _formKey1 = GlobalKey<FormBuilderState>();

  late SecureStorage secureStorage = SecureStorage();
  // Placeholder for user name
  String userName = "";
  List<String>? selectedWorkTypes = [];
  final List<TextEditingController> controllers = [];
  final List<TextEditingController> contactInfocontrollers = [];
  List<Map<String, dynamic>> data = [
    {
      'description': TextEditingController(),
      'note': TextEditingController(),
      'descriptionImage': null,
    },
  ];
  List<Map<String, dynamic>> datacontactInfo = [
    {
      'name': TextEditingController(),
      'phone': TextEditingController(),
      'position': TextEditingController(),
    },
  ];

  // Start with one set of fields
  // List<ContactInfo> contacts = [ContactInfo()];
  void _addNewContact() {
    setState(() {
      datacontactInfo.add({
        'name': TextEditingController(),
        'phone': TextEditingController(),
        'position': TextEditingController(),
      });
      TextEditingController controller = TextEditingController();
      contactInfocontrollers.add(controller);
    });
  }

  void _removeContact(int index) {
    setState(() {
      print("remove");
      if (datacontactInfo.isNotEmpty &&
          index >= 0 &&
          index < datacontactInfo.length) {
        datacontactInfo.removeAt(index);
        if (index < contactInfocontrollers.length) {
          contactInfocontrollers.removeAt(index);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch user name on widget initialization
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    secureStorage = SecureStorage();
    String? name = await secureStorage.read("username");
    print('username : $name');
    // Fetch user name using the key
    if (name != null) {
      setState(() {
        userName = name; // Set the user name if found
        print("username in create screen: $userName");
      });
    }
  }

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
                  backgroundColor: AppColorManager.mainAppColor,
                ),
                onPressed: () => Navigator.pop(context, ImageSource.camera),
                child: const Text(
                  'الكاميرا',
                  style: TextStyle(color: AppColorManager.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorManager.mainAppColor,
                ),
                onPressed: () => Navigator.pop(context, ImageSource.gallery),
                child: const Text('المعرض',
                    style: TextStyle(color: AppColorManager.white)),
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
        if (rowIndex < reportController.reportDescription.length) {
          reportController.reportDescription[rowIndex].desImg =
              File(image.path);
        } else {
          // Ensure that the jobDescription list is long enough to add a new item
          for (int i = reportController.reportDescription.length;
              i <= rowIndex;
              i++) {
            reportController.reportDescription
                .add(ReportDescription(description: ''));
          }
          reportController.reportDescription[rowIndex].desImg =
              File(image.path);
        }
        print(
            "img in controller in _pickImage function: ${reportController.reportDescription[rowIndex].desImg}");
      });
    }
  }

  void addRow() {
    setState(() {
      data.add({
        'description': TextEditingController(),
        'note': TextEditingController(),
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

  bool isSuggestionSelected = false; // Flag to track selection source

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إنشاء تقرير',
          style: TextStyle(color: AppColorManager.white),
        ), // Customize with your screen title
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColorManager.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),

        backgroundColor: AppColorManager.mainAppColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: AppPaddingManager.p20,
              left: AppPaddingManager.p12,
              right: AppPaddingManager.p12,
              bottom: AppPaddingManager.p12),
          child: FormBuilder(
            key: _formKey1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center(
                //   child: SizedBox(
                //     height: size.height * 0.1,
                //     child: Image.asset('assets/images/logo.png'),
                //   ),
                // ),
                // const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "مقدم البلاغ:",
                      style: TextStyle(
                          color: AppColorManager.greyAppColor,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    Obx(() {
                      if (reportController.isLoading.value) {
                        return const CircularProgressIndicator();
                      } else {
                        if (reportController.complaintPartyList.isNotEmpty) {
                          var dropdownItems = reportController
                              .complaintPartyList
                              .map((complaintParty) {
                            return DropdownMenuItem<String>(
                              value: complaintParty
                                  .username, // Use 'username' instead of 'name'
                              child: Text(complaintParty
                                  .username), // Use 'username' instead of 'name'
                            );
                          }).toList();

                          String? validSelectedValue =
                              reportController.selected.value;
                          if (!dropdownItems.any(
                              (item) => item.value == validSelectedValue)) {
                            validSelectedValue = dropdownItems.first.value;
                            reportController.selected.value =
                                validSelectedValue!;
                          }

                          return DropdownButton<String>(
                            value: validSelectedValue,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                DataComplaintParty selectedComplaintParty =
                                    reportController.complaintPartyList
                                        .firstWhere(
                                  (complaintParty) =>
                                      complaintParty.username ==
                                      newValue, // Use 'username' instead of 'name'
                                );
                                reportController.complaintPartyId =
                                    selectedComplaintParty.id;
                                reportController.selected.value = newValue;
                              }
                            },
                            items: dropdownItems,
                          );
                        } else {
                          return const Text('No items available');
                        }
                      }
                    }),
                  ],
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم المشروع ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال موقع المشروع ';
                          }
                          return null;
                        },
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
                          reportController.complaintNumber = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال رقم البلاغ ';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      // height: 200,
                      // Use Flexible here to allow the ListView to size itself appropriately within the Column.
                      child: ListView.builder(
                        // Make ListView itself to determine its own height
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: datacontactInfo.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    // Responsible person field
                                    child: TextFormField(
                                      onChanged: (value) {
                                        datacontactInfo[index]['name'] = value;
                                        if (index <
                                            reportController
                                                .contactInfo.length) {
                                          reportController
                                              .contactInfo[index].name = value;
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'الرجاء إدخال اسم المسؤول'; // 'Please enter the name of the responsible person';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "اسم المسؤول",
                                        labelStyle: const TextStyle(
                                            color: AppColorManager.greyAppColor,
                                            fontSize: 12),
                                        hintText: "ادخل اسم المسؤول",
                                        hintStyle: const TextStyle(
                                            color: AppColorManager.greyAppColor,
                                            fontSize: 10),
                                        prefixIcon: const Icon(
                                          Icons.person_2_rounded,
                                          color: AppColorManager.mainAppColor,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(12.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    // Position field
                                    child: TextFormField(
                                      onChanged: (value) {
                                        datacontactInfo[index]['position'] =
                                            value;
                                        if (index <
                                            reportController
                                                .contactInfo.length) {
                                          reportController
                                              .contactInfo[index].name = value;
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'الرجاء إدخال منصب المسؤول';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "منصبه",
                                        labelStyle: const TextStyle(
                                            color: AppColorManager.greyAppColor,
                                            fontSize: 12),
                                        hintText: "ادخل منصب المسؤول",
                                        hintStyle: const TextStyle(
                                            color: AppColorManager.greyAppColor,
                                            fontSize: 10),
                                        prefixIcon: const Icon(
                                          Icons.person_2_rounded,
                                          color: AppColorManager.mainAppColor,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(12.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: TextFormField(
                                      onChanged: (value) {
                                        datacontactInfo[index]['phone'] = value;
                                        if (index <
                                            reportController
                                                .contactInfo.length) {
                                          reportController
                                              .contactInfo[index].phone = value;
                                        }
                                      },
                                      validator: (value) {
                                        String pattern = r'^\+971[0-9]{9}$';
                                        RegExp regex = RegExp(pattern);
                                        if (value == null || value.isEmpty) {
                                          return 'الرجاء إدخال رقم المسؤول'; // 'Please enter the responsible person\'s number';
                                        } else if (!regex.hasMatch(value)) {
                                          return 'الرجاء إدخال رقم صحيح بالشكل +971XXXXXXXXX'; // 'Please enter a valid number in the format +971XXXXXXXXX';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "رقم المسؤول",
                                        labelStyle: const TextStyle(
                                            color: AppColorManager.greyAppColor,
                                            fontSize: 12),
                                        hintText: "ادخل رقم المسؤول",
                                        hintStyle: const TextStyle(
                                            color: AppColorManager.greyAppColor,
                                            fontSize: 10),
                                        prefixIcon: const Icon(
                                          Icons.numbers,
                                          color: AppColorManager.mainAppColor,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(12.0),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.remove,
                                        color: AppColorManager.mainAppColor,
                                        size: 30,
                                      ),
                                      onPressed: () => _removeContact(index),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                            ],
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: _addNewContact,
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
                  ],
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
                  decoration: const InputDecoration(border: InputBorder.none),

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
                Obx(() {
                  final descriptionSuggestions = reportController.desList
                      .map((des) => des.description)
                      .toList();
                  return SizedBox(
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
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
                                Autocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text == '') {
                                      return const Iterable<String>.empty();
                                    }
                                    return descriptionSuggestions
                                        .where((String option) {
                                      return option.toLowerCase().contains(
                                          textEditingValue.text.toLowerCase());
                                    });
                                  },
                                  onSelected: (String selection) {
                                    // Set flag on selection
                                    setState(() => isSuggestionSelected = true);
                                    data[index]['description'] = selection;
                                    if (index <
                                        reportController
                                            .reportDescription.length) {
                                      reportController.reportDescription[index]
                                          .description = selection;
                                    }
                                  },
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
                                        labelText: 'وصف البلاغ',
                                        labelStyle: TextStyle(
                                          color: AppColorManager.greyAppColor,
                                          fontSize: 12,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) {
                                        data[index]['description'] = value;
                                        if (index <
                                            reportController
                                                .reportDescription.length) {
                                          reportController
                                              .reportDescription[index]
                                              .description = value;
                                        } else {
                                          reportController.reportDescription
                                              .add(ReportDescription(
                                                  description: value));
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'الرجاء إدخال وصف البلاغ '; // 'Please enter the name of the responsible person';
                                        }
                                        return null;
                                      },
                                    );
                                  },
                                ),
                                TextFormField(
                                  onChanged: (value) {
                                    data[index]['note'] = value;
                                    if (index <
                                        reportController
                                            .reportDescription.length) {
                                      reportController.reportDescription[index]
                                          .note = value;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'ملاحظات',
                                    labelStyle: TextStyle(
                                      color: AppColorManager.greyAppColor,
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
                                      onTap: () async =>
                                          await _pickImage(index),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: data[index]
                                                    ['descriptionImage'] ==
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
                                        color: AppColorManager.mainAppColor,
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
                  );
                }),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: addRow,
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
                const SizedBox(height: 16),
                // Checkbox to show/hide the budget field
                CheckboxListTile(
                  title: const Text(
                    'تحديد الميزانية؟',
                    style: TextStyle(
                        color: AppColorManager.secondaryAppColor,
                        fontWeight: FontWeight.bold),
                  ),
                  value: _isBudgetFieldVisible,
                  onChanged: (bool? value) {
                    setState(() {
                      _isBudgetFieldVisible = value!;
                      if (_isBudgetFieldVisible) {
                        reportController.urgent = 1;
                      } else {
                        reportController.urgent = 0;
                        reportController.budget = 0;
                      }
                    });
                  },
                ),

                // Conditionally display the TextFormField for budget
                if (_isBudgetFieldVisible)
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _budgetController,
                    decoration: InputDecoration(
                      labelText: "الميزانية",
                      labelStyle: const TextStyle(
                          color: AppColorManager.greyAppColor, fontSize: 12),
                      hintText: "ادخل ميزانيتك",
                      hintStyle: const TextStyle(
                          color: AppColorManager.greyAppColor, fontSize: 10),
                      prefixIcon: const Icon(
                        Icons.attach_money,
                        color: AppColorManager.mainAppColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.all(12.0),
                    ),
                    onChanged: (value) {
                      // Assuming you have a method in your controller to update the budget
                      // Convert the value to a number before storing, handling conversion errors as needed
                      try {
                        final budget = int.parse(value);
                        reportController.budget = budget;
                      } catch (e) {
                        // Handle the error, e.g., show a message that the input is not a valid number
                      }
                    },
                  ),
                const SizedBox(height: 20),

                Center(
                  child: SizedBox(
                    width: size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey1.currentState!.validate()) {
                          print("إرسال");

                          for (int i = 0; i < data.length; i++) {
                            reportController.reportDescription[i].description =
                                data[i]['description'];
                            String noteText;
                            if (data[i]['note'] is TextEditingController) {
                              noteText = data[i]['note'].text;
                            } else if (data[i]['note'] is String) {
                              noteText = data[i]['note'];
                            } else {
                              // Handle unexpected data types, possibly log an error or assign a default value
                              noteText = ""; // Default or error value
                            }
                            reportController.reportDescription[i].note =
                                noteText;
                            // reportController.reportDescription[i].note =
                            //     data[i]['note'].text;
                            reportController.reportDescription[i].desImg =
                                data[i]['descriptionImage'];
                          }
                          for (int i = 0; i < datacontactInfo.length; i++) {
                            if (i < reportController.contactInfo.length) {
                              reportController.contactInfo[i].name =
                                  datacontactInfo[i]['name'];
                            } else {
                              var newContact = ContactInfo(
                                  name: datacontactInfo[i]['name'],
                                  phone: datacontactInfo[i]['phone'],
                                  position: datacontactInfo[i]['position']);
                              reportController.contactInfo.add(newContact);
                            }

                            reportController.contactInfo[i].name =
                                datacontactInfo[i]['name'];
                            reportController.contactInfo[i].phone =
                                datacontactInfo[i]['phone'];
                            reportController.contactInfo[i].position =
                                datacontactInfo[i]['position'];

                            print(
                                "name: ${reportController.contactInfo[i].name}");
                            print(
                                "phone: ${reportController.contactInfo[i].phone}");
                            print(
                                "position: ${reportController.contactInfo[i].position}");
                          }

                          EasyLoading.show(
                              status: 'loading...', dismissOnTap: true);
                          await reportController.create();
                          if (reportController.createStatus) {
                            print(
                                "createStatus: ${reportController.createStatus}");
                            EasyLoading.showSuccess(reportController.message,
                                duration: const Duration(seconds: 2));
                            final reportListController =
                                Get.find<ReportListController>();
                            reportListController.fetchReports();

                            Get.offNamed('home');
                          } else {
                            EasyLoading.showError(reportController.message);
                            Get.offNamed('create');
                            print("error create report");
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
