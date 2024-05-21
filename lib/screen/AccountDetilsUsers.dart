import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/model/server_user.dart';
import 'package:flutter_application_1/screen/home_user.dart';
import 'package:flutter_application_1/screen/profile.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  
  SlideRightRoute({required this.page})
    : super(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) =>
            page,
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) =>
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
      );
}

class AccountDetailsPage extends StatefulWidget {
  @override
  _AccountDetailsPageState createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();

  void _getUserInfo() async {
    String nationalId = _nationalIdController.text;
    String password = _idNumberController.text;

    Map<String, dynamic> userInfo =
        await ServerUserAPI.getUserInfo(nationalId, password);

    if (userInfo['status'] == 'success') {
      Navigator.push(
        context,
        SlideRightRoute(page: ProfilePage(userInfo: userInfo)),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to retrieve user information"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Details'),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SearchPage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nationalIdController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 14,
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
              decoration: InputDecoration(
                hintText: 'National ID',
                hintStyle: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your National ID';
                } else if (value.length != 14) {
                  return 'National ID must be 14 digits';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _idNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 11,
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
              decoration: InputDecoration(
                hintText: 'Phone number',
                hintStyle: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your phone number';
                } else if (value.length != 14) {
                  return 'Phone number must be 11 digits';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _getUserInfo();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0XFFFFFFFF)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: Text(
                  'Ok',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF3A50C2)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
