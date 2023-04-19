// ignore_for_file: prefer_const_constructors

import 'package:chat_app/Screens/chat_list.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _username = '';
  String _password = '';

  void login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _username = _usernameController.text;
        _password = _passwordController.text;
      });

      // Check if the login credentials match any of the two hardcoded user accounts
      if (_username == 'user1' && _password == 'password1') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatList()),
        );
      } else if (_username == 'user2' && _password == 'password2') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatList()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Failed'),
            content: Text('Invalid username or password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  'assets/images/login_signin.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      login();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const ChatList(),
                      //   ),
                      // );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          return Colors.red;
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    child: const Text("Login"),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
