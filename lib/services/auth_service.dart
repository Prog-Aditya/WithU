import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:withu/helper/helper_function.dart';
import 'package:withu/services/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginuserwithEmailanPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //register
  Future registeruserwithemailanpassword(
      String fullname, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call database service to update tha database
        await DataBaseService(uid: user.uid).updateUserdata(fullname, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //signout
  Future signOut() async {
    try {
      await helperFunction.svaeUserLogedInstatus(false);
      await helperFunction.svaeUserName("");
      await helperFunction.svaeUseremail("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
