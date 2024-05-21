import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/forgetPassword.dart';
import 'package:flutter_application_1/screen/home_user.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> userInfo;

  const ProfilePage({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: const Text("Name"),
                subtitle: Text(
                    "${userInfo['user_info']['first_name']} ${userInfo['user_info']['last_name']}"),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Country"),
                subtitle: Text("${userInfo['user_info']['country']}"),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("City"),
                subtitle: Text("${userInfo['user_info']['city']}"),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("Phone Number"),
                subtitle: Text("${userInfo['user_info']['id_number']}"),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("User Type"),
                subtitle: Text("${userInfo['user_info']['user_type']}"),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgetPassword()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0XFFFFFFFF)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: const Text(
                  'Change Password',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF3A50C2)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0XFFFFFFFF)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: const Text(
                  'Go to Search',
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
