import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class DevicePage extends StatefulWidget {
  final int index;
  const DevicePage({super.key, required this.index});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      //Appbar title
      appBar: AppBar(
        backgroundColor: Colors.blue,  
        title: const Text(
          "Control Device",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child: FirebaseAnimatedList(
          query: FirebaseDatabase.instance.ref("${user!.uid}/devices"),
          itemBuilder: (context, snapshot, animation, index) {
            if (index == widget.index) {
              return Column(
                children: [
                  Text(snapshot.child("DeviceName").value.toString()),
                  Text(snapshot.child("Digital").value.toString()),
                ]
              );
            }else{
              return const SizedBox(height: 0,);
            }
          }
        ),
      ),
    );
  }
}