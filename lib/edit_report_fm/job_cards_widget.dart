// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

// import '../create_report/report_controller.dart';
// import '../jobDes/job_description_model.dart';

// class JobCardsWidget extends StatefulWidget {
//   const JobCardsWidget({super.key});

//   @override
//   _JobCardsWidgetState createState() => _JobCardsWidgetState();
// }

// class _JobCardsWidgetState extends State<JobCardsWidget> {
//   List<Map<String, dynamic>> jobCards = [];

//   void _addJobCard() {
//     setState(() {
//       jobCards.add({
//         'description': '',
//         'price': 0,
//         'quantity': 0,
//         'note': '',
//         'image': '',
//         'unit': 0,
//         // Assuming 'id' is null if manually entered
//         'jobDescriptionId': null,
//       });
//     });
//   }

//   void _removeJobCard(int index) {
//     setState(() {
//       jobCards.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             itemCount: jobCards.length,
//             itemBuilder: (context, index) {
//               return JobCard(
//                 data: jobCards[index],
//                 onUpdate: (updatedCard) {
//                   setState(() {
//                     jobCards[index] = updatedCard;
//                   });
//                 },
//                 onDelete: () => _removeJobCard(index), // Add this line
//               );
//             },
//           ),
//         ),
//         ElevatedButton(
//           onPressed: _addJobCard,
//           child: const Text('Add Job Card'),
//         ),
//       ],
//     );
//   }
// }

// class JobCard extends StatefulWidget {
//   final Map<String, dynamic> data;
//   final Function(Map<String, dynamic>) onUpdate;
//   final VoidCallback onDelete;

//   const JobCard(
//       {super.key,
//       required this.data,
//       required this.onUpdate,
//       required this.onDelete});

//   @override
//   _JobCardState createState() => _JobCardState();
// }

// class _JobCardState extends State<JobCard> {
//   // Assume controller is initialized and available here

//   final ReportController reportController = Get.put(ReportController());
  // late TextEditingController _priceController;
  // late TextEditingController _quantityController;
  // late TextEditingController _noteController;
  // late TextEditingController _unitController;
//   File? _image;

  // @override
  // void initState() {
  //   super.initState();
  //   _priceController = TextEditingController();
  //   _quantityController = TextEditingController();
  //   _unitController = TextEditingController();
  //   _noteController = TextEditingController(text: widget.data['note']);
  //   // Initialize fields if data is already present
  //   if (widget.data.containsKey('description')) {}
  //   if (widget.data.containsKey('unit')) {
  //     _unitController.text = widget.data['unit'].toString();
  //   }
  //   if (widget.data.containsKey('price')) {
  //     _priceController.text = widget.data['price'].toString();
  //   }
  //   if (widget.data.containsKey('quantity')) {
  //     _quantityController.text = widget.data['quantity'].toString();
  //   }
  // }

//   void _onDescriptionSelected(String selection) {
//     final option = reportController.desList.firstWhere(
//         (opt) => opt.description == selection,
//         orElse: () => DataAllDes(description: '', id: 0, price: 0, unit: ''));
//     setState(() {
//       _priceController.text = option.price.toString();
//       _unitController.text = option.unit;
//       // Update the widget's data and notify the parent
//       widget.data['description'] = selection;
//       widget.data['price'] = option.price;
//       widget.data['unit'] = option.unit;
//       widget.onUpdate(widget.data);
//     });
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         widget.data['image'] = _image;
//         widget.onUpdate(widget.data);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       reportController.desList
//           .map((des) =>
//               des.description) // Assuming your model has a 'description' field
//           .toList();
//       return SizedBox(
//         width: double.infinity,
//         child:
// Card(
//           elevation: 4.0,
//           margin: const EdgeInsets.all(8.0),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Obx(() {
//                   // Check if data is still loading

//                   if (reportController.isLoading.isTrue) {
//                     return const CircularProgressIndicator();
//                   }
//                   return Autocomplete<DataAllDes>(
//                     displayStringForOption: (DataAllDes option) =>
//                         option.description,
//                     optionsBuilder: (TextEditingValue textEditingValue) {
//                       if (textEditingValue.text.isEmpty) {
//                         return const Iterable<DataAllDes>.empty();
//                       }
//                       return reportController.desList.where((DataAllDes item) {
//                         // Case insensitive search in description
//                         return item.description
//                             .toLowerCase()
//                             .contains(textEditingValue.text.toLowerCase());
//                       });
//                     },
                    // optionsViewBuilder: (BuildContext context,
                    //     AutocompleteOnSelected<DataAllDes> onSelected,
                    //     Iterable<DataAllDes> options) {
                    //   return Align(
                    //     alignment: Alignment.topLeft,
                    //     child: Material(
                    //       child: SizedBox(
                    //         width: 300, // Set your width or make it dynamic
                    //         height: 200, // Set your height or make it dynamic
                    //         child: ListView.builder(
                    //           itemCount: options.length,
                    //           itemBuilder: (BuildContext context, int index) {
                    //             final DataAllDes option =
                    //                 options.elementAt(index);
                    //             return GestureDetector(
                    //               onTap: () {
                    //                 onSelected(option);
                    //               },
                    //               child: ListTile(
                    //                 title: Text(option.description),
                    //                 subtitle:
                    //                     Text("${option.price} ${option.unit}"),
                    //               ),
                    //             );
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //   );
                    // },
//                     onSelected: (DataAllDes selection) {
//                       _onDescriptionSelected(selection.description);
//                     },
//                   );
//                 }),
//                 TextFormField(
//                   controller: _noteController,
//                   decoration: const InputDecoration(labelText: 'ملاحظة'),
//                   onChanged: (value) {
//                     widget.data['note'] = value;
//                     widget.onUpdate(widget.data);
//                   },
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: _priceController,
//                         decoration: const InputDecoration(labelText: 'السعر'),
//                         keyboardType: TextInputType.number,
//                         onChanged: (value) {
//                           widget.data['price'] = int.tryParse(value) ?? 0;
//                           widget.onUpdate(widget.data);
//                         },
//                       ),
//                     ),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _unitController,
//                         decoration: const InputDecoration(labelText: 'الوحدة'),
//                         keyboardType: TextInputType.text,
//                         onChanged: (value) {
//                           widget.data['unit'] = value;
//                           widget.onUpdate(widget.data);
//                         },
//                       ),
//                     ),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _quantityController,
//                         decoration: const InputDecoration(labelText: 'الكمية'),
//                         keyboardType: TextInputType.number,
//                         onChanged: (value) {
//                           widget.data['quantity'] = int.tryParse(value) ?? 0;
//                           widget.onUpdate(widget.data);
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: widget.onDelete, // Use the passed method
//                       child: const Icon(Icons.delete),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             Colors.red, // Set the background color to red
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: _pickImage,
//                       child: const Text('Pick an image'),
//                     ),
//                   ],
//                 ),
//                 // _image != null
//                 //     ? Image.file(_image!)
//                 //     : TextButton(
//                 //         onPressed: _pickImage,
//                 //         child: const Text('Pick an image'),
//                 //       ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _priceController.dispose();
//     _quantityController.dispose();
//     _noteController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../create_report/report_controller.dart';
import '../jobDes/job_description_model.dart';

class JobCardsManager extends StatefulWidget {
  const JobCardsManager({Key? key}) : super(key: key);

  @override
  State<JobCardsManager> createState() => _JobCardsManagerState();
}

class _JobCardsManagerState extends State<JobCardsManager> {
  final ReportController reportController = Get.put(ReportController());
  final List<Map<String, dynamic>> jobCards = [];

  void _addJobCard() {
    setState(() {
      jobCards.add({
        'description': '',
        'price': 0,
        'quantity': 0,
        'note': '',
        'image': null,
        'unit': '',
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
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
                        displayStringForOption: (DataAllDes option) =>
                            option.description,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<DataAllDes>.empty();
                          }
                          return reportController.desList
                              .where((DataAllDes item) {
                            return item.description
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (DataAllDes selection) {
                          setState(() {
                            data['description'] = selection.description;
                            data['price'] = selection.price;
                            data['unit'] = selection.unit;
                            // You may need to set the ID or other properties as well
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Note'),
                        initialValue: data['note'],
                        onChanged: (value) =>
                            setState(() => data['note'] = value),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Price'),
                              initialValue: data['price'].toString(),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => setState(() =>
                                  data['price'] = int.tryParse(value) ?? 0),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Quantity'),
                              initialValue: data['quantity'].toString(),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => setState(() =>
                                  data['quantity'] = int.tryParse(value) ?? 0),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Unit'),
                              initialValue: data['unit'],
                              onChanged: (value) =>
                                  setState(() => data['unit'] = value),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => _removeJobCard(index),
                            style: ElevatedButton.styleFrom(
                                // backgroundColor: Colors.red,
                                ),
                            child: const Icon(Icons.delete),
                          ),
                          ElevatedButton(
                            onPressed: () => _pickImage(data),
                            child: const Icon(Icons.camera_alt_rounded),
                          ),
                        ],
                      ),
                      // Display the selected image if available
                      if (data['image'] != null) Image.file(data['image']),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: _addJobCard,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}


  // void updateTotalPrice(int index) {
  //   setState(() {
  //     int quantity = int.tryParse(quantityControllers[index].text) ?? 0;
  //     int price = int.tryParse(priceControllers[index].text) ?? 0;
  //     int total = quantity * price;
  //     totalpriceControllers[index].text = total.toString();
  //   });
  // }

  // void addRow() {
  //   setState(() {
  //     data.add({
  //       'description': TextEditingController(),
  //       'note': TextEditingController(),
  //       'descriptionImage': null,
  //     });
  //     TextEditingController controller = TextEditingController();
  //     controllers.add(controller);
  //   });
  // }

  // void removeRow(int index) {
  //   setState(() {
  //     print("remove");
  //     if (data.isNotEmpty && index >= 0 && index < data.length) {
  //       data.removeAt(index);
  //       if (index < controllers.length) {
  //         controllers.removeAt(index);
  //       }
  //     }
  //   });
  // }

  // List<Map<String, dynamic>> data = [
  // {
  //   'description': TextEditingController(),
  //   'unit': TextEditingController(),
  //   'quantity': TextEditingController(),
  //   'price': TextEditingController(),
  //   'descriptionImage': null,
  // },
  // ];
  // Function to get an ID based on a description
  // int getIdFromDescription(String description) {
  //   final mapping = data.firstWhere(
  //     (map) => map['description'] == description,
  //     orElse: () => {'id': null},
  //   );
  //   return mapping['id'] ?? 0;
  // }

  // Future<void> _pickImage(int rowIndex) async {
  //   final option = await showDialog<ImageSource>(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('اختر مصدر الصورة',
  //             style: TextStyle(fontWeight: FontWeight.bold)),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: AppColorManager.mainAppColor,
  //               ),
  //               onPressed: () => Navigator.pop(context, ImageSource.camera),
  //               child: const Text(
  //                 'الكاميرا',
  //                 style: TextStyle(color: AppColorManager.white),
  //               ),
  //             ),
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: AppColorManager.mainAppColor,
  //               ),
  //               onPressed: () => Navigator.pop(context, ImageSource.gallery),
  //               child: const Text('المعرض',
  //                   style: TextStyle(color: AppColorManager.white)),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );

  //   if (option == null) return;

  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: option);

  //   if (image != null) {
  //     setState(() {
  //       if (rowIndex < data.length) {
  //         data[rowIndex]['descriptionImage'] = File(image.path);
  //         print(data[rowIndex]['descriptionImage']);
  //       }
  //       if (rowIndex < reportController.reportDescription.length) {
  //         reportController.reportDescription[rowIndex].desImg =
  //             File(image.path);
  //       } else {
  //         // Ensure that the jobDescription list is long enough to add a new item
  //         for (int i = reportController.reportDescription.length;
  //             i <= rowIndex;
  //             i++) {
  //           // reportController.
  //           //     .add(ReportDescription(description: ''));
  //         }
  //         reportController.reportDescription[rowIndex].desImg =
  //             File(image.path);
  //       }
  //       print(
  //           "img in controller in _pickImage function: ${reportController.reportDescription[rowIndex].desImg}");
  //     });
  //   }
  // }

  // final List<TextEditingController> controllers = [];


                    /*Obx(() {
                      final descriptionSuggestions = reportController.desList
                          .map((des) => des
                              .description) // Assuming your model has a 'description' field
                          .toList();
                      return SizedBox(
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
                                    Autocomplete<String>(
                                      optionsBuilder:
                                          (TextEditingValue textEditingValue) {
                                        if (textEditingValue.text == '') {
                                          return const Iterable<String>.empty();
                                        }
                                        return descriptionSuggestions
                                            .where((String option) {
                                          return option.toLowerCase().contains(
                                              textEditingValue.text
                                                  .toLowerCase());
                                        });
                                      },
                                      onSelected: (String selection) {
                                        // Assuming selection is just the description and you can map it to an ID
                                        data[index]['description'] = selection;
                                        var selectedId =
                                            getIdFromDescription(selection);

                                        if (index <
                                            editController
                                                .jobDescription.length) {
                                          editController.jobDescription[index]
                                              .description = selection;
                                          editController
                                              .reportJobDescription[index]
                                              .jobDescriptionId = selectedId;
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
                                          controller:
                                              fieldTextEditingController,
                                          focusNode: fieldFocusNode,
                                          decoration: const InputDecoration(
                                            labelText: 'وصف العمل',
                                            labelStyle: TextStyle(
                                              color:
                                                  AppColorManager.greyAppColor,
                                              fontSize: 12,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            data[index]['description'] = value;

                                            if (index <
                                                editController
                                                    .jobDescription.length) {
                                              editController
                                                  .reportJobDescription[index]
                                                  .jobDescription!
                                                  .description = value;
                                            } else {
                                              // Handle adding a new description logic here, if necessary
                                              JobDescription jobDescription =
                                                  JobDescription(
                                                      description: value);
                                              editController
                                                  .reportJobDescription
                                                  .add(ReportJobDescription(
                                                      jobDescription:
                                                          jobDescription));
                                            }
                                          },
                                        );
                                      },
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.25,
                                          child: TextFormField(
                                            onChanged: (value) {
                                              data[index]['unit'] = value;
                                              if (index <
                                                  editController
                                                      .reportDescription
                                                      .length) {
                                                reportController
                                                    .reportJobDescription[index]
                                                    .note = value;
                                              }
                                            },
                                            decoration: const InputDecoration(
                                              labelText: 'الوحدة',
                                              labelStyle: TextStyle(
                                                color: AppColorManager
                                                    .greyAppColor,
                                                fontSize: 12,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.25,
                                          child: TextFormField(
                                            onChanged: (value) {
                                              data[index]['quantity'] = value;
                                              if (index <
                                                  editController
                                                      .reportJobDescription
                                                      .length) {
                                                editController
                                                    .reportJobDescription[index]
                                                    .quantity = int.tryParse(value);
                                              }
                                            },
                                            decoration: const InputDecoration(
                                              labelText: 'الكمية',
                                              labelStyle: TextStyle(
                                                color: AppColorManager
                                                    .greyAppColor,
                                                fontSize: 12,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.25,
                                          child: TextFormField(
                                            onChanged: (value) {
                                              data[index]['price'] = value;
                                              if (index <
                                                  editController
                                                      .reportJobDescription
                                                      .length) {
                                                editController
                                                    .reportJobDescription[index]
                                                    .price = int.tryParse(value);
                                              }
                                            },
                                            decoration: const InputDecoration(
                                              labelText: 'السعر',
                                              labelStyle: TextStyle(
                                                color: AppColorManager
                                                    .greyAppColor,
                                                fontSize: 12,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ],
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
                                                    data[index]
                                                        ['descriptionImage'],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            print('edit');

                            for (int i = 0;
                                i < editController.reportJobDescription.length;
                                i++) {
                              print(
                                  "id:  ${editController.reportJobDescription[i].jobDescriptionId}");

                              print(
                                  "description : ${editController.reportJobDescription[i].jobDescription!.description}");
                              print(
                                  "unit : ${editController.reportJobDescription[i].jobDescription!.unit}");
                              print(
                                  "quantity : ${editController.reportJobDescription[i].quantity}");
                              print(
                                  "price : ${editController.reportJobDescription[i].jobDescription!.price}");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColorManager.mainAppColor,
                          ),
                          child: Text("تعديـل",
                              style: TextStyle(color: AppColorManager.white)),
                        ),
                      ],
                    )
                  */
