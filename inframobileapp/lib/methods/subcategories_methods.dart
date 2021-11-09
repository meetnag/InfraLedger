import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/subcategories_model.dart';

// const String CATEGORIES_COLLECTION = "subCategory";

final auth = FirebaseAuth.instance;
final User user = auth.currentUser;
final uid = user.uid;

class subCategoryMethods {
  // final CollectionReference subcategoryCollection =
  //     FirebaseFirestore.instance.collection(CATEGORIES_COLLECTION);

  // Stream<DocumentSnapshot> callStream({String uid}) =>
  //     subcategoryCollection.doc(uid).snapshots();

  Future<bool> addsubCategory({subCategory subcategory}) async {
    try {
      Map<String, dynamic> subcategories = subcategory.toMap(subcategory);

      // print(await subcategoryCollection.doc(uid).get());
      await FirebaseFirestore.instance
          .collection('subCategories')
          .doc(uid)
          .set(subcategories);

      print("##### Entered successfully #####");
      return true;
    } catch (e) {
      print(uid);
      print("##### COULD NOT ENTER #####");
      print(e);
      return false;
    }
  }

  // Future<bool> deletesubCategory({subCategory subcategory}) async {
  //   try {
  // await subcategoryCollection.doc().delete();
  //     return true;
  //   } subcatch (e) {
  //     print(e);
  //     return false;
  //   }
  // }
}
