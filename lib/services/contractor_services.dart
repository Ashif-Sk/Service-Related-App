import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/contractor_model.dart';

class ContractorServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future addServiceDetails(ContractorModel service) async {
    try {
      String contractorId = _auth.currentUser!.uid;
      await _firestore
          .collection('contractors')
          .doc(contractorId)
          .collection('services')
          .add(service.toJson());
    } catch (e) {
      print('Contractor service not published');
    }
  }

  Future<List<ContractorModel>?> getAllServicesBySubcategoryId(
      String subCategoryId) async {
    try {
      final service = _firestore.collectionGroup('services');
      List<ContractorModel> services = await service
          .where("subcategory", isEqualTo: subCategoryId)
          .orderBy("timeStamp", descending: true)
          .get()
          .then((snapshots) => snapshots.docs
              .map((doc) => ContractorModel.fromJson(doc.data()))
              .toList());
      return services;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<List<ContractorModel>?> getAllServicesByContractorId(
      String contractorId) async {
    try {
      CollectionReference service = _firestore
          .collection('contractors')
          .doc(contractorId)
          .collection('services');
      List<ContractorModel> services = await service.get().then((snapshots) {
        return snapshots.docs
            .map((doc) =>
                ContractorModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
      return services;
    } catch (e) {
      print('no availableContractor service ');
    }
    return null;
  }
}
