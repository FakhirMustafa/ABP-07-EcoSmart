import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = 'Guest User';
  String _email = 'guest@example.com';
  String? _profileImagePath;

  String get name => _name;
  String get email => _email;
  String? get profileImagePath => _profileImagePath;

  void updateProfile({
    required String name,
    required String email,
    String? image,
  }) {
    _name = name;
    _email = email;
    if (image != null) {
      _profileImagePath = image;
    }
    notifyListeners();
  }

  void updateProfileImage(String path) {
    _profileImagePath = path;
    notifyListeners();
  }
}
