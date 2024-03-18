
// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:cityway_report_fm/homepage/reoport_list_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
  // late List<String?> selectedMaterials;
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

  // @override
  // void initState() {
  //   super.initState();
  //   desControllers = List.generate(widget.report.jobDescription!.length,
  //       (index) => TextEditingController());
  //   unitControllers = List.generate(widget.report.jobDescription!.length,
  //       (index) => TextEditingController());
  //   quantityControllers = List.generate(widget.report.jobDescription!.length,
  //       (index) => TextEditingController());
  //   priceControllers = List.generate(widget.report.jobDescription!.length,
  //       (index) => TextEditingController());
  //   totalpriceControllers = List.generate(widget.report.jobDescription!.length,
  //       (index) => TextEditingController());

  //   for (int i = 0; i < widget.report.jobDescription!.length; i++) {
  //     desControllers[i].text = widget.report.jobDescription![i].description;
  //   }
  //   editController.setReportId(widget.report.id!);
  //   // selectedMaterials =
  //   //     List<String?>.filled(widget.report.jobDescription!.length, null);
  //   selectedMaterials = List.generate(widget.report.jobDescription!.length,
  //       (_) => {'id': null, 'name': null});
  // }

  @override
  void initState() {
    super.initState();

    // Initialize description controllers
    desControllers = List.generate(
        widget.report.jobDescription!.length,
        (index) => TextEditingController(
            text: widget.report.jobDescription![index].description));

    // Initialize unit, quantity, and price controllers with values from the report
    unitControllers = List.generate(
        widget.report.jobDescription!.length,
        (index) => TextEditingController(
            text: widget.report.jobDescription![index].material?.unit ?? ''));

    quantityControllers = List.generate(
        widget.report.jobDescription!.length,
        (index) => TextEditingController(
            text: widget.report.jobDescription![index].quantity.toString()));

    priceControllers = List.generate(
        widget.report.jobDescription!.length,
        (index) => TextEditingController(
            text: widget.report.jobDescription![index].price.toString()));

    // Initialize totalpriceControllers, you might need to calculate total price here as well
    totalpriceControllers =
        List.generate(widget.report.jobDescription!.length, (index) {
      int total = widget.report.jobDescription![index].quantity *
          widget.report.jobDescription![index].price;
      return TextEditingController(text: total.toString());
    });

    // Your existing logic for selectedMaterials initialization
    selectedMaterials = List.generate(widget.report.jobDescription!.length,
        (_) => {'id': null, 'name': null});

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
                        itemCount: widget.report.jobDescription!.length,
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
                                  child: TextFormField(
                                    controller: desControllers.isNotEmpty &&
                                            index < desControllers.length
                                        ? desControllers[index]
                                        : TextEditingController(),
                                    decoration: InputDecoration(
                                      labelText: 'الوصف',
                                    ),
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
                                                value: selectedMaterials[index]
                                                        ['name'] ??
                                                    widget
                                                        .report
                                                        .jobDescription?[index]
                                                        .material
                                                        ?.name,
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
                                SizedBox(width: 10), // Spacer between fields

                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: size.width *
                                          0.15, // Adjust the width as needed
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
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: quantityControllers[index],
                                        decoration: InputDecoration(
                                          labelText: 'الكمية',
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
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColorManger.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.network(
                                      widget.report.jobDescription![index]
                                          .desImg!,
                                      fit: BoxFit.cover,
                                      width: 300,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        // Display a placeholder or error message
                                        return Placeholder(); // Example placeholder widget
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Center(
                        child: ElevatedButton(
                      onPressed: () async {
                        List<JobDescription> jobDescriptions = [];
                        for (int i = 0; i < desControllers.length; i++) {
                          String description = desControllers[i].text;
                          // String unit = unitControllers[i].text;
                          int quantity =
                              int.tryParse(quantityControllers[i].text) ?? 0;
                          int price =
                              int.tryParse(priceControllers[i].text) ?? 0;
                          // int totalPrice =
                          //     int.tryParse(totalpriceControllers[i].text) ?? 0;
                          int materialId = selectedMaterials[i]['id']?? 0;
                          print('material id in screen: $materialId');
                          // Create a JobDescription object with the collected data
                          JobDescription jobDescription = JobDescription(
                            description: description,
                            quantity: quantity,
                            price: price,
                            materialId: materialId,
                          );

                          // Add the JobDescription to the list
                          jobDescriptions.add(jobDescription);
                        }

                        // Call the edit method of the controller and pass the jobDescriptions list
                        // await editController.edit(jobDescriptions);
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
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorManger.mainAppColor,
                      ),
                      child: Text("تعديـل",
                          style: TextStyle(color: AppColorManger.white)),
                    ))
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
