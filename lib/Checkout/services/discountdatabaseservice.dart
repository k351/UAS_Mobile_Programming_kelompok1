import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_flutter/Checkout/models/discount.dart';

const String DISCOUNTS_COLLECTION_REF = "discounts";

class DiscountDatabaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Discount> _discountsRef;

  DiscountDatabaseService() {
    _discountsRef = _firestore
        .collection(DISCOUNTS_COLLECTION_REF)
        .withConverter<Discount>(
          fromFirestore: (snapshots, _) => Discount.fromJson(snapshots.data()!),
          toFirestore: (discount, _) => discount.toJson(),
        );
  }

  // Fetch all discounts
  Future<List<Discount>> fetchDiscounts() async {
    try {
      QuerySnapshot<Discount> snapshot = await _discountsRef.get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Fetch a specific discount by code and return the discount amount
  Future<num?> fetchDiscountAmountByCode(String code) async {
    try {
      QuerySnapshot<Discount> snapshot =
          await _discountsRef.where('code', isEqualTo: code).get();
      if (snapshot.docs.isNotEmpty) {
        // Return the discount amount (assuming `discountAmount` is a field in your Discount model)
        return snapshot.docs.first.data().discountValue;
      }
      return null; // Discount not found
    } catch (e) {
      rethrow;
    }
  }

  // Add a new discount
  Future<void> addDiscount(Discount discount) async {
    try {
      await _discountsRef.add(discount);
    } catch (e) {
      rethrow;
    }
  }

  // Update an existing discount
  Future<void> updateDiscount(String docId, Discount updatedDiscount) async {
    try {
      await _discountsRef.doc(docId).set(updatedDiscount);
    } catch (e) {
      rethrow;
    }
  }

  // Remove a discount by document ID
  Future<void> removeDiscount(String docId) async {
    try {
      await _discountsRef.doc(docId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
