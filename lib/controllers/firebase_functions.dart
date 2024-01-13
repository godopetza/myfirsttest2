import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home_screen.dart';
import '../note.dart';

class HomeController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var db = FirebaseFirestore.instance;
  var isLoading = false.obs;

  var usernotes = <Note>[].obs;

  @override
  void onInit() {
    getusernotes();
    super.onInit();
  }

  Future createNote(String title, String content) async {
    final notesdoc = db.collection('notes').doc();
    final note = Note(
      id: notesdoc.id,
      title: title,
      content: content,
      uid: auth.currentUser!.uid,
    );

    try {
      await notesdoc.set(note.toJson());
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      debugPrint("error in createNote() $e");
    }
  }

  Future updateNote(String id, String title, String content) async {
    final notesdoc = db.collection('notes').doc(id);
    final note = Note(
      id: notesdoc.id,
      title: title,
      content: content,
      uid: auth.currentUser!.uid,
    );

    try {
      await notesdoc.update(note.toJson());
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      debugPrint("error in createNote() $e");
    }
  }

  //by user id
  Future getusernotes() async {
    isLoading = false.obs;
    usernotes = <Note>[].obs;
    try {
      usernotes = <Note>[].obs;
      db
          .collection("notes")
          .where(
            "uid",
            isEqualTo: auth.currentUser!.uid,
          )
          .snapshots()
          .listen((event) {
        usernotes.clear();
        for (var docSnapshot in event.docs) {
          final fundraiser = Note.fromJson(docSnapshot.data());
          usernotes.add(fundraiser);
        }

        isLoading.value = true;
      });
    } catch (e) {
      debugPrint("error in getusernotes() $e");
    }
  }
}
