// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, unused_local_variable, unused_element, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:chat_app/Screens/player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/message_model.dart';
import '../Providers/message_provider.dart';

class ChatScreen extends StatefulWidget {
  final String? notificationmessage;
  const ChatScreen({super.key, this.notificationmessage});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();

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
                                            widget.notificationmessage ??
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
                            provider.pickImage(context);
                          },
                          icon: Icon(
                            Icons.image,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(left: 16),
                    //   width: 38,
                    //   height: 38,
                    //   padding: EdgeInsets.only(left: 4),
                    //   decoration: BoxDecoration(
                    //     color: Colors.red.withAlpha(40),
                    //     borderRadius: BorderRadius.all(
                    //       Radius.circular(10),
                    //     ),
                    //   ),
                    //   child: Center(
                    //     child: IconButton(
                    //       onPressed: () {
                    //         provider.startRecording();
                    //       },
                    //       icon: Icon(
                    //         Icons.keyboard_voice,
                    //         color: Colors.black,
                    //         size: 18,
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                          provider.sendMessage(message);
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
