import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  
  bool isAgreedToTerms = false; 

  void signUp(String email, String password, String username, String phone) async {
    final String baseUrl = 'http://192.168.1.167:3000';
    print("insidesignup");
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/signup'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'username': username,
          'phone': phone,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User created successfully!'),
            backgroundColor: Colors.deepPurpleAccent,
          ),
        );
        Navigator.of(context).pushReplacementNamed('/login');
      } else if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User already exists.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        print('Failed to create user: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create user.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (error) {
      print('Error during sign up: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error during sign up.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Signup',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor:Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60.0),
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color:Colors.deepPurpleAccent,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Please fill in the details to sign up',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 40.0),
            
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person, color:Colors.deepPurpleAccent),
                hintText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email, color: Colors.deepPurpleAccent),
                hintText: 'Email Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock, color: Colors.deepPurpleAccent),
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone, color:Colors.deepPurpleAccent),
                hintText: 'Phone Number (+country code)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                // Optional: Automatically format the phone number
                if (!value.startsWith('+')) {
                  phoneController.text = '+${value.replaceAll(RegExp(r'[^0-9]'), '')}';
                  phoneController.selection = TextSelection.fromPosition(TextPosition(offset: phoneController.text.length));
                }
              },
            ),


            CheckboxListTile(
              title: const Text("I agree to the Terms and Conditions"),
              value: isAgreedToTerms,
              onChanged: (bool? value) {
                setState(() {
                  isAgreedToTerms = value!;
                });
              },
            ),

            ElevatedButton(
              onPressed: () {
                if (isAgreedToTerms) {
                  signUp(
                    emailController.text,
                    passwordController.text,
                    usernameController.text,
                    phoneController.text,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please agree to the Terms and Conditions.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor:Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/login'),
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(
                    color:Colors.deepPurpleAccent,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}
