import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/firebase_functions.dart';
import 'edit_screen.dart';

class HomeScreen extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (_) => const HomeScreen());
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showContent = true;
  int? _selectedIndex;
  final controller = Get.put(HomeController());

  //Function to delete a note from Firebase
  Future<void> _deleteNote(String id) async {
    try {
      await FirebaseFirestore.instance.collection("notes").doc(id).delete();
    } catch (e) {
      // Handle error
      debugPrint("Error deleting note: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Notes'),
          actions: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade200,
              child: Text(
                "${controller.usernotes.length}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 22.0),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Obx(() {
          return ListView.separated(
            itemCount: controller.usernotes.length,
            separatorBuilder: (context, index) => const Divider(
              color: Colors.blueGrey,
            ),
            itemBuilder: (context, index) => ListTile(
              trailing: _selectedIndex == index
                  ? SizedBox(
                      width: 110.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              //Open Edit Mode
                              Get.to(() => EditScreen(
                                    appBarTitle: 'Edit Note',
                                    enableFields: true,
                                    id: controller.usernotes[index].id,
                                    notetitle:
                                        controller.usernotes[index].title,
                                    notedesc:
                                        controller.usernotes[index].content,
                                  ));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.blue),
                            onPressed: () async {
                              // Delete note
                              await _deleteNote(controller.usernotes[index].id);
                            },
                          ),
                        ],
                      ),
                    )
                  : null,
              title: Text("${controller.usernotes[index].title}"),
              subtitle: showContent
                  ? Text("${controller.usernotes[index].content}")
                  : null,
              onTap: () {
                //Open View Mode
                Get.to(() => EditScreen(
                      appBarTitle: 'View Note',
                      enableFields: false,
                      notetitle: controller.usernotes[index].title,
                      notedesc: controller.usernotes[index].content,
                    ));
              },
              onLongPress: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          );
        }),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                child: showContent
                    ? const Icon(Icons.unfold_less)
                    : const Icon(Icons.menu),
                heroTag: "btn1",
                tooltip: 'Show less. Hide notes content',
                onPressed: () {
                  setState(() {
                    showContent = !showContent;
                  });
                }),

            /* Notes: for the "Show More" icon use: Icons.menu */

            FloatingActionButton(
              child: const Icon(Icons.add),
              heroTag: "btn2",
              tooltip: 'Add a new note',
              onPressed: () {
                // Add Note Mode
                Get.to(() => const EditScreen(
                      appBarTitle: 'Add Note',
                      enableFields: true,
                      postnew: true,
                    ));
              },
            ),
          ],
        ),
      );
    });
  }
}
