import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contrador/components/ui_components.dart';
import 'package:contrador/models/message_model.dart';
import 'package:contrador/services/chat_services.dart';
import 'package:contrador/view/details/contractor_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String chatRoomId;

  const ChatPage(
      {super.key,required this.receiverId,required this.chatRoomId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final UiComponents _uiComponents = UiComponents();
  final ChatServices _chatServices = ChatServices();
  final TextEditingController _messageController = TextEditingController();
  int? _selectedIndex;
  String chatRoomId = '';
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  String receiverName = '';
  String receiverProfile = '';


  void loadReceiverInfo() async {
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.receiverId)
        .get();

    setState(() {
      receiverName = doc['name'] ?? 'User';
      receiverProfile = doc['profilePic'] ?? '';
    });
  }

  void toggleDeleteIcon(int? index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: _uiComponents.headline2(receiverName),
        actions: [
          PopupMenuButton<int>(
            color: Theme.of(context).colorScheme.tertiary,
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 1, child: _uiComponents.normalText('View Profile')),
              PopupMenuItem(
                  value: 2, child: _uiComponents.normalText('Report')),
              PopupMenuItem(value: 3, child: _uiComponents.normalText('Block')),
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  Flexify.go( ContractorProfilePage(contractorId: widget.receiverId, contractor: null,),
                      animation: FlexifyRouteAnimations.slide,
                      animationDuration: const Duration(milliseconds: 400));
                  break;
                case 2:
                  showModalBottomSheet(
                      constraints: BoxConstraints(maxHeight: height * 0.55),
                      isScrollControlled: true,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      useSafeArea: true,
                      showDragHandle: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      context: context,
                      builder: (context) {
                        return const ReportForm();
                      });
                  break;
                case 3:
                  print('Tapped');
                  break;
              }
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          10.verticalSpace,
          StreamBuilder<QuerySnapshot>(
              stream: _chatServices.getMessages(widget.chatRoomId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: SpinKitCircle(
                      size: 30,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }
                List<DocumentSnapshot> messages = snapshot.data!.docs;
                return Expanded(
                    child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                  itemCount: messages.length,
                  reverse: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemBuilder: (context, index) {
                    MessageModel message = MessageModel.fromJson(
                        messages[index].data() as Map<String, dynamic>);
                    return Row(
                      children: [
                        Expanded(
                            child: _selectedIndex == index
                                ? ReusableIconButton(
                                    radius: 20,
                                    icon: Icons.delete,
                                    iconColor: Colors.red,
                                    iconSize: 20,
                                    onPressed: () {
                                      messages.removeAt(index);
                                      toggleDeleteIcon(null);
                                    })
                                : Container()),
                        InkWell(
                            onLongPress: () => toggleDeleteIcon(index),
                            onTap: () => toggleDeleteIcon(index),
                            child: ChatBubble(
                              message: message,
                            ))
                      ],
                    );
                  },
                ));
              }),
          Container(
            height: height * 0.08,
            width: width * 1,
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).colorScheme.tertiary,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                        hintText: 'Type your message',
                        hintStyle: GoogleFonts.abel(
                            textStyle: TextStyle(
                                fontSize: 35.rt, fontWeight: FontWeight.w500)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                20.horizontalSpace,
                ReusableIconButton(
                    radius: 25,
                    icon: Icons.send_rounded,
                    iconColor: Theme.of(context).colorScheme.primary,
                    iconSize: 25,
                    onPressed: () {
                       _chatServices.sendMessage(
                          widget.chatRoomId,
                          MessageModel(
                              senderId: currentUserId,
                              messageType: "text",
                              timeStamp: DateTime.now(),
                              message: _messageController.text.toString()));
                      _messageController.clear();
                    })
              ],
            ),
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
      alignment: message.senderId == _userId
          ? Alignment.bottomRight
          : Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: width * 0.7,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(2)),
          color: message.senderId == _userId
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.tertiary,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.message,
                textAlign: TextAlign.start,
                style: GoogleFonts.abel(
                    textStyle: TextStyle(
                        overflow: TextOverflow.visible,
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w600))),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${message.timeStamp.hour}:${message.timeStamp.minute}",
                style: GoogleFonts.abel(
                    textStyle: TextStyle(
                  overflow: TextOverflow.visible,
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
