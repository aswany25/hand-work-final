import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/server_user.dart';
import 'package:flutter_application_1/screen/Login.dart';
import 'package:http/http.dart' as http;

class user extends StatefulWidget {
  const user({Key? key}) : super(key: key);

  @override
  _userState createState() => _userState();
}

class _userState extends State<user> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _secureText = true;
  bool _secureTextConfirm = true;
  bool _nationalIdExists = false;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String _countryController = 'Egypt';
  final _cityController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _userType = 'User';
  final _jobController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    _createUserTable();
  }

  void _createUserTable() {
    http.post(Uri.parse(ServerUserAPI.API_URL), body: {'action': 'CREATE_TABLE'}).then((response) {
      if (response.statusCode == 200) {
        print('User table created successfully');
      } else {
        print('Failed to create user table: ${response.reasonPhrase}');
      }
    }).catchError((error) {
      print('Error creating user table: $error');
    });
  }

  void _insertUser() {
    if (_formKey.currentState!.validate()) {
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String country = _countryController;
      String city = _cityController.text;
      String idNumber = _idNumberController.text;
      String nationalId = _nationalIdController.text;
      String password = _passwordController.text;
      String userType = _userType;
      String job = _jobController.text;

      _checkNationalIdExistence(nationalId).then((exists) {
        setState(() {
          _nationalIdExists = exists;
        });

        if (!exists) {
          ServerUserAPI.insertUser(
            firstName,
            lastName,
            country,
            city,
            idNumber,
            nationalId,
            password,
            userType,
            job,
          ).then((result) {
            if (result == 'User inserted successfully') {
              print('User inserted successfully');
            } else {
              print('Failed to insert user: $result');
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This national ID already exists.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<bool> _checkNationalIdExistence(String nationalId) async {
    bool exists = false;
    await ServerUserAPI.checkUser(nationalId, _passwordController.text).then((result) {
      exists = result['authenticated'];
    }).catchError((error) {
      print('Error checking national id existence: $error');
    });
    return exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    drawerEdgeDragWidth: 20,
    appBar: AppBar(
        backgroundColor: Color(0xFF21BDCA),

        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
        ),
      ),
      body: SafeArea(
      child: Container(
        width: double.infinity,
          height: double.infinity,
  
        padding: const EdgeInsets.all(7),
        child: Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 26),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: TextFormField(
                      controller: _firstNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: "First Name",
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: TextFormField(
                      controller: _lastNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: "Last Name",
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: TextFormField(
                      controller: _idNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: const Icon(Icons.perm_identity_rounded),
                        labelText: "Phone Number",
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                   const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: TextFormField(
                      controller: _nationalIdController,
                      keyboardType: TextInputType.number,
                      maxLength: 14,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: const Icon(Icons.perm_identity_rounded),
                        labelText: "National ID",
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your national ID';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: DropdownButtonFormField<String>(
                      value: _countryController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: "Country",
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      items: <String>[
                        'Egypt',
                        'Saudi Arabia',
                        'United Arab Emirates',
                        'Iraq',
                        'Jordan',
                        
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _countryController = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: TextFormField(
                      controller: _cityController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: const Icon(Icons.home_filled),
                        labelText: "City",
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your city';
                        }
                        return null;
                      },
                    ),
                  ),

                   const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: DropdownButtonFormField<String>(
                      value: _userType,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: "User Type",
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      items: <String>[
                        'User',
                        'Worker',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _userType = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: TextFormField(
                      controller: _jobController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: const Icon(Icons.work),
                        labelText: "Job",
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      validator: (value) {
                        if (_userType == 'Worker' && value!.isEmpty) {
                          return 'Please enter your job title';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _secureText,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _secureText = !_secureText;
                            });
                          },
                        ),
                        labelText: "Password",
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        } else if (!RegExp(r'^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$').hasMatch(value)) {
                          return 'Password must contain at least one letter, one number, and one special character';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _secureTextConfirm,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_secureTextConfirm ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _secureTextConfirm = !_secureTextConfirm;
                            });
                          },
                        ),
                        labelText: "Confirm Password",
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),

                 

                  const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: SizedBox(
                       
                        height: 50,
                      child: ElevatedButton(
                       onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
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
                          'Sign in',
                          style: TextStyle(fontSize: 16,  color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                       )
                      ),
                    ),
                    const SizedBox(height: 25),
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
