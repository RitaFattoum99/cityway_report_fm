// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:path_provider/path_provider.dart';

import '../core/resource/color_manager.dart';

class SignaturePage extends StatefulWidget {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey;
  final String name;
  final Function(File) onSignatureSaved;
  const SignaturePage(
      {Key? key,
      required this.name,
      required this.signatureGlobalKey,
      required this.onSignatureSaved})
      : super(key: key);

  @override
  SignaturePageState createState() => SignaturePageState();
}

class SignaturePageState extends State<SignaturePage> {
  bool isSignatureCompleted = false;
  String imagePath = '';
  @override
  void initState() {
    super.initState();
  }

  //clear the sign
  void _handleClearButtonPressed() {
    widget.signatureGlobalKey.currentState!.clear();
    setState(() {
      isSignatureCompleted = false;
    });
  }

//save sign as image
  void _handleSaveButtonPressed() async {
    final data =
        await widget.signatureGlobalKey.currentState!.toImage(pixelRatio: 2.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'signed_image_${DateTime.now().millisecondsSinceEpoch}.png';

    final filePath = '${directory.path}/$fileName';
    final buffer = bytes!.buffer;
    await File(filePath).writeAsBytes(
        buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    setState(() {
      isSignatureCompleted = true;
      imagePath = filePath;
      print("imagePath");
      print(imagePath);
    });

    final imageFile = File(imagePath);
    if (imageFile.existsSync()) {
      widget.onSignatureSaved(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (!isSignatureCompleted) {
                return;
              }
              _handleSaveButtonPressed();
            },
            child: Container(
              height: size.height * 0.20,
              width: size.width * 0.6,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: isSignatureCompleted
                  ? Image.file(File(imagePath))
                  : SfSignaturePad(
                      key: widget.signatureGlobalKey,
                      backgroundColor: Colors.white,
                      strokeColor: Colors.black,
                      minimumStrokeWidth: 1.0,
                      maximumStrokeWidth: 4.0,
                    ),
            ),
          ),
          SizedBox(height: size.height * 0.01),
          isSignatureCompleted
              ? const SizedBox()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: _handleSaveButtonPressed,
                        icon: const Icon(
                          Icons.done,
                          color: Colors.green,
                        )),
                    IconButton(
                        onPressed: _handleClearButtonPressed,
                        icon: const Icon(
                          Icons.cancel,
                          color: AppColorManager.mainAppColor,
                        )),
                  ],
                ),
        ],
      ),
    );
  }
}
