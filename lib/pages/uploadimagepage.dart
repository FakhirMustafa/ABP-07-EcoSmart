import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  final picker = ImagePicker();
  File? _image;

  Future<void> pickAndSaveImage() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission ditolak')),
      );
      return;
    }

    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final Directory directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
      String newPath = path.join(directory.path, path.basename(pickedFile.path));
      final newImage = await File(pickedFile.path).copy(newPath);

      setState(() {
        _image = newImage;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gambar disimpan di: ${newImage.path}')),
      );
    } else {
      print('Tidak ada gambar diambil');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Save Image Locally')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null ? Image.file(_image!) : Text('Belum ada gambar'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickAndSaveImage,
              child: Text('Ambil & Simpan Gambar'),
            ),
          ],
        ),
      ),
    );
  }
}
