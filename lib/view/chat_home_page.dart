import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contrador/components/ui_components.dart';
import 'package:contrador/services/chat_services.dart';
import 'package:contrador/view/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/chat_room_model.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  String _userId = '';
  final ChatServices _chatServices = ChatServices();
  final UiComponents _uiComponents = UiComponents();

  @override
  void initState() {
    _userId = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: _uiComponents.headline2("Messages",Theme.of(context).colorScheme.tertiary),
      ),
      body: FutureBuilder<List<ChatRoomModel>>(
        future: _chatServices.getUserChatRooms(_userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: _uiComponents.loading()
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No chats yet"));
          }

          var chatRooms = snapshot.data!;

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              var chatRoom = chatRooms[index];
              var otherUserId = chatRoom.users
                  .firstWhere((id) => id != _userId); // Get the other user's ID

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const ListTile(title: Text("Loading..."));
                  }
                  var userData = userSnapshot.data!;
                  String name = userData['name'] ?? "Unknown";
                  String profilePic = userData['imagePath'] ?? "";

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ListTile(shape: const Border(bottom: BorderSide(color:Colors.grey,width: 0.5)),
                      tileColor: Theme.of(context).colorScheme.primaryContainer,
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: profilePic.isNotEmpty
                            ? NetworkImage(profilePic)
                            : const AssetImage('images/profile.png')
                                as ImageProvider,
                      ),
                      title: _uiComponents.headline3(name),
                      subtitle: Text(chatRoom.lastMessage,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Text(
                        "${chatRoom.timeStamp.day}/${chatRoom.timeStamp.month}/${chatRoom.timeStamp.year}", // Format time
                        style: const TextStyle(color: Colors.grey),
                      ),
                      onTap: () {
                        Flexify.go(
                            ChatPage(
                                receiverId: otherUserId,
                                chatRoomId: chatRoom.chatRoomId),
                            animation: FlexifyRouteAnimations.slide,
                            animationDuration: const Duration(milliseconds: 400));
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
