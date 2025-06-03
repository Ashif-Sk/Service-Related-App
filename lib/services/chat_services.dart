import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contrador/models/chat_room_model.dart';
import 'package:contrador/models/message_model.dart';
import 'package:contrador/view/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexify/flexify.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /*
  Chat room services
   */
  Stream<List<ChatRoomModel>> getUserChatRooms(String userId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: userId) // Get only the chats where the user is a participant
        .orderBy('timestamp', descending: true) // Show recent chats first
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ChatRoomModel.fromJson(doc.data()))
        .toList());
  }


  Future<String> createOrGetChatRoom(String userId1, String userId2) async {
    String chatRoomId = userId1.hashCode <= userId2.hashCode
        ? '$userId1\_$userId2'
        : '$userId2\_$userId1';

    final docRef = FirebaseFirestore.instance.collection('chats').doc(chatRoomId);
    final docSnap = await docRef.get();

    if (!docSnap.exists) {
      ChatRoomModel newRoom = ChatRoomModel(
        chatRoomId: chatRoomId,
        users: [userId1, userId2],
        lastMessage: '',
        timeStamp: DateTime.now(),
        isTyping: false,
      );

      await docRef.set(newRoom.toJson());
    }

    return chatRoomId;
  }

  void startNewChat(String otherUserId) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    String chatRoomId = await createOrGetChatRoom(currentUserId, otherUserId);

    // Optional: navigate to the chat screen
    Flexify.go(ChatPage(chatRoomId: chatRoomId, receiverId: otherUserId));
  }

  /*
  Message services
   */

  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .snapshots();
  }

  void sendMessage(String chatRoomId, MessageModel message) async {
    await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(message.toJson());
    //Update last message
    _firestore
        .collection('chats')
        .doc(chatRoomId)
        .update({"lastMessage": message.message, "timeStamp": DateTime.now()});
  }
}
