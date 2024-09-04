// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_studentmanagement/constants/constants.dart';
import 'package:getx_studentmanagement/controller/controller.dart';
import 'package:getx_studentmanagement/model/model.dart';
import 'package:getx_studentmanagement/widgets/appbar_widget.dart';

final StudentController studentController = Get.put(StudentController());

class Details extends StatelessWidget {
  final StudentModel student;

  const Details({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppbarWidget(title: 'Details', backgroundColor: kpurple)),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.deepPurple[200],
              borderRadius: BorderRadius.circular(7)),
          height: 400,
          width: 350,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                  backgroundImage: FileImage(File(student.imageurl.toString())),
                  radius: 60,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  student.name,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'department : ${student.department}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'rollno : ${student.rollno}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'mobile : ${student.phoneno}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
