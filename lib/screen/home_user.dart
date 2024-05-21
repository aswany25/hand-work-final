import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/model/posts.dart';
import 'package:flutter_application_1/model/server_post.dart';
import 'package:flutter_application_1/screen/AccountDetilsUsers.dart';
import 'package:flutter_application_1/screen/Login.dart';
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Posts> _posts = [];
  List<Posts> _filteredPosts = [];
  int _selectedIndex = 0;
  String _searchText = '';

  @override
  void initState() {
    _getPosts();
    super.initState();
  }

  Future<void> _getPosts() async {
    try {
      List<Posts> posts = await Services.getAllPosts();
      setState(() {
        _posts = posts;
        _filteredPosts = posts;
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AccountDetailsPage()),
        );
      } else if (_selectedIndex == 2) { // إذا تم الضغط على زر تسجيل الخروج
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  void _filterPosts(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        _filteredPosts = _posts;
      } else {
        _filteredPosts = _posts.where((post) {
          final postTextLower = post.postText.toLowerCase();
          final searchTextLower = searchText.toLowerCase();
          return postTextLower.contains(searchTextLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearchDialog(context);
              },
            ),
            Text('Hand Work'),
            SizedBox(width: 48), // لتوازن المساحة المخصصة لأيقونة السهم التي تمت إزالتها
          ],
        ),
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
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildHomeContent() {
    return Row(
      children: [
        Expanded(
          child: _filteredPosts.isEmpty
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
                    itemCount: _filteredPosts.length,
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
                                        _filteredPosts[index].username[0]
                                            .toUpperCase(),
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
                                          '${_filteredPosts[index].username}',
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
                                              '${_filteredPosts[index].city}',
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
                                                text: _filteredPosts[index]
                                                    .phonenumber));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Phone number copied successfully'),
                                                duration:
                                                    Duration(seconds: 2),
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
                                                '${_filteredPosts[index].phonenumber}',
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
                                      '${_filteredPosts[index].postText}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _filteredPosts[index].image.isNotEmpty
                                  ? Image.memory(
                                      base64Decode(
                                          _filteredPosts[index].image),
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

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String tempSearchText = _searchText;

        return AlertDialog(
          title: Text('Search'),
          content: TextField(
            onChanged: (value) {
              tempSearchText = value;
            },
            decoration: InputDecoration(
              labelText: 'Enter search text',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Search'),
              onPressed: () {
                setState(() {
                  _searchText = tempSearchText;
                  _filterPosts(_searchText);
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('All'),
              onPressed: () {
                  _getPosts();
              },
            ),
          ],
        );
      },
    );
  }
}
