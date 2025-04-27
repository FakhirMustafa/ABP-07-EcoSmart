import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes_abp/utils/routes.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Color(0xFFF2FFF5),
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'About EcoSmart',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Color(0xFF363636),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Aplikasi pengelolaan limbah menggunakan teknologi pengenalan gambar dan pembelajaran mesin untuk mengklasifikasikan jenis limbah dari gambar pengguna. Tujuan aplikasi ini adalah meningkatkan kesadaran masyarakat tentang pengelolaan limbah yang benar dan mendukung praktik berkelanjutan.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xFF363636),
                ),
              ),
            ),
            SizedBox(height: 30),
            _buildProfile('assets/images/fakhir.png', 'Fakhir Mustafa Afdal', size),
            SizedBox(height: 40),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildMember('assets/images/popo.png', 'Septya Andini Putri'),
                _buildMember('assets/images/nathan.png', 'Nathanael Andra Wijaya'),
                _buildMember('assets/images/kyla.jpg', 'Kyla Azzahra Kinan'),
                _buildMember('assets/images/ario.jpg', 'Ario Mukti Elsandy'),
              ],
            ),
            Spacer(),
            Container(
              color: Color(0xFF4F7942),
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, rDashboard),
                    child: _buildFooterIcon('assets/vectors/vector_7_x2.svg', 26.7),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, rHome),
                    child: _buildFooterIcon('assets/vectors/vector_14_x2.svg', 32),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, rProfile),
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
                          'assets/vectors/vector_4_x2.svg',
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
  Widget _buildProfile(String imagePath, String role, Size size) {
    return Column(
      children: [
        Container(
          width: size.width * 0.25,
          height: size.width * 0.25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          role,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xFF363636),
          ),
        ),
      ],
    );
  }
  Widget _buildMember(String imagePath, String name) {
    return Column(
      children: [
        Container(
          width: 71,
          height: 71,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 10,
            color: Color(0xFF363636),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterIcon(String asset, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(asset),
    );
  }
}
