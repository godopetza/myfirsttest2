import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../note.dart';

class HomeController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var db = FirebaseFirestore.instance;
  var isLoading = false.obs;

  var usernotes = <Note>[];

  //by user id
  Future getusernotes() async {
    isLoading = false.obs;
    usernotes = <Note>[];
    try {
      usernotes = <Note>[];
      await db
          .collection("notes")
          .where(
            "uid",
            isEqualTo: auth.currentUser!.uid,
          )
          .get()
          .then(
        (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            final fundraiser = Note.fromJson(docSnapshot.data());
            usernotes.add(fundraiser);
          }

          isLoading.value = true;
        },
        onError: (e) => print("Error completing getusernotes(): $e"),
      );
    } catch (e) {
      print("error in getusernotes() $e");
    }
  }
}
