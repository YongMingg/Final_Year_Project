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

      //Appbar title
      appBar: AppBar(
        backgroundColor: Colors.blue,  
        title: const Text(
          "Login",
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
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "",
                ),
                obscureText: true,
              ),
              const SizedBox(height: 100,),
        
              //login button
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
                          child: const Text("Login", style: TextStyle(fontSize: 19),), 
                          onPressed: (){

                            //login to account
                            if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                              _login();
                            }else{
                              //tell user about incorrect information
                              _toast(msg: "Email or Password cannot be empty");
                            }
                            
                          }, 
                        ),
                      ), 
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              
              InkWell(
                onTap: () {
                  Get.toNamed("/RegisterPage");
                },
                child: Text("No account? Register now", style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue[700],
                ),),
              ),

            ],
          ),
        ),
      ),
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
          Get.offNamed("/HomePage");
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