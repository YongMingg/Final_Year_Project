import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavProfilePage extends StatefulWidget {
  const NavProfilePage({super.key});

  @override
  State<NavProfilePage> createState() => _NavProfilePageState();
}

class _NavProfilePageState extends State<NavProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blue,  
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Profile page"),
            ElevatedButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                await FirebaseAuth.instance.signOut().then((onValue) {
                  FirebaseFirestore.instance.collection("Users").doc(user!.uid).update({"LoginStatus": false});
                  Get.offNamed("/LoginPage");
                });
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
