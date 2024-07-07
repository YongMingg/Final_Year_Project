import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //Appbar title
      appBar: AppBar(
        backgroundColor: Colors.blue,  
        title: const Text(
          "Register",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      //body content
      body: Padding(
        padding: const EdgeInsets.only(left: 80, right: 80),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "example@email.com",
                  hintStyle: TextStyle(color: Colors.grey,)
                ),
              ),
              const SizedBox(height: 50,),
        
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "",
                ),
              ),
              const SizedBox(height: 50,),

              TextField(
                obscureText: true,
                controller: confirmpasswordController,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  hintText: "",
                ),
              ),
              const SizedBox(height: 100,),
        
              //register button
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Colors.purple),
                            foregroundColor: WidgetStatePropertyAll(Colors.white),
                          ),
                          child: const Text("Register", style: TextStyle(fontSize: 19),), 
                          onPressed: (){

                            if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty && confirmpasswordController.text.isNotEmpty) {
                              if (passwordController.text == confirmpasswordController.text) {
                                _register();
                              } else {
                                _toast(msg: "Password and Confirm Password is different");
                              }
                            }else{
                              //toast to tell user
                              _toast(msg: "Input cannot be empty");
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

  Future<void> _register() async{
    final auth = FirebaseAuth.instance;
    await auth.createUserWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text,
    ).then((UserCredential userCredential){
      // Get the UID of the user
      User? user = userCredential.user;
      if (user != null) {
        String uid = user.uid; 
        Map<String, dynamic> userInfo = {
          "Id": uid,
          "Email": emailController.text,
          "Username": "user#${uid.substring(0, 4)}",
          "Counter": "0",
          "LoginStatus": false,
        };
        FirebaseFirestore.instance.collection("Users").doc(uid).set(userInfo);
      }
      _toast(msg: "Registered Successfully! Please Login");
      Get.offAllNamed("/LoginPage");
    }).catchError((error){
      _toast(msg: error.toString());
    });
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