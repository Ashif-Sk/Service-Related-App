import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contrador/components/ui_components.dart';
import 'package:contrador/services/chat_services.dart';
import 'package:contrador/view/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/chat_room_model.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final ChatServices _chatServices = ChatServices();
  final UiComponents _uiComponents = UiComponents();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          title: _uiComponents.headline2('Chats'),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: StreamBuilder<List<ChatRoomModel>>(
            stream: _chatServices.getAllChats(userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: _uiComponents.normalText('No messages')
                );
              }
              List<ChatRoomModel>? allChats = snapshot.data;

              return ListView.builder(
                  itemCount: allChats!.length,
                  itemBuilder: (BuildContext context, index) {
                    ChatRoomModel chatRoom = allChats[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 10.0, right: 10, top: 5),
                      child: ListTile(
                        onTap: () {
                          Flexify.go(
                              ChatPage(
                                chatRoomId: chatRoom.chatRoomId,
                                receiverName: chatRoom.receiverName, contractorId: chatRoom.receiverId,
                              ),
                              animation: FlexifyRouteAnimations.slide,
                              animationDuration:
                                  const Duration(milliseconds: 400));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        tileColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        leading: Container(
                          height: height * 0.08,
                          width: width * 0.14,
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: AssetImage('images/profile.png'),
                                  fit: BoxFit.cover),
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.35)),
                        ),
                        trailing: Text(
                          "${chatRoom.timeStamp.day}/${chatRoom.timeStamp.month}/${chatRoom.timeStamp.year}",
                          style: GoogleFonts.abel(
                              textStyle: TextStyle(
                            overflow: TextOverflow.visible,
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 23.rt,
                            fontWeight: FontWeight.normal,
                          )),
                        ),
                        title: Text(
                          chatRoom.receiverName,
                          style: GoogleFonts.abel(
                              textStyle: TextStyle(
                            overflow: TextOverflow.visible,
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 31.rt,
                            fontWeight: FontWeight.bold,
                          )),
                        ),
                        subtitle: Text(
                          chatRoom.lastMessage,
                          style: GoogleFonts.abel(
                              textStyle: TextStyle(
                            overflow: TextOverflow.visible,
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 28.rt,
                            fontWeight: FontWeight.normal,
                          )),
                        ),
                      ),
                    );
                  });
            }));
  }
}
