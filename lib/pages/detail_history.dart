import 'dart:io';
import 'package:flutter/material.dart';
import '../models/history_model.dart';

class DetailHistory extends StatelessWidget {
  final HistoryItem historyItem;

  const DetailHistory({Key? key, required this.historyItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final file = File(historyItem.imagePath);

    return Scaffold(
      backgroundColor: const Color(0xFFF2FFF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F7942),
        title: const Text('Detail Histori'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            file.existsSync()
                ? Image.file(
                    file,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
            const SizedBox(height: 20),
            _buildInfoTile('Kategori Sampah', historyItem.kategori),
            _buildInfoTile('Penyelesaian', historyItem.penyelesaian),
            _buildInfoTile('Waktu Klasifikasi', _formatWaktu(historyItem.waktu)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF363636),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF7A7A7A),
            ),
          ),
        ],
      ),
    );
  }

  String _formatWaktu(DateTime waktu) {
    return '${waktu.day}/${waktu.month}/${waktu.year} ${waktu.hour}:${waktu.minute.toString().padLeft(2, '0')}';
  }
}
