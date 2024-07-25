import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

      body: _pageList[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        fixedColor: const Color.fromRGBO(107, 112, 222, 1),
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
          backgroundColor: currentIndex == 1? const Color.fromRGBO(107, 112, 222, 1): Colors.grey.shade300,
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