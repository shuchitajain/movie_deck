import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  signUpWithEmailAndPassword({required String email, required String password}) async{
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
      ).then((auth) => _user = auth.user);
      print(_user.toString());
      if(user != null) {
        var fss = FlutterSecureStorage();
        await fss.write(key: "uid", value: user!.uid);
        await fss.write(key: "email", value: user!.email);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
      ).then((auth) => _user = auth.user);
      print(_user.toString());
      if(user != null) {
        var fss = FlutterSecureStorage();
        await fss.write(key: "uid", value: user!.uid);
        await fss.write(key: "email", value: user!.email);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
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
      print(_user.toString());
      if(user != null) {
        var fss = FlutterSecureStorage();
        await fss.write(key: "uid", value: user!.uid);
        await fss.write(key: "email", value: user!.email);
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    return Future.delayed(Duration.zero);
  }
}