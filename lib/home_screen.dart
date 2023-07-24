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

  //Function to delete a note from Firebase
  Future<void> _deleteNote(String id) async {
    try {
      await FirebaseFirestore.instance.collection("notes").doc(id).delete();

      // Refresh the data after deletion
      setState(() {
        _selectedIndex = null; // Reset the selected index
        showContent = true; // Reset showContent to true
      });
    } catch (e) {
      // Handle error
      print("Error deleting note: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (_) {
          return FutureBuilder(
              future: _.getusernotes(),
              builder: (context, snapshot) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('My Notes'),
                    actions: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade200,
                        child: Text(
                          "${_.usernotes.length}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22.0),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  body: GetBuilder<HomeController>(
                      init: HomeController(),
                      builder: (_) {
                        return ListView.separated(
                          itemCount: _.usernotes.length,
                          separatorBuilder: (context, index) =>
                              const Divider(
                            color: Colors.blueGrey,
                          ),
                          itemBuilder: (context, index) => ListTile(
                            trailing: _selectedIndex == index
                                ? SizedBox(
                                    width: 110.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () {
                                            //Open Edit Mode
                                            Get.to(() => EditScreen(
                                                  appBarTitle:
                                                      'Edit Note',
                                                  enableFields: true,
                                                  id: _.usernotes[index]
                                                      .id,
                                                  notetitle: _
                                                      .usernotes[index]
                                                      .title,
                                                  notedesc: _
                                                      .usernotes[index]
                                                      .content,
                                                ));
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.blue),
                                          onPressed: () async {
                                            // Delete note
                                            await _deleteNote(
                                                _.usernotes[index].id);
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : null,
                            title: Text("${_.usernotes[index].title}"),
                            subtitle: showContent
                                ? Text("${_.usernotes[index].content}")
                                : null,
                            onTap: () {
                              //Open View Mode
                              Get.to(() => EditScreen(
                                    appBarTitle: 'View Note',
                                    enableFields: false,
                                    notetitle: _.usernotes[index].title,
                                    notedesc: _.usernotes[index].content,
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
        });
  }
}
