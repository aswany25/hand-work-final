import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/model/posts.dart';
import 'package:flutter_application_1/screen/CreatePost.dart';
import 'package:image/image.dart' as img;
import 'AccountDetilsWorker.dart';
import 'Login.dart';
import '../model/server_post.dart';

class WorkerPage extends StatefulWidget {
  const WorkerPage({Key? key}) : super(key: key);

  @override
  _WorkerPageState createState() => _WorkerPageState();
}

class _WorkerPageState extends State<WorkerPage> {
  List<Posts> _posts = [];

  @override
  void initState() {
    _getPosts();
    super.initState();
  }

  int _selectedIndex = 0;

  Future<void> _getPosts() async {
    try {
      List<Posts> posts = await Services.getAllPosts();
      setState(() {
        _posts = posts;
      });
      if (kDebugMode) {
        print('Length: ${_posts.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching posts: $e');
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        _getPosts(); // استدعاء الدالة _getPosts() عند الضغط على زر "Home"
      } else if (_selectedIndex == 1) {
        // إذا تم الضغط على زر "Create Post"
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CreatePost()),
        );
      } else if (_selectedIndex == 2) {
        // إذا تم الضغط على زر "Profile"
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AccountDetailsWorkerPage()),
        );
      } else if (_selectedIndex == 3) {
        // إذا تم الضغط على زر "Logout"
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home worker'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _selectedIndex == 0 ? buildHomeContent() : buildProfileContent(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey, // لون الأيقونات غير المحددة
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildHomeContent() {
    return Row(
      children: [
        Expanded(
          child: _posts.isEmpty
              ? const Center(
                  child: Text(
                    'There is no post',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _getPosts,
                  backgroundColor: Colors.blue,
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: _posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 20,
                                      child: Text(
                                        _posts[index].username[0].toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_posts[index].username}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_city,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              '${_posts[index].city}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(
                                                text:
                                                    _posts[index].phonenumber));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Phone number copied successfully'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.phone,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                '${_posts[index].phonenumber}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_posts[index].postText}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _posts[index].image.isNotEmpty
                                  ? Image.memory(
                                      base64Decode(_posts[index].image),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget buildProfileContent() {
    return Center(
      child: Text(
        'Profile Page',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
