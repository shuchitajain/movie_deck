import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_deck/ui/config.dart';

class AuthProvider with ChangeNotifier {
  late final FirebaseAuth _auth;

  AuthProvider(this._auth);

  User? _user;
  User? get user => _user;
  Stream<User?> get authState => _auth.idTokenChanges();

  // AuthProvider.instance() : _auth = FirebaseAuth.instance {
  //   _auth.authStateChanges().listen((User? user) {
  //     if (user == null) {
  //       print('User is currently signed out!');
  //     } else {
  //       _user = user;
  //       print('User is signed in!');
  //     }
  //     notifyListeners();
  //   });
  // }

  Future<int> signUpWithEmailAndPassword({required String email, required String password}) async{
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
      ).then((auth) => _user = auth.user);
      if(user != null) {
        await App.fss.write(key: "uid", value: user!.uid);
        await App.fss.write(key: "email", value: user!.email);
      }
      return -1;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use"){
        print("already in use");
        return 0;
      }
      else if(e.code == "weak-password") {
        print("weak pass");
        return 1;
      }
      print("done ${e.code}");
      return 2;
    }
  }

  Future<int> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
      ).then((auth) => _user = auth.user);
      if(user != null) {
        await App.fss.write(key: "uid", value: user!.uid);
        await App.fss.write(key: "email", value: user!.email);
      }
      return -1;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return 0;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 1;
      }
      return 2;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential).then((auth) => _user = auth.user);
      print("Google user $_user");
      if(user != null) {
        await App.fss.write(key: "uid", value: user!.uid);
        await App.fss.write(key: "email", value: user!.email);
        String? uid = await App.fss.read(key: "uid");
        print("UID $uid");
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    await App.fss.deleteAll();
    return Future.delayed(Duration.zero);
  }
}