import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/auth/Auth.dart';
import 'package:frontend/pages/Login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> fetchLoggedInUserDetails() async {
    // Call getCurrentUser to fetch the user
    User? user = await Auth().getCurrentUser();

    if (user != null) {
      // If a user is logged in, print or display their details
      print('User ID: ${user.uid}');
      print('Email: ${user.email}');
      print('Display Name: ${user.displayName ?? "No name available"}');
      print('Photo URL: ${user.photoURL ?? "No photo available"}');
      print('Email Verified: ${user.emailVerified}');
      print('Is Anonymous: ${user.isAnonymous}');
      print('Phone Number: ${user.phoneNumber ?? "No phone number"}');
      print(
          'Provider IDs: ${user.providerData.map((provider) => provider.providerId).join(", ")}');
    } else {
      // If no user is logged in, inform the user
      print('No user is currently logged in.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLoggedInUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Home screen",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          margin: EdgeInsets.only(top: 98),
          child: Center(
            child: Column(
              children: [
                Text("User id "),
                TextButton(
                    onPressed: () {
                      Auth().logout().then((value) => Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (_) => const Login())));
                    },
                    child: const Text("LOGOUT")),
              ],
            ),
          ),
        ));
  }
}
