// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_studentmanagement/db_functions/functions_db.dart';
import 'package:getx_studentmanagement/model/model.dart';
import 'package:getx_studentmanagement/screens/home_page.dart';
import 'package:image_picker/image_picker.dart';

class StudentController extends GetxController {
  var students = <StudentModel>[].obs;
  var filteredstudents = <StudentModel>[].obs;

  final nameEditingController = TextEditingController();
  final ageEditingController = TextEditingController();
  final rollnoEditingController = TextEditingController();
  final departmentEditingController = TextEditingController();
  final phonenoEditingController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAllStudents();
  }

  Future<void> fetchAllStudents() async {
    try {
      final fetchedstudents = await getAllStudents();
      students.assignAll(fetchedstudents);
      print(
          "Fetched students: $students"); // Debugging: Print the fetched students

      filteredstudents.assignAll(fetchedstudents);
    } catch (e) {
      if (kDebugMode) {
        print('error fetching students: $e');
      }
    }
  }

  filterStudents() {
    if (searchController.text.isEmpty) {
      studentController.students.value = studentController.students;
    } else {
      studentController.students.value = studentController.students
          .where((student) => student.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }
  }

  Future<void> addStudent(StudentModel student) async {
    try {
      await addStudent(student);
      fetchAllStudents();
    } catch (e) {
      if (kDebugMode) {
        print('error fetching students: $e');
      }
    }
  }

  Future<void> updateStudent(StudentModel updatedStudent) async {
    try {
      await updateStudent(updatedStudent);
      fetchAllStudents();
    } catch (e) {
      if (kDebugMode) {
        print('error fetching students: $e');
      }
    }
  }

  Future<void> deleteStudent(StudentModel studentId) async {
    try {
      await deleteStudent(studentId);
      fetchAllStudents();
    } catch (e) {
      if (kDebugMode) {
        print('error fetching students: $e');
      }
    }
  }

  void search(String query) {
    final lowerCaseQuery = query.toLowerCase();
    if (lowerCaseQuery.isEmpty) {
      filteredstudents.assignAll(students);
    } else {
      filteredstudents.assignAll(
        students.where((student) {
          return student.name.toLowerCase().contains(lowerCaseQuery);
        }).toList(),
      );
    }
  }

  Future<String?> pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        return pickedFile.path;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching students: $e');
      }
      return null;
    }
  }
}
