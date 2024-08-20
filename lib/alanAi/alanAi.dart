import 'dart:async';
import 'dart:convert';
import 'package:alan_voice/alan_voice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Alanai {

  late String userConfigJson;
  
  //constructor, add alan button and handle commands
  Alanai() {

    //initialiaze user and add button
    _initializeUser();

    /// Handle commands from Alan AI Studio
    AlanVoice.onCommand.add((command) {
      debugPrint("got new command ${command.toString()}");

      _handleCommand(command.data);
    });

  }

  Future<void> _initializeUser() async {
    try {
      String? userToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      String userId = FirebaseAuth.instance.currentUser!.uid;

      if (userToken != null) {
        var userConfig = {
          "token": userToken,
          "userId": userId
        };

        userConfigJson = jsonEncode(userConfig);

        AlanVoice.addButton(
          "45d1f7b21b72321a90d980651bf13ed92e956eca572e1d8b807a3e2338fdd0dc/stage",
          server: "v1.alan.app",
          buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT,
          bottomMargin: 40,
          authJson: userConfigJson
        );
      } else {
        debugPrint("User is not authenticated.");
      }
    } catch (error) {
      debugPrint("Error getting user info: $error");
    }
  }

  void _handleCommand(Map<String, dynamic> command) {
    switch(command['command']) {
      case "back":
        Get.back();
        break;
      case "add device":
        Get.toNamed("/AddDevicePage");
        break;
      case "add sensor":
        Get.toNamed("/AddSensorPage");
        break;
      default:
        debugPrint("Unknown command");
    }
  }

}