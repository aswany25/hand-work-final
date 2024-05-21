import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/screen/home_worker.dart';
import 'package:image/image.dart' as img;
import '../model/server_post.dart';


class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _userNameTD = TextEditingController();
  final TextEditingController _nationalID = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _postTitleTD = TextEditingController();
  final TextEditingController _postTextTD = TextEditingController();
  PlatformFile? _selectedFile;

  void _clearTextInput() {
    _userNameTD.text = '';
    _nationalID.text = '';
    _phoneNumber.text = '';
    _city.text = '';
    _postTitleTD.text = '';
    _postTextTD.text = '';
    setState(() {
      _selectedFile = null;
    });
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      Uint8List? resizedImage = await _resizeImage(file.bytes!, 800, 800);
      if (resizedImage != null) {
        setState(() {
          _selectedFile = PlatformFile(
            name: file.name,
            size: resizedImage.length,
            bytes: resizedImage,
          );
        });
      }
    }
  }

  Future<Uint8List?> _resizeImage(Uint8List data, int maxWidth, int maxHeight) async {
    try {
      img.Image? image = img.decodeImage(data);
      if (image != null) {
        img.Image resizedImage = img.copyResize(image, width: maxWidth, height: maxHeight);
        return Uint8List.fromList(img.encodePng(resizedImage));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error resizing image: $e');
      }
    }
    return null;
  }

  void _createTable() {
    Services.createTable().then((result) {
      if (result == 'success') {
        if (kDebugMode) {
          print('Success to create table');
        }
      } else {
        if (kDebugMode) {
          print('Failed to create table');
        }
      }
    });
  }

  void _addPost() {
    _createTable();
    if (_userNameTD.text.isEmpty ||
        _nationalID.text.isEmpty ||
        _phoneNumber.text.isEmpty ||
        _city.text.isEmpty ||
        _postTitleTD.text.isEmpty ||
        _postTextTD.text.isEmpty ||
        _selectedFile == null) {
      if (kDebugMode) {
        print('Empty Field');
      }
      return;
    } else {
      String base64Image = base64Encode(_selectedFile!.bytes!);
      Services.addPost(
        _userNameTD.text,
        _nationalID.text,
        _phoneNumber.text,
        _city.text,
        _postTitleTD.text,
        _postTextTD.text,
        base64Image,
      ).then((result) {
        if (result == 'success') {
          _clearTextInput();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.blue,
              content: Row(
                children: [
                  Icon(Icons.thumb_up, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Post added',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Failed to add post',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home worker'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create a post',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _userNameTD,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(hintText: 'Username'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nationalID,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 20),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(14),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: const InputDecoration(hintText: 'National ID'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _phoneNumber,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 20),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: const InputDecoration(hintText: 'Phone Number'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _city,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(hintText: 'City'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _postTitleTD,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _postTextTD,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 20),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(hintText: 'Text Post'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: const Text(
                      'Choose Image',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  if (_selectedFile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _selectedFile!.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addPost,
                    child: const Text(
                      'Share Now',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                   onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const WorkerPage()),
                      );
                    },
                    child: const Text(
                      'Back to home',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
