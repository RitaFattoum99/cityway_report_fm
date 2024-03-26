// // ignore_for_file: prefer_const_constructors, avoid_print
// import 'dart:io';

// import 'package:cityway_report_fm/core/config/service_config.dart';
// import 'package:cityway_report_fm/homepage/reoport_list_controller.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:image_picker/image_picker.dart';

// import '../create_report/report_controller.dart';
// import '/core/resource/color_manager.dart';
// import '../core/resource/size_manager.dart';
// import '/edit_report_fm/edit_report_controller.dart';
// import '/homepage/allreport_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class EditReportScreen extends StatefulWidget {
//   final DataAllReport report;

//   const EditReportScreen({Key? key, required this.report}) : super(key: key);

//   @override
//   State<EditReportScreen> createState() => _EditReportScreenState();
// }

// class _EditReportScreenState extends State<EditReportScreen> {
//   final EditReportController editController = Get.put(EditReportController());
//   final ReportController reportController = Get.put(ReportController());

//   // final _formKey1 = GlobalKey<FormState>();
//   // final _formKey2 = GlobalKey<FormState>();

//   late List<Map<String, dynamic>> selectedMaterials;

//   List<TextEditingController> desControllers = [];
//   TextEditingController unitController = TextEditingController();
//   TextEditingController quantityController = TextEditingController();
//   TextEditingController priceController = TextEditingController();
//   TextEditingController totalpriceController = TextEditingController();

//   List<TextEditingController> unitControllers = [];
//   List<TextEditingController> quantityControllers = [];
//   List<TextEditingController> priceControllers = [];
//   List<TextEditingController> totalpriceControllers = [];
//   List<ImageSourceWrapper?> selectedImages = [];

//   void updateTotalPrice(int index) {
//     setState(() {
//       int quantity = int.tryParse(quantityControllers[index].text) ?? 0;
//       int price = int.tryParse(priceControllers[index].text) ?? 0;
//       int total = quantity * price;
//       totalpriceControllers[index].text = total.toString();
//     });
//   }

//   void addRow() {
//     setState(() {
//       data.add({
//         'description': TextEditingController(),
//         'note': TextEditingController(),
//         'descriptionImage': null,
//       });
//       TextEditingController controller = TextEditingController();
//       controllers.add(controller);
//     });
//   }

//   String? getMaterialNameSafe(int index) {
//     if (index < selectedMaterials.length) {
//       return selectedMaterials[index]['name'];
//     }
//     return null; // Or a default value as needed
//   }

//   List<Map<String, dynamic>> data = [
//     {
//       'description': TextEditingController(),
//       'unit': TextEditingController(),
//       'quantity': TextEditingController(),
//       'price': TextEditingController(),
//       'descriptionImage': null,
//       'job_description_id': null,
//     },
//   ];
//   // Function to get an ID based on a description
//   int getIdFromDescription(String description) {
//     final mapping = data.firstWhere(
//       (map) => map['description'] == description,
//       orElse: () => {'id': null},
//     );
//     return mapping['id'] ?? 0;
//   }

//   Future<void> _pickImage(int rowIndex) async {
//     final option = await showDialog<ImageSource>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('اختر مصدر الصورة',
//               style: TextStyle(fontWeight: FontWeight.bold)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColorManager.mainAppColor,
//                 ),
//                 onPressed: () => Navigator.pop(context, ImageSource.camera),
//                 child: const Text(
//                   'الكاميرا',
//                   style: TextStyle(color: AppColorManager.white),
//                 ),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColorManager.mainAppColor,
//                 ),
//                 onPressed: () => Navigator.pop(context, ImageSource.gallery),
//                 child: const Text('المعرض',
//                     style: TextStyle(color: AppColorManager.white)),
//               ),
//             ],
//           ),
//         );
//       },
//     );

//     if (option == null) return;

//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: option);

//     if (image != null) {
//       setState(() {
//         if (rowIndex < data.length) {
//           data[rowIndex]['descriptionImage'] = File(image.path);
//           print(data[rowIndex]['descriptionImage']);
//         }
//         if (rowIndex < reportController.reportDescription.length) {
//           reportController.reportDescription[rowIndex].desImg =
//               File(image.path);
//         } else {
//           // Ensure that the jobDescription list is long enough to add a new item
//           for (int i = reportController.reportDescription.length;
//               i <= rowIndex;
//               i++) {
//             // reportController.
//             //     .add(ReportDescription(description: ''));
//           }
//           reportController.reportDescription[rowIndex].desImg =
//               File(image.path);
//         }
//         print(
//             "img in controller in _pickImage function: ${reportController.reportDescription[rowIndex].desImg}");
//       });
//     }
//   }

//   final List<TextEditingController> controllers = [];

//   void removeRow(int index) {
//     setState(() {
//       print("remove");
//       if (data.isNotEmpty && index >= 0 && index < data.length) {
//         data.removeAt(index);
//         if (index < controllers.length) {
//           controllers.removeAt(index);
//         }
//       }
//     });
//   }

//   bool isExpanded = false;
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(
//           top: AppPaddingManager.p50,
//           right: AppPaddingManager.p18,
//           left: AppPaddingManager.p18,
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               Center(
//                 child: SizedBox(
//                   height: size.height * 0.1,
//                   child: Image.asset('assets/images/logo.png'),
//                 ),
//               ),
//               SizedBox(
//                 height: size.height * 0.02,
//               ),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.numbers,
//                     color: AppColorManager.mainAppColor,
//                   ),
//                   SizedBox(width: 10),
//                   Text(
//                     widget.report.complaintNumber,
//                     style: const TextStyle(
//                       color: AppColorManager.mainAppColor,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.file_copy,
//                     color: AppColorManager.secondaryAppColor,
//                   ),
//                   SizedBox(width: 10),
//                   Text(
//                     widget.report.project,
//                     style: const TextStyle(
//                       color: AppColorManager.secondaryAppColor,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.location_on,
//                     color: AppColorManager.secondaryAppColor,
//                   ),
//                   SizedBox(width: 10),
//                   Text(
//                     widget.report.location,
//                     style: const TextStyle(
//                       color: AppColorManager.secondaryAppColor,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.person_2_rounded,
//                     color: AppColorManager.secondaryAppColor,
//                   ),
//                   SizedBox(width: 10),
//                   Text(
//                     widget.report.complaintParty,
//                     style: const TextStyle(
//                       color: AppColorManager.secondaryAppColor,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               Text(
//                 'المسؤولين:',
//                 style: const TextStyle(
//                     color: AppColorManager.mainAppColor,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 120,
//                 child: ListView.separated(
//                   separatorBuilder: (context, index) => SizedBox(width: 20),
//                   scrollDirection: Axis.vertical,
//                   itemCount: widget.report.contactInfo.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
                        // decoration: BoxDecoration(
                        //   color: Colors.white,
                        //   boxShadow: [
                        //     BoxShadow(
                        //       color: AppColorManager.secondaryAppColor
                        //           .withOpacity(0.5),
                        //       spreadRadius: 3,
                        //       blurRadius: 4,
                        //       offset: const Offset(0, 1),
                        //     ),
                        //   ],
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.person_2_rounded,
//                                   color: AppColorManager.secondaryAppColor,
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   widget.report.contactInfo[index].name,
//                                   style: const TextStyle(
//                                     color: AppColorManager.secondaryAppColor,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.work_rounded,
//                                   color: AppColorManager.secondaryAppColor,
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   widget.report.contactInfo[index].position,
//                                   style: const TextStyle(
//                                     color: AppColorManager.secondaryAppColor,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.phone,
//                                   color: AppColorManager.secondaryAppColor,
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   widget.report.contactInfo[index].phone,
//                                   style: const TextStyle(
//                                     color: AppColorManager.secondaryAppColor,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 10),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "وصف البلاغ:",
//                       style: TextStyle(
//                         color: AppColorManager.mainAppColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 400,
//                       width: 300,
//                       child: ListView.separated(
//                         separatorBuilder: (context, index) =>
//                             SizedBox(width: 20),
//                         scrollDirection: Axis.horizontal,
//                         itemCount: widget.report.reportDescription.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                 width: 300,
//                                 child: Text(
//                                   isExpanded
//                                       ? widget.report.reportDescription[index]
//                                           .description!
//                                       : "${widget.report.reportDescription[index].description!.substring(0, 50)}...",
//                                   style: const TextStyle(
//                                     color: Colors
//                                         .black, // Replace with your actual color
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     isExpanded = !isExpanded;
//                                   });
//                                 },
//                                 child: Text(
//                                   isExpanded ? "عرض أقل" : "عرض المزيد",
//                                   style: TextStyle(
//                                       color: Colors.blue, fontSize: 16),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Container(
//                                   height: 200,
//                                   width: 300,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                     image: DecorationImage(
//                                       fit: BoxFit.cover,
//                                       image: NetworkImage(getFullImageUrl(widget
//                                           .report
//                                           .reportDescription[index]
//                                           .desImg)),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       "وصف الأعمال:",
//                       style: TextStyle(
//                         color: AppColorManager.mainAppColor,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                     Obx(() {
//                       final descriptionSuggestions = reportController.desList
//                           .map((des) => des
//                               .description) // Assuming your model has a 'description' field
//                           .toList();
//                       return SizedBox(
//                         width: double.infinity,
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: data.length,
//                           itemBuilder: (context, index) {
//                             return Card(
//                               margin: const EdgeInsets.symmetric(vertical: 4),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     /*  Autocomplete<String>(
//                                       optionsBuilder:
//                                           (TextEditingValue textEditingValue) {
//                                         if (textEditingValue.text == '') {
//                                           return const Iterable<String>.empty();
//                                         }
//                                         return descriptionSuggestions
//                                             .where((String option) {
//                                           return option.toLowerCase().contains(
//                                               textEditingValue.text
//                                                   .toLowerCase());
//                                         });
//                                       },
//                                       onSelected: (String selection) {
//                                         data[index]['description'] = selection;
//                                         if (index <
//                                             reportController
//                                                 .reportJobDescription.length) {
//                                           reportController
//                                               .reportJobDescription[index]
//                                               .jobDescription
//                                               .description = selection;
//                                         }
//                                       },
//                                       fieldViewBuilder: (BuildContext context,
//                                           TextEditingController
//                                               fieldTextEditingController,
//                                           FocusNode fieldFocusNode,
//                                           VoidCallback onFieldSubmitted) {
//                                         return TextFormField(
//                                           controller:
//                                               fieldTextEditingController,
//                                           focusNode: fieldFocusNode,
//                                           decoration: const InputDecoration(
//                                             labelText: 'وصف العمل',
//                                             labelStyle: TextStyle(
//                                               color:
//                                                   AppColorManager.greyAppColor,
//                                               fontSize: 12,
//                                             ),
//                                             border: InputBorder.none,
//                                           ),
//                                           onChanged: (value) {
//                                             data[index]['description'] = value;
//                                             if (index <
//                                                 reportController
//                                                     .reportJobDescription
//                                                     .length) {
//                                               reportController
//                                                   .reportJobDescription[index]
//                                                   .jobDescription
//                                                   .description = value;
//                                             } else {
//                                               reportController
//                                                   .reportJobDescription
//                                                   .add();
//                                             }
//                                           },
//                                         );
//                                       },
//                                     ),
//                                     */
//                                     Autocomplete<String>(
//                                       optionsBuilder:
//                                           (TextEditingValue textEditingValue) {
//                                         if (textEditingValue.text == '') {
//                                           return const Iterable<String>.empty();
//                                         }
//                                         return descriptionSuggestions
//                                             .where((String option) {
//                                           return option.toLowerCase().contains(
//                                               textEditingValue.text
//                                                   .toLowerCase());
//                                         });
//                                       },
//                                       onSelected: (String selection) {
//                                         // Assuming selection is just the description and you can map it to an ID
//                                         var selectedId =
//                                             getIdFromDescription(selection);
//                                         data[index]['description'] = selection;
//                                         data[index]['job_description_id'] =
//                                             selectedId; // Ensure this matches your data structure
//                                         // if (index <
//                                         //     reportController
//                                         //         .reportJobDescription.length) {
//                                         //   reportController
//                                         //       .reportJobDescription[index]
//                                         //       .jobDescription
//                                         //       .description = selection;
//                                         //   reportController
//                                         //       .reportJobDescription[index]
//                                         //       .jobDescription
//                                         //       .id = selectedId;
//                                         // }
//                                         if (index <
//                                             editController
//                                                 .jobDescription.length) {
//                                           editController.jobDescription[index]
//                                               .description = selection;
//                                           editController.jobDescription[index]
//                                               .id = selectedId;
//                                         }
//                                       },
//                                       fieldViewBuilder: (
//                                         BuildContext context,
//                                         TextEditingController
//                                             fieldTextEditingController,
//                                         FocusNode fieldFocusNode,
//                                         VoidCallback onFieldSubmitted,
//                                       ) {
//                                         return TextFormField(
//                                           controller:
//                                               fieldTextEditingController,
//                                           focusNode: fieldFocusNode,
//                                           decoration: const InputDecoration(
//                                             labelText: 'وصف العمل',
//                                             labelStyle: TextStyle(
//                                               color:
//                                                   AppColorManager.greyAppColor,
//                                               fontSize: 12,
//                                             ),
//                                             border: InputBorder.none,
//                                           ),
//                                           onChanged: (value) {
//                                             data[index]['description'] = value;

//                                             if (index <
//                                                 editController
//                                                     .jobDescription.length) {
//                                               editController
//                                                   .jobDescription[index]
//                                                   .description = value;
//                                             } else {
//                                               // Handle adding a new description logic here, if necessary
//                                             }
//                                           },
//                                         );
//                                       },
//                                     ),
//                                     Row(
//                                       children: [
//                                         SizedBox(
//                                           width: size.width * 0.25,
//                                           child: TextFormField(
//                                             onChanged: (value) {
//                                               data[index]['unit'] = value;
//                                               if (index <
//                                                   reportController
//                                                       .reportDescription
//                                                       .length) {
//                                                 reportController
//                                                     .reportDescription[index]
//                                                     .note = value;
//                                               }
//                                             },
//                                             decoration: const InputDecoration(
//                                               labelText: 'الوحدة',
//                                               labelStyle: TextStyle(
//                                                 color: AppColorManager
//                                                     .greyAppColor,
//                                                 fontSize: 12,
//                                               ),
//                                               border: InputBorder.none,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: size.width * 0.25,
//                                           child: TextFormField(
//                                             onChanged: (value) {
//                                               data[index]['quantity'] = value;
//                                               if (index <
//                                                   editController
//                                                       .jobDescription.length) {
//                                                 editController
//                                                     .reportDescription[index]
//                                                     .note = value;
//                                               }
//                                             },
//                                             decoration: const InputDecoration(
//                                               labelText: 'الكمية',
//                                               labelStyle: TextStyle(
//                                                 color: AppColorManager
//                                                     .greyAppColor,
//                                                 fontSize: 12,
//                                               ),
//                                               border: InputBorder.none,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: size.width * 0.25,
//                                           child: TextFormField(
//                                             onChanged: (value) {
//                                               data[index]['price'] = value;
//                                               if (index <
//                                                   reportController
//                                                       .reportDescription
//                                                       .length) {
//                                                 reportController
//                                                     .reportDescription[index]
//                                                     .note = value;
//                                               }
//                                             },
//                                             decoration: const InputDecoration(
//                                               labelText: 'السعر',
//                                               labelStyle: TextStyle(
//                                                 color: AppColorManager
//                                                     .greyAppColor,
//                                                 fontSize: 12,
//                                               ),
//                                               border: InputBorder.none,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () async =>
//                                               await _pickImage(index),
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 8),
//                                             child: data[index]
//                                                         ['descriptionImage'] ==
//                                                     null
//                                                 ? const Icon(Icons.add_a_photo)
//                                                 : Image.file(
//                                                     data[index]
//                                                         ['descriptionImage'],
//                                                     width: 150,
//                                                     height: 150,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                           ),
//                                         ),
//                                         IconButton(
//                                           icon: const Icon(
//                                             Icons.remove,
//                                             color: AppColorManager.mainAppColor,
//                                             size: 30,
//                                           ),
//                                           onPressed: () => removeRow(index),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     }),
//                     const SizedBox(height: 16.0),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: addRow,
//                           child: Container(
//                             height: 35,
//                             width: 35,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.green,
//                             ),
//                             child: const Icon(
//                               Icons.add,
//                               color: AppColorManager.white,
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         ElevatedButton(
//                           onPressed: () async {
//                             print('edit');
//                             // List<ReportJobDescription> reportJobDescriptions =
//                             //     [];
//                             for (int i = 0; i < desControllers.length; i++) {
//                               int jobDescriptionId =
//                                   editController.jobDescription[i].id!;
//                               print("jobDescriptionId: $jobDescriptionId");
//                               print(
//                                   "jobDescription : ${editController.jobDescription[i].description}");
//                               int quantity =
//                                   int.tryParse(quantityControllers[i].text) ??
//                                       0;
//                               int price =
//                                   int.tryParse(priceControllers[i].text) ?? 0;
//                               String? desImgPath = selectedImages[i]
//                                   ?.filePath; // Path of the image
//                               if (selectedImages[i]?.isLocal ?? false) {
//                                 // New image picked by the user
//                                 desImgPath = selectedImages[i]?.filePath;
//                               } else if (selectedImages[i]?.isNetwork ??
//                                   false) {
//                                 // Existing image from the server
//                                 desImgPath = selectedImages[i]?.networkUrl;
//                               }
//                               print('image in screen: $desImgPath');
//                               // Assuming `JobDescription` constructor can handle all these fields...
//                               ReportJobDescription reportJobDescription =
//                                   ReportJobDescription(
//                                 jobDescriptionId: jobDescriptionId,
//                                 quantity: quantity,
//                                 price: price,
//                                 desImg: desImgPath,
//                               );
//                               // reportJobDescriptions.add(reportJobDescription);
//                             }
//                             // Call the edit method of the controller and pass the jobDescriptions list
//                             // EasyLoading.show(
//                             //     status: 'loading...', dismissOnTap: true);
//                             // await editController.edit(reportJobDescriptions);
//                             // if (editController.editStatus) {
//                             //   EasyLoading.showSuccess(editController.message,
//                             //       duration: const Duration(seconds: 2));
//                             //   final reportListController =
//                             //       Get.find<ReportListController>();
//                             //   reportListController.fetchReports();

//                             //   Get.offNamed('home');
//                             // } else {
//                             //   EasyLoading.showError(editController.message);
//                             //   print("error edit report");
//                             // }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColorManager.mainAppColor,
//                           ),
//                           child: Text("تعديـل",
//                               style: TextStyle(color: AppColorManager.white)),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ImageSourceWrapper {
//   String? filePath;
//   String? networkUrl;

//   ImageSourceWrapper({this.filePath, this.networkUrl});

//   bool get isLocal => filePath != null;
//   bool get isNetwork => networkUrl != null;
// }
