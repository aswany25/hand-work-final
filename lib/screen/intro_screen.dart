import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/inttro.png'),
                fit: BoxFit.cover,
              ),
            ), 
          ),
          const SizedBox(height: 20),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 65),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/pkpk.png', height: 300),
                   const SizedBox(height: 35),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("       Welcome to           "
                            " HandWork Applction"
                    , style: TextStyle(fontSize: 25 , color: Colors.black), ),
                  ),
                  const SizedBox(height: 140),
                  Padding(
                    padding: const EdgeInsets.only(right: 50),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('LoginScreen');
                      },
                      child: const Text('Get Started'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        minimumSize: const Size(250, 45), // تحديد حجم الزر
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}