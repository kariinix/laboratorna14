import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Native Integration',
        debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel(
      'com.example.native_integration_example/date');
  File? _image;

  Future<void> _getCurrentDate() async {
    String currentDate;
    try {
      final String result = await platform.invokeMethod('getCurrentDate');
      currentDate = result;
    } on PlatformException catch (e) {
      currentDate = "Failed to get date: '${e.message}'";
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDateDialog(currentDate);
    });
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _showDateDialog(String date) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Current Date',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(
                'https://emojiisland.com/cdn/shop/products/Octopus_Iphone_Emoji_JPG_large.png?v=1571606114',
                height: 60,
                width: 60,
              ),
              const SizedBox(height: 10),
              Text(
                date,
                style: const TextStyle(fontSize: 22),

                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Photo App'),
        centerTitle: true,
        backgroundColor: Colors.purple[200],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _getCurrentDate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[200],
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
              ),
              child: const Text('Get Current Date'),
            ),
            const SizedBox(height: 20),
            if (_image == null)
              GestureDetector(
                onTap: _getImage,
                child: const Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: Colors.black,
                ),
              ),
            const SizedBox(height: 20),
            if (_image != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Image.file(
                  _image!,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),
            if (_image != null)
              GestureDetector(
                onTap: _getImage,
                child: const Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
