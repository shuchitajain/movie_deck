import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreHelper {

  static Future<void> addUserToCloud() async{
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'fetch': true,
    },).whenComplete(() => print("Added"));
  }

  static Future<void> addMovies({required List<Map<String, dynamic>> newMovie, required String docId}) async {
   await FirebaseFirestore.instance.collection("users").doc(docId).update({"watchlist": FieldValue.arrayUnion(newMovie)});
  }

  static Future<void> deleteMovie({required List<Map<String, dynamic>> movie, required String docId}) async {
    print("Del from firestore");
    try {
      await FirebaseFirestore.instance.collection('users').doc(docId).update({
          'watchlist': FieldValue.arrayRemove(movie),
        });
      print("${FirebaseFirestore.instance.collection('users').doc(docId).get().then((value) => print(value.data()!["watchlist"]))}");
    } catch (e) {
      print(e);
    }
  }

  static Future<void> updateMovie({required String createdOn, required String docId, required Map<String, dynamic> movie}) async {
    CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');
    await _collectionReference.doc(docId).update({
      'watchlist.' + createdOn : movie,
    });
  }

  static Future<void> toggleFetching({required String docId, required bool fetchOrNot}) async {
    CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');
    await _collectionReference.doc(docId).update({
      'fetch' : fetchOrNot,
    });
  }

}