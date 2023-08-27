import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_database/model_hive_database.dart';
import 'package:image_picker/image_picker.dart';

class UpdateData extends StatefulWidget {
  const UpdateData({super.key, required this.student});
  final Student student;

  @override
  // ignore: no_logic_in_create_state
  State<UpdateData> createState() => _UpdateDataState(student: student);
}

class _UpdateDataState extends State<UpdateData> {
  _UpdateDataState({required this.student});
  Student student;
  TextEditingController nameTextEditingController = TextEditingController();
  XFile? _image;
  @override
  Widget build(BuildContext context) {
    nameTextEditingController.text = student.name.toString();

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 7, 74, 129),
          iconTheme: const IconThemeData(color: Colors.orange),
          title: const Text('UPDATE DATA',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold))),
      body: Center(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (_image != null)
                  Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(75),
                          image: DecorationImage(
                              image: FileImage(File(_image!.path)),
                              fit: BoxFit.cover)))
                else
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(75),
                        image: DecorationImage(
                            image: FileImage(File(student.imageUrl.toString())),
                            fit: BoxFit.cover)),
                  ),
                Container(
                  margin: const EdgeInsets.only(left: 100, top: 100),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 7, 74, 129),
                      borderRadius: BorderRadius.circular(25)),
                  child: GestureDetector(
                      onTap: () {
                        showOPtion();
                      },
                      child: const Icon(Icons.camera_alt, color: Colors.white)),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(
                  top: 30, left: 10, right: 10, bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 3,
                        offset: const Offset(-5, -5)),
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 3,
                        offset: const Offset(5, 5))
                  ]),
              child: TextFormField(
                  controller: nameTextEditingController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Enter Name',
                    hintStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w100),
                    border: InputBorder.none,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 7, 74, 129),
                      foregroundColor: Colors.orange),
                  onPressed: () {
                    student.name = nameTextEditingController.text.toString();
                    student.imageUrl = _image!.path;
                    student.save();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Color.fromARGB(255, 7, 74, 129),
                        content: Text(
                          'UPDATE DATA SUCCESSFULLY',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        )));
                  },
                  child: const Text('UPDATE DATA',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold))),
            )
          ],
        ),
      ),
    );
  }

  //get image
  void getimage({required ImageSource source}) async {
    final image = await ImagePicker().pickImage(source: source);

    setState(() {
      _image = image;
    });
  }

  // show option
  Future showOPtion() async {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () {
                    getimage(source: ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'PHOTO GALLARY',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                  )),
              CupertinoActionSheetAction(
                  onPressed: () {
                    getimage(source: ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'CAMERA',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          );
        });
  }
}
