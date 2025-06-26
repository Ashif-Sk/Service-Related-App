import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contrador/components/ui_components.dart';
import 'package:contrador/services/chat_services.dart';
import 'package:contrador/view/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: _uiComponents.headline2(
            "Messages", Theme.of(context).colorScheme.tertiary),
      ),
      body: FutureBuilder<List<ChatRoomModel>>(
        future: _chatServices.getUserChatRooms(_userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: _uiComponents.loading());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Image.asset(
                'images/empty-chat.png',
                fit: BoxFit.fill,
                height: height * 0.25,
                width: width * 0.5,
              ),
            );
          }

          var chatRooms = snapshot.data!;

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              var chatRoom = chatRooms[index];
              var otherUserId = chatRoom.users
                  .firstWhere((id) => id != _userId); // Get the other user's ID
              final now = DateTime.now();
              final isToday = now.year == chatRoom.timeStamp.year &&
                  now.month == chatRoom.timeStamp.month &&
                  now.day == chatRoom.timeStamp.day;
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

                  return ListTile(
                    shape: const Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.5)),
                    // tileColor: Theme.of(context).colorScheme.primaryContainer,
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: profilePic.isNotEmpty
                          ? NetworkImage(profilePic)
                          : const AssetImage('images/profile.png')
                              as ImageProvider,
                    ),
                    title: _uiComponents.headline3(name),
                    subtitle: Text(
                      chatRoom.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.abel(
                          textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade900)),
                    ),
                    trailing: Text(
                      isToday
                          ? "Today"
                          : "${chatRoom.timeStamp.day}/${chatRoom.timeStamp.month}/${chatRoom.timeStamp.year}", // Format time
                      style: GoogleFonts.abel(
                          textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade900)),
                    ),
                    onTap: () {
                      Flexify.go(
                          ChatPage(
                              receiverId: otherUserId,
                              chatRoomId: chatRoom.chatRoomId),
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
