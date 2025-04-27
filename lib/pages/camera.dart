import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tubes_abp/utils/routes.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  final ImagePicker _picker = ImagePicker();
  Interpreter? _interpreter;
  bool _isLoading = false;

  final List<String> labels = [
    "Kardus",
    "Metal/Kaleng",
    "Kertas",
    "Botol Plastik",
    "Sampah (Susah ditebak)",
  ];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/model/modelsampah.tflite',
      );
      print('Model berhasil dimuat ✅');
    } catch (e) {
      print('Error loading model: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat model: $e')));
    }
  }

  Future<void> _ambilGambar(BuildContext context) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() => _isLoading = true);
      File gambar = File(pickedFile.path);

      try {
        String kategori = await _predictImage(gambar);
        String penyelesaian = _tentukanPenyelesaian(kategori);

        if (!mounted) return;
        Navigator.pushNamed(
          context,
          rResult,
          arguments: {
            'kategori': kategori,
            'penyelesaian': penyelesaian,
            'gambar': gambar,
          },
        );
      } catch (e) {
        print('Error predicting: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal memproses gambar')));
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada gambar yang diambil')),
      );
    }
  }

  Future<String> _predictImage(File image) async {
    if (_interpreter == null) throw Exception("Interpreter belum di-load");

    Uint8List inputBytes = _preProcess(image);
    Float32List input = inputBytes.buffer.asFloat32List();

    List<List<List<List<double>>>> inputTensor = List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) => List.generate(3, (c) => input[(y * 224 + x) * 3 + c]),
        ),
      ),
    );

    var output = List.filled(5, 0.0).reshape([1, 5]);

    _interpreter!.run(inputTensor, output);

    List<double> scores = List<double>.from(output[0]);
    int maxIndex = scores.indexWhere(
      (score) => score == scores.reduce((a, b) => a > b ? a : b),
    );

    return labels[maxIndex];
  }

  Uint8List _preProcess(File imageFile) {
    final imageRaw = img.decodeImage(imageFile.readAsBytesSync())!;
    final resizedImage = img.copyResize(imageRaw, width: 224, height: 224);

    List<double> normalizedPixels = [];

    for (var y = 0; y < resizedImage.height; y++) {
      for (var x = 0; x < resizedImage.width; x++) {
        final pixel = resizedImage.getPixel(x, y);

        final r = img.getRed(pixel);
        final g = img.getGreen(pixel);
        final b = img.getBlue(pixel);

        normalizedPixels.add((r - 127.5) / 127.5);
        normalizedPixels.add((g - 127.5) / 127.5);
        normalizedPixels.add((b - 127.5) / 127.5);
      }
    }

    return Float32List.fromList(normalizedPixels).buffer.asUint8List();
  }

  String _tentukanPenyelesaian(String kategori) {
    switch (kategori) {
      case "Kardus":
        return "Setiap potongan kardus punya potensi! Jadikan kardus bekas sebagai kerajinan tangan seperti kotak organizer, dekorasi dinding, pajangan miniatur, hingga mainan edukatif anak-anak. Sambil mengurangi sampah, kamu juga bisa menciptakan karya yang membanggakan!.";
      case "Metal/Kaleng":
        return "Kaleng bekas bukan hanya sampah, tapi harta karun untuk kreasi! Dengan sedikit sentuhan, kaleng bisa diubah menjadi pot bunga cantik, tempat alat tulis, lampu hias vintage, atau bahkan hiasan dinding artistik. Mulai berkreasi, selamatkan bumi, dan ciptakan karya dari sampah!.";
      case "Kertas":
        return "Kertas bekas? Sulap jadi origami, scrapbook, atau hiasan dinding. Satu lipatan kecil, satu karya besar untuk bumi!";
      case "Botol Plastik":
        return "Botol plastik bekas? Jangan buru-buru buang! Dengan sedikit kreativitas, kamu bisa mengubahnya menjadi pot tanaman unik, tempat alat tulis keren, hiasan gantung warna-warni, hingga mainan edukatif untuk anak. Mari berkreasi dan kurangi sampah plastik dari sekarang!";
      case "Sampah (Susah ditebak)":
      default:
        return "Periksa manual dan buang di tempat sampah umum.";
    }
  }

  void _bukaResultLangsung(BuildContext context) {
    Navigator.pushNamed(
      context,
      rResult,
      arguments: {
        'kategori': 'Contoh',
        'penyelesaian': 'Contoh solusi',
        'gambar': null,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF2FFF5),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF73CAA0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/rectangle_1.png'),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF4F7942)),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: size.height * 0.05,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(
                    onTap: () => _ambilGambar(context),
                    iconPath: 'assets/vectors/vector_5_x2.svg',
                    size: size.width * 0.16,
                  ),
                  _buildButton(
                    onTap: () => _bukaResultLangsung(context),
                    iconData: Icons.article_outlined,
                    size: size.width * 0.16,
                  ),
                  _buildButton(
                    onTap: () {},
                    iconPath:
                        'assets/vectors/bold_video_audio_sound_camera_x2.svg',
                    size: size.width * 0.18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback onTap,
    String? iconPath,
    IconData? iconData,
    required double size,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF4F7942),
          borderRadius: BorderRadius.circular(size / 2),
        ),
        padding: EdgeInsets.all(size * 0.25),
        child:
            iconPath != null
                ? SvgPicture.asset(iconPath, fit: BoxFit.contain)
                : Icon(
                  iconData ?? Icons.camera_alt,
                  color: Colors.white,
                  size: size * 0.5,
                ),
      ),
    );
  }
}
