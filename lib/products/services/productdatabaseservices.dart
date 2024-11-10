import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_flutter/products/models/product.dart';

const String PRODUCT_COLLECTION_REF = "products";

class ProductDatabaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Product> _productsRef;

  ProductDatabaseService() {
    _productsRef = _firestore
        .collection(PRODUCT_COLLECTION_REF)
        .withConverter<Product>(
          fromFirestore: (snapshots, _) => Product.fromJson(snapshots.data()!),
          toFirestore: (product, _) => product.toJson(),
        );
  }

  Future<List<Product>> fetchProducts() async {
    try {
      QuerySnapshot<Product> snapshot = await _productsRef.get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Product?> fetchProductById(String productId) async {
    try {
      DocumentSnapshot<Product> doc = await _productsRef.doc(productId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      rethrow;
    }
  }
}
