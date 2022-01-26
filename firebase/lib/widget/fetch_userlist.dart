import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseManager {
  CollectionReference product =
      FirebaseFirestore.instance.collection('product');
  Future getUsersList() async {
    List itemsList = [];
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await product.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
