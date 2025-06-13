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
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final ChatServices _chatServices = ChatServices();
  final UiComponents _uiComponents = UiComponents();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: _uiComponents
            .headline2("Messages"),
      ),
      body: StreamBuilder<List<ChatRoomModel>>(
        stream: _chatServices.getUserChatRooms(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitCircle(
                size: 30,
                color: Theme.of(context).colorScheme.primary,
              ),
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
              var otherUserId =
              chatRoom.users.firstWhere((id) => id != userId); // Get the other user's ID

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const ListTile(title: Text("Loading..."));
                  }
                  var userData = userSnapshot.data!;
                  String name = userData['name'] ?? "Unknown";
                  String profilePic = userData['profilePic'] ?? "";

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: profilePic.isNotEmpty
                          ? NetworkImage(profilePic)
                          : const AssetImage('images/profile.png') as ImageProvider,
                    ),
                    title: Text(name),
                    subtitle: Text(chatRoom.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: Text(
                      "${chatRoom.timeStamp.hour}:${chatRoom.timeStamp.minute}", // Format time
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      Flexify.go(
                           ChatPage(receiverId: otherUserId, chatRoomId: chatRoom.chatRoomId),
                          animation: FlexifyRouteAnimations.slide,
                          animationDuration: const Duration(milliseconds: 400));
                    },
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