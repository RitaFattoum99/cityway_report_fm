// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String projectName = "";
  String reportParty = "";
  String location = "";
  String contactNumber = "";
  String contactPosition = "";
  List<String> workTypes = [];
  List<Map<String, String>> jobDescriptions = [];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Perform form submission logic here
      // For now, we'll just print the data to the console
      print("Project Name: $projectName");
      print("Report Party: $reportParty");
      print("Location: $location");
      print("Contact Number: $contactNumber");
      print("Contact Position: $contactPosition");
      print("Work Types: $workTypes");
      print("Job Descriptions: $jobDescriptions");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Form Submission",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Form Submission"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Project Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a project name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    projectName = value!;
                  },
                ),
                // Add similar TextFormField widgets for other fields (report party, location, etc.)

                // Multi-select checkboxes for work types
                CheckboxListTile(
                  title: const Text("Work Types"),
                  value: workTypes.contains("Type A"),
                  onChanged: (newValue) {
                    setState(() {
                      if (newValue!) {
                        workTypes.add("Type A");
                      } else {
                        workTypes.remove("Type A");
                      }
                    });
                  },
                ),
                // Add more checkboxes for other work types

                // Dynamic table for job descriptions
                ElevatedButton(
                  onPressed: () {
                    // Show a dialog to input job description
                    // Add the entered description to the jobDescriptions list
                  },
                  child: const Text("Add Job Description"),
                ),

                // Submit button
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
