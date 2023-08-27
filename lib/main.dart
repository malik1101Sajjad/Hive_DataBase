import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_database/add_data.dart';
import 'package:hive_database/boxes.dart';
import 'package:hive_database/model_hive_database.dart';
import 'package:hive_database/navigation_page.dart';
import 'package:hive_database/show_image.dart';
import 'package:hive_database/update_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String tableName = 'student';
  await Hive.initFlutter();
  Hive.registerAdapter(StudentAdapter());
  await Hive.openBox<Student>(tableName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'STUDENT DATA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 64, 114),
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      body: ValueListenableBuilder<Box<Student>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, value, child) {
          var data = value.values.toList().cast<Student>();
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 5, right: 5),
                margin: const EdgeInsets.all(10),
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
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(NavigationPage(
                        child: UpdateData(student: data[index])));
                  },
                  //leading image
                  leading: GestureDetector(
                    onTap: () {
                      showImage(data[index]);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: FileImage(
                                  File(data[index].imageUrl.toString())),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  //name
                  title: Text(data[index].name.toString(),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  //delete icons
                  trailing: GestureDetector(
                      onTap: () {
                        deleteData(data[index]);
                      },
                      child: const Icon(Icons.delete, color: Colors.grey)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 2, 64, 114),
        onPressed: () {
          Navigator.of(context).push(NavigationPage(child: const AddData()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.orange,
        ),
      ),
    );
  }

  void deleteData(Student student) async {
    await student.delete();
  }

  void showImage(Student student) {
    showGeneralDialog(
        context: context,
        anchorPoint: const Offset(5, 5),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        NavigationPage(child: ShowImageData(student: student)));
                  },
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.orange,
                        image: DecorationImage(
                            image: FileImage(File(student.imageUrl.toString())),
                            fit: BoxFit.cover)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  height: 35,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12))),
                  child: Text(
                    student.name,
                    style: const TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          );
        });
  }
}
