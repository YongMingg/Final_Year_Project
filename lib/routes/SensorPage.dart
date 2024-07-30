import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SensorPage extends StatefulWidget {
  final DataSnapshot dataSnapshot;
  final int index;
  const SensorPage({super.key, required this.index ,required this.dataSnapshot});

  @override
  _SensorPageState createState() => _SensorPageState();

}

class _SensorPageState extends State<SensorPage> {

  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController renameDeviceController = TextEditingController();
  TextEditingController renamedDeviceController = TextEditingController();
  bool isRenamed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 30,),
        ),
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
          "Sensor",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, size: 30, color: Colors.white,),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text("Rename Sensor", style: TextStyle(fontSize: 16,)),
                onTap: () {
                  
                  // Set the device name to the controller
                  renameDeviceController.text = widget.dataSnapshot.child("DeviceName").value.toString();

                  //show rename dialog
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: const Text("Rename Sensor"),
                      content: SingleChildScrollView(
                        child: TextField(
                          controller: isRenamed ? renamedDeviceController : renameDeviceController,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: (){
                            Navigator.of(context).pop("Cancel");  //make the dialog disappear and transfer message
                          }, 
                          child: const Text("Cancel")
                        ),
                        TextButton(
                          onPressed: (){
                            if (renameDeviceController.text.isEmpty) {
                              _toast(msg: "Sensor name cannot be empty");
                            } else{
                              if (isRenamed == false) {
                                isRenamed = true;
                                renamedDeviceController.text = renameDeviceController.text;
                                FirebaseDatabase.instance.ref("${user!.uid}/sensors/${widget.dataSnapshot.key}").update({"DeviceName": renameDeviceController.text}).then((onValue){
                                  _toast(msg: "Rename successful");
                                  Navigator.of(context).pop("Done");  //make the dialog disappear and transfer message
                                });
                              }else{
                                if (renamedDeviceController.text.isEmpty) {
                                  _toast(msg: "Sensor name cannot be empty");
                                }else{
                                  FirebaseDatabase.instance.ref("${user!.uid}/sensors/${widget.dataSnapshot.key}").update({"DeviceName": renamedDeviceController.text}).then((onValue){
                                    _toast(msg: "Rename successful");
                                    Navigator.of(context).pop("Done");  //make the dialog disappear and transfer message
                                  });
                                }
                              }
                            }
                          }, 
                          child: const Text("Rename")
                        ),
                      ],
                    );
                  });
                },
              ),
              PopupMenuItem(
                child: const Text("Delete Sensor", style: TextStyle(fontSize: 16,)),
                onTap: () {

                  //show delete dialog
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: const Text("Delete Sensor"),
                      content: const Text("Are you sure you want to delete this Sensor?"),
                      actions: [
                        TextButton(
                          onPressed: (){
                            Navigator.of(context).pop();  //make the dialog disappear and transfer message
                          }, 
                          child: const Text("No")
                        ),
                        TextButton(
                          onPressed: (){
                            FirebaseDatabase.instance.ref("${user!.uid}/sensors/${widget.dataSnapshot.key}").remove().then((onValue){

                              FirebaseFirestore.instance.collection("Users").doc(user!.uid).get().then((value) {
                                int counter = value.get("SensorCounter") as int;
                                FirebaseFirestore.instance.collection("Users").doc(user!.uid).update({
                                  "SensorCounter": --counter,
                                });
                              });

                              _toast(msg: "Device delete successful");
                              Navigator.of(context).pop();  //make the dialog disappear and transfer message
                              Navigator.of(context).pop();
                            });
                          }, 
                          child: const Text("Yes")
                        ),
                      ],
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),

      body: Center(
        child: FirebaseAnimatedList(
          query: FirebaseDatabase.instance.ref("${user!.uid}/sensors"),
          itemBuilder: (context, snapshot, animation, index) {
            if (index == widget.index) {
              String? pinKey = snapshot.key;
              return Column(
                children: [

                  //card with devicee info
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: Colors.amber[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _showText(title: "Sensor Name: ", text: snapshot.child("DeviceName").value.toString()),
                                  ),

                                  //based on different pin show different data
                                  pinKey == "PIN_36" ? 
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: _showText(title: "Ldr Data: ", text: snapshot.child("Data").value.toString()),
                                      ),
                                      _showText(title: "Voltage(V): ", text: "${snapshot.child("Data2").value.toString()} V"), 
                                    ],
                                  )
                                  : pinKey == "PIN_26" ?
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: _showText(title: "Temperature(°C): ", text: "${snapshot.child("Data").value.toString()} °C"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: _showText(title: "Temperature(°F): ", text: "${(((double.parse(snapshot.child("Data").value.toString())) * 1.8) + 32).toString()} °F"),
                                      ),
                                      _showText(title: "Humidity: ", text: "${snapshot.child("Data2").value.toString()} %"), 
                                    ],
                                  )
                                  :
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: _showText(title: "Data: ", text: snapshot.child("Data").value.toString()),
                                      ),
                                      _showText(title: "Data2: ", text: snapshot.child("Data2").value.toString()), 
                                    ],
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
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

  _showText({required String title, required String text}){
    return RichText(
      text: TextSpan(
      children: [
        TextSpan(
          text: title,
          style: const TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 19,
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: text,
          style: const TextStyle(
            fontSize: 19,
            color: Colors.black,
          ),
        ),
      ],
    ),
    );
  }

  void _toast({required String msg}){
    // Show a toast message with the given message
    Fluttertoast.showToast(
      // Set the message of the toast
      msg: msg,
      // Set the length of the toast
      toastLength: Toast.LENGTH_LONG,    
      // Set the gravity of the toast
      gravity: ToastGravity.BOTTOM,     
      // Set the time for the toast
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,        
      fontSize: 16.0                    
    );
  }
}