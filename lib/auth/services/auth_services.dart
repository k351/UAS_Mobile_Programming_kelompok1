import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uas_flutter/auth/model/auth_model.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<AuthModel> signUp(
    String username,
    String email,
    String dob,
    String phoneNumber,
    String password,
  ) async {
    try {
      // Buat pengguna baru dengan email dan password
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Buat instance AuthModel dengan semua data pengguna
      AuthModel authModel = AuthModel(
        name: username,
        email: email,
        dob: dob,
        phone: phoneNumber,
      );

      // Simpan data ke Firestore
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

  signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // Check if the user canceled the sign-in
      if (gUser == null) {
        // Show a snackbar instead of throwing an exception
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google sign-in was canceled.")),
        );
        return;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // Catch the exception and handle it (e.g., show a message to the user)
      print("Error during Google sign-in: ${e.toString()}");

      // Show a snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Failed to sign in with Google: ${e.toString()}")),
      );
    }
  }
}
