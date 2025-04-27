import 'dart:io';
import 'package:flutter/material.dart';
import '../models/history_model.dart';
import '../providers/history_provider.dart';
import 'detail_history.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<HistoryItem> _history = [];
  bool _isNewestFirst = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final data = await HistoryProvider.getHistories(
      newestFirst: _isNewestFirst,
    );
    print('History Loaded: ${data.length} item');
    setState(() {
      _history = data;
      _isLoading = false;
    });
  }

  Future<void> _deleteItem(int index) async {
    await HistoryProvider.deleteHistoryAt(index);
    await _loadHistory();
  }

  Future<void> _clearAll() async {
    await HistoryProvider.clearHistories();
    await _loadHistory();
  }

  void _toggleSort() {
    setState(() {
      _isNewestFirst = !_isNewestFirst;
      _history = _history.reversed.toList();
    });
  }

  void _openDetail(HistoryItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailHistory(historyItem: item)),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Hapus Semua?'),
            content: const Text(
              'Apakah kamu yakin ingin menghapus semua histori?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await _clearAll();
                  if (mounted) Navigator.pop(context);
                },
                child: const Text('Hapus'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FFF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F7942),
        title: const Text('Riwayat Klasifikasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip:
                _isNewestFirst
                    ? 'Urutkan: Lama ke Baru'
                    : 'Urutkan: Baru ke Lama',
            onPressed: _toggleSort,
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Hapus Semua',
            onPressed: _showClearAllDialog,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF4F7942)),
              )
              : _history.isEmpty
              ? const Center(
                child: Text(
                  'Belum ada histori.',
                  style: TextStyle(fontSize: 16, color: Color(0xFF7A7A7A)),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  itemCount: _history.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    return GestureDetector(
                      onTap: () => _openDetail(item),
                      child: _buildHistoryItem(item, index),
                    );
                  },
                ),
              ),
    );
  }

  Widget _buildHistoryItem(HistoryItem item, int index) {
    return Dismissible(
      key: Key('${item.imagePath}-${item.waktu}'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _deleteItem(index),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 12),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: _buildImage(item.imagePath),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                item.kategori,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF363636),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                item.penyelesaian,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Color(0xFF7A7A7A)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    final file = File(path);
    if (file.existsSync()) {
      return Image.file(
        file,
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        height: 100,
        width: double.infinity,
        color: const Color(0xFFE0E0E0),
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
      );
    }
  }
}
