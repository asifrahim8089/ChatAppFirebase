// ignore_for_file: prefer_final_fields

import 'package:chat_app/Model/message_model.dart';
import 'package:flutter/material.dart';

class MessageProvider extends ChangeNotifier {
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  void addMessage(Message message) {
    print("entered to message provider ${message.data}");
    _messages.add(message);
    notifyListeners();
  }
}
