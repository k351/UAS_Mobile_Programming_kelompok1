import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas_flutter/auth/model/auth_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  AuthModel _user = AuthModel(id: "", name: "", email: "", dob: "", phone: "");
  bool _isLoading = false;

  AuthModel get user => _user;
  bool get isLoading => _isLoading;

  Future<void> signUp(
    String username,
    String email,
    String dob,
    String phoneNumber,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Buat pengguna baru dengan email dan password
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Buat instance AuthModel dengan semua data pengguna
      AuthModel authModel = AuthModel(
        id: userCredential.user!.uid,
        name: username,
        email: email,
        dob: dob,
        phone: phoneNumber,
      );

      // Simpan data pengguna ke Firestore
      await firebaseFirestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "id": userCredential.user!.uid,
        "username": username,
        "email": email,
        "dob": dob,
        "phone": phoneNumber,
      });

      _user = authModel; // Perbarui model pengguna lokal
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        throw Exception("Invalid email address format.");
      } else if (e.code == "weak-password") {
        throw Exception("The password provided is too weak.");
      } else {
        throw Exception("An error occurred: ${e.message}");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AuthModel> getUserData() async {
    try {
      var userDoc = await firebaseFirestore
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .get();

      var userData = userDoc.data();
      if (userData != null) {
        _user = AuthModel.fromMap(userData);
        notifyListeners();
      }

      return _user;
    } catch (e) {
      throw Exception("Failed to get user data: ${e.toString()}");
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

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
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
