// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_app/Screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          "Chats",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: 1,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
                  ),
                );
              },
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 189, 189, 189),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: Image(
                              image: AssetImage('assets/images/person.png'),
                              height: 64,
                              width: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 1,
                            right: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  shape: BoxShape.circle),
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Asif Rahim",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "Send Message",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
