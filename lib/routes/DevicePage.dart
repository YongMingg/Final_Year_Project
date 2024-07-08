import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class DevicePage extends StatefulWidget {
  final String status;
  final int index;
  const DevicePage({super.key, required this.index, required this.status});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {

  User? user = FirebaseAuth.instance.currentUser;
  bool sliderOnChanged = false;
  int sliderCurrentValue = 0;
  Timer? debounceTimer; //use to limited setState
  late bool isButtonOn;

  @override
  void initState() {
    super.initState();
    
    if (widget.status == "true") {
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
                  
                },
              ),
              PopupMenuItem(
                child: const Text("Delete Device", style: TextStyle(fontSize: 16,)),
                onTap: () {
                  
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
}