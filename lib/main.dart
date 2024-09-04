import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_studentmanagement/controller/controller.dart';
import 'package:getx_studentmanagement/db_functions/functions_db.dart';
import 'package:getx_studentmanagement/screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StudentController());

    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "STUDENT MANAGEMENT",
      home: HomePage(),
    );
  }
}
