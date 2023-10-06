import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UploadPhotoScreen(),
    );
  }
}

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  _UploadPhotoScreenState createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  final picker = ImagePicker();
  late XFile? pickedFile;
  Uint8List? _image;

  Future getImage() async {
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final unit8List = await pickedFile!.readAsBytes();

    setState(() {
      debugPrint(
          "--------------------- picked file ${pickedFile?.path} ------------------");
      _image = unit8List;
    });
  }

  Future uploadImage() async {
    if (pickedFile != null) {
      final url = Uri.parse("http://yourip:3000/upload");
      final request = http.MultipartRequest('POST', url);

      if (pickedFile != null) {
        final fileName = path.basename(pickedFile!.path);

        debugPrint(
            "--------------------- file name $fileName ------------------");

        request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(Stream.fromFuture(pickedFile!.readAsBytes())),
          _image!.length,
          filename: fileName,
        ));

        try {
          final response = await request.send();
          if (response.statusCode == 200) {
            print('Image uploaded successfully');
          } else {
            print('Failed to upload image');
          }
        } catch (e) {
          debugPrint("--------------------- $e ------------------");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? const Text('No image selected.')
                : Image.memory(
                    _image!,
                    width: 200,
                    height: 200,
                  ),
            ElevatedButton(
              onPressed: getImage,
              child: const Text('Select Image'),
            ),
            ElevatedButton(
              onPressed: uploadImage,
              child: const Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
