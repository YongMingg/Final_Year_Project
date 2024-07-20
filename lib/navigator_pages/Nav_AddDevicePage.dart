import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavAddDevicePage extends StatefulWidget {
  const NavAddDevicePage({super.key});

  @override
  State<NavAddDevicePage> createState() => _NavAddDevicePageState();
}

class _NavAddDevicePageState extends State<NavAddDevicePage> {

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
          "Add Device",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(30, 30, 30, 25),
            child: InkWell(
              onTap: () {
                Get.toNamed("/AddDevicePage");
              },
              child: _showBar(icon: Icons.lightbulb_outline, text: "Devices")
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 30, 30, 25),
            child: InkWell(
              onTap: () {
                Get.toNamed("/AddSensorPage");
              },
              child: _showBar(icon: Icons.sensors, text: "Sensor")
            ),
          ),
        ],
      ),
    );
  }

  Widget _showBar({required IconData icon, required String text}){
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      height: 120,
      decoration: BoxDecoration(
        color:Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Icon(icon, color: Colors.grey.shade700, size: 50,),
          ),
          Expanded(
            flex: 10,
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(text, style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade700, size: 30,),
          ),
        ],
      )
    );
  }
}