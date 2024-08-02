import 'package:flutter/material.dart';
import 'package:generative_ai_gemini/utils/const_asset.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                robot_image,
                width: screenSize.width * 0.4,
                height: screenSize.height * 0.2,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Welcome Back",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0),
              //   child: TextField(
              //     controller: emailController,
              //     decoration: const InputDecoration(
              //         border: OutlineInputBorder(), labelText: "Email"),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0),
              //   child: TextField(
              //     controller: passwordController,
              //     decoration: const InputDecoration(
              //         border: OutlineInputBorder(), labelText: "Password"),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 10.0),
              //   child:
              //       ElevatedButton(onPressed: () {}, child: const Text("Login")),
              // ),
              // const Divider(thickness: 2.0, color: Colors.black),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16.0)),
                    icon: Image.asset(
                      google_icon,
                      height: 24,
                      width: 24,
                    ),
                    onPressed: () {},
                    label: const Text(
                      "Login Wih Google",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
