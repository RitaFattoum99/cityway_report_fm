// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:cityway_report_fm/homepage/reoport_list_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import '/core/resource/color_manager.dart';
import '/core/resource/size_manger.dart';
import '/edit_report_fm/edit_report_controller.dart';
import '/homepage/allreport_model.dart';
import '/material_model.dart';
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
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();

  late List<Map<String, dynamic>> selectedMaterials;

  List<TextEditingController> desControllers = [];
  TextEditingController unitController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController totalpriceController = TextEditingController();

  List<TextEditingController> unitControllers = [];
  List<TextEditingController> quantityControllers = [];
  List<TextEditingController> priceControllers = [];
  List<TextEditingController> totalpriceControllers = [];
  final ImagePicker _picker = ImagePicker();
  List<ImageSourceWrapper?> selectedImages = [];

  @override
  void initState() {
    super.initState();
    int itemsLength = widget.report.jobDescription!.length;
    desControllers = List.generate(
        itemsLength,
        (index) => TextEditingController(
            text: widget.report.jobDescription![index].description));
    unitControllers = List.generate(
        itemsLength,
        (index) => TextEditingController(
            text: widget.report.jobDescription![index].material?.unit ?? ''));
    quantityControllers = List.generate(
        itemsLength,
        (index) => TextEditingController(
            text: widget.report.jobDescription![index].quantity.toString()));
    priceControllers = List.generate(
        itemsLength,
        (index) => TextEditingController(
            text: widget.report.jobDescription![index].price.toString()));
    totalpriceControllers = List.generate(itemsLength, (index) {
      int total = widget.report.jobDescription![index].quantity *
          widget.report.jobDescription![index].price;
      return TextEditingController(text: total.toString());
    });

    //initialization of selectedMaterials to reflect the initial materials from widget.report
    selectedMaterials = widget.report.jobDescription!.map((jd) {
      // Assuming jd.material is the material object with 'id' and 'name' properties
      return {'id': jd.material?.id, 'name': jd.material?.name};
    }).toList();
    // Assuming report.jobDescription is a list of objects that include desImg (String?).
    selectedImages = widget.report.jobDescription!
        .map(
            (description) => ImageSourceWrapper(networkUrl: description.desImg))
        .toList(growable: true);

    print("selected image: $selectedImages");
    editController.setReportId(widget.report.id!);
  }

  void updateTotalPrice(int index) {
    setState(() {
      int quantity = int.tryParse(quantityControllers[index].text) ?? 0;
      int price = int.tryParse(priceControllers[index].text) ?? 0;
      int total = quantity * price;
      totalpriceControllers[index].text = total.toString();
    });
  }

  void _addNewItem() {
    setState(() {
      print('Adding new item');
      desControllers.add(TextEditingController());
      unitControllers.add(TextEditingController());
      quantityControllers.add(TextEditingController());
      priceControllers.add(TextEditingController());
      totalpriceControllers.add(TextEditingController());
      selectedMaterials.add({'id': null, 'name': null});
      // Add a placeholder for a new image in the list
      selectedImages.add(ImageSourceWrapper(
          networkUrl:
              "https://cityway.boomuae.com/reports_cityway_backend/public/default.png"));
    });
  }

  String? getMaterialNameSafe(int index) {
    if (index < selectedMaterials.length) {
      return selectedMaterials[index]['name'];
    }
    return null; // Or a default value as needed
  }

  // Future<void> _pickImage(int index) async {
  //   final XFile? pickedImage =
  //       await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     setState(() {
  //       // Ensure that the list can accommodate the new item
  //       // This check is redundant if you're only calling _pickImage for existing indices
  //       // But it's useful if you might have dynamic addition of images beyond current list size
  //       while (index >= selectedImages.length) {
  //         selectedImages.add(null); // Ensure list size
  //       }
  //       selectedImages[index] = ImageSourceWrapper(filePath: pickedImage.path);
  //     });
  //   }
  // }
  Future<void> _pickImage(int index) async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        if (index < selectedImages.length) {
          selectedImages[index] =
              ImageSourceWrapper(filePath: pickedImage.path);
        } else {
          selectedImages.add(ImageSourceWrapper(filePath: pickedImage.path));
        }
      });
    }
    // No else part needed, as existing images should remain unchanged if no new image is selected
  }

  void _deleteItem(int index) {
    setState(() {
      desControllers.removeAt(index);
      unitControllers.removeAt(index);
      quantityControllers.removeAt(index);
      priceControllers.removeAt(index);
      totalpriceControllers.removeAt(index);
      selectedMaterials.removeAt(index);
      selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: AppPaddingManger.p50,
          right: AppPaddingManger.p18,
          left: AppPaddingManger.p18,
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
              Text(
                'رقم البلاغ: ${widget.report.reportNumber}',
                style: const TextStyle(
                  color: AppColorManger.mainAppColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'اسم المشروع : ${widget.report.project}',
                style: const TextStyle(
                  color: AppColorManger.secondaryAppColor,
                  fontSize: 16,
                ),
              ),
              Text(
                'الموقع: ${widget.report.location}',
                style: const TextStyle(
                  color: AppColorManger.secondaryAppColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'مقدم البلاغ : ${widget.report.complaintParty!.name}',
                style: const TextStyle(
                  color: AppColorManger.secondaryAppColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'الشخص المسؤول : ${widget.report.contactName}',
                style: const TextStyle(
                  color: AppColorManger.secondaryAppColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'منصب المسؤول : ${widget.report.contactPosition}',
                style: const TextStyle(
                  color: AppColorManger.secondaryAppColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'رقم المسؤول : ${widget.report.contactNumber}',
                style: const TextStyle(
                  color: AppColorManger.secondaryAppColor,
                  fontSize: 16,
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
                      "وصف الأعمال:",
                      style: TextStyle(
                        color: AppColorManger.mainAppColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 600,
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: desControllers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding:
                                EdgeInsets.only(bottom: size.height * 0.0001),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: size.width *
                                      0.8, // Adjust the width as needed
                                  child: Form(
                                    key: _formKey1,
                                    child: TextFormField(
                                        controller: desControllers.isNotEmpty &&
                                                index < desControllers.length
                                            ? desControllers[index]
                                            : TextEditingController(),
                                        decoration: InputDecoration(
                                          labelText: 'الوصف',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'الوصف مطلوب';
                                          }
                                          return null;
                                        }),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(
                                        width: size.width * 0.4,
                                        child: Text(
                                          "المادة:",
                                          style: TextStyle(
                                              color: AppColorManger
                                                  .secondaryAppColor,
                                              fontSize: 16),
                                        )),
                                    SizedBox(
                                      width: size.width * 0.4,
                                      child: Obx(() {
                                        if (editController.isLoading.value) {
                                          return const Text(
                                            "اختر المادة..",
                                            style: TextStyle(
                                                color: AppColorManger
                                                    .mainAppColor),
                                          );
                                        } else {
                                          if (editController
                                              .materialList.isNotEmpty) {
                                            // Map materialList to DropdownMenuItem<String>
                                            List<DropdownMenuItem<String>>
                                                // ignore: unused_local_variable
                                                dropdownItems = editController
                                                    .materialList
                                                    .map((material) {
                                              return DropdownMenuItem<String>(
                                                value: material.name,
                                                child: Text(material.name),
                                              );
                                            }).toList();

                                            // Return the DropdownButton with the dropdownItems
                                            return DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value:
                                                    getMaterialNameSafe(index),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    DataMaterial?
                                                        selectedMaterial =
                                                        editController
                                                            .materialList
                                                            .firstWhereOrNull(
                                                                (material) =>
                                                                    material
                                                                        .name ==
                                                                    newValue);
                                                    if (selectedMaterial !=
                                                        null) {
                                                      selectedMaterials[index] =
                                                          {
                                                        'id':
                                                            selectedMaterial.id,
                                                        'name': selectedMaterial
                                                            .name
                                                      };

                                                      // Also set the price and unit for display
                                                      priceControllers[index]
                                                              .text =
                                                          selectedMaterial.price
                                                              .toString();
                                                      unitControllers[index]
                                                              .text =
                                                          selectedMaterial.unit;

                                                      print(
                                                          'material id in screen on change: ${selectedMaterial.id}');
                                                    }
                                                  });
                                                },
                                                items: editController
                                                    .materialList
                                                    .map((material) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: material.name,
                                                    child: Text(material.name),
                                                  );
                                                }).toList(),
                                              ),
                                            );
                                          } else {
                                            // Return a placeholder widget if materialList is empty
                                            return const Text(
                                                'No items available');
                                          }
                                        }
                                      }),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.15,
                                      child: TextFormField(
                                        // controller: unitController,
                                        controller: unitControllers[index],
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          labelText: 'الوحدة',
                                        ),
                                        onChanged: (value) {
                                          // Ensure that the unit list has enough elements to accommodate the index
                                          if (index <
                                              editController.unit.length) {
                                            editController.unit[index] = value;
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    SizedBox(
                                      width: size.width * 0.1,
                                      child: Form(
                                        key: _formKey2,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller:
                                              quantityControllers[index],
                                          decoration: InputDecoration(
                                            labelText: 'الكمية',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'الكمية مطلوبة';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            updateTotalPrice(index);
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    SizedBox(
                                      width: size.width * 0.15,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: priceControllers[index],
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          labelText: 'سعر الوحدة',
                                        ),
                                        onChanged: (value) {
                                          updateTotalPrice(index);
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    SizedBox(
                                      width: size.width * 0.15,
                                      child: TextFormField(
                                        controller:
                                            totalpriceControllers[index],
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          labelText: 'السعر الكلي',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _pickImage(index),
                                    child: Container(
                                      width:
                                          300, // Specify the width of the container
                                      height:
                                          200, // Specify the height of the container
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: selectedImages[index]
                                                      ?.isLocal ??
                                                  false
                                              ? FileImage(
                                                      File(
                                                          selectedImages[index]!
                                                              .filePath!))
                                                  as ImageProvider
                                              : selectedImages[index]
                                                          ?.isNetwork ??
                                                      false
                                                  ? NetworkImage(
                                                      selectedImages[index]!
                                                          .networkUrl!)
                                                  : NetworkImage(
                                                      "https://cityway.boomuae.com/reports_cityway_backend/public/default.png"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteItem(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed:
                                _addNewItem, // We'll implement this method in the next step
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: AppColorManger.white,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey1.currentState!.validate() &&
                                _formKey2.currentState!.validate()) {
                              List<JobDescription> jobDescriptions = [];
                              for (int i = 0; i < desControllers.length; i++) {
                                String description = desControllers[i].text;
                                int quantity =
                                    int.tryParse(quantityControllers[i].text) ??
                                        0;
                                int price =
                                    int.tryParse(priceControllers[i].text) ?? 0;
                                int materialId =
                                    selectedMaterials[i]['id'] ?? 0;
                                // String? desImgPath = selectedImages[i]
                                //     ?.filePath; // Path of the image
                                String? desImgPath;
                                if (selectedImages[i]?.isLocal ?? false) {
                                  // New image picked by the user
                                  desImgPath = selectedImages[i]?.filePath;
                                } else if (selectedImages[i]?.isNetwork ??
                                    false) {
                                  // Existing image from the server
                                  desImgPath = selectedImages[i]?.networkUrl;
                                }
                                print('image in screen: $desImgPath');
                                // Assuming `JobDescription` constructor can handle all these fields...
                                JobDescription jobDescription = JobDescription(
                                  description: description,
                                  quantity: quantity,
                                  price: price,
                                  materialId: materialId,
                                  desImg: desImgPath,
                                  // Add any new fields here
                                );
                                jobDescriptions.add(jobDescription);
                              }
                              // Call the edit method of the controller and pass the jobDescriptions list
                              EasyLoading.show(
                                  status: 'loading...', dismissOnTap: true);
                              await editController.edit(jobDescriptions);
                              if (editController.editStatus) {
                                EasyLoading.showSuccess(editController.message,
                                    duration: const Duration(seconds: 2));
                                final reportListController =
                                    Get.find<ReportListController>();
                                reportListController.fetchReports();

                                Get.offNamed('home');
                              } else {
                                EasyLoading.showError(editController.message);
                                print("error edit report");
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColorManger.mainAppColor,
                          ),
                          child: Text("تعديـل",
                              style: TextStyle(color: AppColorManger.white)),
                        ),
                      ],
                    )
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

class ImageSourceWrapper {
  String? filePath;
  String? networkUrl;

  ImageSourceWrapper({this.filePath, this.networkUrl});

  bool get isLocal => filePath != null;
  bool get isNetwork => networkUrl != null;
}
