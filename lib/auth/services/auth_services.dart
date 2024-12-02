import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_flutter/auth/model/auth_model.dart';

class AuthService {
  // Instance dari FirebaseAuth untuk menangani autentikasi pengguna.
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Instance dari FirebaseFirestore untuk menyimpan dan mengambil data pengguna.
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Fungsi untuk melakukan registrasi pengguna baru (sign-up).
  Future<AuthModel> signUp(
    String username,
    String email,
    String dob,
    String phoneNumber,
    String password,
  ) async {
    try {
      // Membuat pengguna baru dengan email dan password menggunakan Firebase Auth.
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Membuat instance AuthModel dengan data pengguna yang diberikan.
      AuthModel authModel = AuthModel(
        name: username,
        email: email,
        dob: dob,
        phone: phoneNumber,
      );

      // Menyimpan data pengguna di Firestore pada koleksi "users".
      await firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "username": username,
        "email": email,
        "dob": dob,
        "phone": phoneNumber,
        "saldo": 0,
      });

      // Membuat koleksi "carts" untuk pengguna yang baru dibuat, dengan daftar keranjang kosong.
      await firebaseFirestore.collection("carts").doc().set({
        "userId": userCredential.user!.uid,
        "cartList": [],
      });

      return authModel;
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        throw Exception("Invalid email address format.");
      } else if (e.code == "weak-password") {
        throw Exception("The password provided is too weak.");
      } else {
        throw Exception("An error occurred: ${e.message}");
      }
    }
  }

  // Fungsi untuk mengambil data pengguna yang sedang login.
  Future<AuthModel> getUserData() async {
    try {
      var userDoc = await firebaseFirestore
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .get();

      var userData = userDoc.data();
      if (userData != null) {
        return AuthModel.fromMap(userData);
      } else {
        throw Exception("User data not found.");
      }
    } catch (e) {
      throw Exception("Failed to get user data: ${e.toString()}");
    }
  }

  // Fungsi untuk melakukan login pengguna.
  Future<void> login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        throw Exception("Incorrect email address.");
      } else if (e.code == "wrong-password") {
        throw Exception("Incorrect password.");
      } else {
        throw Exception("An error occurred: ${e.message}");
      }
    }
  }
}
