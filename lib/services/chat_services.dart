import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contrador/models/chat_room_model.dart';
import 'package:contrador/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /*
  Chat room services
   */
  Stream<List<ChatRoomModel>> getAllChats(String userId) {
    return _firestore
        .collection('chats')
        .where('userId', isEqualTo: userId)
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatRoomModel.fromJson(doc.data()))
            .toList());
  }

  Future<String> getChatRoomId(String currentUser, String receiverId,
      ChatRoomModel chatRoomModel) async {
    String chatRoomId = currentUser.hashCode <= receiverId.hashCode
        ? '$currentUser\_$receiverId'
        : '$receiverId\_$currentUser';

    DocumentSnapshot chatDoc =
        await _firestore.collection('chats').doc(chatRoomId).get();

    if (!chatDoc.exists) {
      await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .set(chatRoomModel.toJson());
    }
    return chatRoomId;
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
