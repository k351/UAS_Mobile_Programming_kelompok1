import 'package:flutter/material.dart';
import 'package:uas_flutter/auth/model/auth_model.dart';
import 'package:uas_flutter/auth/services/auth_services.dart';

class UserProvider extends ChangeNotifier {
  // Menyimpan instance AuthService untuk melakukan komunikasi dengan API.
  final AuthService authService = AuthService();
  
  // Menyimpan data pengguna, dimulai dengan nilai default.
  AuthModel _user = AuthModel(name: "", email: "", dob: "", phone: "");

  // Status loading untuk menampilkan indikator saat proses sedang berlangsung.
  bool _isLoading = false;

  AuthModel get user => _user;
  bool get isLoading => _isLoading;

  // Fungsi untuk melakukan sign up (registrasi) pengguna baru.
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
      _user = await authService.signUp(
        username,
        email,
        dob,
        phoneNumber,
        password,
      );
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi untuk mendapatkan data pengguna yang sedang login.
  Future<AuthModel> getUserData() async {
    try {
      _user = await authService.getUserData();
      notifyListeners();
      return _user;
    } catch (e) {
      throw Exception("Failed to get user data: ${e.toString()}");
    }
  }

  // Fungsi untuk melakukan login pengguna.
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await authService.login(email, password);
      _user = await authService.getUserData();
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi untuk mereset state pengguna (misalnya setelah logout).
  void resetState() {
    _user = AuthModel(name: "", email: "", dob: "", phone: "");
    notifyListeners();
  }
}
