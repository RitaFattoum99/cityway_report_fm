// ignore_for_file: prefer_const_constructors, avoid_print

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

  List<TextEditingController> desControllers = [];
  TextEditingController unitController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController totalpriceController = TextEditingController();

  List<TextEditingController> unitControllers = [];
  List<TextEditingController> quantityControllers = [];
  List<TextEditingController> priceControllers = [];
  List<TextEditingController> totalpriceControllers = [];

  @override
  void initState() {
    super.initState();
    desControllers = List.generate(widget.report.jobDescription!.length,
        (index) => TextEditingController());
    unitControllers = List.generate(widget.report.jobDescription!.length,
        (index) => TextEditingController());
    quantityControllers = List.generate(widget.report.jobDescription!.length,
        (index) => TextEditingController());
    priceControllers = List.generate(widget.report.jobDescription!.length,
        (index) => TextEditingController());
    totalpriceControllers = List.generate(widget.report.jobDescription!.length,
        (index) => TextEditingController());

    for (int i = 0; i < widget.report.jobDescription!.length; i++) {
      desControllers[i].text = widget.report.jobDescription![i].description;
    }
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
                                SizedBox(
                                  width: size.width * 0.8,
                                  child: Obx(() {
                                    if (editController.isLoading.value) {
                                      return const SizedBox();
                                    } else {
                                      if (editController
                                          .materialList.isNotEmpty) {
                                        // Map materialList to DropdownMenuItem<String>
                                        List<DropdownMenuItem<String>>
                                            dropdownItems = editController
                                                .materialList
                                                .map((material) {
                                          return DropdownMenuItem<String>(
                                            value: material.name,
                                            child: Text(material.name),
                                          );
                                        }).toList();

                                        // Return the DropdownButton with the dropdownItems
                                        return DropdownButton<String>(
                                          value: editController.selected.value,
                                          onChanged: (String? newValue) {
                                            // Find the selected material by name
                                            DataMaterial setSelectedMaterial =
                                                editController.materialList
                                                    .firstWhere(
                                              (material) =>
                                                  material.name == newValue,
                                            );

                                            // Save the selected material ID to the controller
                                            editController.materialList[index]
                                                .id = setSelectedMaterial.id;
                                            // Update the selected value in the controller
                                            editController.selected.value =
                                                newValue!;
                                            print(
                                                'onchange:  ${editController.materialList[index].id}');
                                          },
                                          items: dropdownItems,
                                        );
                                      } else {
                                        // Return a placeholder widget if materialList is empty
                                        return const Text('No items available');
                                      }
                                    }
                                  }),
                                ),
                                SizedBox(width: 10), // Spacer between fields
                                SizedBox(
                                  width: size.width *
                                      0.8, // Adjust the width as needed
                                  child: TextFormField(
                                    // controller: unitController,
                                    controller: unitControllers[index],

                                    decoration: InputDecoration(
                                      labelText: 'الوحدة',
                                    ),
                                    onChanged: (value) {
                                      // Ensure that the unit list has enough elements to accommodate the index
                                      if (index < editController.unit.length) {
                                        editController.unit[index] = value;
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.2,
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
                                      width: size.width * 0.2,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: priceControllers[index],
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
                                      width: size.width * 0.2,
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
                                /*Container(
                                  decoration: BoxDecoration(
                                    color: AppColorManger.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.network(
                                     widget
                                      .report.jobDescription![index].desImg!,
                                    // imageList2[index],
                                    fit: BoxFit.cover,
                                    height: 150,
                                    width: 150,
                                  ),
                                ),*/

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
                          //String unit = unitControllers[i].text;
                          int quantity =
                              int.tryParse(quantityControllers[i].text) ?? 0;
                          int price =
                              int.tryParse(priceControllers[i].text) ?? 0;
                          //int totalPrice = int.tryParse(totalpriceControllers[i].text) ?? 0;
                          int materialId = editController.materialList[i].id;
                          // Create a JobDescription object with the collected data
                          JobDescription jobDescription = JobDescription(
                            description: description,
                            // unit: unit,
                            quantity: quantity,
                            price: price,
                            // totalPrice: totalPrice,
                            materialId: materialId,
                          );

                          // Add the JobDescription to the list
                          jobDescriptions.add(jobDescription);
                        }

                        // Call the edit method of the controller and pass the jobDescriptions list
                        await editController.edit(jobDescriptions);
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
