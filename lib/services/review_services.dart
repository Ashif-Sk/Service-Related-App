import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contrador/models/review_model.dart';

class ReviewServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future uploadReview(ReviewModel review, String contractorId) async {
    try {
      CollectionReference reviews = _firestore
          .collection('contractors')
          .doc(contractorId)
          .collection('reviews');
      await reviews.add(review.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<List<ReviewModel>> getReviews (String contractorId) {
    return _firestore
        .collection('contractors')
        .doc(contractorId)
        .collection('reviews').snapshots().map((snapshot){
          return snapshot.docs.map((doc)=> ReviewModel.fromJson(doc.data())).toList();
    });
  }

  Future updateRatingReviews(String contractorId) async {
    try{
      QuerySnapshot reviews = await _firestore
          .collection('contractors')
          .doc(contractorId)
          .collection('reviews').get();
      if(reviews.docs.isNotEmpty){
        double totalRating = 0;
        int ratingCount = reviews.docs.length;

        for(var doc in reviews.docs){
          totalRating+= (doc["rating"] as num).toDouble();
        }

        double newRating = totalRating/ratingCount;

        await _firestore.collection('contractor').doc(contractorId).update({
          "rating" : newRating,
          "totalRatings" : ratingCount,
        });
      }
    } catch (e){
      print('Error in updating rating');
    }
  }
}
