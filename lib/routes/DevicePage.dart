import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DevicePage extends StatefulWidget {
  final DataSnapshot dataSnapshot;
  final int index;
  const DevicePage({super.key, required this.dataSnapshot, required this.index});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {

  User? user = FirebaseAuth.instance.currentUser;
  bool sliderOnChanged = false;
  int sliderCurrentValue = 0;
  Timer? debounceTimer; //use to limited setState
  late bool isButtonOn;
  TextEditingController renameDeviceController = TextEditingController();
  TextEditingController renamedDeviceController = TextEditingController();
  bool isRenamed = false;

  @override
  void initState() {
    super.initState();
    
    if (widget.dataSnapshot.child("Digital").value.toString() == "true") {
      isButtonOn = false;
    } else {
      isButtonOn = true;
    }
  }

  @override
  void dispose() {
    debounceTimer?.cancel();
    super.dispose();
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
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, size: 30, color: Colors.white,),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text("Rename Device", style: TextStyle(fontSize: 16,)),
                onTap: () {
                  
                  // Set the device name to the controller
                  renameDeviceController.text = widget.dataSnapshot.child("DeviceName").value.toString();

                  //show rename dialog
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: const Text("Rename Device"),
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
                              _toast(msg: "Device name cannot be empty");
                            } else{
                              if (isRenamed == false) {
                                isRenamed = true;
                                renamedDeviceController.text = renameDeviceController.text;
                                FirebaseDatabase.instance.ref("${user!.uid}/devices/${widget.dataSnapshot.key}").update({"DeviceName": renameDeviceController.text}).then((onValue){
                                  _toast(msg: "Rename successful");
                                  Navigator.of(context).pop("Done");  //make the dialog disappear and transfer message
                                });
                              }else{
                                if (renamedDeviceController.text.isEmpty) {
                                  _toast(msg: "Device name cannot be empty");
                                }else{
                                  FirebaseDatabase.instance.ref("${user!.uid}/devices/${widget.dataSnapshot.key}").update({"DeviceName": renamedDeviceController.text}).then((onValue){
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
                child: const Text("Delete Device", style: TextStyle(fontSize: 16,)),
                onTap: () {

                  //show delete dialog
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: const Text("Delete Device"),
                      content: const Text("Are you sure you want to delete this device?"),
                      actions: [
                        TextButton(
                          onPressed: (){
                            Navigator.of(context).pop();  //make the dialog disappear and transfer message
                          }, 
                          child: const Text("No")
                        ),
                        TextButton(
                          onPressed: (){
                            FirebaseDatabase.instance.ref("${user!.uid}/devices/${widget.dataSnapshot.key}").remove().then((onValue){
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
          query: FirebaseDatabase.instance.ref("${user!.uid}/devices"),
          itemBuilder: (context, snapshot, animation, index) {
            if (index == widget.index) {
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
                                    child: _showText(title: "Device Name: ", text: snapshot.child("DeviceName").value.toString()),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _showText(title: "Status: ", text: snapshot.child("Digital").value.toString() == "true" ? "On" : "Off"),
                                  ),
                                  _showText(title: "Brightness(Max 100): ", text: (double.parse(snapshot.child("Analog").value.toString()) / 2.55).round().toString()),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),

                  const SizedBox(height: 170,),

                  //On/Off Button
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isButtonOn = !isButtonOn;
                        FirebaseDatabase.instance.ref("${user!.uid}/devices/${snapshot.key}").update({"Digital": (!isButtonOn).toString()});
                      });
                      
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isButtonOn ? Colors.green : Colors.red,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          isButtonOn ? "Turn On" : "Turn Off",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50,),

                  //Brightness Slider
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const Text(
                          "Brightness Adjust: ",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            valueIndicatorTextStyle: const TextStyle(
                              fontSize: 22, // Adjust label font size here
                              color: Colors.white, 
                              fontWeight: FontWeight.w700
                            ),
                          ),
                          child: Slider(
                            value: sliderOnChanged ? sliderCurrentValue.toDouble() : (double.parse(snapshot.child("Analog").value.toString()) / 2.55),
                            min: 0,
                            max: 100,
                            divisions: 100,
                            label: sliderCurrentValue.round().toString(),
                            onChanged: (value) {
                              if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
                              
                              debounceTimer = Timer(const Duration(milliseconds: 10), () {
                                setState(() {
                                  sliderOnChanged = true;
                                  sliderCurrentValue = value.toInt();
                                });
                              });
                            },
                            onChangeEnd: (value) {
                              FirebaseDatabase.instance.ref("${user!.uid}/devices/${snapshot.key}").update({
                                "Analog": (value.toInt() * 2.55),
                              });
                            },
                          ),
                        ),
                      ],
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