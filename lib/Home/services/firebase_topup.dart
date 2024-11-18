import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTopup {
  // Fungsi untuk mengambil saldo pengguna dari Firestore
  static Future<double> getSaldoFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          // Mengambil saldo dan konversi ke double
          return userSnapshot.data()?['saldo']?.toDouble() ?? 0.0;
        }
      } catch (e) {
        print("Error saat mengambil saldo: $e");
      }
    }
    return 0.0;
  }

  // Fungsi untuk memperbarui saldo di Firestore
  static Future<void> updateSaldoInFirestore(double newSaldo) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'saldo': newSaldo,
        });
      } catch (e) {
        print("Error saat memperbarui saldo: $e");
      }
    }
  }
}
