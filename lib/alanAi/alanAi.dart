import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';

class Alanai {
  
  //constructor, add alan ai button
  Alanai() {
    /// Init Alan Button with project key from Alan AI Studio      
    AlanVoice.addButton("a3a19cf16683a62f90d980651bf13ed92e956eca572e1d8b807a3e2338fdd0dc/stage", server:"v1.alan.app");

    /// Handle commands from Alan AI Studio
    AlanVoice.onCommand.add((command) {
      debugPrint("got new command ${command.toString()}");
    });
  }

}