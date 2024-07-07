import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({super.key});

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {

  TextEditingController deviceNameController = TextEditingController();  //Text controllers
  int seletedValue = 0;
  List<int> availablePins = [2, 15, 16, 17, 5, 18]; // Initial available pins
  User? user = FirebaseAuth.instance.currentUser;
  bool availablePinsIsEmpty = false;

  @override
  void initState() {
    super.initState();
    _fetchChosenPins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //Appbar title
      appBar: AppBar(
        backgroundColor: Colors.blue,  
        title: const Text(
          "Add Device",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(left: 80, right: 80),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: deviceNameController,
                decoration: const InputDecoration(
                  labelText: "Device Name",
                  hintText: "E.g. Smart Light",
                  hintStyle: TextStyle(color: Colors.grey,)
                ),
              ),
              const SizedBox(height: 80,),

              DropdownMenu(
                width: 290,
                label: const Text("Pin Number"),
                helperText: "Select the Pin of your device",
                dropdownMenuEntries: availablePinsIsEmpty ? [const DropdownMenuEntry(value: 0, label: "No Available Pins")] : availablePins.map((pin) => DropdownMenuEntry(value: pin, label: "PIN $pin")).toList(),
                onSelected: (value) {
                  seletedValue = value!;
                },
              ),
              const SizedBox(height: 80,),
              
              //button
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton.icon(
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Colors.purple),
                            foregroundColor: WidgetStatePropertyAll(Colors.white),
                          ),
                          label: const Text("Add Device", style: TextStyle(fontSize: 19),), 
                          icon: const Icon(Icons.add_box_outlined),
                          onPressed: (){
                            User? user = FirebaseAuth.instance.currentUser;
                            
                            if(deviceNameController.text.isNotEmpty && seletedValue != 0){
                              if(user != null){
                                FirebaseDatabase.instance.ref("${user.uid}/devices").child("PIN_$seletedValue").set({
                                  "DeviceName": deviceNameController.text,
                                  "Analog": 255,
                                  "Digital": false,
                                });
                                _toast(msg: "Device added successfully");
                                Get.back();
                              }
                            }else if(deviceNameController.text.isEmpty){
                              _toast(msg: "Please enter a device name");
                            }else if(seletedValue == 0){
                              _toast(msg: "Please select a pin number");
                            }
                          }, 
                        ),
                      ), 
                    ),
                  ],
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
      DatabaseReference ref = FirebaseDatabase.instance.ref("${user!.uid}/devices");
      DatabaseEvent event = await ref.once();
      Map<dynamic, dynamic>? devices = event.snapshot.value as Map<dynamic, dynamic>?;

      if (devices != null) {
        setState(() {
          // Remove chosen pins from available pins
          for (var key in devices.keys) {
            int pin = int.parse(key.toString().split('_')[1]);
            availablePins.remove(pin);
          }
        });
      }
    }

    if(availablePins.isEmpty){
      availablePinsIsEmpty = true;
    }else{
      availablePinsIsEmpty = false;
    }
  }
}