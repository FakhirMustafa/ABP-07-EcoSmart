import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tubes_abp/utils/routes.dart';
import 'package:tubes_abp/pages/uploadimagepage.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? _pickedImage;

  Future<void> _openGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFF2FFF5),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              width: size.width * 0.85,
              height: size.height * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xFF363636),
                image: _pickedImage != null
                    ? DecorationImage(
                        image: FileImage(_pickedImage!),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        image: AssetImage('assets/images/rectangle_1.png'),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _openGallery,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4F7942),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Galeri',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, rCamera);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4F7942),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Kamera',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, rHistory);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4F7942),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                ),
                child: Text(
                  'Lihat History',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Spacer(),
            Container(
              color: Color(0xFF4F7942),
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomIcon(context, rDashboard, 'assets/vectors/vector_1_x2.svg'),
                  _buildBottomIcon(context, rHome, 'assets/vectors/vector_13_x2.svg'),
                  _buildProfileIcon(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomIcon(BuildContext context, String route, String asset) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: SvgPicture.asset(
        asset,
        width: 28,
        height: 28,
      ),
    );
  }

  Widget _buildProfileIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, rProfile);
      },
      child: Column(
        children: [
          Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SvgPicture.asset(
            'assets/vectors/vector_6_x2.svg',
            width: 14,
            height: 8,
          ),
        ],
      ),
    );
  }
}
