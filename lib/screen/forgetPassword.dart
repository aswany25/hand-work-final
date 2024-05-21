import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/model/server_user.dart';
import 'package:flutter_application_1/screen/Login.dart';

void main() {
  runApp(ForgetPassword());
}

class ForgetPassword extends StatelessWidget {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nationalIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ForgetPasswordPage(
        phoneNumberController: _phoneNumberController,
        nationalIDController: _nationalIDController,
        passwordController: _passwordController,
        confirmPasswordController: _confirmPasswordController,
      ),
    );
  }
}

class ForgetPasswordPage extends StatefulWidget {
  final TextEditingController phoneNumberController;
  final TextEditingController nationalIDController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const ForgetPasswordPage({
    Key? key,
    required this.phoneNumberController,
    required this.nationalIDController,
    required this.passwordController,
    required this.confirmPasswordController,
  }) : super(key: key);

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  bool _secureText = true;
  bool _secureTextConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: Container(    
          decoration: const BoxDecoration(
            image: DecorationImage(   
              image: AssetImage('images/BBK.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset('images/hard-work.png', height: constraints.maxHeight * 0.2),
                      SizedBox(height: constraints.maxHeight * 0.1),
                      
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
                        child: TextField(
                          controller: widget.phoneNumberController,
                          keyboardType: TextInputType.number,
                          maxLength: 11,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffix: const Icon(Icons.phone_android_rounded),
                            labelText: "Phone Number",
                            labelStyle: const TextStyle(color: Colors.black),
                            
                          ),
                        ),
                      ),
                      const SizedBox(height:5),
                      
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
                        child: TextField(
                          controller: widget.nationalIDController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          maxLength: 14,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffix: const Icon(Icons.person),
                            labelText: "National ID",
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
                        child: TextField(
                          controller: widget.passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: _secureText,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Password",
                            labelStyle: const TextStyle(color: Colors.black),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _secureText = !_secureText;
                                });
                              },
                              icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility, size: 22),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
                        child: TextField(
                          controller: widget.confirmPasswordController,
                          keyboardType: TextInputType.text,
                          obscureText: _secureTextConfirm,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.greenAccent),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Confirm Password",
                            labelStyle: const TextStyle(color: Colors.black),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _secureTextConfirm = !_secureTextConfirm;
                                });
                              },
                              icon: Icon(_secureTextConfirm ? Icons.visibility_off : Icons.visibility, size: 22),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.1),

                      
                      
                      Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: 170,
                        height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                              _handleChangePasswordButtonPressed();
                            },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 33, 189, 202)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(fontSize: 16,  color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                       )
                      ),
                    ), 
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleChangePasswordButtonPressed() async {
    String phoneNumber = widget.phoneNumberController.text;
    String nationalID = widget.nationalIDController.text;
    String password = widget.passwordController.text;

    Map<String, dynamic> result = await ServerUserAPI.checkPhoneNumber(phoneNumber, nationalID, password);

    if (result['status'] == 'success') {
      String retrievedPassword = result['password'];
      setState(() {
        widget.passwordController.text = retrievedPassword; 
      });
    } else {
      setState(() {
        
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Phone number or national ID does not exist."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSuccessDialog();
    });
  }

void _showSuccessDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Success"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Operation Successful",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "When your information is complete and you press the change password button, if you do not see an error message, know that the process was completed successfully.",
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 8),
                Text(
                  "عندما تكون معلوماتك كاملة وتضغط على زر تغيير كلمة المرور، إذا لم تظهر رسالة خطأ، فاعلم أن العملية تمت بنجاح.",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

}




