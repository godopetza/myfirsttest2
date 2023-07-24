import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:map_exam/home_screen.dart';
import 'package:map_exam/login_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.to(() => const HomeScreen());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut().whenComplete(() {
        Get.to(() => const LoginScreen());
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
