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
  List<int> availablePins = [36]; // Initial available pins
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
                          onPressed: (){

                            //add the pin to the list
                            int pin = int.tryParse(pinController.text) ?? 0;
                            pin == 0 ? null : availablePins.add(pin);
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
                              dropdownMenuEntries: availablePinsIsEmpty 
                                  ? [const DropdownMenuEntry(value: 0, label: "No Available Pins Delete")] 
                                  : availablePins.map((pin) {
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
                                _toast(msg: "Delete Pin $selectedPin Success");
                                selectedPin = null; // Reset the selected pin
                              });
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
                dropdownMenuEntries: availablePinsIsEmpty 
                    ? [const DropdownMenuEntry(value: 0, label: "No Available Pins")] 
                    : availablePins.map((pin) {
                        return DropdownMenuEntry(
                          value: pin,
                          label: "PIN $pin",
                          enabled: pin == availablePins.first,
                        );
                      }).toList(),
                onSelected: (value) {
                  if (value != null && value == availablePins.first) {
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
                      FirebaseDatabase.instance.ref("${user.uid}/sensors").child("PIN_$seletedValue").set({
                        "DeviceName": sensorNameController.text,
                        "Data": 0,
                        "Data2": 0,
                      });
                      _toast(msg: "Device added successfully");
                      Get.back();
                    }
                  }else if(sensorNameController.text.isEmpty){
                    _toast(msg: "Please enter a device name");
                  }else if(seletedValue == 0 && availablePinsIsEmpty == true){
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
      Map<dynamic, dynamic>? sensors = event.snapshot.value as Map<dynamic, dynamic>?;

      if (sensors != null) {
        setState(() {
          // Remove chosen pins from available pins
          for (var key in sensors.keys) {
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