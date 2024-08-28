import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signin() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text,
      password: password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body:Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Enter Email',
                ),
              ),
              TextField(
                controller: password,
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                ),
              ),
              ElevatedButton(
                onPressed: () => signin(),
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/signup'),
                child: Text('Register'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/forgot'),
                child: Text('Forgot Password'),
              ),
            ],
          ),
        )

    );
  }
}
