import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tubes_abp/utils/routes.dart';
import '../providers/user_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _localPickedImage;

  @override
  void initState() {
    super.initState();
    _syncUserInfo();
  }

  Future<void> _syncUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Provider.of<UserProvider>(context, listen: false).updateProfile(
        name: user.displayName ?? 'Guest User',
        email: user.email ?? 'guest@example.com',
        image: null, 
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _localPickedImage = File(pickedFile.path);
      });
      Provider.of<UserProvider>(context, listen: false).updateProfileImage(pickedFile.path);
    }
  }

  void _logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, rLogin, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF2FFF5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F7942),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _logout(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.logout, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImageFromGallery,
                      child: CircleAvatar(
                        radius: size.width * 0.2,
                        backgroundImage: userProvider.profileImagePath != null
                            ? FileImage(File(userProvider.profileImagePath!))
                            : AssetImage('assets/images/fakhir2.png') as ImageProvider,
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nama:', style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text(
                              userProvider.name.isNotEmpty ? userProvider.name : 'Guest User',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16),
                            Text('Email:', style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text(
                              userProvider.email.isNotEmpty ? userProvider.email : 'guest@example.com',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, rSetting),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF73CAA0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                      ),
                      child: Text('Settings', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, rEditProfile),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF73CAA0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                      ),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Color(0xFF4F7942),
              padding: EdgeInsets.symmetric(vertical: 19.6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, rDashboard),
                    child: SvgPicture.asset(
                      'assets/vectors/vector_16_x2.svg',
                      width: 26.7,
                      height: 26.7,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, rHome),
                    child: SvgPicture.asset(
                      'assets/vectors/vector_15_x2.svg',
                      width: 32,
                      height: 28.8,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, rProfile),
                    child: Column(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/vectors/vector_x2.svg',
                          width: 14,
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
