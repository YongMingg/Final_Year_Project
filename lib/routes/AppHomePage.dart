import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../navigator_pages/pages_lib.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 0;
  final List<Widget> _pageList = [
    const NavHomePage(),
    const NavAddDevicePage(),
    const NavProfilePage(),
  ];

  @override
  void initState() {
    super.initState();

    //test here
    User? user = FirebaseAuth.instance.currentUser;
    print("User UID: ${user!.uid}");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,  
        title: const Text(
          "Home",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: _pageList[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        fixedColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(null),
            label: "Add Device",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,   
      floatingActionButton: ClipOval(
        child: FloatingActionButton(
          backgroundColor: currentIndex == 1? Colors.blue: Colors.grey.shade300,
          foregroundColor: currentIndex == 1? Colors.white: Colors.grey.shade900,
          child: const Icon(Icons.add_circle_outline),
          onPressed: (){
            setState(() {
              currentIndex = 1;
            });
          },
        ),
      )

    );
  }
}