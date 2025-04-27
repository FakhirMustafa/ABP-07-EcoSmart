import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tubes_abp/utils/routes.dart';
import 'package:tubes_abp/providers/history_provider.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

    final String kategori = args['kategori'] ?? 'Tidak Diketahui';
    final String penyelesaian = args['penyelesaian'] ?? '-';
    final File? gambar = args['gambar'];

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFF5),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildImage(gambar, size),
                        _buildCategory(kategori),
                        const SizedBox(height: 24),
                        _buildSolution(penyelesaian),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildSaveButton(
                    context,
                    kategori,
                    penyelesaian,
                    gambar,
                  ),
                ),
                _buildBottomNavigation(context),
              ],
            ),
            if (_isSaving)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF4F7942)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(File? gambar, Size size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 35),
      width: size.width,
      height: size.height * 0.4,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: gambar != null
              ? FileImage(gambar)
              : const AssetImage('assets/images/rectangle_1.png') as ImageProvider,
        ),
      ),
    );
  }

  Widget _buildCategory(String kategori) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Dikategorikan sebagai:',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 10,
                color: Color(0xFF999999),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              kategori.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFF363636),
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolution(String penyelesaian) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Penyelesaian',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF363636),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            penyelesaian,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Color(0xFF7A7A7A),
              height: 1.5, // supaya teks lebih nyaman dibaca
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    String kategori,
    String penyelesaian,
    File? gambar,
  ) {
    return GestureDetector(
      onTap: () async {
        if (gambar != null) {
          setState(() => _isSaving = true);
          try {
            await HistoryProvider.saveHistory(
              kategori: kategori,
              penyelesaian: penyelesaian,
              imagePath: gambar.path,
            );
            if (!mounted) return;
            Navigator.pushReplacementNamed(context, rDashboard);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gagal menyimpan ke histori')),
            );
          } finally {
            if (mounted) setState(() => _isSaving = false);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak ada gambar untuk disimpan')),
          );
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF4F7942),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Simpan Hasil',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      color: const Color(0xFF4F7942),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomIcon(context, rDashboard, 'assets/vectors/vector_10_x2.svg'),
          _bottomIcon(context, rHome, 'assets/vectors/vector_3_x2.svg'),
          _profileIcon(context),
        ],
      ),
    );
  }

  Widget _bottomIcon(BuildContext context, String route, String assetPath) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, route),
      child: SvgPicture.asset(assetPath, width: 28, height: 28),
    );
  }

  Widget _profileIcon(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, rProfile),
      child: Column(
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SvgPicture.asset(
            'assets/vectors/vector_11_x2.svg',
            width: 14,
            height: 8,
          ),
        ],
      ),
    );
  }
}
