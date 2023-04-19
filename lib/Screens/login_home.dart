import 'package:chat_app/Screens/login_screen.dart';
import 'package:flutter/material.dart';

class LoginHome extends StatefulWidget {
  const LoginHome({super.key});

  @override
  State<LoginHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/loginscreen.png",
                height: 350,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              const Text(
                'Welcome to the World of chatting',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
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
                          borderRadius: BorderRadius.circular(18.0),
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
            ],
          ),
        ),
      ),
    );
  }
}
