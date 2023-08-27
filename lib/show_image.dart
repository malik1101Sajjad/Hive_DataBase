import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_database/model_hive_database.dart';

class ShowImageData extends StatelessWidget {
  const ShowImageData({super.key, required this.student});
  final Student student;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 7, 74, 129),
          iconTheme: const IconThemeData(color: Colors.orange),
          title: Text(student.name.toString(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold))),
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 3,
                    offset: const Offset(-5, -5)),
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 3,
                    offset: const Offset(5, 5))
              ],
              color: Colors.orange,
              image: DecorationImage(
                  image: FileImage(File(student.imageUrl.toString())),
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
