const function = require("firebase-functions");

const admin = require("firebase-admin");

admin.initializeApp();

exports.sendChatNotifications =

functions.firestore.document("chats/{chatRoomId}/messages/{messageId}").onCreate(async (snap, context) => {
    const messageData = snap.data();
    const receiverId = messageData.receiverId;
    const message = messageData.message;

    const userDoc = await admin.firestore().collection("users").doc(receiverId).get();
    const fcmToken = userDoc.data().fcmToken;

    if (!fcmToken){
        console.log("No fcm Token");
        return null;
    }
    const payload = {
        notification : {
            "title" : "New Message",
            "body" : message,
        },
        token : fcmToken,
    };

    try{
    const response = await admin.messaging().send(payload);
    }catch(e){
        console.error("error in sending message",e);
    }
    return null;
});