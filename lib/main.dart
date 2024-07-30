import 'package:alan_voice/alan_voice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/routes/0_routers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main()async{
  //initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  try {
    var result = await Firebase.initializeApp(
      options: const FirebaseOptions(
      apiKey: 'AIzaSyDHMsHjqDPNFPwFZhtkz6VtEx2aArYlG1U',
      appId: '1:585375698791:android:7ef1a02b29030e596fe9c2',
      messagingSenderId: '585375698791',
      projectId: 'finalyearproject-347c9',
      storageBucket: 'finalyearproject-347c9.appspot.com',
      databaseURL: 'https://finalyearproject-347c9-default-rtdb.asia-southeast1.firebasedatabase.app/',
    ));
    debugPrint("-----------------------");
    debugPrint("$result");
    debugPrint("-----------------------");
  } catch (e) {
    debugPrint("-----------------------");
    debugPrint('Failed to initialize Firebase: $e');
    debugPrint("-----------------------");
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String _initialRoute = "/LoginPage";    
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AlanVoice.removeButton(); //make sure no alan button on starting up app
    _runCodeOnAppOn();  
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached){

    }else if (state == AppLifecycleState.paused) { //At background logout
      // User? user = FirebaseAuth.instance.currentUser;
      // debugPrint("On background");
      // if (user != null) {
      //   debugPrint("User ${user.uid} is logged in.");
      //   FirebaseAuth.instance.signOut().then((onValue) {
      //     FirebaseFirestore.instance.collection("Users").doc(user.uid).update({"LoginStatus": false});
      //     Get.offNamed("/LoginPage");
      //   });
      // }else{
      //   debugPrint("No user logged in.");
      // }
    }
  }

  Future<void> _runCodeOnAppOn() async{
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      debugPrint("User ${user.uid} is logged in.");
      FirebaseAuth.instance.signOut().then((onValue) {
        FirebaseFirestore.instance.collection("Users").doc(user.uid).update({"LoginStatus": false});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      
      getPages: Routers.routes,
      initialRoute: _initialRoute,
      
    );
  }
}

