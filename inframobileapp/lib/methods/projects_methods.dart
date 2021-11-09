import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/projects_model.dart';

// const String CATEGORIES_COLLECTION = "Project";

final auth = FirebaseAuth.instance;
final User user = auth.currentUser;
final uid = user.uid;

class CagetoryMethods {
  // final CollectionReference projectCollection =
  //     FirebaseFirestore.instance.collection(CATEGORIES_COLLECTION);

  // Stream<DocumentSnapshot> callStream({String uid}) =>
  //     projectCollection.doc(uid).snapshots();

  Future<bool> addProject({Project project}) async {
    try {
      Map<String, dynamic> projects = project.toMap(project);

      // print(await projectCollection.doc(uid).get());
      await FirebaseFirestore.instance
          .collection('Projects')
          .doc(uid)
          .collection("project");

      print("##### Entered successfully #####");
      return true;
    } catch (e) {
      print(uid);
      print("##### COULD NOT ENTER #####");
      print(e);
      return false;
    }
  }

  // Future<bool> deleteProject({Project project}) async {
  //   try {
  // await projectCollection.doc().delete();
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }
}
