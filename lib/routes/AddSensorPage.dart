import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AddSensorPage extends StatefulWidget {
  const AddSensorPage({super.key});

  @override
  State<AddSensorPage> createState() => _AddSensorPageState();
}

class _AddSensorPageState extends State<AddSensorPage> {

  TextEditingController pinController = TextEditingController();  //Pin controllers
  TextEditingController sensorNameController = TextEditingController(); //Text controllers
  int seletedValue = 0;
  List<int> availablePins = []; // Initial available pins
  List<int> showPins = []; // Initial show pins
  User? user = FirebaseAuth.instance.currentUser;
  bool showPinsIsEmpty = false;

  @override
  void initState() {
    super.initState();

    _initializePins();
  }

  Future<void> _initializePins() async {
    //fetch the pins from the database
    await _fetchPinsFromFirebase();
    //dont show the pin that in used
    await _fetchChosenPins();

    setState(() {
      showPinsIsEmpty = showPins.isEmpty;
    });
  }

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
          "Add Sensor",
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
                child: const Text("Add PIN", style: TextStyle(fontSize: 16,)),
                onTap: () {

                  //show add pin dialog
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: const Text("Add PIN"),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Text("Please enter the PIN number that have on the board"),
                            TextField(
                              keyboardType: TextInputType.number,
                              controller: pinController,
                            ),
                          ],
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
                          onPressed: () async{

                            //add the pin to the list
                            int pin = int.tryParse(pinController.text) ?? 0;

                            if (pin != 0) {
                              availablePins.add(pin); 
                              showPins.add(pin);
                            } else {
                              _toast(msg: "Invalid Pin");
                            }

                            //update data to database
                            await FirebaseFirestore.instance.collection("Users").doc(user!.uid).update({
                              "SensorArray": availablePins,
                            }).then((e) => setState(() {_fetchChosenPins();}));

                            //show toast message
                            pinController.clear();
                            _toast(msg: "Add Pin $pin Success");
                            Navigator.of(context).pop();
                          }, 
                          child: const Text("Add")
                        ),
                      ],
                    );
                  });

                },
              ),
              PopupMenuItem(
                child: const Text("Delete PIN", style: TextStyle(fontSize: 16,)),
                onTap: () {
                  int? selectedPin;

                  //show delete pin dialog
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: const Text("Delete PIN"),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Text("Please select the PIN number that want to delete"),
                            const Row(children: [Text("*On used PIN cannot delete",)]),
                            const SizedBox(height: 20,),
                            DropdownMenu(
                              width: MediaQuery.of(context).size.width * 0.6,
                              label: const Text("Pin Number"),
                              dropdownMenuEntries: showPinsIsEmpty 
                                  ? [const DropdownMenuEntry(value: 0, label: "No Available Pins Delete")] 
                                  : showPins.map((pin) {
                                      return DropdownMenuEntry(
                                        value: pin,
                                        label: "PIN $pin",
                                      );
                                    }).toList(),
                              onSelected: (value) {
                                if (value != null) {
                                  setState(() {
                                    selectedPin = value;
                                  });
                                }
                              },
                            ),

                          ],
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
                            if (selectedPin != null) {
                              setState(() {
                                availablePins.remove(selectedPin);
                                showPins.remove(selectedPin);

                                //update data to database
                                FirebaseFirestore.instance.collection("Users").doc(user!.uid).update({
                                  "SensorArray": availablePins,
                                }).then((e) => setState(() {_fetchChosenPins();}));

                                //show toast message
                                _toast(msg: "Delete Pin $selectedPin Success");
                                selectedPin = null; // Reset the selected pin
                              });
                            }else{
                              _toast(msg: "No Pin Selected");
                            }

                            Navigator.of(context).pop();
                          }, 
                          child: const Text("Delete")
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

      body: Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15, right: MediaQuery.of(context).size.width * 0.15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              //device name text field
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color.fromRGBO(143, 148, 251, 1), width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(143, 148, 251, .2),
                      blurRadius: 20.0,
                      offset: Offset(0, 10)
                    )
                  ]
                ),
                child: TextField(
                  controller: sensorNameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Device Name",
                    hintStyle: TextStyle(color: Colors.grey)
                  ),
                ),
              ),
              const SizedBox(height: 80,),

              //dropdownmenu
              DropdownMenu(
                width: MediaQuery.of(context).size.width * 0.7,
                label: const Text("Pin Number"),
                helperText: "Select the Pin of your sensor",
                dropdownMenuEntries: showPinsIsEmpty 
                    ? [const DropdownMenuEntry(value: 0, label: "No Available Pins")] 
                    : showPins.map((pin) {
                        return DropdownMenuEntry(
                          value: pin,
                          label: "PIN $pin" == "PIN 36" ? "PIN $pin (LDR Sensor)" : "PIN $pin" == "PIN 26" ? "PIN $pin (Humidity & Temperature Sensor)" : "PIN $pin",
                        );
                      }).toList(),
                onSelected: (value) {
                  if (value != null && value == showPins.first) {
                    setState(() {
                      seletedValue = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 80,),

              //add sensor button
              InkWell(
                onTap: () {
                  
                  User? user = FirebaseAuth.instance.currentUser;
                            
                  if(sensorNameController.text.isNotEmpty && seletedValue != 0){
                    if(user != null){

                      //add data to realtime database
                      FirebaseDatabase.instance.ref("${user.uid}/sensors").child("PIN_$seletedValue").set({
                        "DeviceName": sensorNameController.text,
                        "Data": 0,
                        "Data2": 0,
                      });

                      //update counter of user in the Firestore
                      FirebaseFirestore.instance.collection("Users").doc(user.uid).get().then((value) {
                        int counter = value.get("SensorCounter") as int;
                        FirebaseFirestore.instance.collection("Users").doc(user.uid).update({
                          "SensorCounter": ++counter,
                        });
                      });

                      //show toast msg
                      _toast(msg: "Sensor added successfully");
                      Get.back();
                    }
                  }else if(sensorNameController.text.isEmpty){
                    _toast(msg: "Please enter a device name");
                  }else if(seletedValue == 0 && showPinsIsEmpty == true){
                    _toast(msg: "No Pin available.");
                  }else{
                    _toast(msg: "Please select a pin number");
                  }

                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(143, 148, 251, 1),
                        Color.fromRGBO(143, 148, 251, .7),
                      ]
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, .2),
                        blurRadius: 20.0,
                        offset: Offset(0, 10)
                      )
                    ]
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 25, color: Colors.white,),
                        SizedBox(width: 10,),
                        Text("Add Sensor", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                        SizedBox(width: 10,),
                      ],
                    ),
                  ),
                ),
              ),
              
            ],
          ),
        ),
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

  Future<void> _fetchChosenPins() async {
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref("${user!.uid}/sensors");
      DatabaseEvent event = await ref.once();
      Map<dynamic, dynamic>? devices = event.snapshot.value as Map<dynamic, dynamic>?;

      if (devices != null) {
        setState(() {
          // Remove chosen pins from available pins
          for (var key in devices.keys) {
            int pin = int.parse(key.toString().split('_')[1]);
            showPins.remove(pin);
          }
        });
      }
    }

    if(showPins.isEmpty){
      showPinsIsEmpty = true;
    }else{
      showPinsIsEmpty = false;
    }
  }

  Future<void> _fetchPinsFromFirebase() async {
    await FirebaseFirestore.instance.collection("Users").doc(user!.uid).get().then((DocumentSnapshot documentSnapshot){
      if (documentSnapshot.exists) {
        List<int> availablePinsInFb = List<int>.from(documentSnapshot.get("SensorArray"));
        setState(() {
          availablePins = availablePinsInFb;
          showPins = List<int>.from(availablePinsInFb);
        });
      }else {
        debugPrint("Document does not exist");
      }
    }).catchError((error) {
      // Handle errors 
      debugPrint("Error fetching document: $error");
    });
  }
}