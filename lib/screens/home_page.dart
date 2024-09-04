// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_studentmanagement/constants/constants.dart';
import 'package:getx_studentmanagement/controller/controller.dart';
import 'package:getx_studentmanagement/db_functions/functions_db.dart';
import 'package:getx_studentmanagement/model/model.dart';
import 'package:getx_studentmanagement/screens/add_student.dart';
import 'package:getx_studentmanagement/screens/search.dart';
import 'package:getx_studentmanagement/screens/student_details.dart';

final StudentController studentController = Get.put(StudentController());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _fetchStudentsData();
  }

  Future<void> _fetchStudentsData() async {
    final students = await getAllStudents();
    studentController.students.value = students; // Fetch and set data
  }

  Future<void> _showEditDialog(int index) async {
    final student = studentController.students[index];
    final TextEditingController nameController =
        TextEditingController(text: student.name);
    final TextEditingController rollnoController =
        TextEditingController(text: student.rollno.toString());
    final TextEditingController departmentController =
        TextEditingController(text: student.department);
    final TextEditingController phonenoController =
        TextEditingController(text: student.phoneno.toString());
    final TextEditingController ageController =
        TextEditingController(text: student.age.toString());

    showDialog(
      context: context,
      builder: (BuildContext contex) => AlertDialog(
        title: Text("Edit Student"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: rollnoController,
                decoration: InputDecoration(labelText: "Roll No"),
              ),
              TextFormField(
                controller: departmentController,
                decoration: InputDecoration(labelText: "Department"),
              ),
              TextFormField(
                controller: phonenoController,
                decoration: InputDecoration(labelText: "Phone No"),
              ),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(labelText: " Age"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await updateStudent(
                StudentModel(
                  id: student.id,
                  rollno: rollnoController.text,
                  name: nameController.text,
                  department: departmentController.text,
                  phoneno: phonenoController.text,
                  age: ageController.text,
                  imageurl: student.imageurl,
                ),
              );
              Navigator.of(context).pop();
              _fetchStudentsData(); // Refresh the list
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("Changes Updated")));
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {
                Get.to(const SearchPage());
              },
              icon: const Icon(
                Icons.search,
                color: kwhite,
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Logout"),
                        content: Text('Are you sure want to Logout'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('cancel')),
                          TextButton(
                              onPressed: () {
                                exit(0);
                              },
                              child: Text("logout"))
                        ],
                      );
                    });
              },
              icon: Icon(
                Icons.logout,
                color: kwhite,
              ))
        ],
        automaticallyImplyLeading: false,
        backgroundColor: kpurple,
        title: Center(
          child: Text(
            "STUDENT LIST",
            style: TextStyle(color: kwhite, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: Obx(
        () => studentController.students.isEmpty
            ? Center(child: Text("No students available."))
            : ListView.separated(
                itemBuilder: (context, index) {
                  final student = studentController.students[index];
                  final id = student.id;
                  final imageUrl = student.imageurl;
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Details(
                                student: student,
                              )));
                    },
                    leading: GestureDetector(
                      onTap: () {
                        if (imageUrl != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.file(File(imageUrl)),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: CircleAvatar(
                        backgroundImage:
                            imageUrl != null ? FileImage(File(imageUrl)) : null,
                        child: imageUrl == null ? Icon(Icons.person) : null,
                      ),
                    ),
                    title: Text(student.name),
                    subtitle: Text(student.department),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _showEditDialog(index);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("Delete Student"),
                                content:
                                    Text("Are you sure you want to delete?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await deleteStudent(id!);
                                      _fetchStudentsData();
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Deleted Successfully")));
                                    },
                                    child: Text("Ok"),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: studentController.students.length,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddStudent()));
        },
        backgroundColor: kbalck,
        child: Icon(
          Icons.add,
          color: kwhite,
          size: 45,
        ),
      ),
    );
  }
}
