import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contrador/models/user_model.dart';
import 'package:flutter/foundation.dart';

class UserServices{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future addUserDetails(UserModel user,String userId) async{
    try{
      CollectionReference users= _firestore.collection('users');
     await users.doc(userId).set(user.toJson());
    }catch (e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<UserModel?> getUserDetails(String userId)async{
    try{
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      if(doc.exists){
        return UserModel.fromJson(doc.data() as Map<String,dynamic>);
      }

    } catch (e){
      print(e.toString());
    }
    return null;
  }
}