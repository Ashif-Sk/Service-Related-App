import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contrador/models/favourite_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class FavouriteProvider with ChangeNotifier {
  List<FavouriteModel> _favourites = [];

  List<FavouriteModel> get favourites => _favourites;

  void addToWishlist(FavouriteModel favouriteItem){
    final FavouriteModel? favouriteModel = _favourites.firstWhereOrNull((item){
      bool isSameItem = item.serviceId == favouriteItem.serviceId;
      return isSameItem;
    });
    if(favouriteModel == null){
      _favourites.add(favouriteItem);
      saveWishListState();
    }else{
      int index= _favourites.indexOf(favouriteItem);
      print(index);
      _favourites.removeAt(index);
      saveWishListState();
    }
    notifyListeners();
  }

  Future<void> loadWishListState() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot snapshot = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('favourite')
          .get();

      _favourites = snapshot.docs
          .map((doc) =>
              FavouriteModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      notifyListeners();
    }
  }

  Future<void> saveWishListState() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference wishlistRef =
          firestore.collection('users').doc(user.uid).collection('favourite');

      // Clear previous data
      await wishlistRef.get().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      // Save current state
      for (FavouriteModel value in _favourites) {
        await wishlistRef.doc(value.serviceId).set(value.toJson());
      }
    }
  }

  bool isFavourite(FavouriteModel item) {
    final FavouriteModel? favouriteItem = _favourites.firstWhereOrNull((value) {
      bool isSameItem = value.serviceId == item.serviceId;
      return isSameItem;
    });

    if (favouriteItem == null) {
      return false;
    }
    return true;
  }
}
