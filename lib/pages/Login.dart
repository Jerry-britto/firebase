import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/api/auth/Auth.dart';
import 'package:frontend/pages/Register.dart';
import 'package:frontend/pages/ResetPassword.dart';
import 'package:frontend/pages/home_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            key: formKey,
            children: [
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: "Enter Email",
                    suffixIcon: const Icon(Icons.email)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: "Enter Password",
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: isVisible
                            ? const Icon(Icons.visibility)
                            : const Icon(Icons.visibility_off))),
                obscureText: isVisible,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const Resetpassword())),
                      child: const Text("Forgot Password"))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: FloatingActionButton(
                  onPressed: () async {
                    String result =
                        await Auth().login(email.text, password.text);
                    if (result == 'success') {
                      // For success, directly navigate without showing alert
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    } else {
                      // Only show alert for non-success messages
                      displayMessage(result);
                    }
                  },
                  child: Text("LOGIN"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FloatingActionButton.extended(
                  onPressed: () {
                    Auth().signInWithGoogle(context);
                  },
                  label: const Text("Sign in with google")),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("New User? "),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const Register())),
                    child: const Text("REGISTER"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Ok"))
        ],
      ),
    );
  }
}
