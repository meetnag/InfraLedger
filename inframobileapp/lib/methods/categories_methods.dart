import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/categories_model.dart';

// const String CATEGORIES_COLLECTION = "Category";

final auth = FirebaseAuth.instance;
final User user = auth.currentUser;
final uid = user.uid;

class CagetoryMethods {
  // final CollectionReference categoryCollection =
  //     FirebaseFirestore.instance.collection(CATEGORIES_COLLECTION);

  // Stream<DocumentSnapshot> callStream({String uid}) =>
  //     categoryCollection.doc(uid).snapshots();

  Future<bool> addCategory({Category category}) async {
    try {
      Map<String, dynamic> categories = category.toMap(category);

      // print(await categoryCollection.doc(uid).get());
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(uid)
          .set(categories);

      print("##### Entered successfully #####");
      return true;
    } catch (e) {
      print(uid);
      print("##### COULD NOT ENTER #####");
      print(e);
      return false;
    }
  }

  // Future<bool> deleteCategory({Category category}) async {
  //   try {
  // await categoryCollection.doc().delete();
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }
}
