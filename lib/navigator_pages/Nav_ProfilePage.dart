import 'package:alan_voice/alan_voice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../routes/0_routes_lib.dart';

class NavProfilePage extends StatefulWidget {
  const NavProfilePage({super.key});

  @override
  State<NavProfilePage> createState() => _NavProfilePageState();
}

class _NavProfilePageState extends State<NavProfilePage> {

  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController renameUsernameController = TextEditingController();

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
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [          
            SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 50,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("Users").doc(user!.uid).snapshots(), 
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        var userData = snapshot.data!.data() as Map<String, dynamic>;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text(
                                "Username: ", 
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            // Text(
                            //   userData["Username"], 
                            //   style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData["Username"],
                                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.left,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis, // optional, in case it still overflows
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container(height: 0);
                      }
                    },
                  ),
                  const SizedBox(height: 10,),
                  Text(user!.email!, style: TextStyle(fontSize: 20, color: Colors.grey[700]),),
                  const SizedBox(height: 40,),
                ],
              ),
            ),
        
            //action list
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit,size: 30,),
                    title: const Text("Edit Username", style: TextStyle(fontSize: 20),),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () async{
              
                      //initial text controller
                      await FirebaseFirestore.instance.collection("Users").doc(user!.uid).get().then((value) {
                        renameUsernameController.text = value.get("Username");
                      });
              
                      //show rename dialog
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: const Text("Edit Username"),
                          content: SingleChildScrollView(
                            child: TextField(
                              controller: renameUsernameController,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();  //make the dialog disappear
                              }, 
                              child: const Text("Cancel")
                            ),
                            TextButton(
                              onPressed: () async{
              
                                //rename username
                                await FirebaseFirestore.instance.collection("Users").doc(user!.uid).update({"Username": renameUsernameController.text}).then((value) {
                                  _toast(msg: "Username changed successfully");
                                  Navigator.of(context).pop();
                                });
              
                              }, 
                              child: const Text("Edit")
                            ),
                          ],
                        );
                      });
                      
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.book,size: 30,),
                    title: const Text("Terms & Conditions", style: TextStyle(fontSize: 20),),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () {
        
                      //change page
                      Navigator.of(context).push(
                        MaterialPageRoute(builder:(context) {
                            return const TermAndConditionPage();
                        },)
                      );
        
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip,size: 30,),
                    title: const Text("Privacy Policy", style: TextStyle(fontSize: 20),),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () {
        
                      //change page
                      Navigator.of(context).push(
                        MaterialPageRoute(builder:(context) {
                            return const PrivacyPolicyPage();
                        },)
                      );
        
                    },
                  ),
                  const SizedBox(height: 30,),
                  ListTile(
                    leading: const Icon(Icons.logout,size: 30,),
                    title: const Text("Logout", style: TextStyle(fontSize: 20),),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    onTap: () async{
        
                      //show logout dialog
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: const Text("Remind !"),
                          content: const Text("Are you sure to logout?"),
                          actions: [
                            TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();  //make the dialog disappear
                              }, 
                              child: const Text("No")
                            ),
                            TextButton(
                              onPressed: () async{
                                
                                //logout and goto login page
                                await FirebaseAuth.instance.signOut().then((onValue) {
                                  FirebaseFirestore.instance.collection("Users").doc(user!.uid).update({"LoginStatus": false});
                                  AlanVoice.removeButton();  //remove the alan button
                                  Get.offNamed("/LoginPage");
                                });
              
                              }, 
                              child: const Text("Yes")
                            ),
                          ],
                        );
                      });
                    },
                  )
                ]
              ),
            )
          ],
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
}
