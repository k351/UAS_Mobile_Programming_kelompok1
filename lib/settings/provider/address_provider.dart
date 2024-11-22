import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas_flutter/settings/models/address_model.dart';

class AddressProvider with ChangeNotifier {
  final CollectionReference addressCollection =
      FirebaseFirestore.instance.collection('addresses');

  List<AddressModel> _addresses = [];

  List<AddressModel> get addresses => _addresses;

  /// Fetch addresses by userId
  Future<List<AddressModel>> fetchAddressesByUserId(String userId) async {
    if (userId.isEmpty) {
      print("Error: User ID is empty.");
      return [];
    }

    try {
      QuerySnapshot snapshot =
          await addressCollection.where('userId', isEqualTo: userId).get();

      print("Fetched ${snapshot.docs.length} addresses for userId: $userId");

      _addresses = snapshot.docs
          .map((doc) =>
              AddressModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      notifyListeners();
      return _addresses;
    } catch (e) {
      print("Error fetching addresses: $e");
      throw Exception("Failed to fetch addresses: ${e.toString()}");
    }
  }


  /// Add new address
  Future<void> addAddress(AddressModel address) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User is not logged in');
    }

    final docRef = addressCollection.doc();
    await docRef.set({
      'id': docRef.id,
      'userId': userId,
      'fullAddress': address.fullAddress,
      'postalCode': address.postalCode,
      'recipientName': address.recipientName,
      'addressLabel': address.addressLabel,
    });

    await fetchAddressesByUserId(userId);
  }

  /// Delete address by ID
  Future<void> deleteAddress(String id) async {
    try {
      await addressCollection.doc(id).delete();
      _addresses.removeWhere((address) => address.id == id);
      notifyListeners();
    } catch (e) {
      print("Error deleting address: $e");
      throw Exception("Failed to delete address: ${e.toString()}");
    }
  }

  /// Reset state after logout
  void resetState() {
    _addresses = [];
    notifyListeners();
  }
}
