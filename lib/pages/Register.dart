import 'package:flutter/material.dart';
import 'package:frontend/pages/Login.dart';

import '../api/auth/Auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final cpassword = TextEditingController();
  bool isVisible = true, isVisible2 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Center(
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
                TextFormField(
                  controller: cpassword,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "Confirm Password",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible2 = !isVisible2;
                            });
                          },
                          icon: isVisible2
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off))),
                  obscureText: isVisible2,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FloatingActionButton(
                    onPressed: () async {
                      String result =
                          await Auth().register(email.text, password.text);

                      if (result.startsWith('success')) {
                        // Registration successful
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Registration successful! Please check your email'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => Login()),
                        );
                      } else {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text("REGISTER"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text("Already have an account? "),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const Login())),
                      child: const Text("Login"),
                    )
                  ],
                ),
              ],
            ),
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
