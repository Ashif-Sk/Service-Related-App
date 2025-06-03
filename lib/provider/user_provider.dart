import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contrador/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  UserModel? _userData;

  UserModel? get userData => _userData;

  // Future<void> getUserModel() async{
  //   final String userId = FirebaseAuth.instance.currentUser!.uid;
  //  _userData= await _userServices.getUserDetails(userId);
  //  notifyListeners();
  // }

  Future<void> getUserDetails() async {
    final uId = FirebaseAuth.instance.currentUser!.uid;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .get();

      if (doc.exists) {
        _userData = UserModel.fromJson(doc.data()!);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user details: $e');
      }
    }
  }

  Future updateUserDetails(UserModel user,String userId) async{
    try{
      CollectionReference users= FirebaseFirestore.instance.collection('users');
      await users.doc(userId).update(user.toJson());
      getUserDetails();
      notifyListeners();
    }catch (e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
