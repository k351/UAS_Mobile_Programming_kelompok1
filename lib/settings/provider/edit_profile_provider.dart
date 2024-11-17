import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_flutter/settings/models/edit_profile_model.dart';

class EditProfileProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EditProfileModel? _profile;
  bool _isLoading = false;

  EditProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;

  // Load user profile data from Firestore
  Future<void> loadUserProfile() async {
    try {
      _isLoading = true;
      notifyListeners();

      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          _profile =
              EditProfileModel.fromMap(doc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      print("Error loading user profile: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile in Firestore
  Future<void> updateUserProfile(EditProfileModel newProfile) async {
    try {
      _isLoading = true;
      notifyListeners();

      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update(newProfile.toMap());
        _profile = newProfile; // Update local model
      }
    } catch (e) {
      print("Error updating user profile: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
