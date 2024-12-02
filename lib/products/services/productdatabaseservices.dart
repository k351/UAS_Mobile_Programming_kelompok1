import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_flutter/products/models/product.dart';

//String berisi referensi ke product collection di firebase
const String PRODUCT_COLLECTION_REF = "products";

class ProductDatabaseService {
  // Instance Firebase Firestore untuk berkomunikasi dengan database Firestore
  final _firestore = FirebaseFirestore.instance;
  // Referensi koleksi untuk product di Firestore
  late final CollectionReference<Product> _productsRef;

  // Konstruktor untuk menginisialisasi referensi koleksi dengan konverter
  ProductDatabaseService() {
    // Koleksi untuk product dengan konverter JSON ke model product
    _productsRef = _firestore
        .collection(PRODUCT_COLLECTION_REF)
        .withConverter<Product>(
          fromFirestore: (snapshots, _) => Product.fromJson(snapshots.data()!),
          toFirestore: (product, _) => product.toJson(),
        );
  }
  // Mengambil semua data product dari Firestore
  Future<List<Map<String, dynamic>>> fetchProducts(
      [bool withId = false]) async {
    try {
      if (withId == true) {
        QuerySnapshot<Product> snapshot = await _productsRef.get();
        return snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'product': doc.data(),
          };
        }).toList();
      } else {
        QuerySnapshot<Product> snapshot = await _productsRef.get();
        return snapshot.docs.map((doc) {
          return {
            'product': doc.data(),
          };
        }).toList();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Mengambil product berdasarkan id
  Future<Product?> fetchProductById(String productId) async {
    try {
      DocumentSnapshot<Product> doc = await _productsRef.doc(productId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      rethrow;
    }
  }

  // Mengambil product berdasarkan title
  Future<List<Map<String, dynamic>>> fetchProductByTitle(String title) async {
    try {
      QuerySnapshot<Product> snapshot =
          await _productsRef.where('title', isEqualTo: title).get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'product': doc.data(),
        };
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Mengambil product berdasarkan category
  Future<List<Map<String, dynamic>>> fetchProductsByCategory(
      String category) async {
    try {
      QuerySnapshot<Product> snapshot =
          await _productsRef.where('category', isEqualTo: category).get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'product': doc.data(),
        };
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Mengurangi jumlah product berdasarkan id
  Future<void> decreaseProductQuantity(
      String productId, int quantityToDecrease) async {
    try {
      // Fetch the product document by ID
      DocumentSnapshot<Product> doc = await _productsRef.doc(productId).get();

      if (doc.exists) {
        Product product = doc.data()!;

        print(
            "Current quantity for product ID $productId: ${product.quantity}");

        // Ensure the quantity doesn't go below 0
        if (product.quantity - quantityToDecrease >= 0) {
          product =
              product.copyWith(quantity: product.quantity - quantityToDecrease);

          // Update the product with the new quantity in Firestore
          await _productsRef.doc(productId).set(product);
          print(
              "Updated quantity for product ID $productId: ${product.quantity}");
        } else {
          throw Exception("Insufficient quantity to decrease");
        }
      } else {
        throw Exception("Product not found with ID: $productId");
      }
    } catch (e) {
      print("Error in decreasing product quantity: $e");
      rethrow;
    }
  }
}
