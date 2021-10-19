import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInProvider extends ChangeNotifier {

  final googleSignIn = GoogleSignIn();
  final facebookSignIn = FacebookAuth.instance;
  var users = FirebaseFirestore.instance.collection('users');

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if(googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      users.doc('uYfp5wgQtzeWGzLyWng1') // <-- Doc ID where data should be updated.
          .update({
        'email': _user!.email,
        'imageUrl': _user!.photoUrl,
        'name': _user!.displayName,
      }).then((value) => print("updated"));
    } catch(e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future facebookLogin() async {
    try {
      final facebookLoginResult = await facebookSignIn.login(permissions: ["public_profile", "email"]);
      if(facebookLoginResult == null) return;
      final userData = await FacebookAuth.instance.getUserData();
      final AuthCredential facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      users.doc('uYfp5wgQtzeWGzLyWng1') // <-- Doc ID where data should be updated.
          .update({
        'email': userData['email'],
        'imageUrl': userData['picture']['data']['url'],
        'name': userData['name'],
      }).then((value) => print("updated"));
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future googleLogOut() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }

  Future facebookLogOut() async {
    await facebookSignIn.logOut();
    FirebaseAuth.instance.signOut();
  }
}



