import 'package:animate_do/animate_do.dart';
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
      
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('img/home_background.png'),
                  fit: BoxFit.fill
                )
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 30,
                    width: 80,
                    height: 200,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 500), 
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('img/light_1.png')
                          )
                        ),
                      )
                    ),
                  ),
                  Positioned(
                    left: 140,
                    width: 80,
                    height: 150,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 600), 
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('img/light_2.png')
                          )
                        ),
                      )
                    ),
                  ),
                  Positioned(
                    right: 40,
                    top: 40,
                    width: 80,
                    height: 150,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 750), 
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('img/clock.png')
                          )
                        ),
                      )
                    ),
                  ),
                  Positioned(
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 800), 
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: const Center(
                          child: Text("Register", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                        ),
                      )
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  FadeInUp(
                    duration: const Duration(milliseconds: 900), 
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color.fromRGBO(143, 148, 251, 1)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10)
                          )
                        ]
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color:  Color.fromRGBO(143, 148, 251, 1)))
                            ),
                            child: TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey)
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color:  Color.fromRGBO(143, 148, 251, 1)))
                            ),
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey)
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: confirmpasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(color: Colors.grey)
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                  const SizedBox(height: 60,),
        
                  //register button
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000), 
                    child: InkWell(
                      onTap: () {
        
                        //register account                          
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
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ]
                          )
                        ),
                        child: const Center(
                          child: Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 100,),
        
                  //register button
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000), 
                    child: InkWell(
                      onTap: () {
        
                        Get.offNamed("/LoginPage");
        
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ]
                          )
                        ),
                        child: const Center(
                          child: Text("Back to Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
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