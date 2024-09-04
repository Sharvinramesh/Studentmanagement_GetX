// ignore: file_names
// ignore_for_file: avoid_print

import 'dart:io';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_studentmanagement/constants/constants.dart';
import 'package:getx_studentmanagement/controller/controller.dart';
import 'package:getx_studentmanagement/db_functions/functions_db.dart';
import 'package:getx_studentmanagement/model/model.dart';
import 'package:getx_studentmanagement/widgets/appbar_widget.dart';
import 'package:getx_studentmanagement/widgets/textformfield_widget.dart';
import 'package:image_picker/image_picker.dart';

// ignore: use_key_in_widget_constructors
class AddStudent extends StatefulWidget {
  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  RxBool photoRequiredError = false.obs;

  final _formKey = GlobalKey<FormState>();
  RxString pickImage = RxString('');
  final StudentController studentController = Get.find<StudentController>();

  final rollnoController = TextEditingController();
  final nameController = TextEditingController();
  final departmentController = TextEditingController();
  final phonenoController = TextEditingController();
  final agecontroller = TextEditingController();
  final fnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppbarWidget(
            title: "Student Information",
            backgroundColor: kpurple,
            fontWeight: FontWeight.w500,
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(25),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction, // Add this line
          child: Column(
            children: [
              CircleAvatar(
                maxRadius: 60,
                child: Obx(
                  () => GestureDetector(
                      onTap: () async {
                        final imagepath = await studentController
                            .pickImage(ImageSource.gallery);
                        pickImage.value = imagepath ?? '';
                        photoRequiredError.value = pickImage.value.isEmpty;
                      },
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: pickImage.value.isNotEmpty
                            ? FileImage(File(pickImage.value))
                            : null,
                        child: pickImage.value.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: kwhite,
                              )
                            : null,
                      )),
                ),
              ),
              Obx(() {
                if (photoRequiredError.value) {
                  return const Text(
                    'Photo required',
                    style: TextStyle(color: Colors.red),
                  );
                } else {
                  return const SizedBox(); // Return an empty SizedBox if no error
                }
              }),
              const SizedBox(height: 20),
              TextformWidget(
                hintText: 'Age',
                textInputType: TextInputType.number,
                controller: agecontroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Age is required';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 1 || age > 120) {
                    return 'Invalid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              TextformWidget(
                hintText: 'Student Name',
                textInputType: TextInputType.name,
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Name is required';
                  }
                  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                    return 'Invalid name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextformWidget(
                hintText: 'Rollno',
                textInputType: TextInputType.number,
                controller: rollnoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Roll no is required';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Invalid roll number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextformWidget(
                textInputType: TextInputType.name,
                hintText: 'Department',
                controller: departmentController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Department is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextformWidget(
                hintText: 'Phone no',
                textInputType: TextInputType.number,
                controller: phonenoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Phone number is required';
                  }
                  final phoneRegExp = RegExp(r'^[0-9]{10}$');
                  if (!phoneRegExp.hasMatch(value)) {
                    return 'Invalid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (pickImage.value.isEmpty) {
                            Get.snackbar('Error', 'you must select an image',
                                backgroundColor: Colors.red, colorText: kwhite);
                          } else {
                            addstudentbuttonclicked();
                            Get.back(); // Navigates back to the previous screen
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kbalck,
                          minimumSize: const Size(350, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 22, color: kwhite),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addstudentbuttonclicked() async {
    try {
      final name = nameController.text.trim();
      final age = agecontroller.text.trim();
      final department = departmentController.text.trim();
      final rollno = rollnoController.text.trim();
      final phoneno = phonenoController.text.trim();

      if (name.isEmpty ||
          age.isEmpty ||
          rollno.isEmpty ||
          department.isEmpty ||
          phoneno.isEmpty) {
        print('One or more fields are empty'); // Debugging
        return;
      }

      final student = StudentModel(
        imageurl: pickImage.value,
        rollno: rollno,
        name: name,
        department: department,
        phoneno: phoneno,
        age: age,
      );

      // Print student details for debugging
      print('Adding student: $student');

      await addStudent(student);

      // Fetch and print all students after insertion
      final allStudents = await getAllStudents();
      print('All students after addition: $allStudents');

      // Clear the controllers after successful addition
      nameController.clear();
      agecontroller.clear();
      rollnoController.clear();
      departmentController.clear();
      phonenoController.clear();
      pickImage.value = '';

      // Update the controller's students list
      studentController.students.value = allStudents;

      // Print students list in the controller for debugging
      print('Updated students in controller: ${studentController.students}');
    } catch (e) {
      if (kDebugMode) {
        print('Error adding student: $e');
      }
    }
  }
}
