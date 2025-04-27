class HistoryItem {
  final String kategori;
  final String penyelesaian;
  final String imagePath;
  final DateTime waktu;

  HistoryItem({
    required this.kategori,
    required this.penyelesaian,
    required this.imagePath,
    required this.waktu,
  });

  Map<String, dynamic> toJson() {
    return {
      'kategori': kategori,
      'penyelesaian': penyelesaian,
      'imagePath': imagePath,
      'waktu': waktu.toIso8601String(),
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      kategori: json['kategori'] ?? '',
      penyelesaian: json['penyelesaian'] ?? '',
      imagePath: json['imagePath'] ?? '',
      waktu: DateTime.parse(json['waktu']),
    );
  }
}
