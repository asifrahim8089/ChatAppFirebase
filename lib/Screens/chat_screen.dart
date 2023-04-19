// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, unused_local_variable, unused_import, unused_element, avoid_print

import 'dart:io';

import 'package:chat_app/Screens/player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/message_model.dart';
import '../Providers/message_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  Future<void> _sendMessage(Message message) async {
    try {
      // send the message to the server
      final docRef =
          await FirebaseFirestore.instance.collection('messages').add({
        'type': message.type,
        'content': message.data,
        'timestamp': message.timestamp.toIso8601String(),
      });
      // send a notification to the user
      final token = await FirebaseMessaging.instance.getToken();
    } catch (error) {
      // handle the error
      print('Error sending message: $error');
      // show a user-friendly message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to send message. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _pickImage(context) async {
    try {
      final provider = Provider.of<MessageProvider>(context, listen: false);
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final message = Message(
          type: 'image',
          data: pickedFile.path,
          timestamp: DateTime.now(),
        );
        provider.addMessage(message);
        _sendMessage(message);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _startRecording() async {
    _recorder = FlutterSoundRecorder();
    await _recorder?.openAudioSession();
    await _recorder?.startRecorder(toFile: 'example.mp4');
    _player = FlutterSoundPlayer();
  }

  Future<void> _stopRecording(BuildContext context) async {
    final provider = Provider.of<MessageProvider>(context, listen: false);
    final path = await _recorder?.stopRecorder();
    await _recorder?.closeAudioSession();

    final message = Message(
      data: path,
      type: 'audio',
      timestamp: DateTime.now(),
    );
    provider.addMessage(message);
    _sendMessage(message);
  }

  Future<void> _playRecording(String path) async {
    await _player?.startPlayer(fromURI: path);
  }

  Future<void> _stopPlaying() async {
    await _player?.stopPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        automaticallyImplyLeading: true,
        leadingWidth: 30,
        centerTitle: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Image(
                      image: AssetImage('assets/images/person.png'),
                      height: 34,
                      width: 34,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1), shape: BoxShape.circle),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Text(
              "Asif Rahim",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<MessageProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      itemCount: provider.messages.length,
                      itemBuilder: (context, index) {
                        final message = provider.messages[index];
                        switch (message.type) {
                          case 'text':
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                    topRight: Radius.circular(0),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 0),
                                          child: Text(
                                            message.data.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.fade,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          //  Text(
                          //   message.data,
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     color: Colors.black,
                          //   ),
                          // );
                          case 'image':
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  color: Colors.grey,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.file(
                                    File(message.data),
                                    height: 400,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            );

                          case 'audio':
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                margin: EdgeInsets.only(top: 8),
                                child: PlayerWidget(message.data),
                              ),
                            );
                          default:
                            return Container();
                        }
                      },
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 12, 20, 30),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 16),
                        child: TextFormField(
                          style: TextStyle(
                              letterSpacing: 0.1, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            hintText: "Type here",
                            hintStyle: TextStyle(
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide.none
                                // borderSide: BorderSide(color: Colors.black, width: 1),
                                ),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                            filled: true,
                            fillColor: Colors.red.withAlpha(40),
                          ),
                          textInputAction: TextInputAction.send,
                          onFieldSubmitted: (message) {},
                          controller: _textController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      width: 38,
                      height: 38,
                      padding: EdgeInsets.only(left: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(40),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            _pickImage(context);
                          },
                          icon: Icon(
                            Icons.image,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      width: 38,
                      height: 38,
                      padding: EdgeInsets.only(left: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(40),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            _startRecording();
                          },
                          icon: Icon(
                            Icons.keyboard_voice,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final text = _textController.text;
                        if (text.isNotEmpty) {
                          final message = Message(
                            data: text,
                            type: 'text',
                            timestamp: DateTime.now(),
                          );
                          provider.addMessage(message);
                          _sendMessage(message);
                          _textController.clear();
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 16),
                        width: 38,
                        height: 38,
                        padding: EdgeInsets.only(left: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(40),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.send_outlined,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
