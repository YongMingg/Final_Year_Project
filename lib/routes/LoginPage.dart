import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
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
                      child: FadeInUp(duration: const Duration(seconds: 1), child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('img/light_1.png')
                          )
                        ),
                      )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeInUp(duration: const Duration(milliseconds: 1200), child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('img/light_2.png')
                          )
                        ),
                      )),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeInUp(duration: const Duration(milliseconds: 1300), child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('img/clock.png')
                          )
                        ),
                      )),
                    ),
                    Positioned(
                      child: FadeInUp(duration: const Duration(milliseconds: 1600), child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: const Center(
                          child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                        ),
                      )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeInUp(duration: const Duration(milliseconds: 1800), child: Container(
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
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey)
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                    const SizedBox(height: 60,),

                    //login button
                    FadeInUp(
                      duration: const Duration(milliseconds: 1900), 
                      child: InkWell(
                        onTap: () {
                          //login to account
                          if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                            _login();
                          }else{
                            //tell user about incorrect information
                            _toast(msg: "Email or Password cannot be empty");
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
                            child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                          ),
                        ),
                      )
                    ),
                    const SizedBox(height: 70,),
                    FadeInUp(
                      duration: const Duration(milliseconds: 2000), 
                      child: InkWell(
                        onTap: () {
                          Get.toNamed("/RegisterPage");
                        },
                        child: const Text("No account? Register now", style: TextStyle(fontSize: 19, color: Color.fromRGBO(143, 148, 251, 1)),)
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  Future<void> _login() async{
    final auth = FirebaseAuth.instance;
    try {
      //authentication
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim(),
      ).then((UserCredential userCredential){
        // Get the UID of the user
        User? user = userCredential.user;
        if (user != null) {
          String uid = user.uid; 
          FirebaseFirestore.instance.collection("Users").doc(uid).update({"LoginStatus": true});
          Get.offAllNamed("/HomePage");
        }
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Email or Password invalid';
          break;
        case 'user-disabled':
          errorMessage = 'This user has been disabled';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Email or Password invalid';
          break;
        default:
          errorMessage = 'Email or Password invalid';
          break;
      }
      _toast(msg: errorMessage);
    }
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