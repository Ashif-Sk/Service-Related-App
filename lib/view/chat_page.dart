import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contrador/components/ui_components.dart';
import 'package:contrador/models/message_model.dart';
import 'package:contrador/services/chat_services.dart';
import 'package:contrador/view/details/contractor_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String chatRoomId;

  const ChatPage({super.key, required this.receiverId, required this.chatRoomId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final UiComponents _uiComponents = UiComponents();
  final ChatServices _chatServices = ChatServices();
  final TextEditingController _messageController = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  late final Future<DocumentSnapshot> _receiverFuture;

  @override
  void initState() {
    _receiverFuture = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.receiverId)
        .get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: FutureBuilder<DocumentSnapshot>(
          future: _receiverFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text("Loading...");
            var data = snapshot.data!.data() as Map<String, dynamic>;
            String profilePic = data["imagePath"]?? '';
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: profilePic.isNotEmpty
                      ? NetworkImage(profilePic)
                      : const AssetImage('images/profile.png')
                  as ImageProvider,
                ),
                15.horizontalSpace,
                _uiComponents.headline2(
                  data['name'] ?? 'User',
                  Theme.of(context).colorScheme.tertiary,
                ),
              ],
            );
          },
        ),
        actions: [
          PopupMenuButton<int>(
            iconColor: Theme.of(context).colorScheme.tertiary,
            color: Theme.of(context).colorScheme.tertiary,
            itemBuilder: (context) => [
              PopupMenuItem(value: 1, child: _uiComponents.normalText('View Profile')),
              PopupMenuItem(value: 2, child: _uiComponents.normalText('Report')),
              PopupMenuItem(value: 3, child: _uiComponents.normalText('Block')),
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  Flexify.go(
                    ContractorProfilePage(contractorId: widget.receiverId, contractor: null),
                    animation: FlexifyRouteAnimations.slide,
                    animationDuration: const Duration(milliseconds: 400),
                  );
                  break;
                case 2:
                  showModalBottomSheet(
                    constraints: BoxConstraints(maxHeight: height * 0.55),
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    useSafeArea: true,
                    showDragHandle: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    ),
                    context: context,
                    builder: (context) => const ReportForm(),
                  );
                  break;
                case 3:
                  print('Blocked');
                  break;
              }
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MessageList(chatRoomId: widget.chatRoomId),
          TextInputArea(
            controller: _messageController,
            onSend: () {
              if (_messageController.text.trim().isEmpty) return;
              _chatServices.sendMessage(
                widget.chatRoomId,
                MessageModel(
                  senderId: currentUserId,
                  messageType: "text",
                  timeStamp: DateTime.now(),
                  message: _messageController.text.trim(),
                ),
              );
              _messageController.clear();
            },
          )
        ],
      ),
    );
  }
}

class MessageList extends StatefulWidget {
  final String chatRoomId;
  const MessageList({super.key, required this.chatRoomId});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList>{
  final ChatServices _chatServices = ChatServices();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatServices.getMessages(widget.chatRoomId),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return Center(child: _uiComponents.loading());
        // }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("images/alert-unscreen.gif", height: 100),
                  Text("Disclaimer", textAlign: TextAlign.center, style: GoogleFonts.abel(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Text(
                    "1. 🔑 Do not share OTP/PIN, click on unsafe links, or scan any QR codes.\n2. ⚠️ Report suspicious activity/profile.\n3. 🛡️ Don't share personal details like IDs, photos.\n4. 💲 Avoid advance payments.\n5. ❗ Be cautious during meetings.",
                    style: GoogleFonts.abel(fontSize: 14, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        }

        List<DocumentSnapshot> messages = snapshot.data!.docs;


        return Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 5),
            itemCount: messages.length,
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemBuilder: (context, index) {
              MessageModel message = MessageModel.fromJson(messages[index].data() as Map<String, dynamic>);
              return ChatBubble(message: message);
            },
          ),
        );
      },
    );
  }
}

class TextInputArea extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const TextInputArea({super.key, required this.controller, required this.onSend});

  @override
  State<TextInputArea> createState() => _TextInputAreaState();
}

class _TextInputAreaState extends State<TextInputArea> {
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.08,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.primary)),
        color: Theme.of(context).colorScheme.tertiary,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              focusNode: _focusNode,
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: 'Type your message',
                hintStyle: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.w500),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
              keyboardType: TextInputType.multiline,
            ),
          ),
          const SizedBox(width: 20),
          ReusableIconButton(
            radius: 25,
            icon: Icons.send_rounded,
            iconColor: Theme.of(context).colorScheme.primary,
            iconSize: 25,
            onPressed: widget.onSend,
          )
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  ChatBubble({super.key, required this.message});

  final String _userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Align(
      alignment: message.senderId == _userId ? Alignment.bottomRight : Alignment.bottomLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width * 0.7, minWidth: width * 0.2),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
              topRight: const Radius.circular(15),
              bottomLeft: message.senderId == _userId ? const Radius.circular(15) : const Radius.circular(2),
              bottomRight: message.senderId == _userId ? const Radius.circular(2) : const Radius.circular(15),
            ),
            color: message.senderId == _userId
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primaryContainer,
          ),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.message,
                  style: GoogleFonts.abel(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: message.senderId == _userId
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "${message.timeStamp.hour}:${message.timeStamp.minute.toString().padLeft(2, '0')}",
                    style: GoogleFonts.abel(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: message.senderId == _userId
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
