import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screen/home_user.dart';
import 'package:flutter_application_1/screen/home_worker.dart';
import 'package:flutter_application_1/screen/user.dart';
import 'package:flutter_application_1/screen/forgetPassword.dart';
import '../model/server_user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _secureText = true;
  final _nationalIDController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void openHomeScreen() {
    Navigator.of(context).pushReplacementNamed('HomeScreen');
  }

  void check() {}

void login() {
  String nationalId = _nationalIDController.text;
  String password = _passwordController.text;

  if (_formKey.currentState!.validate()) {
    ServerUserAPI.checkUser(nationalId, password).then((result) {
      bool isAuthenticated = result['authenticated'];
      String userType = result['user_type'];

      if (isAuthenticated) {
        if (userType == "Worker") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const WorkerPage()));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SearchPage()));
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Login Status'),
              content: const Text('Login failed'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)],
            ),
          ),
          child: Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                      Image.asset('images/hard-work.png', height: 170),
                      
                    // Image.asset(
                    //   'images/logo.png',
                    //   height: 240,
                    //   fit: BoxFit.contain,
                    // ),
                    const SizedBox(height: 40),
                    const Text(
                             'Welcome Back                  '
                      '                   Login to access your account',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    const SizedBox(height: 12),
                   
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _nationalIDController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 14,
                      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      decoration: InputDecoration(
                        hintText: 'National ID',
                        hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
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
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _secureText,
                      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _secureText = !_secureText;
                            });
                          },
                          icon: Icon(
                            _secureText ? Icons.visibility_off : Icons.visibility,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgetPassword()));
                          },
                          child: const Text(
                            'Forget Password ?',
                            style: TextStyle(color: Color.fromARGB(255, 33, 189, 202)),
                          ),
                        ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: 60,
                        height: 45,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 33, 189, 202)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                       )
                      ),
                    ),
                    
                       
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.grey),
                        ),
TextButton(
  onPressed: () {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const user()));
  },
  child: const Text(
    "Sign Up",
    style: TextStyle(color: Color.fromARGB(255, 33, 189, 202)),
  ),
),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}