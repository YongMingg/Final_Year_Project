import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/routes/DevicePage.dart';
import 'package:final_year_project/routes/SensorPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class NavHomePage extends StatefulWidget {
  const NavHomePage({super.key});

  @override
  State<NavHomePage> createState() => _NavHomePageState();
}

class _NavHomePageState extends State<NavHomePage> {

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //Appbar title
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(78, 84, 198, 1),
                Color.fromRGBO(125, 130, 237, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(0.3),
            ),
          ),
        ),
        title: const Text(
          "Home",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      //content
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
        
            //welcome word
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Welcome Home,", style: TextStyle(fontSize: 16),),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("Users").doc(user!.uid).snapshots(), 
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      } else if (snapshot.hasData) {
                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                        return Text(
                          userData["Username"], 
                          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
                        );
                      } else {
                        return Container(height: 0);
                      }
                    },
                  ),
                ]
              ),
            ),
            
        
            //Connected Devices word
            StreamBuilder(
              stream: FirebaseDatabase.instance.ref("${user!.uid}/devices").onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> event) {
                if (event.hasData && event.data!.snapshot.value != null){
                  return const Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Text(
                      "Connected Devices",
                      style: TextStyle(
                        fontSize: 21, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  );
                }else{
                  return Container(height: 0,);
                }
              }
            ),
        
            //Devices list
            Flexible(
              child: StreamBuilder(
                stream: FirebaseDatabase.instance.ref("${user!.uid}/devices").onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> event) {
                  if (event.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else if (event.hasData && event.data!.snapshot.value != null) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            FirebaseAnimatedList(
                              physics: const NeverScrollableScrollPhysics(),
                              duration: Durations.extralong4,
                              shrinkWrap: true, // ajust height with content
                              query: FirebaseDatabase.instance.ref("${user!.uid}/devices"),
                              itemBuilder: (context, snapshot, animation, index) {
                                return InkWell(
                                  onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder:(context) {
                                            return DevicePage(dataSnapshot: snapshot, index: index);
                                        },)
                                      );
                                  },
                                  child: Card(
                                    color: Colors.amber[100],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: ListTile(
                                      minVerticalPadding: 30,
                                      leading: CircleAvatar(
                                        backgroundColor: (snapshot.child("Digital").value.toString() == "true") ? Colors.green: Colors.red,
                                        radius: 10,
                                      ),
                                      minLeadingWidth: 20,
                                      title: Text(snapshot.child("DeviceName").value.toString()),
                                      titleTextStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                      subtitle: Text((snapshot.child("Digital").value.toString() == "true") ? "Status: On" : "Status: Off" ),
                                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 28, color: Colors.grey.shade700,),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(height: 0);
                  }
                }
              ),
            ),
        
            //Connected Sensor word
            StreamBuilder(
              stream: FirebaseDatabase.instance.ref("${user!.uid}/sensors").onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> event) {
                if (event.hasData && event.data!.snapshot.value != null){
                  return const Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Text(
                      "Connected Sensor",
                      style: TextStyle(
                        fontSize: 21, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  );
                }else{
                  return Container(height: 0,);
                }
              }
            ),
        
            // Sensor list
            Flexible(
              child: StreamBuilder(
                stream: FirebaseDatabase.instance.ref("${user!.uid}/sensors").onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> event) {
                  if (event.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else if (event.hasData && event.data!.snapshot.value != null) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            FirebaseAnimatedList(
                              physics: const NeverScrollableScrollPhysics(),
                              duration: Durations.extralong4,
                              shrinkWrap: true, // ajust height with content
                              query: FirebaseDatabase.instance.ref("${user!.uid}/sensors"),
                              itemBuilder: (context, snapshot, animation, index) {
                                return InkWell(
                                  onTap: () {  //change to sensor page when click
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder:(context) {
                                            return SensorPage(index: index, dataSnapshot: snapshot,);
                                        },)
                                      );
                                  },
                                  child: Card(
                                    color: Colors.amber[100],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: ListTile(
                                      minVerticalPadding: 30,
                                      minLeadingWidth: 20,
                                      title: Text(snapshot.child("DeviceName").value.toString()),
                                      titleTextStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 28, color: Colors.grey.shade700,),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(height: 0,);
                  }
                }
              ),
            ),

            //return a picture if no devices or sensors found
            StreamBuilder(
              stream: FirebaseDatabase.instance.ref("${user!.uid}/devices").onValue, 
              builder: (context, AsyncSnapshot<DatabaseEvent> event){
                if (event.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (event.hasData && event.data!.snapshot.value != null) {
                  return Container(height: 0,);
                }else{
                  return StreamBuilder(
                    stream: FirebaseDatabase.instance.ref("${user!.uid}/sensors").onValue, 
                    builder: (context, AsyncSnapshot<DatabaseEvent> event){
                      if (event.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (event.hasData && event.data!.snapshot.value != null) {
                        return Container(height: 0,); 
                      }else{
                        return Center(
                          child: Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.18,),
                              Image.asset("img/no_device.png",height: 150,),
                              const SizedBox(height: 10,),
                              const Text("No devices or sensors found!", style: TextStyle(fontSize: 17),),
                            ],
                          ),
                        );
                      }
                    }
                  );
                }
              }
            )
          ],
        ),
      ),
    );
  }
}
