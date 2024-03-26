// ignore_for_file: must_be_immutable

import '/core/resource/color_manager.dart';
import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatefulWidget {
  TextEditingController controller = TextEditingController();
  IconData icon;
  String label;
  String hintText;
  String valedate;
  final Function(String?) onChanged;
  TextFormFieldWidget(
      {super.key,
      required this.icon,
      required this.controller,
      required this.label,
      required this.hintText,
      required this.valedate,
      required this.onChanged});

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //keyboardType: TextInputType.number,
      onChanged: widget.onChanged,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle:
            const TextStyle(color: AppColorManager.greyAppColor, fontSize: 12),
        hintText: widget.hintText,
        hintStyle:
            const TextStyle(color: AppColorManager.greyAppColor, fontSize: 10),
        prefixIcon: Icon(
          widget.icon,
          color: AppColorManager.mainAppColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.all(12.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return widget.valedate;
        }
        return null;
      },
    );
  }
}
