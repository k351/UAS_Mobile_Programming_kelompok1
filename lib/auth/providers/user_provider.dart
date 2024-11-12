import 'package:flutter/material.dart';
import 'package:uas_flutter/auth/model/auth_model.dart';
import 'package:uas_flutter/auth/services/auth_services.dart';

class UserProvider extends ChangeNotifier {
  final AuthService authService = AuthService();
  AuthModel _user = AuthModel(name: "", email: "", dob: "", phone: "");
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

  Future<AuthModel> getUserData() async {
    try {
      _user = await authService.getUserData();
      notifyListeners();
      return _user;
    } catch (e) {
      throw Exception("Failed to get user data: ${e.toString()}");
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await authService.login(email, password);
      _user = await authService.getUserData();
      notifyListeners();
    } catch (e) {
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
