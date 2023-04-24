// ignore_for_file: prefer_final_fields, depend_on_referenced_packages, unused_element, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:chat_app/Model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/chat_screen.dart';

class MessageProvider extends ChangeNotifier {
  List<Message> _messages = [];
  String? recipientEmail;
  String? deviceToken;
  BuildContext? context;

  List<Message> get messages => _messages;

  void addMessage(Message message) {
    print("entered to message provider ${message.data}");
    _messages.add(message);
    notifyListeners();
  }

  ///Send message to the server
  Future<void> sendMessage(Message message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      print("the message send is ${message.data}");
      String? senderEmail = prefs.getString('email');
      if (senderEmail == 'user2@gmail.com') {
        recipientEmail = "user1@gmail.com";
        notifyListeners();
      } else {
        recipientEmail = "user2@gmail.com";
        notifyListeners();
      }
      print(recipientEmail);
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: recipientEmail)
              .get();

      if (querySnapshot.size > 0) {
        deviceToken = querySnapshot.docs.first.data()['device_token'];
        print(deviceToken);
        // send the message to the server
        final docRef =
            await FirebaseFirestore.instance.collection('messages').add(
          {
            'type': message.type,
            'content': message.data,
            'timestamp': message.timestamp.toIso8601String(),
          },
        );
        await sendMessageToDevice(deviceToken.toString(), message.data);
      }

      // // send a notification to the user
    } catch (error) {
      // handle the error
      print('Error sending message: $error');
    }
  }

  /// Handle notifications when the app is in the foreground
  Future<void> onMessage(Map<String, dynamic> message) async {
    String notificationMessage = message['notification']['body'];

    // Show the message in the chat screen
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) =>
            ChatScreen(notificationmessage: notificationMessage),
      ),
    );
  }

  /// Handle notifications when the app is in the background
  Future<void> onBackgroundMessage(message) async {
    String notificationMessage = message.notification!.body!;

    // Show the message in the chat screen
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) =>
            ChatScreen(notificationmessage: notificationMessage),
      ),
    );
  }

  ///notify the user about message
  Future<void> sendMessageToDevice(String deviceToken, String message) async {
    print("entered send message to device function");
    try {
      // Set up the notification data
      Map<String, dynamic> notification = {
        'notification': {
          'title': 'You have a new Message',
          'body': message.toString()
        },
        'priority': 'high',
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': deviceToken // The device token you obtained earlier
      };

      print(notification["notification"]["body"]);
      // Send the notification
      http
          .post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAADhfGkE0:APA91bEWtYuF-u5UUvLkQv4tm3bWLN2l5bQ6SfmoD-GVH7IfDo_32Ws0PXR0h0C0s1Zs_Ih7msR5Eb2xq03qMdWIQFQafeRKUogZXWXax2GXp_6wIHIm3zv5UNgVOR0UExBVO7TW0-DI'
        },
        body: jsonEncode(notification),
      )
          .then((response) {
        if (response.statusCode == 200) {
        } else {
          print('Error sending message: ${response.statusCode}');
        }
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

//image pick and send
  Future<void> pickImage(context) async {
    try {
      // final provider = Provider.of<MessageProvider>(context, listen: false);
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final message = Message(
          type: 'image',
          data: pickedFile.path,
          timestamp: DateTime.now(),
        );
        addMessage(message);
        sendMessage(message);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> startRecording() async {}

  Future<void> _stopRecording(BuildContext context) async {}

  Future<void> _playRecording(String path) async {}

  Future<void> _stopPlaying() async {}
}
