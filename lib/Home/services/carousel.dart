import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCarousel {
  static Future<List<String>> getHomeCarouselFromFirestore() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('carousel')
          .doc('rpwrFZWzOU4hHRZZAYxy')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['homeCarousel'] is List) {
          return List<String>.from(data['homeCarousel']);
        }
      }
    } catch (e) {
      print("Error when loading carousel: $e");
    }
    return [];
  }
}
