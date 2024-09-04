import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_studentmanagement/constants/constants.dart';
import 'package:getx_studentmanagement/controller/controller.dart';
import 'package:getx_studentmanagement/screens/student_details.dart';

final StudentController studentController = Get.put(StudentController());

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    studentController.fetchAllStudents();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  style: const TextStyle(color: kwhite),
                  controller: searchcontroller,
                  onChanged: (value) {
                    studentController.search(value);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: kbalck,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: kwhite),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: kwhite,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (studentController.filteredstudents.isEmpty) {
                    return const Center(child: Text('No students found'));
                  } else {
                    return ListView.separated(
                      separatorBuilder: (context, index) => kheight10,
                      itemCount: studentController.filteredstudents.length,
                      itemBuilder: (context, index) {
                        var student = studentController.filteredstudents[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    Details(student: student)));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: kwhite,
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: FileImage(
                                                File(student.imageurl!)),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 36),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            student.name,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              color: kbalck,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'department: ${student.department}',
                                            style: const TextStyle(
                                              color: kbalck,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Age: ${student.age}',
                                            style: const TextStyle(
                                              color: kbalck,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
